use my_db3;

describe customers; 

-- customersテーブルに1件データを挿入 (id=1, name='Taro', age=21)
insert into customers (id, name , age)
values 
    (1 , 'Taro' , 21);

select * from customers;

show create table customers\G -- customersテーブルのCREATE文を表示

-- customers_chk_1 という制約を削除
alter table customers drop constraint customers_chk_1;

describe customers;

-- customersテーブルにあるageカラムのデフォルト値を20に設定
alter table customers 
alter age set default 20;

-- ageカラムを指定せずにデータを挿入。デフォルト値が適用される (id=2, name='Jiro', age=20)
insert into customers(id , name) 
values
     (2, 'Jiro');

select * from customers;

-- nameカラムにnot null制約を追加 (nameはnull不可)
alter table customers modify name varchar(255) not null;

describe customers;

-- nameにnullを挿入しようとすると、not null制約によりエラーが発生する
insert into customers(id, name) values(3, null); -- エラーが発生する

-- check制約を追加しようとするが、既にageが20以下のデータが存在するためエラーが発生
alter table customers add constraint check_age check (age > 20); -- エラーが発生

-- 代わりにageが20以上であればOKとするチェック制約を追加 (これなら既存データに問題なし)
alter table customers add constraint check_age check (age >= 20);

describe customers; 

-- 主キーを一度削除
alter table customers drop primary key;

-- idカラムを主キーとして再度追加
alter table customers
add constraint pk_customers primary key (id);

describe customers; 

-- studentsテーブルの構造を確認
describe students;

-- studentsテーブルのCREATE文を表示
show create table students\G

-- 外部キー制約students_ibfk_1を削除
alter table students drop constraint students_ibfk_1;

-- studentsテーブルのschool_idカラムに外部キー制約を追加
-- これはschoolsテーブルのidカラムを参照する外部キー制約
alter table students
add constraint fk_schools_students
foreign key (school_id) references schools(id);

-- studentsテーブルの構造を確認
show create table students\G