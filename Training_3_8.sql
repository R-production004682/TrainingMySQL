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