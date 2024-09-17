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


-- ordersテーブルから、order_price * order_amountの合計を日ごとに集計し、7日間の平均を計算する
-- 日ごとの合計金額（売上）を取得
with daily_summary as(
    select
        order_date, sum(order_price * order_amount) as sale
    from
        orders
    group by order_date
)
-- 6行前から現在の行までの売上の移動平均を計算する（行数ベース）
-- 過去6日間から当日までの売上の平均
-- 日付範囲に基づく1週間前から現在までの売上の平均を計算する（日付ベース）
select *, 
avg(sale) over (order by order_date rows between 6 preceding and current row) as 6行前から現在の行までの平均,
avg(sale) over (order by order_date range between interval 7 day preceding and current row) as 1週間内の平均
from daily_summary limit 10;

-- 社員の年齢ごとに支払いの合計を計算し、全期間の支払合計と最大支払額を求める
select *, 
sum(summary_salary.payment) 
over(order by age range between unbounded preceding and unbounded following) as 全期間の支払合計
from employees as emp 
inner join(
    -- 各社員の支払い総額を計算するために、salariesテーブルを集計
    select employee_id , sum(payment) as payment
    from salaries 
    group by employee_id
) as summary_salary
on emp.id = summary_salary.employee_id limit 10;


-- 前後1年の給料増減率を計算
select emp.*, 
lag(summary_salary.payment, 1) over(order by emp.age) as 前年の支払額,
lead(summary_salary.payment, 1) over(order by emp.age) as 来年の支払額,
(case 
    when lag(summary_salary.payment, 1) over(order by emp.age) is not null 
    then (summary_salary.payment - lag(summary_salary.payment, 1) over(order by emp.age)) / lag(summary_salary.payment, 1) over(order by emp.age)
    else null
end) as 支払増減率
from employees as emp 
inner join (
    select employee_id, sum(payment) as payment
    from salaries 
    group by employee_id
) as summary_salary
on emp.id = summary_salary.employee_id limit 10;

