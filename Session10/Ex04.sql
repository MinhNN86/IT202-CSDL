USE social_network_pro;
-- 2) Tạo chỉ mục phức hợp (Composite Index)
EXPLAIN ANALYZE
SELECT
    post_id,
    content,
    created_at
FROM posts
WHERE user_id = 1 AND YEAR(created_at) = 2026;

# Trước khi tạo index
#   -> Filter: (year(posts.created_at) = 2026)  (cost=0.7 rows=2) (actual time=0.023..0.0268 rows=2 loops=1)
#    -> Index lookup on posts using posts_fk_users (user_id=1)  (cost=0.7 rows=2) (actual time=0.0135..0.0171 rows=2 loops=1)

# Tạo index
CREATE INDEX idx_created_at_user_id ON posts(created_at, user_id);

# Sau khi tạo index
# -> Filter: (year(posts.created_at) = 2026)  (cost=0.7 rows=2) (actual time=0.213..0.231 rows=2 loops=1)
#    -> Index lookup on posts using posts_fk_users (user_id=1)  (cost=0.7 rows=2) (actual time=0.159..0.176 rows=2 loops=1)

-- 3) Tạo chỉ mục duy nhất (Unique Index)
EXPLAIN ANALYZE
SELECT
    user_id,
    username,
    email
FROM users
WHERE email = 'an@gmail.com';

# Trước khi tạo index
#    -> Rows fetched before execution  (cost=0..0 rows=1) (actual time=84e-6..126e-6 rows=1 loops=1)

# Tạo index
CREATE INDEX idx_email ON users(email);

# Sau khi tạo index
#     -> Rows fetched before execution  (cost=0..0 rows=1) (actual time=251e-6..292e-6 rows=1 loops=1)

-- 4) Xóa chỉ mục
DROP INDEX idx_created_at_user_id ON posts;
DROP INDEX idx_email ON users;

