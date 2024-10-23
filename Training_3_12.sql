use my_db4;

-- prefecturesテーブルの行数を取得（都道府県データの件数）
select count(*) from prefectures;

-- customersテーブルの行数を取得（顧客データの件数）
select count(*) from customers;

-- customersテーブルのprefecture_codeにインデックスを作成することで、都道府県コードでの検索が高速化されるので、
-- customersテーブルのprefecture_codeにインデックスを作成。
create index idx_customers_prefecture_code on customers(prefecture_code);


-- prefecturesテーブルに、customersテーブルに存在する都道府県コードのみを取得する（EXISTSを使用）
explain analyze
select * from prefectures as pr
where exists (select 1 from customers as ct where pr.prefecture_code = ct.prefecture_code);
/*
    -> Nested loop semijoin  (cost=266 rows=2293)
        (actual time=0.077..0.536 rows=41 loops=1)
    -> Table scan on pr  (cost=4.95 rows=47)
        (actual time=0.0319..0.0439 rows=47 loops=1)
    -> Covering index lookup on ct using idx_customers_prefecture_code (prefecture_code=pr.prefecture_code)  (cost=37.7 rows=48.8)
        (actual time=0.0103..0.0103 rows=0.872 loops=47)
    -- prefecturesテーブルをフルテーブルスキャンしてから、各行に対してcustomersテーブルでインデックスルックアップが行われている。
    -- EXISTS句は、条件が成立する最初の行が見つかればすぐに終了するため、効率が良い。
    -- 実際のパフォーマンスも良く、全体の実行時間は約0.536秒。
*/

-- prefecture_codeがcustomersテーブルに存在する行を取得（INを使用）
explain analyze
select * from prefectures as pr
where prefecture_code in (select prefecture_code from customers as ct where pr.prefecture_code = ct.prefecture_code);
/*
    -> Nested loop semijoin  (cost=266 rows=2293)
        (actual time=0.143..0.908 rows=41 loops=1)
    -> Table scan on pr  (cost=4.95 rows=47)
        (actual time=0.067..0.0865 rows=47 loops=1)
    -> Covering index lookup on ct using idx_customers_prefecture_code (prefecture_code=pr.prefecture_code)  (cost=37.7 rows=48.8)
        (actual time=0.0172..0.0172 rows=0.872 loops=47)
    -- IN句を使用したクエリも、結果的にEXISTS句と同じ処理が行われ、ネストされたループセミジョインが発生している。
    -- ただし、IN句は全体のリストを先に生成して比較するため、EXISTS句よりも遅くなる傾向がある。
    -- この例では、全体の実行時間が約0.908秒となっており、EXISTS句よりも若干時間がかかっている。
*/