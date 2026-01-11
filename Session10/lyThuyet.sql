DROP DATABASE IF EXISTS DemoSession10;
CREATE DATABASE DemoSession10;
USE DemoSession10;

CREATE TABLE products (
    productCode VARCHAR(15) PRIMARY KEY,
    productName VARCHAR(70),
    productLine VARCHAR(50),
    productScale VARCHAR(10),
    productVendor VARCHAR(50),
    productDescription TEXT,
    quantityInStock SMALLINT,
    buyPrice DECIMAL(10,2),
    MSRP DECIMAL(10,2)
);

USE DemoSession10;

INSERT INTO products VALUES
('P00001','1969 Harley Davidson Ultimate Chopper','Motorcycles','1:10','Min Lin Diecast','Highly detailed replica of the 1969 chopper with chrome finish and working suspension.', 7933, 48.81, 95.70),
('P00002','1952 Alpine Renault 1300','Classic Cars','1:18','Classic Metal Creations','Die-cast model with opening doors and detailed interior.', 7305, 98.58, 214.30),
('P00003','Chevrolet Camaro','Sports Cars','1:12','Autoart Studio Design','Replica of the 1969 Camaro with realistic engine and paint.', 658, 34.95, 68.99),
('P00004','Ford Mustang','Sports Cars','1:24','Highway 66 Replicas','Detailed Mustang model with rubber tires and chrome accents.', 4500, 27.50, 54.99),
('P00005','Harley-Davidson Road King','Motorcycles','1:10','Min Lin Diecast','Classic touring bike model with saddlebags and windshield.', 1200, 56.20, 112.40),
('P00006','Porsche 911 Carrera','Sports Cars','1:18','Precision Modelworks','High-fidelity Porsche 911 replica with accurate lights and badges.', 890, 120.00, 245.00),
('P00007','Volkswagen Beetle','Classic Cars','1:18','Classic Metal Creations','Iconic Beetle model in multiple pastel colors with interior detail.', 5400, 21.75, 45.00),
('P00008','Yamaha YZF-R1','Motorcycles','1:12','MotoCraft Models','Sport bike replica with fairing detail and rear stand.', 310, 72.30, 144.99),
('P00009','Lamborghini Aventador','Sports Cars','1:18','Exquisite Models','Supercar model with scissor doors and carbon fiber decals.', 125, 225.00, 499.99),
('P00010','Fiat 500','Classic Cars','1:24','Retro Wheels Co.','Compact city car model with removable roof and interior seating.', 2400, 14.95, 29.95),
('P00011','Ducati Panigale V4','Motorcycles','1:12','MotoCraft Models','High-performance Ducati replica with detailed braking system.', 410, 89.50, 179.00),
('P00012','Ferrari F8 Tributo','Sports Cars','1:18','Exquisite Models','Ferrari supercar model with premium paint and badge detail.', 75, 310.00, 699.99);

-- View trong SQL

# Tạo view truy vấn thông tin gồm: Mã SP, Tên SP, Dòng SP, Số lượng, Giá bán
CREATE VIEW view_product_info
AS
SELECT productCode, productName, productLine, quantityInStock, buyPrice
FROM products
WHERE quantityInStock > 5000
WITH CHECK OPTION ;

# Xem view
SELECT * from view_product_info;

# Xóa view
DROP VIEW view_product_info;

# Chỉnh sửa view
ALTER VIEW view_product_info
AS
SELECT productCode, productName, productLine, quantityInStock
FROM products;

# Cập nhật giá trị bảng thông qua view
UPDATE view_product_info
SET quantityInStock = 1000
WHERE productCode = 'P00002';

-- INDEX (CHỈ MỤC) TRONG MYSQL
CREATE TABLE customers (
    customerNumber INT PRIMARY KEY,
    customerName VARCHAR(50),
    contactLastName VARCHAR(50),
    contactFirstName VARCHAR(50),
    phone VARCHAR(50),
    addressLine1 VARCHAR(50),
    addressLine2 VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postalCode VARCHAR(15),
    country VARCHAR(50),
    salesRepEmployeeNumber INT,
    creditLimit DECIMAL(10,2)
);
INSERT INTO customers VALUES
    (103, 'Atelier graphique', 'Schmitt', 'Carine', '40.32.2555', '54, rue Royale', NULL, 'Nantes', NULL, '44000', 'France', 1370, 21000.00),
    (112, 'Signal Gift Stores', 'King', 'Jean', '7025551838', '8489 Strong St.', NULL, 'Las Vegas', 'NV', '83030', 'USA', 1166, 71800.00),
    (114, 'Australian Collectors, Co.', 'Ferguson', 'Peter', '03 9520 4555', '636 St Kilda Road', 'Level 3', 'Melbourne', 'Victoria', '3004', 'Australia', 1611, 117300.00),
    (119, 'La Rochelle Gifts', 'Labrune', 'Janine', '40.67.8555', '67, rue des Cinquante Otages', NULL, 'Nantes', NULL, '44000', 'France', 1370, 118200.00),
    (121, 'Baane Mini Imports', 'Bergulfsen', 'Jonas', '07-98 9555', 'Erling Skakkes gate 78', NULL, 'Stavern', NULL, '4110', 'Norway', 1504, 81700.00);

# Tạo chỉ mục cho 2 cột
CREATE INDEX idx_phone_address
ON customers(phone, addressLine1);

# Xóa chỉ mục
DROP INDEX idx_phone_address ON customers;

# Kiểm tra truy vấn
EXPLAIN ANALYZE
SELECT * FROM customers
WHERE phone = '40.32.2555' and addressLine1 = '54, rue Royale';

# khi CHƯA CÓ chỉ mục
# -> Filter: ((customers.addressLine1 = '54, rue Royale') and (customers.phone = '40.32.2555'))  (cost=0.75 rows=1) (actual time=0.133..0.152 rows=1 loops=1)
#    -> Table scan on customers  (cost=0.75 rows=5) (actual time=0.119..0.136 rows=5 loops=1)

# khi ĐÃ CÓ chỉ mục
# -> Index lookup on customers using idx_phone_address (phone='40.32.2555', addressLine1='54, rue Royale')  (cost=0.35 rows=1) (actual time=0.0859..0.0908 rows=1 loops=1)