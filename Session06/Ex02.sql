DROP DATABASE IF EXISTS DatabaseEx02;
CREATE DATABASE DatabaseEx02;
USE DatabaseEx02;

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
    (2002, 1, '2025-02-10',  300.00, 'completed'),
    (2003, 1, '2025-03-15',   75.50, 'pending'),
    (2004, 2, '2025-01-20',   45.50, 'pending'),
    (2005, 2, '2025-04-20',  550.00, 'completed'),
    (2006, 3, '2025-03-03',   99.99, 'cancelled');

-- Hiển thị tổng tiền mà mỗi khách hàng đã chi tiêu
SELECT
    c.customer_id,
    c.full_name,
    SUM(o.total_amount) AS TongTienKhachDaChi
FROM Customers c
INNER JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name;

-- Hiển thị giá trị đơn hàng cao nhất của từng khách
SELECT
    c.full_name,
    MAX(o.total_amount) AS DonHangCaoNhat
FROM Customers c
INNER JOIN Orders o on c.customer_id = o.customer_id
GROUP BY c.full_name;

-- Sắp xếp danh sách khách hàng theo tổng tiền giảm dần
SELECT
    c.customer_id,
    c.full_name,
    SUM(o.total_amount) AS TongTienKhachDaChi
FROM Customers c
INNER JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY SUM(o.total_amount) DESC;