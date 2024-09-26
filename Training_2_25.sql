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


show create table students\G

-- idは自動増分(auto_increment)で、nameは動物の名前を格納する。
create table animals
(
    id int primary key auto_increment comment '主キーのID(INT型)です。',
    name varchar(50) not null comment '動物の名前です。'
);

-- 各列の詳細情報（カラムの定義やコメント）を表示。
show full columns from animals\G

-- idは自動生成され、"Deg"という名前が登録。
insert into animals values(null, "Deg");

-- animalsテーブル内のすべてのデータを表示。
select * from animals;

-- idを自動生成し、"Cat"という名前を挿入。
insert into animals(name) values("Cat");

-- 次に割り当てられるauto_incrementの値を確認。
select auto_increment from information_schema.tables 
where table_name = "animals";

-- idが4の行を挿入。指定されたidを使ってデータを挿入する。
INSERT into animals values(4 , "Panda");

-- 自動増分を使用して、"Flish"という名前を挿入。
INSERT into animals values(null , "Flish");

-- 自動増分の初期値を100に変更。次に挿入されるidは100から始まる。
alter table animals auto_increment = 100;

-- 自動増分のidで"Bird"を挿入。
insert into animals values(null, "Bird");

-- テーブルの全データを再度確認。
select * from animals;

-- 複数の動物名を一度に挿入。UNION ALLを使って複数の行を同時に挿入する例です。
insert into animals(name)
select "Snake" 
union all
select "Dino"
union all
select "Gibra";

-- animalsテーブル内の既存のnameを再度挿入。テーブル内のデータを再利用して挿入する例です。
insert into animals(name)
select name from animals;

-- 最終的に全データを確認。
select * from animals;