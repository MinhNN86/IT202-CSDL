DROP DATABASE IF EXISTS DatabaseEx06;
CREATE DATABASE DatabaseEx06;
USE DatabaseEx06;

CREATE TABLE Products(
    product_id INT PRIMARY KEY ,
    product_name VARCHAR(255) ,
    price INT
);

CREATE TABLE OrderDetail(
    order_id INT PRIMARY KEY ,
    product_id INT ,
    quantity INT ,
    unit_price INT ,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Products (product_id, product_name, price) VALUES
    (1, 'Áo Thun', 200),
    (2, 'Quần Jean', 450),
    (3, 'Giày Thể Thao', 800),
    (4, 'Mũ Lưỡi Trai', 150),
    (5, 'Áo Khoác', 600),
    (6, 'Váy', 400),
    (7, 'Túi Xách', 700),
    (8, 'Đồng Hồ', 1500);

INSERT INTO OrderDetail (order_id, product_id, quantity, unit_price) VALUES
    (1, 1, 5, 200),
    (2, 1, 10, 195),
    (3, 1, 10, 200),

    (4, 2, 8, 450),
    (5, 2, 10, 450),

    (6, 3, 5, 800),
    (7, 3, 7, 820),
    (8, 3, 8, 775),

    (9, 4, 4, 150),
    (10, 4, 5, 160),

    (11, 5, 5, 600),
    (12, 5, 10, 600),

    (13, 6, 6, 400),
    (14, 6, 5, 380),

    (15, 7, 3, 700),
    (16, 7, 2, 750),

    (17, 8, 5, 1500),
    (18, 8, 4, 1490),
    (19, 8, 3, 1520);


SELECT
    p.product_name AS `Tên sản phẩm`,
    SUM(od.quantity) AS `Tổng số lượng bán`,
    SUM(od.quantity * od.unit_price) AS `Tổng doanh thu`,
    ROUND(SUM(od.quantity * od.unit_price) / SUM(od.quantity), 2) AS `Giá bán trung bình`
FROM OrderDetail od
JOIN Products p ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(od.quantity) >= 10
ORDER BY SUM(od.quantity * od.unit_price) DESC
LIMIT 5;

