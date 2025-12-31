DROP DATABASE IF EXISTS DatabaseEx03;
CREATE DATABASE DatabaseEx03;
USE DatabaseEx03;

CREATE TABLE Customers(
    customer_id INT PRIMARY KEY ,
    full_name VARCHAR(255) ,
    city VARCHAR(255)
);

CREATE TABLE Orders(
    order_id INT PRIMARY KEY ,
    customer_id INT ,
    order_date DATE ,
    total_amount DECIMAL(10, 2) ,
    status VARCHAR(20) CHECK ( status IN ('pending', 'completed', 'cancelled') ) ,
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Customers (customer_id, full_name, city) VALUES
    (1, 'Nguyen Van An', 'Hanoi'),
    (2, 'Tran Thi Binh', 'Ho Chi Minh'),
    (3, 'Le Van Cuong', 'Da Nang');

INSERT INTO Orders (order_id, customer_id, order_date, total_amount, status) VALUES
    (2001, 1, '2025-01-05', 1200.00, 'completed'),
    (2002, 1, '2025-01-05',  300.00, 'completed'),
    (2003, 1, '2025-03-15',   75.50, 'pending'),
    (2004, 2, '2025-01-20',   45.50, 'pending'),
    (2005, 2, '2025-04-20', 6000000.00, 'completed'),
    (2006, 3, '2025-03-03',   99.99, 'cancelled'),
    (2007, 3, '2025-03-03',  150.00, 'completed'),
    (2008, 2, '2025-04-20', 5500000.00, 'pending');

-- Tính tổng doanh thu theo từng ngày
SELECT
    order_date,
    SUM(total_amount) AS TongDoanhThu
FROM Orders
GROUP BY order_date
ORDER BY order_date;

-- Tính số đơn hàng theo từng ngày
SELECT
    order_date,
    COUNT(*) AS SoLuongDonHang
FROM Orders
GROUP BY order_date
ORDER BY order_date;

-- Chỉ hiển thị các ngày có doanh thu > 10.000.000
SELECT
    order_date,
    SUM(total_amount) AS TongDoanhThu
FROM Orders
GROUP BY order_date
HAVING SUM(total_amount) > 10000000
ORDER BY order_date;