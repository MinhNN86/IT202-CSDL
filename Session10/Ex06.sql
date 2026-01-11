USE social_network_pro;

# Tạo view
CREATE VIEW view_users_summary
AS
SELECT
    p.user_id,
    u.username,
    COUNT(*) AS total_posts
FROM posts p
JOIN users u ON p.user_id = u.user_id
GROUP BY p.user_id, u.username;

# Xem view với điều kiện
SELECT * FROM view_users_summary
WHERE total_posts > 5;