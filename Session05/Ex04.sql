DROP DATABASE DatabaseEx04;
CREATE DATABASE DatabaseEx04;
USE DatabaseEx04;

CREATE TABLE Customers(
    customer_id INT PRIMARY KEY ,
    full_name VARCHAR(255) ,
    email VARCHAR(255) ,
    city VARCHAR(255) ,
    status VARCHAR(20) CHECK ( status IN ('active', 'inactive') )
);

CREATE TABLE Orders(
    order_id INT PRIMARY KEY ,
    customer_id INT ,
    total_amount DECIMAL(10, 2),
    order_date DATE,
    status VARCHAR(20) CHECK ( status IN ('pending', 'completed', 'cancelled') ),
    CONSTRAINT fk_order_custom FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Thêm dữ liệu mẫu cho bảng Customers
INSERT INTO Customers (customer_id, full_name, email, city, status) VALUES
    (1, 'Nguyen Van A', 'vana@example.com', 'Hanoi', 'active'),
    (2, 'Tran Thi B', 'thib@example.com', 'Ho Chi Minh', 'inactive'),
    (3, 'Le Thi C', 'letc@example.com', 'Da Nang', 'active'),
    (4, 'Pham Van D', 'vand@example.com', 'Can Tho', 'active');

-- Thêm dữ liệu mẫu cho bảng Orders
INSERT INTO Orders (order_id, customer_id, total_amount, order_date, status) VALUES
    (1, 1, 15000000, '2025-12-01', 'completed'),
    (2, 2, 8000000, '2025-12-02', 'pending'),
    (3, 1, 500000, '2025-12-03', 'completed'),
    (4, 3, 4000000, '2025-12-04', 'cancelled'),
    (5, 4, 2000000, '2025-12-05', 'completed'),
    (6, 3, 3500000, '2025-12-06', 'pending');

-- Lấy danh sách đơn hàng đã hoàn thành
SELECT * FROM Orders
WHERE status = 'completed';
-- Lấy các đơn hàng có tổng tiền > 5.000.000
SELECT * FROM Orders
WHERE total_amount > 5000000;
-- Hiển thị 5 đơn hàng mới nhất
SELECT * FROM Orders
ORDER BY order_date DESC
LIMIT 5;
-- Hiển thị các đơn hàng đã hoàn thành, sắp xếp theo tổng tiền giảm dần
SELECT * FROM Orders
WHERE status = 'completed'
ORDER BY total_amount;

