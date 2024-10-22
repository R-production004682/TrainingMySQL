use my_db4;

-- 無駄なGROUP BY
explain analyze select
age, count(*) from customers group by age
having age < 30;
/*
    -> Filter: (customers.age < 30)
        (actual time=3.94..3.94 rows=8 loops=1)
    -> Table scan on <temporary>
        (actual time=3.93..3.93 rows=49 loops=1)
    -> Aggregate using temporary table
        (actual time=3.93..3.93 rows=49 loops=1)
    -> Table scan on customers  (cost=204 rows=2000)
        (actual time=1.1..2.69 rows=2000 loops=1)
*/

explain analyze select
age, count(*) from customers where age < 30
group by age;
/*
    -> Table scan on <temporary>
        (actual time=1.02..1.02 rows=8 loops=1)
    -> Aggregate using temporary table
        (actual time=1.02..1.02 rows=8 loops=1)
    -> Filter: (customers.age < 30)  (cost=204 rows=667)
        (actual time=0.0887..0.89 rows=321 loops=1)
    -> Table scan on customers  (cost=204 rows=2000)
        (actual time=0.083..0.74 rows=2000 loops=1)
*/

create index idx_customers_age on customers(age);
explain analyze select
age, count(*) from customers where age < 30
group by age;
/*
    -> Group aggregate: count(0)  (cost=97.1 rows=49)
        (actual time=0.0342..0.1 rows=8 loops=1)
    -> Filter: (customers.age < 30)  (cost=65 rows=321)
        (actual time=0.0164..0.0874 rows=321 loops=1)
    -> Covering index range scan on customers using idx_customers_age over (NULL < age < 30)  (cost=65 rows=321)
        (actual time=0.0152..0.0733 rows=321 loops=1)
*/
drop index idx_customers_age on customers;

-- MAX, MINはインデックスを利用する。
--インデックスなし
explain analyze select max(age), min(age) from customers;
/*
    -> Aggregate: max(customers.age), min(customers.age)  (cost=404 rows=1)
        (actual time=0.835..0.835 rows=1 loops=1)
    -> Table scan on customers  (cost=204 rows=2000)
        (actual time=0.0612..0.613 rows=2000 loops=1)
*/

-- インデックスあり
create index idx_customers_age on customers(age);
explain analyze select max(age), min(age) from customers;
/*
    -> Rows fetched before execution  (cost=0..0 rows=1)
        (actual time=200e-6..300e-6 rows=1 loops=1)
*/

-- ただし、avgやsumはインデックスが使用されないので注意（全部計算しなきゃいけないからフルスキャンになる）
explain analyze select max(age), min(age), avg(age) from customers;
/*
    -> Aggregate: avg(customers.age)  (cost=404 rows=1)
        (actual time=1.4..1.4 rows=1 loops=1)
    -> Covering index scan on customers using idx_customers_age  (cost=204 rows=2000)
        (actual time=0.0385..0.506 rows=2000 loops=1)
*/

-- DISTINCTの代わりにEXISTSを使う
explain analyze select distinct pr.name from prefectures as pr
inner join customers as ct
on pr.prefecture_code = ct.prefecture_code;
/*
    -> Table scan on <temporary>  (cost=1104..1131 rows=2000)
        (actual time=8.45..8.45 rows=1 loops=1)
    -> Temporary table with deduplication  (cost=1104..1104 rows=2000)
        (actual time=8.45..8.45 rows=1 loops=1)
    -> Nested loop inner join  (cost=904 rows=2000)
        (actual time=0.0766..2.66 rows=2000 loops=1)
    -> Filter: (ct.prefecture_code is not null)  (cost=204 rows=2000)
        (actual time=0.0607..1.06 rows=2000 loops=1)
    -> Table scan on ct  (cost=204 rows=2000)
        (actual time=0.0596..0.928 rows=2000 loops=1)
    -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1)
        (actual time=655e-6..676e-6 rows=1 loops=2000)
*/


explain analyze select name from prefectures as pr
where exists ( select 1 from customers as ct where pr.prefecture_code = ct.prefecture_code );
/*
    -> Nested loop inner join  (cost=9410 rows=94000)
        (actual time=1.4..1.44 rows=41 loops=1)
    -> Table scan on pr  (cost=4.95 rows=47)
        (actual time=0.146..0.155 rows=47 loops=1)
    -> Single-row index lookup on <subquery2> using <auto_distinct_key> (prefecture_code=pr.prefecture_code)
        (cost=404..404 rows=1) (actual time=0.027..0.0271 rows=0.872 loops=47)
    -> Materialize with deduplication  (cost=404..404 rows=2000)
        (actual time=1.24..1.24 rows=41 loops=1)
    -> Filter: (ct.prefecture_code is not null)  (cost=204 rows=2000)
        (actual time=0.0521..0.848 rows=2000 loops=1)
     -> Table scan on ct  (cost=204 rows=2000)
        (actual time=0.0503..0.668 rows=2000 loops=1)
*/

-- UNIONの代わりにUNION ALL
explain analyze select * from customers where age < 30
UNION
SELECT * from customers where age > 50;
/*
    -> Table scan on <union temporary>  (cost=461..477 rows=1126)
        (actual time=5.79..5.94 rows=1126 loops=1)
    -> Union materialize with deduplication  (cost=461..461 rows=1126)
        (actual time=5.78..5.78 rows=1126 loops=1)
    -> Index range scan on customers using idx_customers_age over (NULL < age < 30), with index condition: (customers.age < 30)
        (cost=145 rows=321) (actual time=0.0713..1.9 rows=321 loops=1)
    -> Filter: (customers.age > 50)  (cost=204 rows=805)
        (actual time=0.0813..1.73 rows=805 loops=1)
    -> Table scan on customers  (cost=204 rows=2000)
        
        (actual time=0.0789..1.52 rows=2000 loops=1)
*/