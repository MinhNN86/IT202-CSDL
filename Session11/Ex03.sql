USE social_network_pro;

DELIMITER //
CREATE PROCEDURE CalculateBonusPoints(
    IN p_user_id INT,
    INOUT p_bonus_points INT
)
BEGIN
    DECLARE post_count INT;

    -- Đếm số lượng bài viết của user
    SELECT COUNT(*) INTO post_count
    FROM posts
    WHERE user_id = p_user_id;

    -- Kiểm tra điều kiện và cộng điểm thưởng
    IF post_count >= 20 THEN
        SET p_bonus_points = p_bonus_points + 100;
    ELSEIF post_count >= 10 THEN
        SET p_bonus_points = p_bonus_points + 50;
    END IF;
END //
DELIMITER ;

-- 3) Gọi thủ tục với user_id = 1 và điểm khởi đầu là 100
SET @bonus = 100;
CALL CalculateBonusPoints(1, @bonus);

-- 4) Select ra p_bonus_points sau khi gọi thủ tục
SELECT @bonus AS final_bonus_points;

-- 5) Xóa thủ tục vừa tạo
DROP PROCEDURE IF EXISTS CalculateBonusPoints;
