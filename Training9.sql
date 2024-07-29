select database();
describe customers;

select * from customers where name is NULL;

/* 指す意味は同じ
select null = null;
select null is null;
*/

#NULLじゃないデータを取り出せる。
select * from customers where name is not null limit 10;
select * from prefectures;

#nullを取り出す。
select * from prefectures where name is null;
 
 #unknownを取り出す。
 select * from prefectures where name = "";