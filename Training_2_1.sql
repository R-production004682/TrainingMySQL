show databases;

use my_db;
select * from users limit 10;

#transactionの開始
start transaction;

#update処理
update users set name = "奥山 成美" where id = 1;
select * from users limit 10;
#この段階はまだステージング段階

#ROLLBACK(トランザクション開始前に戻す)
rollback;
select * from users limit 10;

#commit(トランサクションをDBに反映)
commit;

#ROLLBACK
rollback;
select * from students;

#id = 300を削除
delete from students where id = 300;

#AUTOCOMMIT確認
show variables where variable_name="autocommit";

#autocommitをoffにする。
set autocommit = 0;

delete from students where id = 299;
#ここのdeleteは、表示上消えてるけど、内部的に残っている状態になる。
#だから、別のセッションでselect * from students;をしたら、id 299が残っている状態で出力される。
#つまり、コミットの処理を手動で書かないと、insertや、updateなりがローカルに反映されない状態を作り出せる。

#SQLの反映
commit;

select * from students order by id desc limit 10;

#AUTOCOMMITをもとに戻す
set autocommit = 1;