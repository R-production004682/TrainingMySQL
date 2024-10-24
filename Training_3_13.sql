use my_db4;

create table tmp{
    id int primary key,
    name varchar(50)
};

insert into tmp values
(1 , "A"),
(2 , "B"),
(3 , "C");

select * from tmp;


-- こんな重い処理をオンライン処理で実行していると、馬鹿にならないので、、、
select * from ct.id , SUM(sh.sales_amount) from customers as ct
inner join sales_history as sh
on ct.id = sh.customer_id
group by ct.id;

-- 夜間バッチを使用する
create table customer_summary as
select * from ct.id , SUM(sh.sales_amount) from customers as ct
inner join sales_history as sh
on ct.id = sh.customer_id
group by ct.id;