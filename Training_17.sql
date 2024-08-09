#ROUND , FLOOR , CEILING

select round(3.14 , 1); #小数第一位まで出力
select round(3.14 , -1); #一の位を四捨五入

select floor(3.84); #切り捨て

select ceiling(3.14); #切り上げ

select rand();#ランダムに値を抽出
select floor(rand() * 10); #ランダムに抽出した文字を小数点以下で切り捨て

select power(3 , 4);
#累乗を計算し、BMIを出力する。
select weight/power(height/100 , 2) as BMI from students limit 10;


#COALESCE
select * from tests_score limit 10;

select coalesce(NULL , NULL , NULL , "A", NULL , "A" , NULL , "B");
select coalesce(test_score_1 , test_score_2 , test_score_3),
 test_score_1 , test_score_2 , test_score_3 as score from tests_score limit 10;

 select substring("apple" , 3);
 