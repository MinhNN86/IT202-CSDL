DROP DATABASE IF EXISTS DatabaseEx05;
CREATE DATABASE DatabaseEx05;
USE DatabaseEx05;

CREATE TABLE Customers(
    customer_id INT PRIMARY KEY ,
    customer_name VARCHAR(255)
);

CREATE TABLE Orders(
    order_id INT PRIMARY KEY ,
    customer_id INT ,
    total_amount INT ,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Customers(customer_id, customer_name) VALUES
    (1, 'Nguyen Van A'),
    (2, 'Tran Thi B'),
    (3, 'Le Van C'),
    (4, 'Pham Thi D'),
    (5, 'Hoang Van E'),
    (6, 'Do Thi F');

INSERT INTO Orders(order_id, customer_id, total_amount) VALUES
    (1001, 1, 2500000),
    (1002, 2, 3200000),
    (1003, 1, 3500000),
    (1004, 3, 200000),
    (1005, 4, 5000000),
    (1006, 2, 4800000),
    (1007, 5, 150000),
    (1008, 5, 250000),
    (1009, 6, 100000),
    (1010, 6, 200000),
    (1011, 6, 300000),
    (1012, 1, 4200000),
    (1013, 2, 2100000),
    (1014, 3, 500000),
    (1015, 4, 700000),
    (1016, 5, 350000),
    (1017, 6, 400000);


SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.customer_id) AS TongSoDonHang,
    SUM(o.total_amount) AS TongTienDaChi,
    AVG(o.total_amount) AS TrungBinhGiaTriDonHang
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING
   TongSoDonHang >= 3
  AND TongTienDaChi > 10000000
ORDER BY TongTienDaChi DESC ;

