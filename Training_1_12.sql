#前方一致検索
select * from users where name like "村%";

#後方一致検索
select * from users where name like "%郎";

#中間一致検索
select * from users where name like "%ab%" limit 10;

#任意の一文字を検索
select * from prefectures where name like "福_県";

#演算子と一緒にも使える
select * from prefectures where name like "福%" || name like "宮%";

#複雑な検索
select * from users where birth_place = "日本" and (name like "%郎" or name like "%子")  order by name;
