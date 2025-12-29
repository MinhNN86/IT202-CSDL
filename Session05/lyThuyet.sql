-- Cấu trúc câu lệnh SELECT
# SELECT ( Danh sách các cột cần lấy ra )
# FROM ( Tên bản cần lấy ra dữ liệu )
# WHERE ( điều kiện lấy dữ liệu )
# GROUP BY ( danh sách các cột cần nhóm )
# HAVING ( điều kiện lấy dữ liệu của nhóm )
# ORDER BY ( là danh sách các cột cần sắp sếp )
# LIMIT ( giới hạn bản ghi trả về )
# LIMIT ... OFFSET ( trả về bắt đầu từ bản ghi )
# Đặt tên alas cho các thành phần: cột, bảng
# SELECT customerName (as 'Tên khách hàng') FROM Customers

CREATE DATABASE DemoSession04;
USE DemoSession04;

CREATE TABLE Students(
    student_id INT PRIMARY KEY ,
    name VARCHAR(50),
    age INT,
    gender BIT
);

SELECT name, age
FROM Students
WHERE age > 20
GROUP BY age         # Nhóm các bản ghi theo cột age
HAVING COUNT(*) > 1  # Lọc các nhóm có hơn 1 bản ghi
ORDER BY age DESC;    # Sắp xếp kết quả theo age giảm dần

-- Truy vấn với mệnh đề where
SELECT * FROM Students
WHERE age > 10;
-- Lệnh Between
SELECT * FROM Students
WHERE age BETWEEN 10 and 15;
-- Lệnh IN
SELECT * FROM Students
WHERE age IN (5, 6, 10);
-- Like: so sánh string ( _ : Đại diện cho 1 kí tự ), ( % : đại diện cho 1 xâu kí tự )
SELECT * FROM Students
WHERE name LIKE 'Nguyen%';
-- CASE
SELECT name, age, CASE
    WHEN 1 THEN 'Nam'
    WHEN 2 THEN 'Nữ'
    ELSE 'Không xác định'
    END as 'Giới tính'
FROM Students;


-- Truy vấn với mệnh dề ORDER BY, LIMIT
SELECT * FROM Students
ORDER BY age DESC;
# ASC: Trật tự tăng dần ( mặc định nếu không viết )
# DESC: Trật tự giảm dần

SELECT * FROM Students
LIMIT 10 OFFSET 0; # Lấy 10 bản ghi đầu tiên
