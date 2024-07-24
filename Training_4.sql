select DATABASE();

create TABLE students(
    id int PRIMARY KEY,
    name CHAR(10)
);

insert into students values(1 , "ABCDEF     "); --Char型の場合スペースが削除されて表示される。

select * from students;

alter TABLE students MODIFY name VARCHAR(10);

insert into students values(2 , "ABCDEF     ");

select * from students;

select name , char_length(name) from students; --文字数表示
