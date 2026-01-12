USE social_network_pro;

DELIMITER //
CREATE PROCEDURE CalculatePostLikes(IN p_post_id INT,
                                    OUT total_likes INT)
BEGIN
    SELECT COUNT(*) INTO total_likes
    FROM likes
    WHERE post_id = p_post_id;
END //
DELIMITER ;

-- 3) Gọi stored procedure CalculatePostLikes với post_id = 1
CALL CalculatePostLikes(101, @total_likes);

-- Truy vấn giá trị của tham số OUT total_likes
SELECT @total_likes AS total_likes_for_post_101;

-- 4) Xóa thủ tục vừa tạo
DROP PROCEDURE IF EXISTS CalculatePostLikes;