use my_db;
describe users;
update users set name = "奥村 成美" where id = 1;
select * from users limit 10; #長いと感じたら短く表示してもらってOK データ量{ 1 ~ 200}
select * from users where name = "奥村 成美"; #名前で絞り込む
select * from users where birth_place = "日本" limit 10; #出身地で絞り込む
select * from users where birth_place<> "日本" order by age limit 10; #日本以外で出生した人を都市の若い順に抽出
select * from users where age >= 50 limit 10; #年齢が50以上の人を抽出
select * from users where age <= 50 limit 10; #年齢が50歳以下の人を抽出
select * from users where birth_day < "2011-04-03" limit 10; #誕生日が2011年4月3日よりも前に生まれた人を抽出
select * from users where is_admin = 1; #管理者権限がある人のみ表示
update users set name = "奥山 成美" where id = 1; #id 1番目のユーザーの名前を変更
select * from users where id = 1;
select * from users order by id desc limit 1;
delete from users where id = 200; #200番目を削除
select * from users order by id desc limit 1;
