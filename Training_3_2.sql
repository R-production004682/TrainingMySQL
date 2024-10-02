-- データベースとテーブルの確認
USE my_db3;

SHOW TABLES;

-- studentsテーブルの内容確認
SELECT * FROM students;

-- インデックス一覧の確認
SHOW INDEX FROM students\G

-- シンプルなWHERE句によるインデックスなしのクエリパフォーマンス確認
EXPLAIN SELECT * FROM students WHERE name = "Taro"\G

-- インデックスの作成（単一カラムに対して）
CREATE INDEX idx_students_name ON students(name);

-- インデックス使用後のクエリパフォーマンス確認
EXPLAIN SELECT * FROM students WHERE name = "Taro"\G

-- 関数インデックスの作成（lower関数を使用）
CREATE INDEX idx_students_lower_name ON students((LOWER(name)));

-- 関数インデックスを使用したクエリパフォーマンス確認
EXPLAIN SELECT * FROM students WHERE LOWER(name) = "Taro"\G

-- インデックスに対するさらなる検証パターン

-- 複数カラムのインデックス作成と検証
CREATE INDEX idx_students_name_age ON students(name, age);

-- 複数カラムインデックスのクエリ検証（両方のカラムを使用）
EXPLAIN SELECT * FROM students WHERE name = "Taro" AND age = 20\G

-- 複数カラムインデックスを部分的に使用（片方のみ使用）
EXPLAIN SELECT * FROM students WHERE name = "Taro"\G

-- インデックスを使用しないクエリ検証
EXPLAIN SELECT * FROM students WHERE age = 20\G

-- インデックス作成後のインデックス一覧を確認
SHOW INDEX FROM students\G

-- テーブルの内容確認
SHOW TABLES;
SELECT * FROM users;

-- ユニークインデックスの作成
CREATE UNIQUE INDEX idx_users_uniq_first_name ON users(first_name);

-- ユニークインデックスの確認
SHOW INDEX FROM users\G

-- ユニークインデックスが適用されたカラムに重複データを挿入してエラーを確認
-- (このクエリはエラーを発生させます)
INSERT INTO users(id, first_name) VALUES (3, "ABC");

-- ユニークインデックスに違反するデータを再度挿入して検証
-- (このクエリは同じ"ABC"でエラーが発生します)
INSERT INTO users(id, first_name) VALUES (4, "ABC");

-- ユニーク制約に違反しないデータを挿入して確認
INSERT INTO users(id, first_name) VALUES (5, "XYZ");

-- 関数インデックスの検証（ユーザー名の小文字変換による一意性の確認）
CREATE UNIQUE INDEX idx_users_lower_first_name ON users((LOWER(first_name)));

-- 小文字変換による重複チェック（大文字と小文字の違いがユニーク制約でカバーされるか確認）
-- (このクエリはエラー)
INSERT INTO users(id, first_name) VALUES (6, "xyz");