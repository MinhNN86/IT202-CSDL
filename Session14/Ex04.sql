DROP DATABASE IF EXISTS DatabaseEx04;
CREATE DATABASE DatabaseEx04;
USE DatabaseEx04;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    posts_count INT DEFAULT 0
);
CREATE TABLE posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    like_count INT DEFAULT 0,
    comments_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
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
CREATE PROCEDURE sp_post_comment(
    p_post_id INT,
    p_user_id INT,
    p_content TEXT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    proc_end: BEGIN
        START TRANSACTION;
        -- 1. Kiểm tra post tồn tại
        SELECT COUNT(*) INTO v_count
        FROM posts
        WHERE post_id = p_post_id;

        IF v_count = 0 THEN
            ROLLBACK ;
            LEAVE proc_end;
        END IF;

        -- 2. Kiểm tra user tồn tại
        SELECT COUNT(*) INTO v_count
        FROM users
        WHERE user_id = p_user_id ;

        IF v_count = 0 THEN
            ROLLBACK ;
            LEAVE proc_end;
        END IF;

        -- 3. Thêm bình luận
        INSERT INTO comments(post_id, user_id, content) VALUES
        (p_post_id, p_user_id, p_content);

        -- 4. Tạo savepoint sau khi insert comment
        SAVEPOINT after_insert;

        -- 5. Cập nhật số lượng comment
        UPDATE posts
        SET comments_count = comments_count + 1
        WHERE post_id = p_post_id;

        COMMIT ;
    END proc_end;
END // 
DELIMITER ;

INSERT INTO users (user_id, username) VALUES
    (1, 'user1'),
    (2, 'user2'),
    (3, 'user3');
INSERT INTO posts (user_id, content) VALUES
    (1, 'Bài viết đầu tiên của Minh');

CALL sp_post_comment(1, 1, 'Bình luận đầu tiên');

-- Trường hợp 2: Gây lỗi ở bước UPDATE
-- Xóa post trước khi gọi thủ tục để UPDATE bị lỗi
DELETE FROM posts WHERE post_id = 1;
CALL sp_post_comment(1, 1, 'Bình luận thứ hai');

-- Giải thích:
-- 1. Thủ tục sẽ thêm bình luận vào bảng comments và tạo savepoint.
-- 2. Khi đến bước UPDATE posts SET comments_count = comments_count + 1 WHERE post_id = p_post_id;
--    do post_id = 1 đã bị xóa nên câu lệnh UPDATE sẽ không cập nhật được dòng nào (hoặc có thể gây lỗi nếu có ràng buộc khác).
-- 3. Nếu có xử lý lỗi bằng HANDLER, có thể rollback về savepoint after_insert để không mất bình luận vừa thêm.