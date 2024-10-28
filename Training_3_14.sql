USE my_db4;

-- レンジパーティションを使ったテーブルの作成
CREATE TABLE users_partitioned (
    name VARCHAR(50),
    age INT
)
PARTITION BY RANGE(age) (
    PARTITION p0 VALUES LESS THAN (20),    -- 年齢20歳未満のデータを格納
    PARTITION p1 VALUES LESS THAN (40),    -- 年齢20歳以上40歳未満のデータを格納
    PARTITION p2 VALUES LESS THAN (60)     -- 年齢40歳以上60歳未満のデータを格納
);

-- テストデータを挿入
INSERT INTO users_partitioned VALUES
("Taro", 18),
("Jiro", 28),
("Saburo", 38),
("Yoshiko", 48);

-- 全件取得（各パーティションにまたがるデータを取得）
SELECT * FROM users_partitioned;

-- p1パーティションのデータのみを取得（年齢が20歳以上40歳未満のデータに該当）
SELECT * FROM users_partitioned PARTITION(p1);

-- クエリプランの確認: 全データのスキャン
EXPLAIN SELECT * FROM users_partitioned\G

-- クエリプランの確認: パーティションフィルタを使用したスキャン
EXPLAIN SELECT * FROM users_partitioned WHERE age < 20\G

-- パーティション範囲外のデータの挿入テスト（エラーになる可能性あり）
-- 修正点: `partition p_max`を追加して、範囲外のデータも格納可能にしておく
INSERT INTO users_partitioned VALUES("Yoko" , 72);

-- alter tableを使用してパーティションを追加（範囲外データの対応）
ALTER TABLE users_partitioned
PARTITION BY RANGE(age) (
    PARTITION p0 VALUES LESS THAN (20),
    PARTITION p1 VALUES LESS THAN (40),
    PARTITION p2 VALUES LESS THAN (60),
    PARTITION p_max VALUES LESS THAN (MAXVALUE)  -- すべての範囲外データを格納
);

-- テーブル情報の確認
SHOW TABLES;
SHOW CREATE TABLE users_partitioned\G

/*
sales_history_partitionedテーブルの定義例
*/
SHOW CREATE TABLE sales_history_partitioned\G

/*
sales_history_partitioned | CREATE TABLE `sales_history_partitioned` (
`id` mediumint unsigned NOT NULL AUTO_INCREMENT,
`customer_id` mediumint unsigned DEFAULT NULL,
`product_id` mediumint unsigned DEFAULT NULL,
`sales_amount` mediumint unsigned DEFAULT NULL,
`sales_day` date NOT NULL DEFAULT '1970-01-01',
PRIMARY KEY (`id`,`sales_day`)
) ENGINE=InnoDB AUTO_INCREMENT=2500001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

PARTITION BY RANGE (YEAR(`sales_day`))
(PARTITION p0_lt_2016 VALUES LESS THAN (2016) ENGINE = InnoDB,
 PARTITION p1_lt_2017 VALUES LESS THAN (2017) ENGINE = InnoDB,
 PARTITION p2_lt_2018 VALUES LESS THAN (2018) ENGINE = InnoDB,
 PARTITION p3_lt_2019 VALUES LESS THAN (2019) ENGINE = InnoDB,
 PARTITION p4_lt_2020 VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION p5_lt_2021 VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION p6_lt_max VALUES LESS THAN MAXVALUE ENGINE = InnoDB)
*/

-- データ件数の確認
-- パーティション化されたテーブルと非パーティションテーブルの比較
SELECT COUNT(*) FROM sales_history_partitioned;
SELECT COUNT(*) FROM sales_history;

-- パーティションを利用した特定期間のデータ取得（パーティション化されている場合）
SELECT COUNT(*) FROM sales_history_partitioned
WHERE sales_day BETWEEN "2016-01-01" AND "2016-12-31"\G

-- パーティション化されていないテーブルの特定期間のデータ取得
SELECT COUNT(*) FROM sales_history
WHERE sales_day BETWEEN "2016-01-01" AND "2016-12-31"\G



-- LISTパーティションを用いたshopsテーブルの作成
-- 店舗ID (id)、店舗名 (name)、店舗タイプ (shop_type) の3つのカラムを持つ
-- 店舗タイプ (shop_type) に基づいて、異なるパーティションにデータを格納する
create table shops(
    id int,
    name VARCHAR(50),
    shop_type int
)
partition by list(shop_type)(
    partition p0 values in(1, 2, 3),   -- shop_typeが1, 2, 3のレコードはp0パーティションに格納
    partition p1 values in(4, 5),      -- shop_typeが4, 5のレコードはp1パーティションに格納
    partition p2 values in(6, 7)       -- shop_typeが6, 7のレコードはp2パーティションに格納
);

-- 初期データの挿入
-- shop_typeごとに異なるパーティションに格納される
insert into shops values
(1, "Shop A", 1),
(2, "Shop B", 2),
(3, "Shop C", 3),
(4, "Shop D", 4),
(5, "Shop E", 5),
(6, "Shop F", 6),
(7, "Shop G", 7);

-- コメント：
-- INSERT文により、異なるshop_typeに対応するレコードが適切なパーティションに格納される。
-- 例えば、shop_type=1, 2, 3のレコードはp0、4, 5はp1、6, 7はp2にそれぞれ格納される。

-- p0パーティション内のデータのみを選択
select * from shops partition (p0);
/*
+------+--------+-----------+
| id   | name   | shop_type |
+------+--------+-----------+
|    1 | Shop A |         1 |
|    2 | Shop B |         2 |
|    3 | Shop C |         3 |
+------+--------+-----------+
*/

-- p0およびp1パーティション内のデータを選択
select * from shops partition (p0, p1);
/*
+------+--------+-----------+
| id   | name   | shop_type |
+------+--------+-----------+
|    1 | Shop A |         1 |
|    2 | Shop B |         2 |
|    3 | Shop C |         3 |
|    4 | Shop D |         4 |
|    5 | Shop E |         5 |
+------+--------+-----------+
*/

-- p2パーティション内のデータのみを選択
select * from shops partition (p2);
/*
+------+--------+-----------+
| id   | name   | shop_type |
+------+--------+-----------+
|    6 | Shop F |         6 |
|    7 | Shop G |         7 |
+------+--------+-----------+
*/

-- パーティションの追加: 新たなパーティションp3を追加し、shop_typeが8, 9, 10のレコードを格納
alter table shops add partition
(partition p3 values in (8, 9, 10));

-- コメント：
-- 新規の店舗タイプ (shop_type) 8, 9, 10のデータを格納するためにp3パーティションを追加
-- 既存のテーブル構造に新しい値範囲を追加する際に有効

-- p3パーティションに対応するレコードを挿入
insert into shops values
(8, "Shop H", 8),
(9, "Shop I", 9),
(10, "Shop J", 10);

-- コメント：
-- 追加したパーティションp3に、shop_typeが8, 9, 10の新しいデータを挿入
-- これにより、異なるshop_typeに応じたデータの分割がさらに細かくなり、クエリパフォーマンスを向上させる


-- データベース選択
USE my_db4;

-- ハッシュパーティションのテーブル作成
CREATE TABLE IF NOT EXISTS h_partition (
    name VARCHAR(50),
    partition_key INT
)
PARTITION BY HASH(partition_key)
PARTITIONS 4;  -- 4つのパーティションに分割

-- データの挿入 (ハッシュパーティション)
INSERT INTO h_partition (name, partition_key) VALUES
    ("A", 1),  -- パーティション決定のキーとして1
    ("B", 2),
    ("E", 3),
    ("C", 4),
    ("G", 5),
    ("D", 6),
    ("F", 7),
    ("H", 8);

-- パーティション p3 からのデータ選択
SELECT * FROM h_partition PARTITION(p3);

-- 追加データの挿入 (ハッシュパーティション)
INSERT INTO h_partition (name, partition_key) VALUES ("J", 8);

-- パーティション p0 からのデータ選択
SELECT * FROM h_partition PARTITION(p0);

-- キーパーティションのテーブル作成
CREATE TABLE IF NOT EXISTS k_partition (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(59)
)
PARTITION BY KEY()
PARTITIONS 2;  -- 2つのパーティションに分割

-- データの挿入 (キーパーティション)
INSERT INTO k_partition (name) VALUES
    ("A"), ("B"), ("C"), ("D"),
    ("E"), ("F"), ("G"), ("H"), ("I");

-- パーティション p1 からのデータ選択
SELECT * FROM k_partition PARTITION(p1);