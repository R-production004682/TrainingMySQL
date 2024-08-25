show databases;

create database my_db2;

use my_db2;

#テーブルにcsという別の名前を付ける
select cs.name from classes as cs;

#テーブルに別名を付けるわけなので、複数のカラムを指定することが出来る。
select cs.name,cs.id from classes as cs;

#デフォルトの名前も使用可
select cs.name,id from classes as cs;