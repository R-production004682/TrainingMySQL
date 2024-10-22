use my_db4;

show index from customers;

drop index idx_customers_age on customers;

-- 悪い例：同じテーブル(prefectures)に対して2回同じ副問い合わせが発生している
select * from customers
where prefecture_code in (select prefecture_code from prefectures where name = "東京都")
or 
where prefecture_code in (select prefecture_code from prefectures where name = "大阪府");

-- 改善例：無駄な副問い合わせを1つにまとめることで、パフォーマンスを向上させる
select * from customers
where prefecture_code in 
(select prefecture_code from prefectures where name in ("東京都", "大阪府"));

-- コメント：
-- 同じ`prefectures`テーブルに対して2回の副問い合わせを行う代わりに、IN句で1回の問い合わせにまとめています。
-- テーブルへのアクセスが1回で済むため、無駄な処理を減らし、クエリの実行速度が向上します。
-- `EXPLAIN`で確認すれば、テーブルアクセスの回数が減っていることがわかります。

-- 悪い例：SELECT句内で副問い合わせが行われており、各行ごとに都道府県名を取得しているため、処理コストが高い
explain analyze
select *,
(select name from prefectures as pr where pr.prefecture_code = ct.prefecture_code)
from customers as ct;
/*
    -> Table scan on ct  (cost=204 rows=2000)
        (actual time=0.197..1.87 rows=2000 loops=1)
    -> Select #2 (subquery in projection; dependent)
    -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.35 rows=1)
        (actual time=0.00134..0.00136 rows=1 loops=2000)
    -- `EXPLAIN ANALYZE`の結果から、`prefectures`テーブルへのサブクエリが各行ごとに実行されていることが確認できる。
    -- 2000行に対して都度副問い合わせが発生しており、パフォーマンスが悪化している。
*/

-- 改善例：LEFT JOINを使ってテーブルを結合し、一度に全ての行に対応する都道府県名を取得する
explain analyze
select *, pr.name
from customers as ct
left join prefectures as pr
on pr.prefecture_code = ct.prefecture_code;
/*
    -> Nested loop left join  (cost=904 rows=2000)
        (actual time=0.0884..2.25 rows=2000 loops=1)
    -> Table scan on ct  (cost=204 rows=2000)
        (actual time=0.0696..0.896 rows=2000 loops=1)
    -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1)
        (actual time=552e-6..569e-6 rows=1 loops=2000)
    -- LEFT JOINを使用した場合、`prefectures`テーブルに対するインデックスを活用して効率的に結合が行われる。
    -- 各行に対する個別の副問い合わせではなく、1回のJOINで処理が完了するため、パフォーマンスが大幅に向上する。
    -- `EXPLAIN`結果でも、テーブルスキャンの回数が減り、サブクエリが排除されたことが確認できる。
*/


-- 2016年度の月ごとの集計カラムを追加
explain analyze select * from sales_history
where sales_day between '2016-01-01' AND '2016-12-31';
/*
    -> Filter: (sales_history.sales_day between '2016-01-01' and '2016-12-31')  (cost=503 rows=556)
        (actual time=0.0606..3.14 rows=608 loops=1)
    -> Table scan on sales_history  (cost=503 rows=5000)
        (actual time=0.0575..1.46 rows=5000 loops=1)
    
    -- フルテーブルスキャンが発生しています。2016年度の範囲に絞り込んでいるものの、
        インデックスがないため、全データをスキャンしています。
*/


-- 2016年度の日ごとの集計カラムを追加
explain analyze select sales_day, sum(sales_amount)
from sales_history
where sales_day between '2016-01-01' AND '2016-12-31'
group by sales_day;
/*
    -> Table scan on <temporary>
        (actual time=2.51..2.52 rows=281 loops=1)
    -> Aggregate using temporary table
        (actual time=2.5..2.5 rows=281 loops=1)
    -> Filter: (sales_history.sales_day between '2016-01-01' and '2016-12-31')  (cost=503 rows=556)
        (actual time=0.0344..2.15 rows=608 loops=1)
    -> Table scan on sales_history  (cost=503 rows=5000)
        (actual time=0.0318..0.861 rows=5000 loops=1)
    
    -- GROUP BY句によって日ごとの集計が行われている。
        集計処理のため、一時テーブルが使用されており、集計結果を保持するための追加処理が発生しています。
    -- 全データに対するフルテーブルスキャンが発生。
*/


-- 副問い合わせを使って日ごとの集計結果をLEFT JOINで結合
explain analyze select * from sales_history
left join
(select sales_day, sum(sales_amount) as sales
from sales_history 
where sales_day between '2016-01-01' AND '2016-12-31'
group by sales_day) as sales_summary
on sales_history.sales_day = sales_summary.sales_day;
/*
    -> Nested loop left join  (cost=13117 rows=0)
        (actual time=2.3..5.33 rows=5000 loops=1)
    -> Table scan on sales_history  (cost=503 rows=5000)
        (actual time=0.042..1.1 rows=5000 loops=1)
    -> Index lookup on sales_summary using <auto_key0> (sales_day=sales_history.sales_day)  (cost=0.25..2.52 rows=10.1)
        (actual time=740e-6..752e-6 rows=0.122 loops=5000)
    
    -- 副問い合わせで集計を行い、それをLEFT JOINで結合していますが、
        依然としてフルテーブルスキャンが発生しています。
    -- 一時テーブルとネストされたループ結合があるため、全体的な処理時間が長くなっています。
*/


-- 副問い合わせに含まれているNULLを除外した形で表示
explain analyze select * from sales_history
left join
(select sales_day, sum(sales_amount) as sales
from sales_history 
where sales_day between '2016-01-01' AND '2016-12-31'
group by sales_day) as sales_summary
on sales_history.sales_day = sales_summary.sales_day
where sales_history.sales_day between '2016-01-01' AND '2016-12-31';
/*
    -> Nested loop left join  (cost=1905 rows=0)
        (actual time=3.02..5.25 rows=608 loops=1)
    -> Filter: (sales_history.sales_day between '2016-01-01' and '2016-12-31')  (cost=503 rows=556)
        (actual time=0.0564..1.97 rows=608 loops=1)
    -> Table scan on sales_history  (cost=503 rows=5000)
        (actual time=0.0533..0.984 rows=5000 loops=1)
    -> Index lookup on sales_summary using <auto_key0> (sales_day=sales_history.sales_day)
        (cost=0.25..2.52 rows=10.1) (actual time=0.00518..0.00529 rows=1 loops=608)
    
    -- LEFT JOINでNULLが含まれる行を除外するためにWHERE句を追加しています。
    このWHERE句でデータを再度フィルタリングしていますが、依然として副問い合わせの結果を結合しているため、効率が悪い。
*/


-- sales_summaryを別テーブルとして結合
explain analyze select sales_history.*, sales_summary.sales_daily_amount
from sales_history
left join
(select sales_day, sum(sales_amount) as sales_daily_amount
from sales_history 
where sales_day between '2016-01-01' AND '2016-12-31'
group by sales_day) as sales_summary
on sales_history.sales_day = sales_summary.sales_day
where sales_history.sales_day between '2016-01-01' AND '2016-12-31';
/*
    -> Nested loop left join  (cost=1905 rows=0)
        (actual time=4.54..7.33 rows=608 loops=1)
    -> Filter: (sales_history.sales_day between '2016-01-01' and '2016-12-31')  (cost=503 rows=556)
        (actual time=0.0774..2.47 rows=608 loops=1)
    -> Table scan on sales_history  (cost=503 rows=5000)
        (actual time=0.0727..1.22 rows=5000 loops=1)
    -> Index lookup on sales_summary using <auto_key0> (sales_day=sales_history.sales_day)
        (cost=0.25..2.52 rows=10.1) (actual time=0.00774..0.00786 rows=1 loops=608)
    
    -- sales_summaryをサブクエリとして利用していますが、LEFT JOINのため、サブクエリの処理が全体的に遅くなっています。
    -- 副問い合わせでの集計結果の結合が非効率的なため、実行時間が増加しています。
*/


-- ウィンドウ関数を用いて集計処理を高速化
explain analyze select sh.*, sum(sh.sales_amount) over(partition by sh.sales_day)
from sales_history as sh
where sh.sales_day between '2016-01-01' AND '2016-12-31';
/*
    -> Window aggregate with buffering: sum(sales_history.sales_amount) OVER (PARTITION BY sh.sales_day )
        (actual time=4..4.57 rows=608 loops=1)
    -> Sort: sh.sales_day  (cost=503 rows=5000)
        (actual time=3.97..4.01 rows=608 loops=1)
    -> Filter: (sh.sales_day between '2016-01-01' and '2016-12-31')  (cost=503 rows=5000)
        (actual time=0.0922..3.69 rows=608 loops=1)
    -> Table scan on sh  (cost=503 rows=5000)
        (actual time=0.0863..1.72 rows=5000 loops=1)
    
    -- ウィンドウ関数を用いることで、集計処理を最適化。副問い合わせや一時テーブルの使用がなくなり、
        集計結果を効率的に取得しています。
    -- 実行時間も改善されており、全体的に効率的な処理が行われています。
*/

-- インデックスを追加してさらに高速化を図るが、期待した効果は得られなかった
create index idx_sales_history_sales_day on sales_history(sales_day);

explain analyze select sh.*, sum(sh.sales_amount) over(partition by sh.sales_day)
from sales_history as sh
where sh.sales_day between '2016-01-01' AND '2016-12-31';
/*
    -> Window aggregate with buffering: sum(sales_history.sales_amount) OVER (PARTITION BY sh.sales_day )
        (actual time=7.27..7.72 rows=608 loops=1)
    -> Sort: sh.sales_day  (cost=274 rows=608)
        (actual time=7.25..7.28 rows=608 loops=1)
    -> Index range scan on sh using idx_sales_history_sales_day over ('2016-01-01' <= sales_day <= '2016-12-31'),
        with index condition: (sh.sales_day between '2016-01-01' and '2016-12-31')  (cost=274 rows=608)
        (actual time=0.0752..6.9 rows=608 loops=1)
    
    -- インデックスを追加したが、処理時間がむしろ増加している。
    -- これは、インデックスレンジスキャンがウィンドウ関数に対して最適な方法でないためだと見て取れます。
        ウィンドウ関数の処理は全体的にテーブルをスキャンする必要があるため、インデックスが逆に負荷をかけてしまった結果です。
*/
