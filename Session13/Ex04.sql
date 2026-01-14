DROP DATABASE IF EXISTS DatabaseEx04;
CREATE DATABASE DatabaseEx04;
USE DatabaseEx04;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATE,
    follower_count INT DEFAULT 0,
    post_count INT DEFAULT 0
);
CREATE TABLE posts (
post_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT,
content TEXT,
created_at DATETIME,
like_count INT DEFAULT 0,
FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    post_id INT,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);
CREATE TABLE post_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME,
    changed_by_user_id INT,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER trg_after_insert_like
    AFTER INSERT ON likes
    FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END // DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_after_delete_like
    AFTER DELETE ON likes
    FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END // DELIMITER ;


INSERT INTO users (username, email, created_at) VALUES
    ('alice', 'alice@example.com', '2025-01-01'),
    ('bob', 'bob@example.com', '2025-01-02'),
    ('charlie', 'charlie@example.com', '2025-01-03');
INSERT INTO posts (user_id, content, created_at) VALUES
    (1, 'Alice first post', '2025-01-10 10:00:00'),
    (2, 'Bob first post', '2025-01-11 09:00:00'),
    (3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');
INSERT INTO likes (user_id, post_id) VALUES
    (2, 1),
    (3, 1),
    (1, 2),
    (3, 2),
    (1, 3);

DELIMITER //
CREATE TRIGGER trg_before_update_post
BEFORE UPDATE ON posts
FOR EACH ROW
BEGIN
    IF OLD.content <> NEW.content THEN
        INSERT INTO post_history (
            post_id,
            old_content,
            new_content,
            changed_at,
            changed_by_user_id
        )
        VALUES (
                OLD.post_id,
                OLD.content,
                NEW.content,
                NOW(),
                OLD.user_id);
    END IF;
END // DELIMITER ;

UPDATE posts
SET content = 'Alice first post (edited version)'
WHERE post_id = 1;

UPDATE posts
SET content = 'Bob post updated'
WHERE post_id = 2;

SELECT * FROM post_history;


