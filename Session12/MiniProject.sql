DROP DATABASE IF EXISTS Mini_project_SS12;
CREATE DATABASE Mini_project_SS12;
USE Mini_project_SS12;

CREATE TABLE Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE TABLE Comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE TABLE Friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'accepted')),
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (friend_id) REFERENCES Users(id)
);

CREATE TABLE Likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (post_id) REFERENCES Posts(id)
);

-- Bài 1:
# Thêm người dùng mới (use column name `password`)
INSERT INTO Users(username, password, email) VALUES
    ('minhnn', '1234@', 'minhnn@example.com');

# Hiển thị danh sác người dùng
SELECT * FROM Users;

-- Bài 2:
-- 1. Tạo VIEW chỉ hiển thị thông tin công khai (alias id -> user_id)
CREATE OR REPLACE VIEW vw_public_users AS
SELECT
    id AS user_id,
    username,
    created_at
FROM Users;

-- 2. SELECT từ VIEW
SELECT * FROM vw_public_users;

-- 3. SELECT trực tiếp từ bảng Users (để so sánh)
SELECT * FROM Users;

-- Bài 3
-- 1. Tạo INDEX cho username
CREATE INDEX idx_username ON Users(username);

-- Xem danh sách index của bảng Users
SHOW INDEX FROM Users;

-- 2. Truy vấn tìm user theo username (sử dụng INDEX)
SELECT id AS user_id, username, email
FROM Users
WHERE username = 'minhnn';

-- Truy vấn tìm user với pattern (sử dụng INDEX - chỉ hiệu quả với prefix)
SELECT id AS user_id, username
FROM Users
WHERE username LIKE 'minh%';

-- Bài 4: Procedure tạo bài viết (kiểm tra user tồn tại)
DELIMITER //
CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE user_exists INT;

    SELECT COUNT(*) INTO user_exists
    FROM Users
    WHERE id = p_user_id;

    IF user_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User không tồn tại';
    END IF;

    INSERT INTO Posts(user_id, content) VALUES
        (p_user_id, p_content);

    SELECT 'Đăng bài viết thành công' AS message;
END //
DELIMITER ;

# Gọi Procedure để tạo bài viết
CALL sp_create_post(1, 'Đây là bài viết đầu tiên của tôi');
# Kiểm tra bài viết vừa tạo
SELECT * FROM Posts;
# Thử gọi với user_id không tồn tại (sẽ báo lỗi)
CALL sp_create_post(999, 'Bài viết từ user không tồn tại');

-- Bài 5: View recent posts (7 ngày)
CREATE OR REPLACE VIEW vw_recent_posts AS
SELECT
    p.id AS post_id,
    p.user_id,
    u.username,
    p.content,
    p.created_at,
    (SELECT COUNT(*) FROM Likes l WHERE l.post_id = p.id) AS like_count,
    (SELECT COUNT(*) FROM Comments c WHERE c.post_id = p.id) AS comment_count
FROM Posts p
         JOIN Users u ON p.user_id = u.id
WHERE p.created_at >= NOW() - INTERVAL 7 DAY;

SELECT *
FROM vw_recent_posts
ORDER BY created_at DESC;

-- Bài 6: Index optimization
CREATE INDEX idx_post_user_created_at ON Posts(user_id, created_at);

SELECT id AS post_id, user_id, content, created_at
FROM Posts
WHERE user_id = 1
ORDER BY created_at DESC
LIMIT 20;

SHOW INDEX FROM Posts;

-- Bài 7: Procedure đếm số bài viết của 1 user
DELIMITER //
CREATE PROCEDURE sp_count_posts(
    IN p_user_id INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_total
    FROM Posts
    WHERE user_id = p_user_id;
END //
DELIMITER ;

CALL sp_count_posts(1, @total_posts);
SELECT @total_posts AS 'Tổng số bài viết';

-- Bài 8: Thêm cột status và view active users
ALTER TABLE Users ADD COLUMN status VARCHAR(20) DEFAULT 'active'
    CHECK (status IN ('active', 'inactive', 'banned'));

CREATE OR REPLACE VIEW vw_active_users AS
SELECT id AS user_id,
       username,
       password,
       email,
       status,
       created_at
FROM Users
WHERE status = 'active'
WITH CHECK OPTION;

# INSERT / UPDATE thông qua View
INSERT INTO vw_active_users(username, password, email, status) VALUES
    ('user_active', '123@','active@example.com', 'active');

UPDATE vw_active_users
SET email = 'newemail@example.com'
WHERE username = 'minhnn';

-- Bài 9
DELIMITER //
CREATE PROCEDURE sp_add_friend(
    IN p_user_id INT,
    IN p_friend_id INT
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_exists INT;

    -- 1) Cannot friend yourself
    IF p_user_id = p_friend_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot add yourself as a friend';
    ELSE
        -- 2) Check both users exist
        SELECT COUNT(*) INTO v_count FROM Users WHERE id IN (p_user_id, p_friend_id);
        IF v_count < 2 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or both users do not exist';
        ELSE
            -- 3) Check existing friend/request in either direction
            SELECT COUNT(*) INTO v_exists
            FROM Friends
            WHERE (user_id = p_user_id AND friend_id = p_friend_id)
               OR (user_id = p_friend_id AND friend_id = p_user_id);

            IF v_exists > 0 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Friend request already exists or users are already friends';
            ELSE
                -- 4) Insert pending friend request
                INSERT INTO Friends(user_id, friend_id, status)
                VALUES (p_user_id, p_friend_id, 'pending');

                SELECT 'Friend request sent' AS message;
            END IF;
        END IF;
    END IF;
END //
DELIMITER ;

INSERT INTO Users(username, password, email) VALUES
    ('alice', 'pwd@123', 'alice@example.com');

CALL sp_add_friend(1, 2);
SELECT * FROM Friends;

-- Bài 10
DELIMITER //
CREATE PROCEDURE sp_suggest_friends_simple(
    IN p_user_id INT,
    IN p_limit INT
)
BEGIN
    SELECT id AS suggested_id, username, email
    FROM Users
    WHERE id != p_user_id
      AND id NOT IN (
          SELECT friend_id FROM Friends WHERE user_id = p_user_id
          UNION
          SELECT user_id FROM Friends WHERE friend_id = p_user_id
      )
    LIMIT p_limit;
END // DELIMITER ;

-- Ví dụ gọi procedure:
SET @limit = 5;
CALL sp_suggest_friends(1, @limit);
SELECT @limit AS 'Số lượng gợi ý thực tế';

-- Bài 11:
#1
SELECT
    p.id AS post_id,
    p.content,
    p.user_id,
    u.username,
    COUNT(l.user_id) AS like_count,
    p.created_at
FROM Posts p
JOIN Users u ON p.user_id = u.id
LEFT JOIN Likes l ON p.id = l.post_id
GROUP BY p.id, p.content, p.user_id, u.username, p.created_at
ORDER BY like_count DESC
LIMIT 5;
#2 
CREATE OR REPLACE VIEW vw_top_posts AS
SELECT
    p.id AS post_id,
    p.content,
    p.user_id,
    u.username,
    COUNT(l.user_id) AS like_count,
    p.created_at
FROM Posts p
JOIN Users u ON p.user_id = u.id
LEFT JOIN Likes l ON p.id = l.post_id
GROUP BY p.id, p.content, p.user_id, u.username, p.created_at
ORDER BY like_count DESC
LIMIT 5;
#3
CREATE INDEX idx_likes_post_id ON Likes(post_id);

SELECT * FROM vw_top_posts;

-- Bài 12: 
DELIMITER //
CREATE PROCEDURE sp_add_comment(
    IN p_user_id INT,
    IN p_post_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE user_exists INT;
    DECLARE post_exists INT;

    -- Kiểm tra user tồn tại
    SELECT COUNT(*) INTO user_exists FROM Users WHERE id = p_user_id;
    -- Kiểm tra post tồn tại
    SELECT COUNT(*) INTO post_exists FROM Posts WHERE id = p_post_id;

    IF user_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User không tồn tại';
    ELSEIF post_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Post không tồn tại';
    ELSE
        INSERT INTO Comments(post_id, user_id, content) VALUES (p_post_id, p_user_id, p_content);
        SELECT 'Thêm bình luận thành công' AS message;
    END IF;
END //
DELIMITER ;

# Tạo View hiển thị bình luận
CREATE OR REPLACE VIEW vw_post_comments AS
SELECT
    c.id AS comment_id,
    c.post_id,
    u.username AS commenter,
    c.content,
    c.created_at
FROM Comments c
JOIN Users u ON c.user_id = u.id;

# Ví dụ gọi procedure:
CALL sp_add_comment(1, 1, 'Bài viết rất hay!');
SELECT * FROM vw_post_comments WHERE post_id = 1;

-- Bài 13: 
DELIMITER //
CREATE PROCEDURE sp_like_post(
    IN p_user_id INT,
    IN p_post_id INT
)
BEGIN
    DECLARE already_liked INT;

    -- Kiểm tra user đã thích post chưa
    SELECT COUNT(*) INTO already_liked
    FROM Likes
    WHERE user_id = p_user_id AND post_id = p_post_id;

    IF already_liked > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User đã thích bài viết này!';
    ELSE
        INSERT INTO Likes(user_id, post_id) VALUES (p_user_id, p_post_id);
        SELECT 'Đã ghi nhận lượt thích' AS message;
    END IF;
END // DELIMITER ;

# Tạo View thống kê lượt thích
CREATE OR REPLACE VIEW vw_post_likes AS
SELECT
    post_id,
    COUNT(*) AS like_count
FROM Likes
GROUP BY post_id;

# Ví dụ gọi procedure:
CALL sp_like_post(1, 1);
SELECT * FROM vw_post_likes WHERE post_id = 1;

-- Bài 14
DELIMITER //
CREATE PROCEDURE sp_search_social(
    IN p_option INT,
    IN p_keyword VARCHAR(100)
)
BEGIN
    IF p_option = 1 THEN
        # Tìm người dùng theo username
        SELECT id AS user_id, username, email, created_at
        FROM Users
        WHERE username LIKE CONCAT('%', p_keyword, '%');
    ELSEIF p_option = 2 THEN
        # Tìm bài viết theo content
        SELECT p.id AS post_id, p.content, p.user_id, u.username, p.created_at
        FROM Posts p
        JOIN Users u ON p.user_id = u.id
        WHERE p.content LIKE CONCAT('%', p_keyword, '%');
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Giá trị p_option không hợp lệ!';
    END IF;
END // DELIMITER ;

#Tìm người dùng có username chứa từ "an"
CALL sp_search_social(1, 'minh');

# Tìm bài viết có nội dung chứa từ "database"
CALL sp_search_social(2, 'database');
