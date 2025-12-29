DROP DATABASE DatabaseEx02;
CREATE DATABASE DatabaseEx02;
USE DatabaseEx02;

CREATE TABLE Products(
    product_id INT PRIMARY KEY ,
    product_name VARCHAR(255),
    price DECIMAL(10, 2) ,
    stock INT ,
    status VARCHAR(20) CHECK ( status IN ('active', 'inactive'))
);

INSERT INTO Products (product_id, product_name, price, stock, status) VALUES
(1, 'Laptop', 15000000, 10, 'active'),
(2, 'Smartphone', 8000000, 25, 'active'),
(3, 'Tablet', 4000000, 15, 'inactive'),
(4, 'Charger', 500000, 50, 'active');

-- Lấy danh sách sản phẩm active
SELECT * FROM Products 
WHERE status = 'active';

-- Lấy các sản phẩn có giá hơn 1.000.000
SELECT * FROM Products
WHERE price > 1000000;

-- Lấy danh sách sản phẩn đang bán và giá tăng dần
SELECT * FROM Products
WHERE status = 'active'
ORDER BY price;