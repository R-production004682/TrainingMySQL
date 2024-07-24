USE my_db;

SELECT DATABASE();

-- 主キー無しテーブル作成
CREATE TABLE users (
    id INT,
    name VARCHAR(10),
    age INT,
    phone_number char(13),
    message TEXT
);

SHOW TABLES;
DESCRIBE users;

DROP TABLE users;
SHOW TABLES;

-- 主キー付きテーブル作成
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(10),
    age INT,
    phone_number char(13),
    message TEXT
);

DESCRIBE users;
