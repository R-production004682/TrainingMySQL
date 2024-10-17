use my_db4;

-- インデックスがない状態で、「first_name」に関数upper()を使用した検索を実行
explain analyze select * from customers where upper(first_name) = "JOSEPH";
/*
    -> Filter: (upper(customers.first_name) = 'JOSEPH')  (cost=200 rows=1971)
        (actual time=0.0654..1.16 rows=15 loops=1)
    -> Table scan on customers  (cost=200 rows=1971)
        (actual time=0.0583..0.948 rows=2000 loops=1)
    -- インデックスがないため、テーブル全体をスキャンするフルテーブルスキャンが発生。
    -- 実行時間は約1.16秒で、2000行のデータに対して15行がフィルタされた。
*/

-- 「first_name」に対してインデックスを追加
-- ただし、upper()関数を使用しているため、このインデックスは使用されない
create index idx_customers_first_name on customers(first_name);
explain analyze select * from customers where upper(first_name) = "JOSEPH";
/*
    -> Filter: (upper(customers.first_name) = 'JOSEPH')  (cost=200 rows=1971)
        (actual time=0.048..0.855 rows=15 loops=1)
    -> Table scan on customers  (cost=200 rows=1971)
        (actual time=0.0426..0.696 rows=2000 loops=1)
    -- インデックスを追加しても、upper()関数を使用しているため、依然としてフルテーブルスキャンが発生している。
    -- 実行時間は若干短縮されたが、根本的な問題は解決していない。
*/

-- upper()を使った値に対してインデックスを作成することで、関数を使った検索にもインデックスを利用可能にする
create index idx_customers_lower_first_name on customers((upper(first_name)));
explain analyze select * from customers where upper(first_name) = "JOSEPH";
/*
    -> Index lookup on customers using idx_customers_lower_first_name (upper(first_name)='JOSEPH')  (cost=5.25 rows=15)
        (actual time=0.118..0.124 rows=15 loops=1)
    -- upper()関数に対してインデックスを作成したため、インデックススキャンが利用され、実行時間が大幅に改善。
    -- 15行をわずか0.124秒で取得でき、フルテーブルスキャンが回避された。
*/

-- IN句を使って異なる大文字小文字のバリエーションを検索
explain analyze select * from customers where first_name in ("joseph", "Joseph", "JOSEPH");
/*
    -> Index range scan on customers using idx_customers_first_name over (first_name = 'joseph'), with index condition: (customers.first_name in ('joseph','Joseph','JOSEPH'))  (cost=7.01 rows=15)
        (actual time=0.129..0.172 rows=15 loops=1)
    -- インデックスを使った範囲スキャンが実行され、複数の大文字小文字のバリエーションに対する検索も効率的に行われる。
    -- 実行時間は0.172秒と、upper()を使ったクエリに比べても良好なパフォーマンス。
*/

-- 追加したインデックスを削除
drop index idx_customers_first_name on customers;
drop index idx_customers_lowner_first_name on customers;

-- ageカラムに対してインデックスを作成し、検索のパフォーマンスを検証
create index idx_customers_age on customers(age);
explain analyze select * from customers where age = 25;
/*
    -> Index lookup on customers using idx_customers_age (age=25)  (cost=12.9 rows=37)
        (actual time=0.196..0.208 rows=37 loops=1)
    -- ageカラムに対するインデックスが正しく利用され、インデックススキャンにより37行のデータを約0.2秒で取得。
    -- フルテーブルスキャンと比較して、パフォーマンスが大幅に向上。
*/

-- age+2のようにカラムに対して計算を行うと、インデックスが無効化されフルスキャンが発生
explain analyze select * from customers where age + 2 = 25;
/*
    -> Filter: ((customers.age + 2) = 25)  (cost=204 rows=2000)
        (actual time=0.278..1.6 rows=35 loops=1)
    -> Table scan on customers  (cost=204 rows=2000)
        (actual time=0.134..1.43 rows=2000 loops=1)
    -- ageカラムに対して計算を行うとインデックスが無効化され、フルテーブルスキャンが発生。
    -- 実行時間は1.6秒と、ageそのものを使った場合よりも大幅に遅くなっている。
*/