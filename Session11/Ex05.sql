USE social_network_pro;

DELIMITER //
CREATE PROCEDURE CalculateUserActivityScore(
    IN p_user_id INT,
    OUT activity_score INT,
    OUT activity_level VARCHAR(50)
)
BEGIN
    DECLARE post_count INT;
    DECLARE comment_count INT;
    DECLARE like_received_count INT;

    -- Đếm số bài viết của user (mỗi post +10 điểm)
    SELECT COUNT(*) INTO post_count
    FROM posts
    WHERE user_id = p_user_id;

    -- Đếm số comment của user (mỗi comment +5 điểm)
    SELECT COUNT(*) INTO comment_count
    FROM comments
    WHERE user_id = p_user_id;

    -- Đếm số like nhận được (JOIN posts và likes, mỗi like +3 điểm)
    SELECT COUNT(*) INTO like_received_count
    FROM likes l
    JOIN posts p ON l.post_id = p.post_id
    WHERE p.user_id = p_user_id;

    -- Tính tổng điểm hoạt động
    SET activity_score = (post_count * 10) + (comment_count * 5) + (like_received_count * 3);

    -- Phân loại mức hoạt động
    CASE
        WHEN activity_score > 500 THEN
            SET activity_level = 'Rất tích cực';
        WHEN activity_score >= 200 THEN
            SET activity_level = 'Tích cực';
        ELSE
            SET activity_level = 'Bình thường';
    END CASE;
END //
DELIMITER ;

-- 3) Gọi thủ tục với user_id = 1 và select ra kết quả
CALL CalculateUserActivityScore(1, @score, @level);

SELECT
    @score AS activity_score,
    @level AS activity_level;

-- 4) Xóa thủ tục vừa khởi tạo
DROP PROCEDURE IF EXISTS CalculateUserActivityScore;
