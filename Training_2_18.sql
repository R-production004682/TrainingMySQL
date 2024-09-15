use my_db2;

-- row_number, rank, dense_rank を用いたクエリ
select *, 
row_number() over(order by age) as row_num, -- 各行に連続した行番号を付与する（重複があっても連続）
rank()       over(order by age) as row_rank, -- 値が重複した場合、同じランクを付け、その次のランクはスキップ
dense_rank() over(order by age) as row_dense -- 値が重複した場合、同じランクを付け、次のランクをスキップしない
from employees;

-- CUME_DIST と PERCENT_RANK を用いたクエリ
select age, 
rank() over(order by age) as row_rank, -- 各行にランクを付与（重複があればスキップ）
count(*) over() as cnt, -- 全体の行数を取得
percent_rank() over(order by age) as p_age, -- (ランク - 1) / (行数 - 1) で相対的な順位を計算
cume_dist() over(order by age) as c_age -- 現在の行の値以下の行の割合（累積分布）
from employees;

-- LAG, LEAD を用いたクエリ
select age, 
lag(age) over(order by age) as prev_age, -- 直前の行の値を取得
lag(age, 3, 0) over(order by age) as third_prev_age, -- 3つ前の行の値を取得、ない場合は0を返す
lead(age) over(order by age) as next_age, -- 直後の行の値を取得
lead(age, 2, 0) over(order by age) as second_next_age -- 2つ後の行の値を取得、ない場合は0を返す
from customers;

-- FIRST_VALUE, LAST_VALUE
select *,
first_value(first_name) over(partition by department_id order by age) ,
last_value(first_name) over(partition by department_id order by age
range between unbounded preceding and unbounded following) 
from employees;

-- NTILE
select * from 
(select age,
NTILE(10) over(order by age) as ntile_value
from employees) as tmp
where tmp.ntile_value = 8;
