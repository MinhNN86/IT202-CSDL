DROP DATABASE DatabaseEx01;
CREATE DATABASE DatabaseEx01;
USE DatabaseEx01;

CREATE TABLE Customers(
    customer_id INT PRIMARY KEY ,
    full_name VARCHAR(255) ,
    city VARCHAR(255)
);

CREATE TABLE Orders(
    order_id INT PRIMARY KEY ,
    customer_id INT ,
    order_date DATE ,
    status VARCHAR(20) CHECK ( status IN ('pending', 'completed', 'cancelled') ),
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Customers (customer_id, full_name, city) VALUES
    (1, 'Nguyen Van An', 'Hanoi'),
    (2, 'Tran Thi Binh', 'Ho Chi Minh'),
    (3, 'Le Van Cuong', 'Da Nang'),
    (4, 'Pham Thi Dung', 'Hai Phong'),
    (5, 'Hoang Lan', 'Can Tho');

INSERT INTO Orders (order_id, customer_id, order_date, status) VALUES
    (1001, 1, '2025-01-10', 'completed'),
    (1002, 2, '2025-02-15', 'pending'),
    (1003, 3, '2025-03-01', 'cancelled'),
    (1004, 4, '2025-03-20', 'completed'),
    (1005, 1, '2025-04-05', 'pending');

-- Hiển thị danh sách đơn hàng kèm tên khách hàng
SELECT
    o.order_id,
    c.full_name,
    o.order_date,
    o.status
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id;

-- Hiển thị mỗi khách hàng đã đặt bao nhiêu đơn hàng
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS SoDonHang
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY SoDonHang DESC ;

-- Chỉ hiển thị các khách hàng có ít nhất 1 đơn hàng
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS SoDonHang
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 1;