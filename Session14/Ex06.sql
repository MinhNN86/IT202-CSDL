DROP DATABASE IF EXISTS DatabaseEx06;
CREATE DATABASE DatabaseEx06;
USE DatabaseEx06;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    friends_count INT DEFAULT 0
);
CREATE TABLE friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (friend_id) REFERENCES users(user_id)
);

CREATE TABLE friend_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    from_user_id INT NOT NULL,
    to_user_id INT NOT NULL,
    status ENUM('pending','accepted','rejected') DEFAULT 'pending',
    FOREIGN KEY (from_user_id) REFERENCES users(user_id),
    FOREIGN KEY (to_user_id) REFERENCES users(user_id)
);

DELIMITER //
CREATE PROCEDURE sp_accept_friend_request (
    IN p_request_id INT,
    IN p_to_user_id INT
)
BEGIN
    DECLARE v_from_user INT;
    DECLARE v_status VARCHAR(10);
    DECLARE v_count INT DEFAULT 0;

    proc_end: BEGIN
        START TRANSACTION;

        -- 1. Lấy thông tin request
        SELECT from_user_id, status
        INTO v_from_user, v_status
        FROM friend_requests
        WHERE request_id = p_request_id
        AND to_user_id = p_to_user_id;

        -- 2. Kiểm tra request hợp lệ
        IF v_from_user IS NULL OR v_status <> 'pending' THEN
            ROLLBACK;
            LEAVE proc_end;
        END IF;

        -- 3. Kiểm tra đã là bạn chưa
        SELECT COUNT(*) INTO v_count
        FROM friends
        WHERE user_id = p_to_user_id
          AND friend_id = v_from_user;

        IF v_count > 0 THEN
            ROLLBACK;
            LEAVE proc_end;
        END IF;

        -- 4. Thêm quan hệ bạn bè hai chiều
        INSERT INTO friends (user_id, friend_id)
        VALUES (p_to_user_id, v_from_user);

        INSERT INTO friends (user_id, friend_id)
        VALUES (v_from_user, p_to_user_id);

        -- 5. Tăng friends_count cho cả hai
        UPDATE users
        SET friends_count = friends_count + 1
        WHERE user_id IN (p_to_user_id, v_from_user);

        -- 6. Cập nhật trạng thái request
        UPDATE friend_requests
        SET status = 'accepted'
        WHERE request_id = p_request_id;

        COMMIT;
    END proc_end;

END // DELIMITER ;
INSERT INTO users (user_id, username) VALUES
    (1, 'user1'),
    (2, 'user2'),
    (3, 'user3');

INSERT INTO friend_requests (from_user_id, to_user_id)
VALUES (1, 2);

CALL sp_accept_friend_request(1, 2);
-- SAI: Chấp nhận thêm lần nữa
CALL sp_accept_friend_request(1, 2);
-- SAI: Sai người chấp nhận
CALL sp_accept_friend_request(1, 3);

