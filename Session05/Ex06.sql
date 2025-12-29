DROP DATABASE DatabaseEx06;
CREATE DATABASE DatabaseEx06;
USE DatabaseEx06;

CREATE TABLE Customers
(
    customer_id INT PRIMARY KEY,
    full_name   VARCHAR(255),
    email       VARCHAR(255),
    city        VARCHAR(255),
    status      VARCHAR(20) CHECK ( status IN ('active', 'inactive') )
);

CREATE TABLE Orders
(
    order_id     INT PRIMARY KEY,
    customer_id  INT,
    total_amount DECIMAL(10, 2),
    order_date   DATE,
    status       VARCHAR(20) CHECK ( status IN ('pending', 'completed', 'cancelled') ),
    CONSTRAINT fk_order_custom FOREIGN KEY (customer_id) REFERENCES Customers (customer_id)
);

INSERT INTO Customers (customer_id, full_name, email, city, status)
VALUES (1, 'Nguyen Van A', 'vana@example.com', 'Hanoi', 'active');

INSERT INTO Orders (order_id, customer_id, total_amount, order_date, status)
VALUES (1, 1, 1200000, '2025-12-01', 'completed'),
       (2, 1, 2500000, '2025-12-02', 'completed'),
       (3, 1, 500000, '2025-12-03', 'pending'),
       (4, 1, 750000, '2025-12-04', 'completed'),
       (5, 1, 3200000, '2025-12-05', 'completed'),
       (6, 1, 450000, '2025-12-06', 'cancelled'),
       (7, 1, 980000, '2025-12-07', 'completed'),
       (8, 1, 1500000, '2025-12-08', 'pending'),
       (9, 1, 2100000, '2025-12-09', 'completed'),
       (10, 1, 670000, '2025-12-10', 'completed'),
       (11, 1, 1300000, '2025-12-11', 'pending'),
       (12, 1, 900000, '2025-12-12', 'completed'),
       (13, 1, 5400000, '2025-12-13', 'completed'),
       (14, 1, 250000, '2025-12-14', 'cancelled'),
       (15, 1, 1750000, '2025-12-15', 'completed'),
       (16, 1, 299000, '2025-12-16', 'pending'),
       (17, 1, 4000000, '2025-12-17', 'completed'),
       (18, 1, 120000, '2025-12-18', 'completed'),
       (19, 1, 820000, '2025-12-19', 'pending'),
       (20, 1, 2300000, '2025-12-20', 'completed');

-- Trang 1: hiển thị 5 đơn hàng mới nhất
SELECT * FROM Orders
ORDER BY order_date DESC
LIMIT 5 OFFSET 0;

-- Trang 2: hiển thị 5 đơn hàng tiếp theo
SELECT * FROM Orders
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;

-- Trang 3: hiển thị 5 đơn hàng tiếp theo
SELECT * FROM Orders
ORDER BY order_date DESC
LIMIT 5 OFFSET 10;

-- Chỉ hiển thị các đơn hàng chưa bị hủy
SELECT * FROM Orders
WHERE status IN ('completed', 'pending');