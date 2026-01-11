USE social_network_pro;

-- 2) Tạo một index có tên idx_user_gender trên cột gender của bảng users
CREATE INDEX idx_user_gender ON users(gender);

-- 3) Tạo view tên view_user_activity để hiển thị tổng số lượng bài viết và bình luận của mỗi người dùng
CREATE VIEW view_user_activity
AS
SELECT
    u.user_id,
    COUNT(DISTINCT p.post_id) AS total_posts,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
LEFT JOIN comments c ON u.user_id = c.user_id
GROUP BY u.user_id;

-- 4) Hiển thị lại view trên
SELECT * FROM view_user_activity;

-- 5) Viết truy vấn kết hợp view_user_activity với bảng users
SELECT
    u.user_id,
    u.username,
    u.full_name,
    v.total_posts,
    v.total_comments
FROM view_user_activity v
JOIN users u ON v.user_id = u.user_id
WHERE v.total_posts > 5 AND v.total_comments > 20
ORDER BY v.total_comments DESC
LIMIT 5;


