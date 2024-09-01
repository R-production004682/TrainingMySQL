use my_db2;

# EXISTS（NULLの存在する場合）
select * from customers as c1
where exists(
    # customers_2テーブルに、first_name, last_name, phone_numberが一致するレコードが存在するかチェック
    select * from customers_2 as c2
        where c1.first_name = c2.first_name and 
              c1.last_name  = c2.last_name  and
              # phone_numberが一致するか、両方のphone_numberがNULLである場合に条件を満たす
              (c1.phone_number = c2.phone_number or (c1.phone_number is null and c2.phone_number is null))
);

# NOT EXISTS
select * from customers as c1
where not exists(
    # customers_2テーブルに、first_name, last_name, phone_numberが一致するレコードが存在しないことをチェック
    select 1 
    from customers_2 as c2
    where c1.first_name = c2.first_name 
    and c1.last_name = c2.last_name 
    # phone_numberが一致するか、両方のphone_numberがNULLである場合に条件を満たす
    and (c1.phone_number = c2.phone_number or (c1.phone_number is null and c2.phone_number is null))
);

# NOT IN の場合
select * 
from customers as c1
where (first_name, last_name, phone_number) not in (
    # customers_2テーブルのfirst_name, last_name, phone_numberの組み合わせに含まれないレコードを取得
    select first_name, last_name, phone_number
    from customers_2
);
