DROP DATABASE IF EXISTS DatabaseEx06;
CREATE DATABASE DatabaseEx06;
USE DatabaseEx06;

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL
);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
    (1, '2024-01-10', 150000),
    (1, '2024-01-15', 200000),
    (2, '2024-02-01', 300000),
    (3, '2024-02-10', 250000),
    (3, '2024-02-15', 180000),
    (5, '2024-03-01', 400000);

SELECT
    customer_id,
    SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) > (
        SELECT AVG(total_per_customer)
        FROM (
            SELECT SUM(total_amount) AS total_per_customer
            FROM orders
            GROUP BY customer_id
        ) AS temp
    );