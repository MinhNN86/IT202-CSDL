DROP DATABASE IF EXISTS DatabaseEx03;
CREATE DATABASE DatabaseEx03;
USE DatabaseEx03;

-- Tạo bảng users
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATE,
    follower_count INT DEFAULT 0,
    post_count INT DEFAULT 0
);

-- Tạo bảng posts
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

INSERT INTO users (username, email, created_at) VALUES
    ('alice', 'alice@example.com', '2025-01-01'),
    ('bob', 'bob@example.com', '2025-01-02'),
    ('charlie', 'charlie@example.com', '2025-01-03'),
    ('david', 'david@example.com', '2025-01-04');
INSERT INTO posts (user_id, content, created_at) VALUES
    (1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
    (1, 'Alice second post', '2025-01-10 12:00:00'),
    (2, 'Bob first post', '2025-01-11 09:00:00'),
    (3, 'Charlie sharing thoughts', '2025-01-12 15:00:00'),
    (4, 'David joins the platform', '2025-01-13 08:30:00');
INSERT INTO likes (user_id, post_id, liked_at) VALUES
-- Bob & Charlie like bài của Alice
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),

-- Alice & David like bài của Bob
(1, 3, '2025-01-11 10:00:00'),
(4, 3, '2025-01-11 10:30:00'),

-- Alice & Bob like bài của Charlie
(1, 4, '2025-01-12 16:00:00'),
(2, 4, '2025-01-12 16:10:00'),

-- Charlie like bài của David
(3, 5, '2025-01-13 09:00:00');

DELIMITER //
CREATE TRIGGER trg_before_insert_like
BEFORE INSERT ON likes
FOR EACH ROW
BEGIN
    DECLARE post_owner INT;

    SELECT user_id INTO post_owner
    FROM posts
    WHERE post_id = NEW.post_id;

    IF NEW.user_id = post_owner THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT  = 'Không được like bài viết của chính mình';
    END IF;
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
CREATE TRIGGER trg_after_update_like
AFTER UPDATE ON likes
FOR EACH ROW
BEGIN
    IF OLD.post_id <> NEW.post_id THEN
        UPDATE posts
        SET like_count = like_count - 1
        WHERE post_id = OLD.post_id;

        UPDATE posts
        SET like_count = like_count + 1
        WHERE post_id = NEW.post_id;
    END IF;
END // DELIMITER ;

-- Giả sử post_id = 1 là của user_id = 1
INSERT INTO likes(user_id, post_id)
VALUES (1, 1);

INSERT INTO likes(user_id, post_id)
VALUES (2, 1);

SELECT * FROM posts WHERE post_id = 1;

CREATE VIEW user_statistics AS
SELECT
    u.user_id,
    u.username,
    u.post_count,
    IFNULL(SUM(p.like_count), 0) AS total_likes
FROM users u
         LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.post_count;

SELECT * FROM posts;
SELECT * FROM user_statistics;