use my_db4;

explain analyze select * from customers as ct inner join prefectures as pr
on ct.prefecture_code = pr.prefecture_code\G

/*
*************************** 1. row ***************************
EXPLAIN: -> Nested loop inner join  (cost=890 rows=1971) (actual time=0.0723..2.88 rows=2000 loops=1)
    -> Filter: (ct.prefecture_code is not null)  (cost=200 rows=1971) (actual time=0.0568..1.19 rows=2000 loops=1)
        -> Table scan on ct  (cost=200 rows=1971) (actual time=0.056..1.05 rows=2000 loops=1)
    -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=689e-6..713e-6 rows=1 loops=2000)
*/