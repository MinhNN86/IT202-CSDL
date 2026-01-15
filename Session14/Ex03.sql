DROP DATABASE IF EXISTS DatabaseEx03;
CREATE DATABASE DatabaseEx03;
USE DatabaseEx03;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    posts_count INT DEFAULT 0,
    following_count INT DEFAULT 0,
    followers_count INT DEFAULT 0
);
CREATE TABLE followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    PRIMARY KEY (follower_id, followed_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (followed_id) REFERENCES users(user_id)
);
CREATE TABLE follow_log(
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    follower_id INT,
    followed_id INT,
    error_message VARCHAR(255),
    create_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE PROCEDURE sp_follow_user(
    IN p_follower_id INT,
    IN p_followed_id INT
)
main_label: BEGIN
    DECLARE v_count INT DEFAULT 0;

    -- 1. Không được tự follow chính mình
    IF p_follower_id = p_followed_id THEN
        INSERT INTO follow_log (follower_id, followed_id, error_message) VALUES
        (p_follower_id, p_followed_id, 'Không thể tự follow chính mình');
        LEAVE main_label;
    END IF;

    -- 2. Kiểm tra user follower tồn tại
    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_follower_id;

    IF v_count = 0 THEN
        INSERT INTO follow_log(follower_id, followed_id, error_message) VALUES
        (p_follower_id, p_followed_id, 'Follower không tồn tại');
        LEAVE main_label;
    END IF;

    -- 3. Kiểm tra user followed tồn tại
    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_followed_id;

    IF v_count = 0 THEN
        INSERT INTO follow_log(follower_id, followed_id, error_message) VALUES
            (p_follower_id, p_followed_id, 'Followed không tồn tại');
        LEAVE main_label;
    END IF;

    -- 4. Kiểm tra đã follow trước đó chưa
    SELECT COUNT(*) INTO v_count
    FROM followers
    WHERE follower_id = p_follower_id
    AND followed_id = p_followed_id;

    IF v_count > 0 THEN
        INSERT INTO follow_log(follower_id, followed_id, error_message) VALUES
            (p_follower_id, p_followed_id, 'Đã follow trước đó');
        LEAVE main_label;
    END IF;

    -- 5. Thực hiện follow (chỉ bắt đầu transaction khi đã pass hết kiểm tra)
    START TRANSACTION;

    INSERT INTO followers(follower_id, followed_id) VALUES
    (p_follower_id, p_followed_id);

    UPDATE users
    SET following_count = following_count + 1
    WHERE user_id = p_follower_id;

    UPDATE users
    SET followers_count = followers_count + 1
    WHERE user_id = p_followed_id;

    COMMIT;
END // DELIMITER ;

-- Thêm dữ liệu test
INSERT INTO users (user_id, username) VALUES
(1, 'user1'),
(2, 'user2'),
(3, 'user3');

CALL sp_follow_user(1, 2);  -- Hợp lệ: user1 follow user2
CALL sp_follow_user(1, 2);  -- Lỗi: Đã follow trước đó
CALL sp_follow_user(1, 1);  -- Lỗi: Tự follow chính mình
CALL sp_follow_user(1, 999); -- Lỗi: Follower không tồn tại (999)

SELECT * FROM followers;
SELECT * FROM follow_log;