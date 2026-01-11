USE social_network_pro;

CREATE VIEW view_user_activity_status
AS
SELECT
    u.user_id,
    u.username,
    u.gender,
    u.created_at,
    CASE
        WHEN p.post_count > 0 OR c.comment_count > 0 THEN 'Active'
        ELSE 'Inactive'
    END AS status
FROM users u
LEFT JOIN (
    SELECT user_id, COUNT(*) AS post_count
    FROM posts
    GROUP BY user_id
) p ON u.user_id = p.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS comment_count
    FROM comments
    GROUP BY user_id
) c ON u.user_id = c.user_id;

# Xem kết quả
SELECT * FROM view_user_activity_status;

# Thống kê kết quả
SELECT
    status,
    COUNT(*) AS user_count
FROM view_user_activity_status
GROUP BY status
ORDER BY user_count DESC;

