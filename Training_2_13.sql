use my_db2;

# customers テーブルと customers_2 テーブルのすべての行を統合する
# これにより、両方のテーブルに含まれるすべての行が取得される
select * from customers
UNION
select * from customers_2;

# customers_2 テーブルに存在しない customers テーブルの行を取得する
# これは、EXCEPT を EXISTS で表現する方法
select * from customers as c1 
    where not exists(
        select * from customers_2 as c2
        where
        c1.id = c2.id and
        c1.first_name = c2.first_name and
        c1.last_name = c2.last_name and
        (c1.phone_number = c2.phone_number or 
        (c1.phone_number is null and c2.phone_number is null)) and
        c1.age = c2.age
);

# customers_2 テーブルにも存在する customers テーブルの行を取得する
# これは、INTERSECT を EXISTS で表現する方法
select * from customers as c1 
    where exists(
        select * from customers_2 as c2
        where
        c1.id = c2.id and
        c1.first_name = c2.first_name and
        c1.last_name = c2.last_name and
        (c1.phone_number = c2.phone_number or 
        (c1.phone_number is null and c2.phone_number is null)) and
        c1.age = c2.age
);