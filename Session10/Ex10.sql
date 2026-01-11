USE social_network_pro;

# 2. Tạo Index
CREATE INDEX idx_username ON users(username);

# 3. Tạo View view_user_activity 2
CREATE VIEW view_user_activity_2 AS
SELECT
    u.user_id,
    COUNT(DISTINCT p.post_id) AS total_posts,
    COUNT(DISTINCT CASE WHEN f.status = 'accepted'
    THEN f.friend_id END) AS total_friends
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
LEFT JOIN friends f ON u.user_id = f.user_id
GROUP BY u.user_id;

# 4. Hiển thị View
SELECT * FROM view_user_activity_2;

# 5. Truy vấn kết hợp với bảng users + cột mở rộng
SELECT
    u.full_name,
    v.total_posts,
    v.total_friends,
    CASE
        WHEN v.total_friends > 5 THEN 'Nhiều bạn bè'
        WHEN v.total_friends >= 2 THEN 'Vừa đủ bạn bè'
        ELSE 'Ít bạn bè'
        END AS friend_description,
    CASE
        WHEN v.total_posts > 10 THEN v.total_posts * 1.1
        WHEN v.total_posts >= 5 THEN v.total_posts
        ELSE v.total_posts * 0.9
        END AS post_activity_score
FROM users u
         JOIN view_user_activity_2 v ON u.user_id = v.user_id
WHERE v.total_posts > 0
ORDER BY v.total_posts DESC;

