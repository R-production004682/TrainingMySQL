#if(条件式, 真の値, 偽の値)

select if(10 < 20, "A" , "B");# A
select if(20 < 10, "A" , "B");# B

select * from users;

#出生地が二本だった場合、日本人と表示し、そうじゃなかったらその他と出力。
select *, if(birth_place="日本" , "日本人" , "その他") as "国籍" from users limit 10;

#年齢が20歳以上だったら成人、そうではなかったら未成年と出力
select name, age, if(age < 20, "未成年" , "成人") from users limit 10;

select * from students;

#6組でかつ、身長が170cm以上の人、そうではなかった場合、その他と出力する。
select *, if(class_no = 6 and height > 170, "6組の170cm以上の人", "その他") from students limit 10;

select * from users;

select  name,if(name like "%田%" , "名前に田を含む" , "その他") as name_check from users limit 10;

