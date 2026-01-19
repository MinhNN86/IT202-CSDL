DROP DATABASE IF EXISTS onTapCSDL;
CREATE DATABASE onTapCSDL;
USE onTapCSDL;

-- Bảng Customers
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    address VARCHAR(255)
);

-- Bảng Products
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    category VARCHAR(50) NOT NULL
);

-- Bảng Employees
CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    birthday DATE,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    revenue DECIMAL(10,2) DEFAULT 0
);

-- Bảng Orders
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Bảng OrderDetails
CREATE TABLE OrderDetails (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Câu 3: Chỉnh sửa bảng
ALTER TABLE Customers
ADD COLUMN email VARCHAR(100) NOT NULL UNIQUE ;

ALTER TABLE Employees
DROP COLUMN birthday;

-- Câu 4
INSERT INTO Customers (customer_name, phone, address, email) VALUES
    ('Nguyen Van A', '0900000001', 'Ha Noi', 'a@gmail.com'),
    ('Tran Thi B', '0900000002', 'Hai Phong', 'b@gmail.com'),
    ('Le Van C', '0900000003', 'Da Nang', 'c@gmail.com'),
    ('Pham Thi D', '0900000004', 'HCM', 'd@gmail.com'),
    ('Hoang Van E', '0900000005', 'Can Tho', 'e@gmail.com');
INSERT INTO Products (product_name, price, quantity, category) VALUES
    ('Laptop HP', 1200, 50, 'Laptop'),
    ('Iphone 15', 1500, 100, 'Phone'),
    ('Chuột Logitech', 20, 300, 'Accessory'),
    ('Bàn phím cơ', 80, 200, 'Accessory'),
    ('Màn hình Dell', 300, 150, 'Monitor');
INSERT INTO Employees (employee_name, position, salary) VALUES
    ('Nguyen Minh', 'Manager', 2000),
    ('Tran Hoa', 'Sale', 1200),
    ('Le Tung', 'Sale', 1200),
    ('Pham Long', 'Support', 1000),
    ('Hoang Anh', 'Sale', 1300);
INSERT INTO Orders (customer_id, employee_id, order_date) VALUES
    (1,1,'2026-01-10 10:00:00'),
    (2,2,'2026-01-12 14:00:00'),
    (3,3,'2026-01-15 09:00:00'),
    (1,2,'2026-01-18 11:00:00'),
    (4,4,'2026-01-18 12:00:00');
INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
    (1,1,2,1200),
    (1,3,60,20),
    (2,2,1,1500),
    (2,3,50,20),
    (3,4,101,80),
    (4,5,2,300),
    (5,3,10,20); 

-- Câu 5
# 5.1
SELECT * FROM Customers;

UPDATE Products
SET product_name = 'Laptop Dell XPS', price = 99.99
WHERE product_id = 1;
#5.2
SELECT
    o.order_id,
    c.customer_name,
    e.employee_name,
    o.total_amount,
    o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Employees e ON o.employee_id = e.employee_id;

-- Câu 6
#6.1
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(*) AS TongSoDon
fROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY TongSoDon DESC ;
#6.2
SELECT
    e.employee_id,
    e.employee_name,
    SUM(o.total_amount) AS DoanhThu
FROM Employees e
JOIN Orders o ON e.employee_id = o.employee_id
WHERE YEAR(o.order_date) = YEAR(CURRENT_DATE)
GROUP BY e.employee_id;
#6.3
SELECT
    p.product_id,
    p.product_name,
    SUM(od.quantity) AS total_quantity
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
JOIN Orders o ON od.order_id = o.order_id
WHERE MONTH(o.order_date) = MONTH(CURRENT_DATE)
AND YEAR(o.order_date) = YEAR(CURRENT_DATE)
GROUP BY p.product_id
HAVING total_quantity > 100
ORDER BY total_quantity DESC ;

-- Câu 7
# 7.1
SELECT
    c.customer_id,
    c.customer_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
# 7.2
SELECT *
FROM Products
WHERE price > (
    SELECT AVG(price) FROM Products
);
# 7.3
SELECT c.customer_id, c.customer_name,
SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING total_spent = (
    SELECT MAX(total)
    FROM (
             SELECT SUM(total_amount) AS total
             FROM Orders
             GROUP BY customer_id
    ) AS t
);

-- CÂU 8
# 8.1
CREATE VIEW view_order_list AS
SELECT o.order_id, c.customer_name, e.employee_name,
       o.total_amount, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Employees e ON o.employee_id = e.employee_id
ORDER BY o.order_date DESC;

SELECT * FROM view_order_list;

# 8.2
CREATE VIEW view_order_detail_product AS
SELECT od.order_detail_id, p.product_name,
       od.quantity, od.unit_price
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
ORDER BY od.quantity DESC;

SELECT * FROM view_order_detail_product;

-- CÂU 9
# 9.1
DELIMITER //
CREATE PROCEDURE proc_insert_employee(
    IN p_name VARCHAR(100),
    IN p_position VARCHAR(50),
    IN p_salary DECIMAL(10,2),
    OUT new_id INT
)
BEGIN
    INSERT INTO Employees (employee_name, position, salary) VALUES
    (p_name, p_position, p_salary);
    SET new_id = LAST_INSERT_ID();
END // DELIMITER ;

SET @new_id = 0;
CALL proc_insert_employee('MinhNN', 'IT', 1000, @new_id);
SELECT @new_id AS inserted_employee_id;

# 9.2
DELIMITER //
CREATE PROCEDURE proc_get_orderdetails(
    IN p_product_id INT
)
BEGIN
    SELECT * FROM OrderDetails
    WHERE product_id = p_product_id;
END // DELIMITER ;

CALL proc_get_orderdetails(2);

# 9.3
DELIMITER //
CREATE PROCEDURE proc_cal_total_amount_by_order(
    IN p_order_id INT,
    OUT total_products INT
)
BEGIN
    SELECT COUNT(*)
    INTO total_products
    FROM (
        SELECT product_id
        FROM OrderDetails
        WHERE order_id = p_order_id
        GROUP BY product_id
    ) AS unique_products;
END // DELIMITER ;

SET @total_products = 0;
CALL proc_cal_total_amount_by_order(1, @total_products);
SELECT @total_products AS totalProduct;

-- CÂU 10
DELIMITER //
CREATE TRIGGER trigger_after_insert_order_details
BEFORE INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    DECLARE stock INT;

    SELECT quantity INTO stock
    FROM Products
    WHERE product_id = NEW.product_id;

    IF stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng sản phầm trong kho không đủ';
    ELSE
        UPDATE Products
        SET quantity = quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
    END IF;
END // DELIMITER ;

INSERT INTO OrderDetails(order_id, product_id, quantity, unit_price) VALUES (1, 1, 3, 1200);
-- CÂU 11
DELIMITER //
CREATE PROCEDURE proc_insert_order_details(
    IN p_order_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_price DECIMAL(10, 2)
)
BEGIN
    DECLARE order_count INT;
    START TRANSACTION;
    SELECT COUNT(*) INTO order_count
    FROM Orders
    WHERE order_id = p_order_id;

    IF order_count = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'không tồn tại mã hóa đơn';
    ELSE
        INSERT INTO OrderDetails(order_id, product_id, quantity, unit_price)
        VALUES (p_order_id, p_product_id, p_quantity, p_price);

        UPDATE Orders
        SET total_amount = total_amount + (p_quantity * p_price)
        WHERE order_id = p_order_id;

        COMMIT;
    END IF;
END // DELIMITER ;
CALL proc_insert_order_details(999, 1, 1, 1200);
CALL proc_insert_order_details(1, 2, 1, 1500);