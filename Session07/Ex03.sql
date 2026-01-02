DROP DATABASE IF EXISTS DatabaseEx03;
CREATE DATABASE DatabaseEx03;
USE DatabaseEx03;

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL
);
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
    (1, '2024-01-10', 150000),
    (2, '2024-01-15', 300000),
    (3, '2024-02-01', 250000),
    (4, '2024-02-10', 500000),
    (5, '2024-03-05', 200000),
    (6, '2024-03-20', 450000);

SELECT *
FROM orders
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM orders
);
