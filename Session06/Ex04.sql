DROP DATABASE IF EXISTS DatabaseEx04;
CREATE DATABASE DatabaseEx04;
USE DatabaseEx04;

CREATE TABLE Products(
    product_id INT PRIMARY KEY ,
    product_name VARCHAR(255) ,
    price DECIMAL(10, 2)
);

CREATE TABLE OrderItems(
    order_id INT PRIMARY KEY ,
    product_id INT ,
    quantity INT ,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Products(product_id, product_name, price) VALUES
    (1, 'Lenovo ThinkPad X1 Carbon', 1500.00),
    (2, 'Apple iPhone 14', 999.99),
    (3, 'Samsung 55\" LED TV', 799.00),
    (4, 'Logitech MX Master 3 Mouse', 79.99),
    (5, 'Sony WH-1000XM4 Headphones', 299.99);

INSERT INTO OrderItems(order_id, product_id, quantity) VALUES
    (5001, 1, 2000), -- tăng số lượng bán ra cho sản phẩm 1
    (5002, 2, 2),
    (5003, 3, 1),
    (5004, 4, 3),
    (5005, 1, 1500); -- tăng thêm số lượng bán ra cho sản phẩm 1

-- Hiển thị mỗi sản phẩm đã bán được bao nhiêu sản phẩm
SELECT
    p.product_id,
    p.product_name,
    SUM(o.quantity) AS DaBanDuoc
FROM Products p
LEFT JOIN OrderItems o ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name;

-- Tính doanh thu của từng sản phẩm
SELECT
    p.product_id,
    p.product_name,
    SUM(o.quantity) * p.price AS DoanhThuTuSanPham
FROM Products p
LEFT JOIN OrderItems o ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name;

-- Chỉ hiển thị các sản phẩm có doanh thu > 5.000.000
SELECT
    p.product_id,
    p.product_name,
    SUM(o.quantity) * p.price AS DoanhThuTuSanPham
FROM Products p
LEFT JOIN OrderItems o ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.price
HAVING SUM(o.quantity) * p.price > 5000000;