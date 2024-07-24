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