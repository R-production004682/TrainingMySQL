#length , char_length
select length("ABC");
select length("あいう");

select name, length(name) from users limit 10;

select char_length("ABC");
select char_length("あいう") as length;

select name, char_length(name) from users;

#TRIM, LTRIM, RTRIM 空白削除
select LTRIM("  ABC  ") as text;
select RTRIM("  ABC  ") as text;
select TRIM("  ABC  ") as text;

select name , char_length(name) as name_length from employees
 where char_length(name) <> char_length(TRIM(name));
#nameの方は、日本人の場合、空白を入れたら5文字なのにもかかわらず、name_lengthでは7文字と表示される。

#updateして空白を削除したものにする。
update employees;
set name= TRIM(name);
where char_length(name) <> char_length(TRIM(name));

#REPLACE : 置換
select replace("I like an apple" , "apple" , "lemon");

#Mrs. をMsに変更
select replace(name, "Mrs" , "Ms") from users where name like "Mrs%";

update users set name = replace(name, "Mrs" , "Ms") where name like "Mrs%";

select * from users;

#UPPER , LOWER
select upper("apple");
select lower("APPLE");

select name , upper(name),lower(name) from users;

#substring : 一部取り出し
select substring(name , 2 , 3) , name from employees;

select * from employees where substr(name , 2 , 1) = "田";

#ewverse : 逆順
select reverse(name) , name from employees;
