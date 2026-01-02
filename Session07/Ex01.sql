DROP DATABASE IF EXISTS DatabaseEx01;
CREATE DATABASE DatabaseEx01;
USE DatabaseEx01;

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

INSERT INTO customers (name, email) VALUES
    ('Nguyễn Văn A', 'a@gmail.com'),
    ('Nguyễn Văn B', 'b@gmail.com'),
    ('Nguyễn Văn C', 'c@gmail.com'),
    ('Nguyễn Văn D', 'd@gmail.com'),
    ('Nguyễn Văn E', 'e@gmail.com'),
    ('Nguyễn Văn F', 'f@gmail.com'),
    ('Nguyễn Văn G', 'g@gmail.com');
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
    (1, '2024-01-10', 150000),
    (1, '2024-02-05', 200000),
    (2, '2024-03-12', 300000),
    (3, '2024-03-20', 250000),
    (5, '2024-04-01', 400000),
    (6, '2024-04-15', 180000),
    (6, '2024-05-01', 220000);

SELECT *
FROM customers
WHERE id IN (
    SELECT customer_id
    FROM orders
);