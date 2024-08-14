select database();

use my_db;

create table people(
    id int PRIMARY KEY,
    name VARCHAR(50),
    birth_day DATE DEFAULT '1990-01-01'
);
#insert文1
insert into people values(1, 'Taro' , '2001-01-01');
select * from people;

#insert文2
insert into people(id , name) values(2 , 'jiro');
select * from people;
