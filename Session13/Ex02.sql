DROP DATABASE IF EXISTS DatabaseEx02;
CREATE DATABASE DatabaseEx02;
USE DatabaseEx02;

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

INSERT INTO users (username, email, created_at, post_count) VALUES
    ('alice', 'alice@example.com', '2025-01-01', 2),
    ('bob', 'bob@example.com', '2025-01-02', 1),
    ('charlie', 'charlie@example.com', '2025-01-03', 1);
INSERT INTO posts (user_id, content, created_at) VALUES
    (1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
    (1, 'Second post by Alice', '2025-01-10 12:00:00'),
    (2, 'Bob first post', '2025-01-11 09:00:00'),
    (3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');
INSERT INTO likes (user_id, post_id, liked_at) VALUES
    (2, 1, '2025-01-10 11:00:00'),
    (3, 1, '2025-01-10 13:00:00'),
    (1, 3, '2025-01-11 10:00:00'),
    (3, 4, '2025-01-12 16:00:00');

-- Tạo TRIGGER
DELIMITER //
CREATE TRIGGER trg_after_insert_like
    AFTER INSERT ON likes
    FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END // DELIMITER ;
-- Tạo TRIGGER
DELIMITER //
CREATE TRIGGER trg_after_delete_like
    AFTER DELETE ON likes
    FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END // DELIMITER ;

-- Tạo view
CREATE VIEW user_statistics AS
SELECT
    u.user_id,
    u.username,
    u.post_count,
    IFNULL(SUM(p.like_count), 0) AS total_likes
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.post_count;

INSERT INTO likes (user_id, post_id, liked_at)
VALUES (2, 4, NOW());

-- Kiểm tra like_count của post_id = 4
SELECT * FROM posts WHERE post_id = 4;

-- Kiểm tra View
SELECT * FROM user_statistics;


