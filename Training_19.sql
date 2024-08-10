select database();

select * from users;

#出生地が日本だった場合、日本人、それ以外は外国人かを判定し、
#国籍のカラムを最後に作り、そこに表示する
select *,
    case birth_place
        when "日本" then "日本人"
        else "外国人"
    end as "国籍"
from users limit 20;

#条件をさらに絞る事もできる
select *,
    case birth_place
        when "日本" then "日本人"
        when "Iraq" then "イラク人"
        else "外国人"
    end as "国籍"
from users limit 20;

select * from prefectures;
#地方に絞り込む
select name,
case
when name in ("香川県","愛媛県","徳島県","高知県") then "四国"
when name in ("兵庫県","大阪府","京都府","奈良県","三重県","和歌山県") then "近畿"
else "その他"
end as "地域名"
from prefectures;


#計算式にも流用できる。
#閏年を求めてみる。
select name , birth_day, 
case
when date_format(birth_day,"%Y") % 4 = 0 and date_format(birth_day, "%Y") % 100 <> 0 then "閏年"
else "閏年じゃない"
end as "閏年か"
from users limit 10;

select *, 
case 
when student_id % 3 = 0 then test_score_1
when student_id % 3 = 1 then test_score_2
when student_id % 3 = 2 then test_score_3
end as score
from tests_score limit 10;


#order byにcase
select *,
    case
        when name in ("香川県","愛媛県","徳島県","高知県") then "四国"
        when name in ("兵庫県","大阪府","京都府","奈良県","三重県","和歌山県") then "近畿"
        else "その他" end as "地域名"
    from prefectures
order by 
    case
        when name in ("香川県","愛媛県","徳島県","高知県") then "四国"
        when name in ("兵庫県","大阪府","京都府","奈良県","三重県","和歌山県") then "近畿"
        else "その他"
end desc;


#updateにcase
select * from users;
alter table users add birth_era VARCHAR(2) after birth_day;

select *,
case
when birth_day < "1989-01-07" then "昭和"
when birth_day < "2019-05-01" then "平成"
when birth_day >= "2019-05-01" then "令和"
else "不明"
end as "元号"
from users limit 15;

update users
set birth_era = case
when birth_day < "1989-01-07" then "昭和"
when birth_day < "2019-05-01" then "平成"
when birth_day >= "2019-05-01" then "令和"
else "不明"
end;

select * from users limit 15;

#NULLを使う場合
select * from customers where name is NULL;

#ダメな書き方
select *,
case name
when NULL then "不明"
else ""
end as "NULL CHECK"
from customers where name is NULL;
#------------------------------------

#正しい書き方
select *,
case
when name IS NULL then "不明"
else ""
end as "NULL CHECK"
from customers where name is null;