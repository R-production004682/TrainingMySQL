#算術演算子

# + , - , * , / , %
select 1 + 1;

use my_db;
select name, age , age + 3 from users limit 10; #実年齢に3歳足した数値にする

select 10 - 5;
select name, age , age - 1 as age_1 from users limit 10;#実年齢に-1した数値にする。
select birth_day, birth_day+2 from users limit 10;#誕生日を変更してみる

select 3 * 5;
select * from employees limit 10;
select department, name, salary ,salary * 1.1 as salary_next_year from employees limit 10;#現在の年収と、来年の年収を表示

select 10 / 3;
select salary / 10 from employees limit 10;

select 10 % 3; 
select age % 12 from users limit 10;

#concat(文字の連結) ||
select concat(department,':',name) as "部署 : 名前" from employees;
select concat(name , "(", age , ")") as "名前(年齢)" from users;#名前（年齢）のような出力をする

#NOW , CURDATE , DATE_FORMAT
select NOW(); #現在時刻
select NOW(), name , age from users limit 10; #計測時間付きでデータを出力する。

select CURDATE();#日付
select DATE_FORMAT(NOW() , "%Y/%m/%d %H");
