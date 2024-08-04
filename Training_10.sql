select database();

describe customers;

#name が null のデータを抽出。
select * from customers where name is null;

select null = null;
select null is null;

#name が nullじゃないデータを抽出。
select * from customers where name is not null limit 10;

select * from prefectures limit 10;

#name が nullのデータだけを抽出
select * from prefectures where name is null;

#name が unknownのデータを抽出
select * from prefectures where name = "";
