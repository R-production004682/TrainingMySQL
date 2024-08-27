use my_db2;

# 副問い合わせ4: FROM句でサブクエリを使用して集計
select 
    max(avg_age) as "部署ごとの平均年齢の最大",  # 部署ごとの平均年齢の最大値を取得
    min(avg_age) as "部署ごとの平均年齢の最小"   # 部署ごとの平均年齢の最小値を取得
from
(select department_id, avg(age) as avg_age from employees group by department_id) as tmp_emp;
# サブクエリで各部署ごとの平均年齢を計算し、結果をtmp_empという一時テーブルとして扱う

# 年代の集計: 各年代ごとの従業員数の最大値と最小値を取得
SELECT MAX(age_count) as "最大従業員数", MIN(age_count) as "最小従業員数"
FROM (
  SELECT floor(age/10) * 10 AS age_decade, COUNT(*) AS age_count
  FROM employees
  GROUP BY age_decade
) AS age_summary;
# サブクエリで従業員を10年ごとにグループ化し、各年代の従業員数をカウント



# 副問い合わせ5: SELECT句でサブクエリを使用
select * from customers limit 10;  # customersテーブルの最初の10行を表示
select * from orders limit 10;     # ordersテーブルの最初の10行を表示


select cs.id, cs.first_Name, cs.last_Name, 
(select max(order_date) from orders as order_max where cs.id = order_max.customer_id) as "最近の注文日",  # 顧客ごとの最新の注文日
(select min(order_date) from orders as order_max where cs.id = order_max.customer_id) as "最古の注文日",  # 顧客ごとの最古の注文日
(select sum(order_amount * order_price) from orders as tmp_order where cs.id = tmp_order.customer_id) as "全支払い金額"  # 顧客ごとの総支払い金額
from customers as cs
where cs.id < 10;  # 顧客IDが10未満の顧客情報を取得

# 副問い合わせ6: CASEと使う
-- 「経営企画部」の従業員は「経営層」、それ以外は「その他」と表示
select emp.*,
  case 
    when emp.department_id = (
      -- 部署名が「経営企画部」の部署IDを取得
      select id from departments where name = "経営企画部"
    ) 
    then "経営層"  -- 経営企画部に所属している場合
    else "その他"   -- その他の部署に所属している場合
  end as "役割"
from employees as emp;

-- 給料が平均より高いかどうかを判定するクエリ
select emp.*,
  case
    when emp.id in (
      -- 給料が平均より高い従業員IDを取得
      select distinct employee_id 
      from salaries 
      where payment > (
        -- 給料の平均値を計算
        select avg(payment) from salaries
      )
    )
    then "○"  -- 給料が平均より高い場合
    else "×"  -- 給料が平均以下の場合
  end as "給料が平均より高いか"
from employees emp;
