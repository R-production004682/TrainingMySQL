USE my_db3;

CREATE TABLE messages
(
    name_code CHAR(8), -- 固定長のコード/ID用
    name VARCHAR(25),  -- 可変長の名前
    message TEXT       -- 長いメッセージ用（最大 65535 バイト）
);

INSERT INTO messages (name_code, name, message)
VALUES
    ("00000001", "Yoshida Takeshi", "これはテストメッセージです。"),
    ("00000002", "Yoshida Yusaku", "こちらは別のテストメッセージです。");