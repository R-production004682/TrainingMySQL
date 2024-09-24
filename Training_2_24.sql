use my_db3;

show tables;

drop table employees;

create table employees
(
    company_id int ,
    employee_code CHAR(8),
    name varchar(255),
    age int,
    primary key (company_id, employee_code)
);

insert into employees (company_id, employee_code, name, age)
values 
    (1, '1000001', 'Taro', 20),
    (1, '1000002', 'Taro', 20);

select * from employees;

update employees set name = 'Jiro' where employee_code = '1000002';

select * from employees;

alter table employees add constraint uniq_employees_name unique(name);
describe employees;

-- 制約一覧
select * from information_schema.key_column_usage
where table_name = 'employees'\G

-- unique制約の削除
alter table employees drop index uniq_employees_name;
describe employees;

-- unique制約の追加
alter table employees add constraint uniq_employees_name_age unique(name , age);
select * from employees;
describe employees;

insert into employees(company_id, employee_code, name, age)
values
    (3, '1000003', 'Taro', 18);

select * from employees;

show create table employees\G
