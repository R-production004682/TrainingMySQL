#AND , OR
select * from employees limit 10;

#営業部の名前の一部に田が入っている人を抽出
select * from employees where department = " 営業部 " and name like "%田%";

#営業部の名前の一部に田が入っていて、年齢が35歳よりも若い人を抽出
select * from employees where department = " 営業部 " and name like "%田%" and age < 35;

#営業部の名前の一部に「田」か「西」が入っていて、年齢が35歳よりも若い人を抽出
select * from employees where department = " 営業部 " and (name like "%田%" or name like "%西%") and age < 35;

#営業部か開発部の人を抽出
select * from employees where department = " 営業部 " or department = " 開発部 " limit 10;

#上のSQLを短縮して書く
select * from employees where department in (" 営業部 " , " 開発部 ") limit 10;

#not（直後の否定）
select * from employees where not department = " 営業部 " limit 10;
