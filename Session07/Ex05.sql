DROP DATABASE IF EXISTS DatabaseEx05;
CREATE DATABASE DatabaseEx05;
USE DatabaseEx05;

CREATE TABLE customers(
    id INT PRIMARY KEY AUTO_INCREMENT ,
    name VARCHAR(100) NOT NULL ,
    email VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL
);

INSERT INTO customers (name, email) VALUES
    ('Nguyễn Văn A', 'a@gmail.com'),
    ('Nguyễn Văn B', 'b@gmail.com'),
    ('Nguyễn Văn C', 'c@gmail.com'),
    ('Nguyễn Văn D', 'd@gmail.com'),
    ('Nguyễn Văn E', 'e@gmail.com');
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
    (1, '2024-01-10', 150000),
    (1, '2024-01-15', 200000),
    (2, '2024-02-01', 300000),
    (3, '2024-02-10', 250000),
    (3, '2024-02-15', 180000),
    (5, '2024-03-01', 400000);

SELECT *
FROM customers
WHERE id = (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) = (
        SELECT MAX(total_sum)
        FROM (
             SELECT SUM(total_amount) AS total_sum
             FROM orders
             GROUP BY customer_id
        ) AS temp
    )
)