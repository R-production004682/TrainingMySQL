use my_db4;

explain analyze select * from customers where first_name="Olivia";
/*
    -> Filter: (customers.first_name = 'Olivia')  (cost=200 rows=197)
        (actual time=0.0746..1.58 rows=5 loops=1)
    -> Table scan on customers  (cost=200 rows=1971)
        (actual time=0.0703..1.42 rows=2000 loops=1)

-- テーブルスキャンが発生し、全体のパフォーマンスが悪い。約2000行に対してフィルタをかけて5行が抽出されている。
*/

-- 「first_name」にインデックスを作成し、クエリのパフォーマンス向上を図る。
create index idx_customers_first_name on customers(first_name);
explain analyze select * from customers where first_name = "Olivia";
/*
    -> Index lookup on customers using idx_xustomers_first_name (first_name='Olivia')  
        (cost=1.75 rows=5) (actual time=0.0492..0.0536 rows=5 loops=1)

-- インデックスを使うことで、クエリの実行時間がテーブルスキャンよりも大幅に短縮。
*/

-- 「age=41」に対するクエリ。インデックスがないため、テーブルスキャンが発生。
explain analyze select * from customers where age = 41;
/*
    -> Filter: (customers.age = 41)  (cost=200 rows=197) 
        (actual time=0.0762..0.683 rows=35 loops=1)
    -> Table scan on customers  (cost=200 rows=1971)
        (actual time=0.0666..0.615 rows=2000 loops=1)

-- ageに対するインデックスがないため、テーブル全体をスキャンしている。
*/

-- 「age」にインデックスを作成し、クエリのパフォーマンスを改善。
create index idx_customers_age on customers(age);
explain analyze select * from customers where age = 41;
/*
    -> Index lookup on customers using idx_customers_first_name (age=41)  (cost=12.2 rows=35) 
        (actual time=0.0567..0.0618 rows=35 loops=1)

 -- 「age」に対してインデックスが使用され、実行時間が短縮。
*/

-- 複数条件クエリ。インデックスを使ったクエリだが、実行結果は「rows=0」となっている。
explain analyze select * from customers where first_name = "Olivia" and age = 42;
/*
    -> Filter: ((customers.age = 42) and (customers.first_name = 'Olivia'))  (cost=1.63 rows=1)
        (actual time=0.0931..0.0931 rows=0 loops=1)
    -> Intersect rows sorted by row ID  (cost=1.63 rows=1)
        (actual time=0.0916..0.0916 rows=0 loops=1)

-- 条件に合うデータが存在しないため、rows=0が返されている。

    -> Index range scan on customers using idx_xustomers_first_name over (first_name = 'Olivia')  (cost=0.893 rows=5)
        (actual time=0.0598..0.061 rows=5 loops=1)
    -> Index range scan on customers using idx_customers_first_name over (age = 42)  (cost=0.641 rows=42)
        (actual time=0.0136..0.0247 rows=42 loops=1)
*/

-- 「first_name='Olivia'」または「age=42」に対するOR条件のクエリ。
-- 両方のインデックスが使用されているが、データの重複を排除する処理も発生。
explain analyze select * from customers where first_name = "Olivia" or age = 42;
/*
    -> Filter: ((customers.first_name = 'Olivia') or (customers.age = 42))  (cost=21.1 rows=47)
        (actual time=0.123..0.254 rows=47 loops=1)
    -> Deduplicate rows sorted by row ID  (cost=21.1 rows=47)
        (actual time=0.119..0.24 rows=47 loops=1)

    -> Index range scan on customers using idx_xustomers_first_name over (first_name = 'Olivia')  (cost=1.4 rows=5)
        (actual time=0.0733..0.0774 rows=5 loops=1)
    -> Index range scan on customers using idx_customers_first_name over (age = 42)  (cost=4.85 rows=42)
        (actual time=0.0259..0.0512 rows=42 loops=1)

-- OR条件のため、複数のインデックスが使用されつつ、重複した結果を排除する処理が加わる。
*/


drop index idx_customers_first_name on customers;
drop index idx_customers_age on customers;

-- 複合インデックス
create index idx_customers_first_name_age on customers(first_name, age);


-- 複合インデックスを利用したAND条件のクエリ。非常に効率的に処理される。
explain analyze select * from customers where first_name = "Olivia" and age = 42;
/*
    -> Index lookup on customers using idx_customers_first_name_age (first_name='Olivia', age=42)  (cost=0.35 rows=1)
        (actual time=0.012..0.012 rows=0 loops=1)

-- 複合インデックスを利用することで、クエリのパフォーマンスが向上。ただし、結果はrows=0。
*/


-- 複合インデックスは「first_name, age」の順で作成しているため、
-- 「age=42」単体の条件ではインデックスが使用されず、テーブルスキャンが発生
explain analyze select * from customers where age = 42;
/*
    -> Filter: (customers.age = 42)  (cost=200 rows=197)
        (actual time=0.266..1.34 rows=42 loops=1)
    -> Table scan on customers  (cost=200 rows=1971)
        (actual time=0.151..1.22 rows=2000 loops=1)

    -- 複合インデックスは「first_name, age」の順に使用されるため、「age」単体のクエリではインデックスが使われない。
*/


-- OR条件では複合インデックスが利用されず、テーブルスキャンが発生。
explain analyze select * from customers where first_name = "Olivia" or age = 42;
/*
    -> Filter: ((customers.first_name = 'Olivia') or (customers.age = 42))
        (cost=200 rows=201) (actual time=0.125..1.34 rows=47 loops=1)
    -> Table scan on customers  (cost=200 rows=1971)
        (actual time=0.117..1.14 rows=2000 loops=1)

-- OR条件のクエリでは、複合インデックスが活用されず、テーブルスキャンが発生することが多い。
*/

-- まず、インデックスなしの状態で、ORDER BYを使ったクエリのパフォーマンスを検証。
-- インデックスがないため、テーブル全体をスキャンし、ソートが行われている。
drop index idx_customers_first_name_age on customers;
explain analyze select * from customers order by first_name;
/*
    -> Sort: customers.first_name  (cost=200 rows=1971)
        (actual time=1.45..1.62 rows=2000 loops=1)
    -> Table scan on customers  (cost=200 rows=1971)
        (actual time=0.0484..0.736 rows=2000 loops=1)
    -- テーブルスキャン後にソートが実行されており、2000行の処理に約1.62秒かかっている。
    -- ソートコストが高く、最適化の余地がある。
*/

-- first_nameに対してインデックスを追加。
-- しかし、ソート処理が依然として発生し、パフォーマンスの改善はあまり見られない。
create index idx_customers_first_name on customers(first_name);
explain analyze select * from customers order by first_name;
/*
    -> Sort: customers.first_name  (cost=200 rows=1971)
        (actual time=2.62..2.89 rows=2000 loops=1)
    -> Table scan on customers  (cost=200 rows=1971)
        (actual time=0.0727..1.35 rows=2000 loops=1)
    -- インデックスが追加されたが、テーブルスキャンが発生しており、ソートのために時間がかかっている。
    -- 実行時間がむしろ増えていることから、ORDER BYに対するインデックスの効果が限定的であることがわかる。
*/

-- GROUP BYで集計する場合、first_nameにインデックスを張ることでパフォーマンスを向上できるかを検証。
-- インデックスを活用して、集計処理が高速化されている。
explain analyze select first_name , count(*) from customers group by first_name;
/*
    -> Group aggregate: count(0)  (cost=397 rows=468)
        (actual time=0.185..1.34 rows=468 loops=1)
    -> Covering index scan on customers using idx_customers_first_name  (cost=200 rows=1971)
        (actual time=0.165..0.93 rows=2000 loops=1)
    -- first_nameに対するインデックスが利用され、インデックススキャンを活用している。
    -- パフォーマンスは約1.34秒と改善されたが、さらなる最適化の余地がある。
*/

-- 今度はageに対してインデックスを作成し、GROUP BYのパフォーマンスを確認。
create index idx_customers_age on customers(age);
explain analyze select age , count(*) from customers group by age;
/*
    -> Group aggregate: count(0)  (cost=397 rows=49)
        (actual time=0.0796..0.78 rows=49 loops=1)
    -> Covering index scan on customers using idx_customers_age  (cost=200 rows=1971)
        (actual time=0.0599..0.643 rows=2000 loops=1)
    -- ageに対してインデックスを張った結果、GROUP BYの集計処理が約0.78秒に短縮された。
    -- 複数カラムでのインデックスを使えば、さらに効率化が期待できる。
*/

-- first_nameとageの複合インデックスを作成し、GROUP BYを複数カラムに対して実施。
drop index idx_customers_first_name on customers;
drop index idx_customers_age on customers;

-- 複合インデックスでの最適化を試す。
create index idx_customers_first_name_age on customers(first_name, age);
explain analyze select first_name, age , count(*) from customers group by first_name, age;
/*
    -> Group aggregate: count(0)  (cost=397 rows=1829)
        (actual time=0.0446..0.588 rows=1829 loops=1)
    -> Covering index scan on customers using idx_customers_first_name_age  (cost=200 rows=1971)
        (actual time=0.0367..0.326 rows=2000 loops=1)
    -- first_nameとageの複合インデックスを作成することで、GROUP BYの処理が0.588秒まで大幅に短縮された。
    -- インデックススキャンが有効に機能しており、パフォーマンス改善が確認できる。
*/

drop index idx_customers_first_name_age on customers;


-- 外部キーに対してインデックスを適用し、JOINのパフォーマンスを検証。
-- インデックスなしの状態では、結合処理に多くの時間がかかる。
explain analyze select * from prefectures as pr
inner join customers as ct
on pr.prefecture_code = ct.prefecture_code and pr.name = "北海道";
/*
    -> Nested loop inner join  (cost=890 rows=197)
        (actual time=9.46..9.46 rows=0 loops=1)
    -> Filter: (ct.prefecture_code is not null)  (cost=200 rows=1971)
        (actual time=0.0897..1.57 rows=2000 loops=1)
    -> Table scan on ct  (cost=200 rows=1971)
        (actual time=0.0885..1.4 rows=2000 loops=1)
    -> Filter: (pr.`name` = '北海道')  (cost=0.25 rows=0.1)
        (actual time=0.00384..0.00384 rows=0 loops=2000)
    -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1)
        (actual time=0.00359..0.00362 rows=1 loops=2000)
    -- インデックスがないため、結合処理に多くの時間がかかっており、外部キーの結合が最適化されていない。
    -- ネステッドループでの結合が行われ、各ループでテーブルスキャンが発生している。
*/

-- customersテーブルの外部キー（prefecture_code）にインデックスを追加して、JOIN処理のパフォーマンスを向上させる。
create index idx_customers_prefecture_code on customers(prefecture_code);
explain analyze select * from prefectures as pr
inner join customers as ct
on pr.prefecture_code = ct.prefecture_code and pr.name = "北海道";
/*
    -> Nested loop inner join  (cost=73.4 rows=226)
        (actual time=5.52..5.52 rows=0 loops=1)
    -> Filter: (pr.`name` = '北海道')  (cost=4.95 rows=4.7)
        (actual time=5.52..5.52 rows=0 loops=1)
    -> Table scan on pr  (cost=4.95 rows=47)
        (actual time=5.5..5.51 rows=47 loops=1)
    -> Index lookup on ct using idx_customers_prefecture_code (prefecture_code=pr.prefecture_code)  (cost=10.8 rows=48.1)
        (never executed)
    -- prefecture_codeにインデックスを追加したことで、結合時の処理が最適化されたが、
    -- 依然として「北海道」という条件で絞り込んだ際のデータがないため、結果はrows=0。
    -- ただし、インデックスを利用したネステッドループの効率が向上している。
*/

drop index idx_customers_prefecture_code on customers;
