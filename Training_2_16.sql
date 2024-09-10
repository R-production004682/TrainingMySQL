use use_my2;

-- 現在のデータベースに存在するテーブルの一覧を表示する
show tables;

-- employeesテーブルの全データを取得する
select * from employees;

-- ウィンドウ関数の例: 全体の平均年齢と従業員の総数を表示
select *, 
    avg(age) over() as avg_age,     -- 全体の平均年齢
    count(*) over() as total_count  -- 全体の従業員数
from employees;

-- partition byを使用して、部署ごとの集計を行う
select *, 
    avg(age) over(partition by department_id) as avg_age,   -- 部署ごとの平均年齢
    count(*) over(partition by department_id) as count_department  -- 部署ごとの従業員数
from employees;

-- 年齢を10歳ごとに分け、各年齢層ごとの人数を取得する
select distinct 
    concat(count(*) over(partition by floor(age/10)), "人") as age_count,  -- 各年齢層の人数を"人"付きで表示
    floor(age/10) * 10 as age_group  -- 年齢を10の位で切り捨てて、年齢層を表示
from employees;

-- 注文日ごとの月ごとに集計を行い、注文金額の合計を計算する
select *, 
    date_format(order_date, "%Y/%m") as order_month,  -- 注文日を"YYYY/MM"形式に変換して月単位で表示
    sum(order_amount * order_price) over(partition by date_format(order_date, "%Y/%m")) as monthly_sales  -- 月ごとの売上の合計
from orders limit 10;
