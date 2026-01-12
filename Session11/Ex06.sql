USE social_network_pro;

DELIMITER //
CREATE PROCEDURE NotifyFriendsOnNewPost(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE v_full_name VARCHAR(100);
    DECLARE v_post_id INT;

    -- Lấy full_name của người đăng
    SELECT full_name INTO v_full_name
    FROM users
    WHERE user_id = p_user_id;

    -- 1. Thêm bài viết mới vào bảng posts
    INSERT INTO posts(user_id, content) VALUES (p_user_id, p_content);

    -- Lấy post_id vừa được tạo
    SET v_post_id = LAST_INSERT_ID();

    -- 2. Gửi thông báo cho tất cả bạn bè đã accepted (cả hai chiều)
    INSERT INTO notifications(user_id, type, content, is_read, created_at)
    SELECT
        f.friend_id AS user_id,
        'new_post' AS type,
        CONCAT(v_full_name, ' đã đăng một bài viết mới') AS content,
        FALSE AS is_read,
        NOW() AS created_at
    FROM friends f
    WHERE f.user_id = p_user_id
      AND f.status = 'accepted'

    UNION

    SELECT
        f.user_id AS user_id,
        'new_post' AS type,
        CONCAT(v_full_name, ' đã đăng một bài viết mới') AS content,
        FALSE AS is_read,
        NOW() AS created_at
    FROM friends f
    WHERE f.friend_id = p_user_id
      AND f.status = 'accepted';
END //
DELIMITER ;

-- 3) Gọi procedure và thêm bài viết mới
CALL NotifyFriendsOnNewPost(1, 'Chào mọi người, đây là bài viết mới từ stored procedure!');

-- 4) Select ra những thông báo của bài viết vừa đăng
SELECT
    n.notification_id,
    n.user_id,
    u.username,
    u.full_name,
    n.type,
    n.content,
    n.is_read,
    n.created_at
FROM notifications n
JOIN users u ON n.user_id = u.user_id
WHERE n.type = 'new_post'
  AND n.content LIKE '%Nguyễn Văn An%'
ORDER BY n.created_at DESC;

-- 5) Xóa thủ tục vừa khởi tạo
DROP PROCEDURE IF EXISTS NotifyFriendsOnNewPost;
