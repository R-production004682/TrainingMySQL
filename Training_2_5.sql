# 出身地が日本の人を年齢ごとにグループ化し、
# 各グループの人数、最年長と最年少の生年月日を取得する
select age , count(*), max(birth_day), min(birth_day) from users
where birth_place = "日本"
group by age
order by count(*) limit 10;


# 年齢が40歳よりも大きい人を部門ごとにグループ化し、部門ごとの給料合計、
# 平均（小数点以下切り捨て）、最小給料を求める
select department, sum(salary), floor(avg(salary)), min(salary) from employees
where 40 < age
group by department;

# 日本人と日本人以外をグループ化し、各グループの人数と最大年齢を求める
select
case
    when birth_place="日本" then "日本人"
    else "その他"
end as "国籍",
count(*),
max(age)
from users 
group by 
case 
    when birth_place="日本" then "日本人"
    else "その他"
end;

# 都道府県名に基づいて、四国地方とその他の地域にグループ化し、
# 各グループの都道府県数を求める
select
case
    when name in ("香川県","高知県","愛媛県","徳島県") then "四国"
    else "その他"
end as "地域名",
count(*)
from prefectures 
group by
case
    when name in ("香川県","高知県","愛媛県","徳島県") then "四国"
    else "その他"
end;

# 未成年（20歳未満）と成人（20歳以上）を年齢ごとに分類し、各年齢の人数を求める
select age,
case
    when age < 20 then "未成年"
    else "成人"
end as "分類",
count(*)
from users 
group by age 
order by age limit 30;