use my_db2;

-- 全行に対して count を計算する。集計結果には順序は関係しない。
select *, count(*) over() as tmp_count from employees;

-- age（年齢）で並び替えて、並び替えた結果に基づいて count を計算。
-- age で順序が変わるので、集計の結果も変わる。
select *, count(*) over(order by age) as tmp_count from employees;



-- order_date（注文日）で並び替え、各行までの注文価格の合計を計算。(昇順バージョン / 降順バージョン)
select *, sum(order_price) over(order by order_date) as 集計データ from orders limit 10;
select *, sum(order_price) over(order by order_date desc) as 集計データ from orders limit 10;


-- PARTITION BY + ORDER BY
-- 部署ごと（department_id でパーティション）に年齢（age）で並び替え、それぞれの部署ごとに行数をカウントする。
select *, count(*) over(partition by department_id order by age) 
as count_value from employees;


-- 各月の支払いデータに対して、従業員のIDで昇順に並び替えた上で、
-- 最大の支払い額（毎月の合計）を計算する。
-- PARTITION BY paid_date で月ごとにパーティションを区切り、従業員IDで順序付けすることで、各従業員の支払いを集計。
select *, max(sa.payment) over (partition by sa.paid_date order by emp.id ) as 毎月の合計
from employees as emp
inner join salaries as sa
on emp.id = sa.employee_id limit 30;


