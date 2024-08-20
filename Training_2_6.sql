use my_db;
describe employees;

#having
select department, avg(salary) from employees
group by
department having avg(salary) > 3980000;


select birth_place, age, count(*) from users
group by birth_place , age
having count(*) > 1
order by count(*);

#havingのみ
select "重複なし" as "redundancy check" from users
having count(distinct name) = count(name);
