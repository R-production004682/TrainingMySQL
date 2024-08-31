use my_db2;

select * from departments limit 10;
select * from employees limit 10;

# EXISTS
# employeesテーブルのdepartment_idがdepartmentsテーブルのidと一致する行を選択
select * from employees as em
where exists (
    select * from departments as dt where em.department_id = dt.id
);

# 上記のEXISTSをINで書き換えた場合のクエリ
# employeesテーブルのdepartment_idがdepartmentsテーブルのidと一致する行を選択
select * from employees as em
where em.department_id in (
    select id from departments
);

# 特定の部署（営業部、開発部）に所属する従業員を
# EXISTSを使って取得
select * from employees as em
where exists (
    select * from departments as dt
    where dt.name in(
        "営業部","開発部"   
    ) and em.department_id = dt.id
);


select * from customers limit 15;
select * from orders limit 10;
select * from employees limit 10;

# '2020-12-31' に注文がある顧客を取得する
# `customers` テーブルの各レコードについて、`orders` テーブルで条件に合致する注文が存在するかをチェック
select * from customers as ct
where exists(
    select * from orders as od
     where ct.id = od.customer_id and od.order_date = "2020-12-31"
) limit 10;

# '2020-12-31' に注文がない顧客を取得する
# `customers` テーブルの各レコードについて、`orders` テーブルで条件に合致する注文が存在しないかをチェック
select * from customers as ct
where not exists(
    select * from orders as od
     where ct.id = od.customer_id and od.order_date = "2020-12-31"
) limit 10;

# 各従業員のマネージャーが存在するかを確認し、存在する場合にその従業員を取得する
# `employees` テーブルの各レコードについて、別の `employees` テーブルでマネージャーIDに一致するレコードが存在するかをチェック
select * from employees as em1
where exists(
    select 1 from employees as em2 
    where em1.manager_id = em2.id
) limit 10;

# 各従業員のマネージャーが存在しない場合にその従業員を取得する
# `employees` テーブルの各レコードについて、別の `employees` テーブルでマネージャーIDに一致するレコードが存在しないかをチェック
select * from employees as em1
where not exists(
    select 1 from employees as em2 
    where em1.manager_id = em2.id
) limit 10;
