USE social_network_pro;

-- 2) Tạo index
CREATE INDEX idx_hometown ON users(hometown);
DROP INDEX idx_hometown ON users;

-- 3) Thục hiện truy vấn
EXPLAIN ANALYZE
SELECT
    u.user_id,
    u.username,
    u.hometown,
    f.friend_id,
    f.status,
    friend.username AS friend_username,
    friend.full_name AS friend_name
FROM users u
LEFT JOIN friends f ON u.user_id = f.user_id
LEFT JOIN users friend ON f.friend_id = friend.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 3;

# Chưa có index
#-> Limit: 3 row(s)  (cost=1.31 rows=0.222) (actual time=1.39..1.4 rows=3 loops=1)
#    -> Nested loop left join  (cost=1.31 rows=0.222) (actual time=1.38..1.39 rows=3 loops=1)
#        -> Nested loop left join  (cost=0.729 rows=0.222) (actual time=1.37..1.38 rows=3 loops=1)
#            -> Filter: (u.hometown = 'Hà Nội')  (cost=0.207 rows=0.2) (actual time=1.35..1.36 rows=3 loops=1)
#                -> Index scan on u using username (reverse)  (cost=0.207 rows=2) (actual time=1.32..1.33 rows=8 loops=1)
#            -> Index lookup on f using PRIMARY (user_id=u.user_id)  (cost=0.306 rows=1.11) (actual time=0.00853..0.00853 rows=0 loops=3)
#        -> Single-row index lookup on friend using PRIMARY (user_id=f.friend_id)  (cost=0.295 rows=1) (actual time=0.00121..0.00121 rows=0 loops=3)

# Có index
# -> Limit: 3 row(s)  (cost=6.45 rows=3) (actual time=0.0627..0.0648 rows=3 loops=1)
#    -> Nested loop left join  (cost=6.45 rows=7.78) (actual time=0.0542..0.0562 rows=3 loops=1)
#        -> Nested loop left join  (cost=3.73 rows=7.78) (actual time=0.0519..0.0535 rows=3 loops=1)
#            -> Sort: u.username DESC, limit input to 3 row(s) per chunk  (cost=1.2 rows=7) (actual time=0.0386..0.0387 rows=3 loops=1)
#    -> Index lookup on u using idx_hometown (hometown='Hà Nội')  (cost=1.2 rows=7) (actual time=0.0176..0.0228 rows=7 loops=1)
#    -> Index lookup on f using PRIMARY (user_id=u.user_id)  (cost=0.266 rows=1.11) (actual time=0.00457..0.00457 rows=0 loops=3)
#    -> Single-row index lookup on friend using PRIMARY (user_id=f.friend_id)  (cost=0.263 rows=1) (actual time=472e-6..472e-6 rows=0 loops=3)

