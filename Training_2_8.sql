show tables;

#従業員一覧
select * from employees;

#部署一覧
select * from departments;

#INで絞り込む
select * from employees where department_id in(1 , 2); 

#副問い合わせを使う
select * from departments where name in("経営企画部" , "営業部");

#副問い合わせを取り出す方法
select * from employees where department_id in
 (select id from departments where name in("経営企画部" , "営業部"));

 #上の結果を反転させて取り出す方法
select * from employees where department_id not in
 (select id from departments where name in("経営企画部" , "営業部"));


select * from students limit 10;
select * from users limit 10;

#複数カラムのIN(副問い合わせ)
select * from students
where(first_Name, last_Name) in
(select first_Name, last_Name from users) limit 10;


#副問い合わせ : 集計と使う
select max(age) from employees;

select * from employees where age < (select max(age) from employees);