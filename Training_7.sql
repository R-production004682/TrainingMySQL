show tables;

describe people;

alter table people add age int after name;

select * from  people;

describe people;

insert into people values(1 , "John" , 18 , "2001-01-01");
insert into people values(2 , "Alice" , 15 , "2003-01-01");
insert into people values(3 , "Paul" , 19 , "2000-01-01");
insert into people values(4 , "Chris" , 17 , "2002-01-01");
insert into people values(5 , "Vette" , 20 , "1999-01-01");
insert into people values(6 , "Tsuyoshi" , 21 , "1998-01-01");

select * from people;

#年齢順で並べ替える。（昇順）
select * from people order by age;

#年齢順で並べ替える。（降順）
select * from people order by age desc;

#2つカラム
select * from people order by birth_day , name;

insert into people values(7 , "Ayaka" , 18 , "2001-01-01");
insert into people values(8 , "Yamaoka" , 20 , "1999-01-01");

select birth_day from people;
#DISTINCT
select distinct birth_day from people;

#LIMITは最初の行だけ表示
select * from people limit 3;#最初の3レコードのみ抽出

＃飛ばして表示
select * from people limit 3 , 5;
#または、
select * from people limit 5 offset 3;
