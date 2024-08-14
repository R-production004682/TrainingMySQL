-- データベースを選択
SELECT DATABASE();

-- テーブル一覧を表示
SHOW TABLES;

-- テーブル名の変更
ALTER TABLE users RENAME TO users_table;

-- テーブルの構造を確認
DESCRIBE users_table;

-- カラムの削除
ALTER TABLE users_table DROP COLUMN message;

-- テーブルの構造を確認
DESCRIBE users_table;

-- 新しいカラムの追加
ALTER TABLE users_table ADD post_code CHAR(8);

-- 新しいカラムの追加 (age カラムの後に追加)
ALTER TABLE users_table ADD gender CHAR(1) AFTER age;

-- 新しいカラムの追加 (最初の位置に追加)
ALTER TABLE users_table ADD new_id INT FIRST;

-- カラムの削除
ALTER TABLE users_table DROP COLUMN new_id;

-- カラムのデータ型を変更
ALTER TABLE users_table MODIFY COLUMN name VARCHAR(50);

-- カラム名とデータ型を変更
ALTER TABLE users_table CHANGE COLUMN name 名前 VARCHAR(50);

-- カラムの位置を変更
ALTER TABLE users_table CHANGE COLUMN gender gender CHAR(1) AFTER post_code;

-- テーブルの構造を確認
DESCRIBE users_table;

-- 主キーの削除
ALTER TABLE users_table DROP PRIMARY KEY;
