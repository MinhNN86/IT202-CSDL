DROP DATABASE DatabaseEx03;
CREATE DATABASE DatabaseEx03;
USE DatabaseEx03;

CREATE TABLE Customers(
    customer_id INT PRIMARY KEY ,
    full_name VARCHAR(255) ,
    email VARCHAR(255) ,
    city VARCHAR(255) ,
    status VARCHAR(20) CHECK ( status IN ('active', 'inactive') )
);

-- Thêm dữ liệu mẫu cho bảng Customers
INSERT INTO Customers (customer_id, full_name, email, city, status) VALUES
(1, 'Nguyen Van A', 'vana@example.com', 'Hanoi', 'active'),
(2, 'Tran Thi B', 'thib@example.com', 'Ho Chi Minh', 'inactive'),
(3, 'Le Thi C', 'letc@example.com', 'Da Nang', 'active'),
(4, 'Pham Van D', 'vand@example.com', 'Can Tho', 'active');

-- Lấy khách hàng ở HCM
SELECT * FROM Customers
WHERE city = 'Ho Chi Minh';

-- Lấy khách hàng đang hoạt động và ở Hà Nội
SELECT * FROM Customers
WHERE city = 'Hanoi' AND status = 'active';

-- Sắp xếp danh sách khách hàng theo tên ( A -> Z )
SELECT * FROM Customers
ORDER BY full_name ;