show databases;
use my_db;

start transaction;
show tables;

select * from customers limit 10;

#主キーでUPDATE(行ロック)
#他のSQLがアクセスしないように制御できる。
update customers set age=43 where id=1;
ROLLBACK;

start transaction;

update customers set age=42 where name="河野 文典";

#delete
start transaction;
delete from customers where id = 1;

#insert
describe customers;
start transaction;
insert into customers values(1 , "田中 一郎", 21 , "1999-0-01");
select * from customers limit 10;

#selectのロック
#for share(共有ロック)
#for update(排他ロック)

start transaction;
#任意の行に、別のユーザーから更新できないようにしたいという場合には、for shareを使う
select * from customers where id=1 for share;

rollback;

start transaction;
select * from customers where id=1 for update;