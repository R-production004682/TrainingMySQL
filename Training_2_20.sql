select * from employees limit 10;
select * from stores limit 10;

-- withを使ったUPDATE処理
alter table stores add all_sales int;

select * from stores limit 10;
select * from items  limit 10;
select * from orders limit 10;

-- withを使ったUPDATE処理 
-- 一時テーブル (tmp_sales) を使った店舗の売上合計を更新する処理
with tmp_sales as 
(
    -- 商品IDごとに対応する注文の合計金額を店舗単位で集計
    select it.store_id, sum(od.order_amount * od.order_price) as summary
    from items as it
    inner join orders as od 
    on it.id = od.item_id
    group by it.store_id
)
-- 集計結果を使って、storesテーブルのall_sales列を更新
update stores as st
inner join tmp_sales as ts
on st.id = ts.store_id
set st.all_sales = ts.summary;

-- DELETE
-- "開発部" 部署に所属する従業員を削除
delete from employees
where department_id in 
(
    -- "開発部" 部署に該当するIDを取得
    select id from departments where name = "開発部"
);
