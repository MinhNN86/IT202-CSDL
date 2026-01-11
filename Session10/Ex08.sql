USE social_network_pro;

# Tạo một index
CREATE INDEX idx_user_gender ON users(gender);

# Tạo view view_popular_posts
CREATE VIEW view_popular_posts
AS
SELECT
    p.post_id,
    u.username,
    p.content,
    COUNT(DISTINCT l.user_id) AS like_count,
    COUNT(DISTINCT c.comment_id) AS comment_count
FROM posts p
         JOIN users u ON p.user_id = u.user_id
         LEFT JOIN likes l ON p.post_id = l.post_id
         LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY p.post_id, u.username, p.content;

# Xem tất cả bài viết trong view
SELECT * FROM view_popular_posts;

# Truy vấn các bài viết có like + comment > 10, sắp xếp theo tổng tương tác giảm dần
SELECT
    post_id,
    username,
    content,
    like_count,
    comment_count,
    (like_count + comment_count) AS total_interactions
FROM view_popular_posts
WHERE (like_count + comment_count) > 10
ORDER BY total_interactions DESC;

