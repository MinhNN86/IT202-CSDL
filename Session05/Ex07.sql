DROP DATABASE DatabaseEx07;
CREATE DATABASE DatabaseEx07;
USE DatabaseEx07;

CREATE TABLE Products(
    product_id INT PRIMARY KEY ,
    product_name VARCHAR(255),
    price DECIMAL(10, 2) ,
    stock INT ,
    sold_quantity INT ,
    status VARCHAR(20) CHECK ( status IN ('active', 'inactive'))
);

INSERT INTO Products (product_id, product_name, price, stock, sold_quantity, status) VALUES
    (1, 'Laptop', 15000000, 10, 5, 'active'),
    (2, 'Smartphone', 8000000, 25, 12, 'active'),
    (3, 'Tablet', 4000000, 15, 3, 'inactive'),
    (4, 'Charger', 500000, 50, 20, 'active'),
    (5, 'Monitor', 3000000, 8, 2, 'active'),
    (6, 'Keyboard', 200000, 40, 10, 'active'),
    (7, 'Mouse', 150000, 60, 25, 'active'),
    (8, 'Headphones', 700000, 20, 7, 'active'),
    (9, 'Webcam', 600000, 12, 4, 'inactive'),
    (10, 'External HDD', 1200000, 15, 6, 'active'),
    (11, 'SSD 1TB', 2500000, 5, 1, 'active'),
    (12, 'Router', 900000, 10, 3, 'active'),
    (13, 'Printer', 1800000, 6, 2, 'inactive'),
    (14, 'Scanner', 1600000, 4, 0, 'active'),
    (15, 'Projector', 5000000, 2, 1, 'inactive'),
    (16, 'USB Cable', 50000, 200, 50, 'active'),
    (17, 'Power Bank', 400000, 30, 9, 'active'),
    (18, 'Smartwatch', 2200000, 7, 3, 'active'),
    (19, 'Microphone', 350000, 18, 5, 'active'),
    (20, 'Graphic Tablet', 3200000, 3, 0, 'inactive');

# Đang bán (status = 'active') - Giá từ 1.000.000 đến 3.000.000
SELECT * FROM Products
WHERE status = 'active' AND price BETWEEN 1000000 AND 3000000;
# Sắp xếp theo giá tăng dần
SELECT * FROM Products
ORDER BY price;
# Hiển thị 10 sản phẩm mỗi trang
# Trang 1
SELECT * FROM Products
LIMIT 10 OFFSET 0;
# Trang 2
SELECT * FROM Products
LIMIT 10 OFFSET 10;