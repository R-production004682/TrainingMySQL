show databases;

use my_db3;

show tables;

-- "schools"テーブルを作成する
-- このテーブルは学校の情報を保持し、"id"が主キーとなる
create table schools
(
    id int primary key,  -- 学校のID。主キーとして一意でNULLを許さない
    name VARCHAR(255)    -- 学校名。最大255文字の文字列
);

-- "students"テーブルを削除する
-- 注意：この操作はテーブルを完全に削除し、データも失われる
drop table students;

-- "students"テーブルを新たに作成する
-- このテーブルは生徒の情報を保持し、"school_id"が外部キーとして"schools"テーブルを参照する
create table students
(
    id int primary key,                  -- 生徒のID。主キーとして一意でNULLを許さない
    name VARCHAR(255),                   -- 生徒名。最大255文字の文字列
    age int,                             -- 生徒の年齢
    school_id int,                       -- 外部キーとして学校のIDを参照
    foreign key(school_id) references schools(id)  -- "schools"テーブルの"id"を参照する外部キー
);

-- "schools"テーブルにデータを挿入する
insert into schools (id, name)
values
    (1, "北高校");

-- "students"テーブルにデータを挿入する
-- "school_id"が存在する"schools"テーブルのIDを参照しているため、エラーは発生しない
insert into students (id, name, age, school_id)
values
    (1, "Taro", 18, 1);

-- 以下の操作は参照整合性エラーが発生する可能性があるため注意が必要

-- "schools"テーブルのIDを更新しようとすると、"students"テーブルの外部キーとの整合性が取れなくなりエラーが発生する
update schools set id = 2;

-- "schools"テーブルの削除は、関連する"students"のレコードがある場合にエラーを引き起こす
delete from schools;

-- "students"テーブルの"school_id"を存在しないIDに更新すると参照整合性エラーが発生する
update students set school_id = 3;

-- "employees"テーブルの構造を表示する
describe employees;

-- "salaries"テーブルを作成する
-- このテーブルは給与情報を保持し、複数のカラムを外部キーとして参照する
create table salaries
(
    id int primary key,                             -- 給与のID。主キー
    company_id int,                                 -- 会社のID
    employee_code CHAR(8),                          -- 従業員コード（8文字）
    payment int,                                    -- 支払い金額
    paid_date date,                                 -- 支払日
    foreign key (company_id, employee_code) references employees(company_id, employee_code)  
    -- "employees"テーブルの"company_id"と"employee_code"を参照する外部キー
);

-- "employees"テーブルからすべてのデータを選択する
select * from employees;

-- "salaries"テーブルにデータを挿入する
-- 参照する"employees"テーブルに存在する組み合わせでなければ挿入時にエラーが発生する
insert into salaries (id, company_id, employee_code, payment, paid_date)
values
    (1, 1, "00000003", 1000, "2020-01-01");