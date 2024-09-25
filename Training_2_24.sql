use my_db3;

show tables;

drop table employees;

create table employees
(
     company_id int,             -- 会社ID（整数型）
    employee_code CHAR(8),      -- 従業員コード（8文字の固定長文字列）
    name varchar(255),          -- 従業員名（255文字までの可変長文字列）
    age int,                    -- 従業員の年齢（整数型）
    primary key (company_id, employee_code)  -- 主キー（会社IDと従業員コードの複合キー）
);

insert into employees (company_id, employee_code, name, age)
values 
    (1, '1000001', 'Taro', 20),  -- 1人目の従業員（会社ID 1、従業員コード '1000001'、名前 'Taro'、年齢 20）
    (1, '1000002', 'Taro', 20);  -- 2人目の従業員（会社ID 1、従業員コード '1000002'、名前 'Taro'、年齢 20）
    
select * from employees;

update employees set name = 'Jiro' where employee_code = '1000002';

select * from employees;

-- name列にUNIQUE制約を追加し、重複する名前が入らないようにする
alter table employees add constraint uniq_employees_name unique(name);
describe employees;

-- name列に対して付けられたUNIQUE制約を削除
alter table employees drop index uniq_employees_name;
describe employees;

-- 複合UNIQUE制約（nameとage列に対する）を追加
alter table employees add constraint uniq_employees_name_age unique(name , age);

select * from employees;

describe employees;

insert into employees(company_id, employee_code, name, age)
values
    (3, '1000003', 'Taro', 18);

 -- テーブルの作成文を表示（テーブルの詳細構造を確認するため）
show create table employees\G
