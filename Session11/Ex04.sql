USE social_network_pro;

-- 2) Viết procedure
DELIMITER //
CREATE PROCEDURE CreatePostWithValidation(
    IN p_user_id INT,
    IN p_content TEXT,
    OUT result_message VARCHAR(255)
)
BEGIN
    IF CHAR_LENGTH(p_content) < 5 THEN
        SET result_message = 'Nội dung quá ngắn';
    ELSE
        INSERT INTO posts(user_id, content) VALUES
        (p_user_id, p_content);
        SET result_message = 'Thêm bài viết thành công';
    END IF;
END //
DELIMITER ;

-- 3) Gọi thủ tục và thử insert các trường hợp

-- Trường hợp 1: Nội dung quá ngắn (< 5 ký tự)
CALL CreatePostWithValidation(1, 'Hi', @msg1);
SELECT @msg1 AS result_case_1;

-- Trường hợp 2: Nội dung đúng (>= 5 ký tự)
CALL CreatePostWithValidation(1, 'Xin chào tất cả mọi người!', @msg2);
SELECT @msg2 AS result_case_2;

-- Trường hợp 3: Nội dung quá ngắn (rỗng)
CALL CreatePostWithValidation(1, '', @msg3);
SELECT @msg3 AS result_case_3;

-- Trường hợp 4: Nội dung đúng
CALL CreatePostWithValidation(1, 'Đây là một bài đăng mới.', @msg4);
SELECT @msg4 AS result_case_4;

-- 4) Kiểm tra các kết quả - Xem các bài viết vừa được thêm
SELECT post_id, user_id, content, created_at
FROM posts
WHERE user_id = 1
ORDER BY post_id DESC
LIMIT 5;

-- 5) Xóa thủ tục vừa khởi tạo
DROP PROCEDURE IF EXISTS CreatePostWithValidation;