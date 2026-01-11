USE social_network_pro;
# 1.Viết câu truy vấn Select tìm tất cả những User ở Hà Nội. Sử dụng EXPLAIN ANALYZE để kiểm tra truy vấn thực tế.
EXPLAIN ANALYZE
SELECT * FROM users
WHERE hometown = 'Hà Nội';

# 2.
CREATE INDEX idx_hometown ON users(hometown);
# -> Index lookup on users using idx_hometown (hometown='Hà Nội')  (cost=1.2 rows=7) (actual time=0.0569..0.0705 rows=7 loops=1)

# 3.
DROP INDEX idx_hometown ON users;
# -> Filter: (users.hometown = 'Hà Nội')  (cost=2.25 rows=2) (actual time=0.0371..0.051 rows=7 loops=1)
#    -> Table scan on users  (cost=2.25 rows=20) (actual time=0.0338..0.0448 rows=20 loops=1)

