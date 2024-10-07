CREATE TABLE users (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,           -- ユーザーの一意なID
    name VARCHAR(50) NOT NULL,                            -- ユーザー名（必須）
    password VARCHAR(255) CHECK (CHAR_LENGTH(password) >= 8), -- ハッシュ化されたパスワード（8文字以上必須）
    email VARCHAR(50) UNIQUE NOT NULL,                   -- ユーザーのメールアドレス（一意、必須）
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- アカウント作成日時
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 最終更新日時
);

CREATE TABLE tweets (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,           -- ツイートの一意なID
    message VARCHAR(140) NOT NULL,                        -- ツイート内容（必須、140文字以内）
    user_id INT UNSIGNED,                                 -- 投稿したユーザーのID
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- ツイート作成日時
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 最終更新日時
    CONSTRAINT fk_users_tweets FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE -- ユーザーへの外部キー制約
);

CREATE TABLE likes (
    user_id INT UNSIGNED,                                 -- いいねをしたユーザーのID
    tweet_id INT UNSIGNED,                                -- いいねされたツイートのID
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- いいね作成日時
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 最終更新日時
    CONSTRAINT fk_users_like FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, -- ユーザーへの外部キー制約
    CONSTRAINT fk_tweets_like FOREIGN KEY (tweet_id) REFERENCES tweets(id) ON DELETE CASCADE, -- ツイートへの外部キー制約
    PRIMARY KEY (user_id, tweet_id)                       -- 複合主キー（ユーザーIDとツイートID）
);

CREATE TABLE follows (
    follower_id INT UNSIGNED,                             -- フォロワーのユーザーID
    followee_id INT UNSIGNED,                            -- フォローされているユーザーID
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- フォロー作成日時
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 最終更新日時
    CONSTRAINT fk_users_follower FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE, -- フォロワーへの外部キー制約
    CONSTRAINT fk_users_followee FOREIGN KEY (followee_id) REFERENCES users(id) ON DELETE CASCADE, -- フォローされるユーザーへの外部キー制約
    PRIMARY KEY (follower_id, followee_id)               -- 複合主キー（フォロワーIDとフォローされるユーザーID）
);