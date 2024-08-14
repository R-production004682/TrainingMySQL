show tables;

#全レコード。全カラムを表示
select * from people;

#カラムの一部を表示
select id , birth_day from people;

select id as '番号' , name as '名前' from people;

#where句
select * from people where id = 1;

select name as '名前' , birth_day as '誕生日' from people where id = 1;

#名前の検索もできます。
select * from people where name = 'Taro';

#UPDATE文
update people set birth_day = "1900-01-01" , name = "";
select * from people;

#UPDATE where
update people set name = "Yamada" , birth_day = "2000-01-01" where id = 2;
update people set name = "Taro" , birth_day = "2000-01-01" where id = 3;

#DELETE レコード削除
DELETE from people where id = 2;

select * from people;

#DELETE 全削除
delete from people;

select * from people;