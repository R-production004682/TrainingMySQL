show databases;

use my_db;

#UNION : 重複は削除
select * from new_students
union
select * from students;

/*
順番がとびとびになっているのは重複削除されてるから。
| 341 | 堀川 迪子   |    177 |     77 |        5 |
|   4 | 黒沢 敬正   |    163 |     74 |        1 |
|   5 | 中谷 純典   |    159 |     62 |        2 |
|   7 | 吉川 一樹   |    169 |     68 |        4 |
|   8 | 齋藤 保行   |    181 |     81 |        3 |
|  11 | 田原 秀俊   |    179 |     72 |        5 |
*/

select * from new_students
union
select * from students
order by id;

#union all : 重複削除しない
select * from new_students
union all
select * from students;


select * from students where id < 10
union all
select * from students where id > 250;

#カラムを合わせない場合
select id, name from students where id < 10
union
select age,name from users where id < 10
ORDER BY age;

#intersect: 重複を表示
#new_studentsに存在していて、studentsに存在しているものを抽出する。
select * from new_students
intersect
select * from students;


#EXCEPT: 重複以外を表示
#new_studentsに存在していて、studentsに存在しない。
select * from new_students
except
select * from students;

#どちらかに存在(EXCEPT)
select * from new_students
except
select * from students
union all
select * from students
except
select * from new_students;