use my_db2;


-- departmentsテーブルから「営業部」に属する従業員を取得するクエリ
-- employeesテーブルとdepartmentsテーブルを結合し、営業部に所属する従業員を取得する
select * from employees as e 
inner join departments as d
on e.department_id = d.id
where d.name = "営業部";


-- WITH句を使用して、営業部のデータをtmp_departmentsに保存し、employeesテーブルと結合して従業員データを取得
WITH tmp_departments as 
    (
         select * from departments where name = "営業部"
    ) 
select * from employees as e 
inner join tmp_departments
on e.department_id = tmp_departments.id;


-- storesテーブルからidが1, 2, 3の店舗を取り出す
-- itemsテーブルと結合し、さらにordersテーブルと結合する
-- ordersテーブルのorder_amount（注文数量）とorder_price（注文価格）を掛け合わせた合計金額を店舗名ごとに集計する
WITH tmp_stores as (
    -- storesテーブルから指定された店舗IDを抽出
    select * from stores
    where id in(1, 2, 3)
 ), tmp_items_orders as (
    -- itemsとordersテーブルを結合して、商品と注文の情報を店舗ごとに紐付ける
    select 
        items.id as item_id,                  -- 商品ID
        tmp_stores.id as store_id,            -- 店舗ID
        orders.id as order_id,                -- 注文ID
        orders.order_amount as order_amount,  -- 注文数量
        orders.order_price as order_price,    -- 注文価格
        tmp_stores.name as store_name         -- 店舗名
    from tmp_stores
        inner join 
            items on tmp_stores.id = items.store_id  -- itemsテーブルとstoresテーブルを結合
        inner join
            orders on items.id = orders.item_id      -- ordersテーブルとitemsテーブルを結合
 )
-- 店舗名ごとに注文金額（数量×価格）の合計を集計
select store_name, sum(order_amount * order_price) as total_sales 
from tmp_items_orders 
group by store_name;