use my_db4

explain analyze select * from customers;
-- -> Table scan on customers  (cost=200 rows=1971) (actual time=0.408..1.55 rows=2000 loops=1)

explain analyze select * from customers where id = 1;
-- ->Rows fetched before execution  (cost=0..0 rows=1) (actual time=700e-6..800e-6 rows=1 loops=1)

explain select * from customers where id = 1\G


explain analyze select * from customers where id > 10;
/*
   -> Filter: (customers.id > 10)  (cost=198 rows=985) 
   (actual time=0.0267..1.85 rows=1990 loops=1)
   
   -> Index range scan on customers using PRIMARY over (10 < id)  
   (cost=198 rows=985) (actual time=0.0226..1.65 rows=1990 loops=1)
*/

explain analyze select * from customers where first_name = "Olivia";
/*
   -> Filter: (customers.first_name = 'Olivia')  (cost=200 rows=197) (actual time=0.0943..1.52 rows=5 loops=1)
   -> Table scan on customers  (cost=200 rows=1971) (actual time=0.0902..1.35 rows=2000 loops=1)
*/

-- 上に比べて、格段に速くなっている
create Index idx_customer_first_name on customers(first_name);
explain analyze select * from customers where first_name = "Olivia";
/*
   -> Index lookup on customers using idx_customer_first_name (first_name='Olivia')  
   (cost=1.75 rows=5) (actual time=0.0491..0.0531 rows=5 loops=1)
*/


select * from customers limit 10;
describe customers;

select count(*) from customers where gender = 'F'; -- 1016人
select count(*) from customers where gender = 'M'; -- 984人

explain analyze select * from customers where gender = 'F';
/*
   -> Filter: (customers.gender = 'F')  (cost=200 rows=197) 
   (actual time=0.0789..1.7 rows=1016 loops=1)
   -> Table scan on customers  (cost=200 rows=1971)
    (actual time=0.0755..1.44 rows=2000 loops=1)
*/

-- 上に比べて、インデックスを付けると遅くなってしまった。
create Index idx_customers_gender on customers(gender);
explain analyze select * from customers where gender = 'F';
/*
 -> Index lookup on customers using idx_customers_gender (gender='F'), with index condition: (customers.gender = 'F')
 (cost=111 rows=1016) (actual time=0.257..2.71 rows=1016 loops=1)
*/

-- ヒント句を付けると若干早くなる。（下記はidx_customers_genderインデックスを使わないで。という意味合い）
explain analyze select * from customers as ct 
ignore index(idx_customers_gender) where ct.gender = 'F';
/*
 -> Filter: (ct.gender = 'F')  (cost=200 rows=986)
  (actual time=0.0812..1.62 rows=1016 loops=1)
 -> Table scan on ct  (cost=200 rows=1971)
  (actual time=0.0763..1.38 rows=2000 loops=1)
*/