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
on emp.id < std.id limit 10;


# LEFT JOIN: employees テーブルと departments テーブルを結合
# employees テーブルには存在するが、departments テーブルに存在しないデータも表示
select emp.id, emp.first_name, emp.last_name, COALESCE(dt.id, "該当する") as department_id, dt.name
from employees as emp
LEFT join departments as dt
on emp.department_id = dt.id;

# students テーブルと enrollments テーブルを LEFT JOIN
# enrollments テーブルにデータがなくても students の全データを取得
# classes テーブルをさらに enrollments に LEFT JOIN
select * from students as std
left join enrollments as enr
on std.id = enr.student_id
left join classes as cs
on enr.class_id = cs.id limit 5;

# RIGHT JOIN: enrollments テーブルにある全データを取得し、students に存在しないデータも表示
# classes テーブルをさらに enrollments に LEFT JOIN
select * from students as std
right join enrollments as enr
on std.id = enr.student_id
left join classes as cs
on enr.class_id = cs.id limit 5;

# FULL JOIN: 左側の students と enrollments を LEFT JOIN で結合し、
# 右側の students と enrollments を RIGHT JOIN で結合した結果を UNION で結合
# どちらにも存在しないデータが NULL で表示される
select * from students as std
    left join enrollments as enr
        on std.id = enr.student_id
    left join classes as cs
        on enr.class_id = cs.id
union all
select * from students as std
    right join enrollments as enr
        on std.id = enr.student_id
    right join classes as cs
        on enr.class_id = cs.id limit 10;