# テーブル一覧を表示
SHOW TABLES;

# studentsテーブルのすべてのデータをtmp_studentsテーブルとしてコピーして作成
CREATE TABLE tmp_students
SELECT * FROM students;

# tmp_studentsテーブルの内容を表示
SELECT * FROM tmp_students limit 15;

# tmp_studentsテーブルの構造を表示
DESCRIBE tmp_students;

# 元のstudentsテーブルの構造を表示
DESCRIBE students;

# tmp_studentsテーブルを削除
DROP TABLE tmp_students;

# idが10未満のデータのみを含むtmp_studentsテーブルを再作成
CREATE TABLE tmp_students
SELECT * FROM students WHERE id < 10;

# 再作成したtmp_studentsテーブルの内容を表示
SELECT * FROM tmp_students limit 10;

# usersテーブルからidを9増やし、固定値のgradeとともにtmp_studentsテーブルにデータを挿入
INSERT INTO tmp_students
SELECT id + 9 AS id, first_Name, last_Name, 2 AS grade FROM users limit 10;

# students, employees, customersテーブルのfirst_Name, last_Nameのユニークな組み合わせをnamesテーブルとして作成
CREATE TABLE names
SELECT first_Name, last_Name FROM students
UNION
SELECT first_Name, last_Name FROM employees
UNION
SELECT first_Name, last_Name FROM customers limit 10;

# 作成したnamesテーブルの内容を表示
SELECT * FROM names limit 10;
