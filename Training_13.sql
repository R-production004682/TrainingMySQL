#in句
#歳が12歳、24歳、36歳の人のみ抽出
select * from users where age in(12, 24, 36);

#出身地がフランス、ドイツ、イタリアの人のみ抽出
select * from users where birth_place in("France" , "Germany", "Italy");

#出身地がフランス、ドイツ、イタリアではない人のみ抽出
select * from users where birth_place not in("France" , "Germany", "Italy") limit 10;

#select + in
#customer_idと合致しているcustomersテーブルのidを持っているデータを持っているレコードを抽出。
select * from customers where id in (select customer_id from receipts) limit 10;
#customer_idと合致しているcustomersテーブルのidを持っているデータを持っているレコードを10行抽出。
select * from customers where id in (select customer_id from receipts where id < 10);

#all, any句
#employeesテーブルで収入5百万以上の人の年齢をすべて取り出し、
#employeesテーブルで取り出した年齢よりも、usersテーブルのageの方が大きいレコードのみ出力。
select * from users where age > all(select age from employees where salary > 5000000);


#employeesテーブルで収入5百万以上の人の年齢をいずれかのみ取り出し、
#employeesテーブルで取り出した年齢よりも、usersテーブルのageの方が大きいレコードのみ出力。
select * from users where age > any(select age from employees where salary > 5000000) limit 10;
