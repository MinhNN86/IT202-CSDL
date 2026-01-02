DROP DATABASE IF EXISTS DatabaseEx02;
CREATE DATABASE DatabaseEx02;
USE DatabaseEx02;

CREATE TABLE products(
    id INT PRIMARY KEY AUTO_INCREMENT ,
    name VARCHAR(255) ,
    price DECIMAL(10, 2) NOT NULL
);
CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL
);

INSERT INTO products (name, price) VALUES
    ('Áo thun', 120000),
    ('Quần jean', 350000),
    ('Giày sneaker', 800000),
    ('Mũ lưỡi trai', 90000),
    ('Balo', 450000),
    ('Áo khoác', 600000),
    ('Tất', 30000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (1, 1, 2),
    (1, 2, 1),
    (2, 3, 1),
    (2, 5, 1),
    (3, 1, 3),
    (4, 6, 1),
    (5, 3, 2);

SELECT *
FROM products
WHERE id IN (
    SELECT product_id
    FROM order_items
)