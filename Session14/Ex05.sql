DROP DATABASE IF EXISTS DatabaseEx05;
CREATE DATABASE DatabaseEx05;
USE DatabaseEx05;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    posts_count INT DEFAULT 0
);
CREATE TABLE posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
CREATE TABLE delete_log(
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL ,
    delete_by INT NOT NULL ,
    delete_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL UNIQUE ,
    user_id INT NOT NULL UNIQUE ,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE comments(
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL ,
    user_id INT NOT NULL ,
    content TEXT NOT NULL ,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE ,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

DELIMITER //
CREATE PROCEDURE sp_delete_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE v_owner_id INT;
    DECLARE v_count INT DEFAULT 0;

    proc_end: BEGIN
        START TRANSACTION ;
        -- 1. Kiểm tra bài viết tồn tại và thuộc về user
        SELECT user_id INTO v_owner_id
        FROM posts
        WHERE post_id = p_post_id;

        -- Nếu không tìm thấy bài viết hoặc không phải chủ sở hữu thì rollback và thoát
        IF v_owner_id IS NULL OR v_owner_id <> p_user_id THEN
            ROLLBACK ;
            LEAVE proc_end;
        END IF;

        -- 2. Xóa likes của bài viết
        DELETE FROM likes
        WHERE post_id = p_post_id;

        -- 3. Xóa comments của bài viết
        DELETE FROM comments
        WHERE post_id = p_post_id;

        -- 4. Xóa bài viết
        DELETE FROM posts
        WHERE post_id = p_post_id;

        -- 5. Giảm posts_count của user
        UPDATE users
        SET posts_count = posts_count - 1
        WHERE user_id = p_user_id;

        -- 6. Ghi log xóa thành công
        INSERT INTO delete_log(post_id, delete_by) VALUES
        (p_post_id, p_user_id);
        COMMIT ;
    END proc_end;

END // DELIMITER ;

INSERT INTO users (user_id, username) VALUES
    (1, 'user1'),
    (2, 'user2'),
    (3, 'user3');
INSERT INTO posts (user_id, content) VALUES
    (1, 'Bài viết đầu tiên của Minh');

CALL sp_delete_post(1, 1);

CALL sp_delete_post(1, 2);
CALL sp_delete_post(999, 1);

