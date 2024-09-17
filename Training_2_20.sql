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

-- SELECTを用いたINSERT
select * from customers limit 10;
select * from orders limit 10;

create table customer_orders
(
    name VARCHAR(255),
    order_date DATE,
    sales INT,
    total_sales INT
);

insert into customer_orders
select 
    concat(ct.last_name, ct.first_name) as 名前,
    od.order_date as 購入日,
    od.order_amount * od.order_price as 購入した金額,
    sum(od.order_amount * od.order_price) over (partition by concat(ct.last_name, ct.first_name) order by od.order_date) as 合計金額
from customers as ct
inner join orders as od 
on ct.id = od.customer_id limit 30;

select * from customer_orders;
