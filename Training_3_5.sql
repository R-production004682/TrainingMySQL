USE my_db4;
SHOW TABLES;

-- 統計情報の確認
-- テーブル 'innodb_table_stats' から my_db4 データベースのテーブル統計情報を確認
SELECT * FROM mysql.innodb_table_stats WHERE database_name = "my_db4"\G

-- 'prefectures' テーブルのデータを確認
SELECT * FROM prefectures;

-- データの挿入と削除
-- 例として「不明」という新しい都道府県データを挿入
INSERT INTO prefectures (prefecture_code, name) VALUES ("48", "不明");

-- 挿入したデータの削除
DELETE FROM prefectures WHERE prefecture_code = "48" AND name = "不明";

-- 統計情報の手動更新
-- 'prefectures' テーブルの統計情報を更新
ANALYZE TABLE prefectures;

-- SQLを実行せずに、実行計画だけを表示
-- 'customers' テーブルのクエリに対する実行計画を確認
EXPLAIN SELECT * FROM customers\G

-- 実際にSQLを実行して、さらに実行計画も表示
-- パフォーマンスの詳細な確認が可能
EXPLAIN ANALYZE SELECT * FROM customers\G

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = 'Kelly'\G

-- インデックスの作成
CREATE INDEX idx_customer_name ON customers (first_name);

-- 再度、実行計画を確認してパフォーマンス向上を確認
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = 'Kelly'\G