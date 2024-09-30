USE my_db3;

-- 1. messages テーブルの作成とデータ挿入
CREATE TABLE messages (
    name_code CHAR(8), -- 固定長のコード/ID用
    name VARCHAR(25),  -- 可変長の名前
    message TEXT       -- 長いメッセージ用（最大 65535 バイト）
);

INSERT INTO messages (name_code, name, message)
VALUES
    ("00000001", "Yoshida Takeshi", "これはテストメッセージです。"),
    ("00000002", "Yoshida Yusaku", "こちらは別のテストメッセージです。");

-- データ確認用のEXPLAIN
EXPLAIN SELECT * FROM messages\G

-- 2. patients テーブルの作成とデータ挿入
CREATE TABLE patients (
    id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT, -- 0 ~ 65535
    name VARCHAR(50),
    age TINYINT UNSIGNED DEFAULT 0 -- 0 ~ 255
);

INSERT INTO patients (name, age)
VALUES
    ("Sachiko", 34),
    ("Sachiko", 255);

-- EXPLAINを使用してクエリの実行計画を確認
EXPLAIN SELECT * FROM patients WHERE age = 34\G

-- 3. idカラムの範囲を拡大
ALTER TABLE patients MODIFY id MEDIUMINT UNSIGNED AUTO_INCREMENT;

-- テーブル構造の確認
SHOW FULL COLUMNS FROM patients

-- 4. height と weight カラムの追加
ALTER TABLE patients ADD COLUMN(height FLOAT);
ALTER TABLE patients ADD COLUMN(weight FLOAT);

-- 5. FLOAT型のデータ挿入
INSERT INTO patients (name, age, height, weight)
VALUES
    ("Taro", 44, 175.6789, 57.8925),
    ("Taro", 44, 175.67891234, 57.892556767); -- 四捨五入によるわずかな誤差

-- FLOAT型の検索クエリに対するEXPLAIN
EXPLAIN SELECT * FROM patients WHERE height > 170\G

-- 6. 浮動小数点型のテーブル作成とデータ挿入
CREATE TABLE tmp_float (num FLOAT);
CREATE TABLE tmp_double (num DOUBLE);

INSERT INTO tmp_float VALUES (12345678);
INSERT INTO tmp_double VALUES (123456789.123456);

-- EXPLAINを使用して数値操作を確認
EXPLAIN SELECT num+2, num FROM tmp_float\G
EXPLAIN SELECT num+2, num FROM tmp_double\G

-- 7. DECIMAL型の追加とデータ挿入
ALTER TABLE patients ADD COLUMN score DECIMAL(7, 3); -- 整数部4桁, 小数部3桁

INSERT INTO patients (name, age, score)
VALUES ("Jiro", 54, 32.456);

-- DECIMAL型カラムに対する検索クエリにEXPLAINを使用
EXPLAIN SELECT * FROM patients WHERE score > 30.000\G

-- 8. DECIMAL型を含むテーブルの作成とデータ挿入
CREATE TABLE tmp_decimal (
    num_float FLOAT,
    num_double DOUBLE,
    num_decimal DECIMAL(20, 10)
);

INSERT INTO tmp_decimal VALUES
(1111111111.1111111111, 1111111111.1111111111, 1111111111.1111111111);

-- データ確認
SELECT * FROM tmp_decimal;

-- 9. BOOLEAN型を使ったテーブルの作成
CREATE TABLE managers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    is_superuser BOOLEAN
);

-- データの挿入
INSERT INTO managers (name, is_superuser)
VALUES
    ("Taro", TRUE),
    ("Jiro", FALSE);

-- BOOLEAN型カラムに対するEXPLAIN
EXPLAIN SELECT * FROM managers WHERE is_superuser = FALSE\G

-- managers テーブルのデータ確認
SELECT * FROM managers;
SELECT * FROM managers WHERE is_superuser = FALSE;

-- 10. インデックスの追加と確認
CREATE INDEX idx_age ON patients(age);

-- インデックスなしのクエリ実行計画
EXPLAIN SELECT * FROM patients WHERE age = 34\G

-- インデックスありのクエリ実行計画
EXPLAIN SELECT * FROM patients WHERE age = 34\G


CREATE table alarms
(
    id int primary key AUTO_INCREMENT,
    alarm_day date,
    alarm_time time,
    create_at timestamp default current_timestamp,
    update_at timestamp default current_timestamp on update current_timestamp
);

select current_timestamp, now(), current_date, current_time; -- 現在のYYYY-MM-DD HH:MM:SS形式で表示

insert into alarms (alarm_day, alarm_time)
values
    ("2024-01-01" , "19:50:21 "),
    ("2021/01/15" , "195031");

select  * from alarms;
update alarms set alarm_time = current_timestamp where id = 1;

select hour(alarm_time), alarm_time from alarms; -- 時のみ抽出
select minute(alarm_time), alarm_time from alarms; -- 分のみ抽出
select second(alarm_time) , alarm_time from alarms; -- 秒のみ抽出

select last_day(alarm_time) , alarm_time from alarms; -- 現在の月の最終日を抽出
select date_format(alarm_day, '%d'), second(alarm_time), alarm_time from alarms;

create table tmp_time(
    num time(5)
);

insert into tmp_time values("21:05:21.54321");

select * from tmp_time;

-- 最後にテーブルを削除
DROP TABLE messages;
DROP TABLE patients;
DROP TABLE tmp_float;
DROP TABLE tmp_double;
DROP TABLE tmp_decimal;
DROP TABLE managers;
DROP TABLE alarms;