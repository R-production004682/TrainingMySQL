select * from customers where is null;

#count
select count(*) from customers; #何行データが入っているか
select count(name) from customers; #列指定(この列に何行入っているか(NULLはカウントしない。))

select count(name) from customers where id > 80;

select * from customers limit 15;

#MAX: 最大, MIN : 最小
select max(age), min(age) from users where birth_place = "日本";
select max(birth_day), min(birth_day) from users;

#SUM: 合計値
select sum(salary) from employees;
select * from employees limit 15;
select avg(salary) from employees;

#avg: nullの場合が面倒
create table tmp_count(num int);
show tables;

insert into tmp_count values(1);
insert into tmp_count values(2);
insert into tmp_count values(3);
insert into tmp_count values(null);

select * from tmp_count;

#nullを含めないで平均を出す。
select avg(num) from tmp_count;

#nullを含めて平均を出す。
select avg(coalesce(num , 0)) from tmp_count;