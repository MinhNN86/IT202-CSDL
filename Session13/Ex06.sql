DROP DATABASE IF EXISTS DatabaseEx06;
CREATE DATABASE DatabaseEx06;
USE DatabaseEx06;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
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
CREATE TABLE friendships (
    follower_id INT,
    followee_id INT,
    status ENUM('pending', 'accepted') DEFAULT 'accepted',
    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (followee_id) REFERENCES users(user_id) ON DELETE CASCADE
);

INSERT INTO users (username, email, created_at) VALUES
    ('alice', 'alice@gmail.com', '2025-01-01'),
    ('bob', 'bob@gmail.com', '2025-01-02'),
    ('charlie', 'charlie@gmail.com', '2025-01-03'),
    ('david', 'david@gmail.com', '2025-01-04');
INSERT INTO posts (user_id, content, created_at) VALUES
    (1, 'Alice post 1', NOW()),
    (1, 'Alice post 2', NOW()),
    (2, 'Bob post 1', NOW()),
    (3, 'Charlie post 1', NOW());
INSERT INTO likes (user_id, post_id) VALUES
    (2, 1),
    (3, 1),
    (4, 1),
    (1, 3),
    (3, 3);

DELIMITER //
CREATE TRIGGER trg_after_insert_friendships
AFTER INSERT ON friendships
FOR EACH ROW
BEGIN
    IF NEW.status = 'accepted' THEN
        UPDATE users
        SET follower_count = follower_count + 1
        WHERE user_id = NEW.followee_id;
    END IF;
END // DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_after_delete_friendship
AFTER DELETE ON friendships
FOR EACH ROW
BEGIN
    IF OLD.status = 'accepted' THEN
        UPDATE users
        SET follower_count = follower_count - 1
        WHERE user_id = OLD.followee_id;
    END IF ;
END // DELIMITER ;

DELIMITER //
CREATE PROCEDURE follow_user(
    IN p_follower_id INT,
    IN p_followee_id INT,
    IN p_status ENUM('pending', 'accepted')
)
BEGIN
    DECLARE check_follow INT DEFAULT 0;

    IF p_follower_id = p_followee_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Không được tự follow chính mình';
    END IF;

    -- Không cho follow trùng
    SELECT COUNT(*) INTO check_follow
    FROM friendships
    WHERE follower_id = p_follower_id
    AND followee_id = p_followee_id;
    

    INSERT INTO friendships (follower_id, followee_id, status)
    VALUES (p_follower_id, p_followee_id, p_status);

END // DELIMITER ;

CREATE VIEW user_profile AS
SELECT
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    IFNULL(SUM(p.like_count), 0) AS total_likes,
    GROUP_CONCAT(p.content ORDER BY p.created_at DESC SEPARATOR ' | ') AS recent_posts
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.follower_count, u.post_count;

CALL follow_user(2, 1, 'accepted'); -- Bob follow Alice
CALL follow_user(3, 1, 'accepted'); -- Charlie follow Alice
CALL follow_user(4, 1, 'accepted'); -- David follow Alice

CALL follow_user(1, 1, 'accepted');
CALL follow_user(2, 1, 'accepted');
DELETE FROM friendships
WHERE follower_id = 3 AND followee_id = 1;

SELECT user_id, username, follower_count FROM users;
SELECT * FROM friendships;
SELECT * FROM user_profile;

