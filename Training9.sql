select database();
describe customers;

select * from customers where name is NULL;

#NULLじゃないデータを取り出せる。
select * from customers where name is not null limit 10;
select * from prefectures;

#nullを取り出す。
select * from prefectures where name is null;
 
 #unknownを取り出す。
 select * from prefectures where name = "";