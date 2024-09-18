create database my_db3;
use my_db3;

-- usersテーブルの作成
create table users(
    id int primary key,              -- idカラム、主キーとして設定
    first_name VARCHAR(255),         -- first_nameカラム、255文字の可変長文字列
    last_name VARCHAR(255) default NULL  -- last_nameカラム、デフォルト値はNULL。NOT NULLを指定していないが、デフォルトはNULL
);

-- usersテーブルにデータを挿入。first_nameとlast_nameはNULLになる
insert into users(id) values(1);

-- usersテーブルの全データを表示
select * from users;

-- users_2テーブルの作成
create table users_2(
    id int primary key,              -- idカラム、主キー
    first_name VARCHAR(255),         -- first_nameカラム
    last_name VARCHAR(255) NOT NULL, -- last_nameカラムは必須で、NOT NULL制約
    age int default 0                -- ageカラム、デフォルト値は0
);

-- last_nameにデフォルト値がないので、insert時に必ず指定が必要
-- これによりエラーが発生する
insert into users_2 (id, first_name) values(1 , "Taro");
-- ERROR 1364 (HY000): Field 'last_name' does not have a default value

-- last_nameを指定してデータを挿入
insert into users_2 (id, first_name, last_name) values(1 , "Taro", "Yamada");

-- users_2テーブルの全データを表示
select * from users_2;

-- last_nameがNOT NULLなので、nullを挿入するとエラー
insert into users_2 values(2, "Jiro", "Suzuki", null);

-- login_usersテーブルの作成。emailにunique制約を設定
create table login_users
(
  id int primary key,              -- idカラム、主キー
  name varchar(255) not null,      -- nameカラム、必須
  email varchar(255) not null unique -- emailカラム、必須でunique制約を持つ
);

-- emailがunique制約を持っているため、同じemailを持つデータの挿入はエラーとなる
insert into login_users values (1, "shiro", "abb@mail.com");
insert into login_users values (2, "shiro", "abb@mail.com");
-- ERROR 1062 (23000): Duplicate entry 'abb@mail.com' for key 'login_users.email'

-- tmp_namesテーブルの作成。nameカラムにunique制約を設定
create table tmp_names
(
    name varchar(255) unique  -- nameカラム、unique制約あり
);

-- unique制約があるため、同じnameの値を挿入するとエラー
insert into tmp_names values("goro");

-- ただし、NULLの場合はunique制約が適用されないため、複数回挿入できる
insert into tmp_names values(null);  -- 成功
insert into tmp_names values(null);  -- 成功