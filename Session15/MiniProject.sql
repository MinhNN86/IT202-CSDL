DROP DATABASE IF EXISTS Mini_project_SS15;
CREATE DATABASE Mini_project_SS15;
USE Mini_project_SS15;


-- BÀI 1 – ĐĂNG KÝ THÀNH VIÊN
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(50),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE PROCEDURE sp_register_user(
    p_username VARCHAR(50),
    p_password VARCHAR(255),
    p_email VARCHAR(100)
)
BEGIN
    DECLARE u_count INT DEFAULT 0;

    # Kiểm tra user tồn tại
    SELECT COUNT(*) INTO u_count
    FROM users
    WHERE username = p_username;
    IF u_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username đã tồn tại';
    END IF;

    # Kiểm tra email đã tồn tại
    SELECT COUNT(*) INTO u_count
    FROM users
    WHERE email = p_email;
    IF u_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email đã tồn tại';
    END IF;

    INSERT INTO users(username, password, email) VALUES
    (p_username, p_password, p_email);

END // DELIMITER ;

CREATE TRIGGER trg_user_register
AFTER INSERT ON users
FOR EACH ROW
INSERT INTO user_log(user_id, action)
VALUES (NEW.user_id, 'REGISTER');

-- === DEMO ===
CALL sp_register_user('alice','123','alice@mail.com');
CALL sp_register_user('bob','123','bob@mail.com');
CALL sp_register_user('charlie','123','charlie@mail.com');

# lỗi
CALL sp_register_user('alice','123','x@mail.com');

SELECT * FROM users;
SELECT * FROM user_log;

-- BÀI 2: ĐĂNG BÀI
CREATE TABLE posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE post_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    action VARCHAR(50),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE PROCEDURE sp_create_post(
    p_user_id INT ,
    p_content TEXT
)
BEGIN
    DECLARE u_count INT DEFAULT 0;

    # Kiểm tra user không tồn tại
    SELECT COUNT(*) INTO u_count
    FROM users
    WHERE user_id = p_user_id;
    IF u_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username không tồn tại';
    END IF;

    -- Kiểm tra nội dung trống
    IF p_content IS NULL OR p_content = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nội dung không được rỗng';
    END IF;

    INSERT INTO posts(user_id, content) VALUES
    (p_user_id, p_content);

END // DELIMITER ;

CREATE TRIGGER trg_post_create
AFTER INSERT ON posts
FOR EACH ROW
INSERT INTO post_log(post_id, action)
VALUES (NEW.post_id, 'CREATE_POST');

-- === DEMO ===
CALL sp_create_post(1,'Hello World');
CALL sp_create_post(1,'Post 2');
CALL sp_create_post(2,'Bob Post');

-- lỗi
CALL sp_create_post(1,'');

SELECT * FROM posts;
SELECT * FROM post_log;

-- BÀI 3 – LIKE / UNLIKE

ALTER TABLE posts ADD like_count INT DEFAULT 0;
CREATE TABLE likes (
    user_id INT,
    post_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id)
);
CREATE TRIGGER trg_like_add
    AFTER INSERT ON likes
    FOR EACH ROW
    UPDATE posts SET like_count = like_count + 1 WHERE post_id = NEW.post_id;

CREATE TRIGGER trg_like_remove
    AFTER DELETE ON likes
    FOR EACH ROW
    UPDATE posts SET like_count = like_count - 1 WHERE post_id = OLD.post_id;

-- === DEMO ====
INSERT INTO likes VALUES (1,1,NOW());
INSERT INTO likes VALUES (2,1,NOW());
DELETE FROM likes WHERE user_id = 1 AND post_id = 1;

SELECT post_id, like_count FROM posts;

-- BÀI 4 – GỬI LỜI MỜI BẠN
CREATE TABLE friends (
    user_id INT,
    friend_id INT,
    status VARCHAR(20) DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (friend_id) REFERENCES users(user_id)
);

DELIMITER //
CREATE PROCEDURE sp_send_friend_request(
    IN p_sender INT,
    IN p_receiver INT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    # Kiểm tra tự kết bạn
    IF p_sender = p_receiver THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Không thể tự kết bạn';
    END IF;

    # Kiểm tra đã gửi lời mời chưa
    SELECT COUNT(*) INTO v_count
    FROM friends
    WHERE user_id = p_sender AND friend_id = p_receiver;
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Đã gửi lời mời';
    END IF;

    INSERT INTO friends(user_id, friend_id)
    VALUES (p_sender, p_receiver);
END // DELIMITER ;

-- === DEMO ===
CALL sp_send_friend_request(1,2);
CALL sp_send_friend_request(2,3);

-- lỗi
CALL sp_send_friend_request(1,1);

SELECT * FROM friends;

-- BÀI 5 – CHẤP NHẬN KẾT BẠN
DELIMITER //
CREATE PROCEDURE sp_accept_friend(
    IN p_user INT,
    IN p_friend INT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    START TRANSACTION;

    # Validate p_user tồn tại
    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_user;
    IF v_count = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User không tồn tại';
    END IF;

    # Validate p_friend tồn tại
    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_friend;
    IF v_count = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Friend không tồn tại';
    END IF;

    UPDATE friends
    SET status='accepted' 
    WHERE user_id = p_friend 
    AND friend_id = p_user 
    AND status = 'pending';  

    IF ROW_COUNT() = 0 THEN  
        ROLLBACK;  
        SIGNAL SQLSTATE '45000'  
        SET MESSAGE_TEXT = 'Không có lời mời hợp lệ';
    END IF;

    INSERT INTO friends(user_id, friend_id, status) 
    VALUES (p_user, p_friend, 'accepted'); 

    COMMIT;  
END // DELIMITER ;

-- === DEMO ===
CALL sp_accept_friend(2,1);
SELECT * FROM friends;

-- BÀI 6 – QUẢN LÝ QUAN HỆ BẠN
DELIMITER //
CREATE PROCEDURE sp_unfriend(
    IN p_user INT,
    IN p_friend INT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    START TRANSACTION;

    # Kiểm tra p_user có tồn tại không
    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_user;
    IF v_count = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User không tồn tại';
    END IF;

    # Kiểm tra p_friend có tồn tại không
    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_friend;
    IF v_count = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Friend không tồn tại';
    END IF;

    # Xóa quan hệ bạn bè
    DELETE FROM friends
    WHERE (user_id = p_user AND friend_id = p_friend)
       OR (user_id=p_friend AND friend_id=p_user);

    COMMIT;
END // DELIMITER ;

-- BÀI 7 – XÓA BÀI VIẾT
CREATE TABLE comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(post_id) REFERENCES posts(post_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id)
);

DELIMITER //
CREATE PROCEDURE sp_delete_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    START TRANSACTION;

    -- Kiểm tra tồn tại post
    SELECT COUNT(*) INTO v_count
    FROM posts
    WHERE post_id = p_post_id AND user_id = p_user_id;
    IF v_count = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='Không có quyền xóa';
    END IF;

    DELETE FROM likes WHERE post_id = p_post_id;
    DELETE FROM comments WHERE post_id = p_post_id;
    DELETE FROM posts WHERE post_id = p_post_id;

    COMMIT;
END // DELIMITER ;

-- BÀI 8 – XÓA TÀI KHOẢN USER
DELIMITER //
CREATE PROCEDURE sp_delete_user(
    IN p_user_id INT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    START TRANSACTION;

    # Kiểm tra p_user_id có tồn tại không
    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_user_id;
    IF v_count = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User không tồn tại';
    END IF;

    DELETE FROM likes WHERE user_id=p_user_id;
    DELETE FROM comments WHERE user_id=p_user_id;
    DELETE FROM friends WHERE user_id=p_user_id OR friend_id=p_user_id;
    DELETE FROM posts WHERE user_id=p_user_id;
    DELETE FROM users WHERE user_id=p_user_id;

    COMMIT;
END // DELIMITER ;


