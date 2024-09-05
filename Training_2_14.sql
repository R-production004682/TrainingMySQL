show databases;
use my_db2;

select * from employees limit 10;
select * from departments limit 10;

# employeesとdepartmentsテーブルをINNER JOINで結合（通常のJOIN）
# department_idが一致するレコード同士を結合
select * from employees as emp
inner join departments as dt
on emp.department_id = dt.id;

# employeesとdepartmentsから特定のカラムのみを取り出す
# emp.id, emp.first_name, emp.last_name, dt.id, dt.nameを選択
select emp.id, emp.first_name, emp.last_name, dt.id as department_id, dt.name
from employees as emp
inner join departments as dt
on emp.department_id = dt.id;

# studentsとusersテーブルを複数のカラム（first_name, last_name）で結合
# 両方のテーブルでfirst_nameとlast_nameが一致するレコードを結合
select * from students as std
inner join users as usr
on std.first_name = usr.first_name and std.last_name = usr.last_name limit 20;

# =ではなく、比較演算子を使って結合
# employees.idがstudents.idより小さいレコードを取得
select * from employees as emp
inner join students as std
on emp.id < std.id limit 10\G

