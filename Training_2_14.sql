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

-- students テーブルと enrollments テーブルを LEFT JOIN
-- enrollments テーブルにデータがなくても students の全データを取得
-- classes テーブルをさらに enrollments に LEFT JOIN
select * from students as std
left join enrollments as enr
on std.id = enr.student_id
left join classes as cs
on enr.class_id = cs.id limit 5;

-- RIGHT JOIN: enrollments テーブルにある全データを取得し、students に存在しないデータも表示
-- classes テーブルをさらに enrollments に LEFT JOIN
select * from students as std
right join enrollments as enr
on std.id = enr.student_id
left join classes as cs
on enr.class_id = cs.id limit 5;

-- FULL JOIN: 左側の students と enrollments を LEFT JOIN で結合し、
-- 右側の students と enrollments を RIGHT JOIN で結合した結果を UNION で結合
-- どちらにも存在しないデータが NULL で表示される
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

-- customers, orders, items storesを紐づける（INNER JOIN） 
-- customers.idで並び替える
select ct.id, ct.last_name, od.item_id, od.order_amount, od.order_price, od.order_date, it.name, st.name 
from customers as ct
inner join orders as od on ct.id = od.customer_id
inner join items  as it on od.item_id = it.id
inner join stores as st on it.store_id = st.id
order by ct.id;

-- customers. orders, items,storesを紐づける（INNER JOIN）
-- customers.idで並び替える（ORDER BY）
-- customers.idが10で、orders.order_dateが2020-08-01よりあとに絞り込む（WHERE）
select ct.id, ct.last_name, od.item_id, od.order_amount, od.order_price, od.order_date, it.name, st.name 
from (select * from customers where id = 10) as ct
inner join (select * from orders where order_date > "2020-08-01") as od on ct.id = od.customer_id
inner join items  as it on od.item_id = it.id
inner join stores as st on it.store_id = st.id
where ct.id = 10 and od.order_date > "2020-08-01"
order by ct.id;

-- GROUP BYの紐づけ
select * from customers as ct
inner join
(select customer_id, sum(order_amount * order_price) as summary_price from orders
GROUP BY customer_id) as order_summary
on ct.id = order_summary.customer_id
order by ct.age limit 5;

-- SELF JOIN（自己結合）
-- 社員テーブルを自己結合して、部下とその上司を取得。
select
    CONCAT(emp1.last_name, emp1.first_name) as "部下の名前",
    emp1.age as "部下の年齢",
    CONCAT(emp2.last_name, emp2.first_name) as "上司の名前",
    emp2.age as "上司の年齢"
from employees as emp1
inner join employees as emp2
on emp1.manager_id = emp2.id;


-- CROSS JOIN（クロス結合）
-- 社員テーブルをクロス結合して、全ての社員の組み合わせを取得するクエリ
-- （ただし、emp1.id < emp2.idの条件でフィルタリング）
select * from employees as emp1 
cross join employees as emp2
where emp1.id < emp2.id limit 10;


-- 計算結果とCASEで紐づけ
-- お客様の年齢が平均年齢よりも高いかどうかを判断。
select * , 
    case when
         cs.age > summary_customers.avg_age then "○"
    else "×"
    end as "平均年齢よりも年齢が高いか"
from customers as cs
cross join (select avg(age) as avg_age from customers) 
as summary_customers;


-- 給与と平均月収の比較
-- 各社員の給与が平均月収以上かどうかを判断する。
select emp.id, avg(payment), summary.avg_payment,
    case 
        when avg(sa.payment) >= summary.avg_payment then '○' 
        else '×'
    end as "平均月収以上か"
from employees as emp
inner join salaries as sa
    on emp.id = sa.employee_id
cross join (
    select avg(payment) as avg_payment from salaries
) as summary 
group by emp.id, summary.avg_payment;
