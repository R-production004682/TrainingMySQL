-- データベース my_db2 を使用
use my_db2;

-- employees テーブルの全データを取得
select * from employees;

-- id が 1 の従業員の年齢を 1 増やす
update employees set age = age + 1 where id = 1;

-- 再度、employees テーブルの全データを取得
select * from employees;

-- 営業部に所属する従業員を取得
select * from employees as emp
where emp.department_id = (select id from departments where name = "営業部");

-- 営業部に所属する従業員の年齢を 2 増やす
update employees as emp
set emp.age = emp.age + 2
where
emp.department_id = (select id from departments where name = "営業部");

-- employees テーブルに department_name 列を追加
alter table employees add department_name varchar(255);

-- LEFT JOIN を使って、employees と departments を結合し
-- 部門名が NULL の場合には "不明" として表示
select emp.*, coalesce(dt.name, "不明") 
from employees as emp
left join departments as dt
on emp.department_id = dt.id;

-- LEFT JOIN を使って従業員の部門名を "不明" または実際の部門名に更新
update employees as emp
left join departments as dt
on emp.department_id = dt.id
set emp.department_name = coalesce(dt.name, "不明");
