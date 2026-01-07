DROP DATABASE IF EXISTS mini_project_SS08;
CREATE DATABASE mini_project_SS08;
USE mini_project_SS08;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(10) NOT NULL UNIQUE
);
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL UNIQUE
);
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending','Completed','Cancel') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers (customer_name, email, phone) VALUES
    ('Nguyễn Văn A', 'a@gmail.com', '0900000001'),
    ('Trần Thị B', 'b@gmail.com', '0900000002'),
    ('Lê Văn C', 'c@gmail.com', '0900000003'),
    ('Phạm Thị D', 'd@gmail.com', '0900000004');
INSERT INTO categories (category_name) VALUES
    ('Điện thoại'),
    ('Laptop'),
    ('Phụ kiện');
INSERT INTO products (product_name, price, category_id) VALUES
    ('iPhone 15', 25000000, 1),
    ('Samsung Galaxy S23', 21000000, 1),
    ('MacBook Air M2', 32000000, 2),
    ('Dell XPS 13', 28000000, 2),
    ('Tai nghe AirPods', 4500000, 3),
    ('Chuột Logitech', 1200000, 3);
INSERT INTO orders (customer_id, status) VALUES
    (1, 'Completed'),
    (1, 'Pending'),
    (2, 'Completed'),
    (3, 'Cancel'),
    (4, 'Completed');
INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (1, 1, 1),
    (1, 5, 2),
    (2, 3, 1),
    (3, 2, 1),
    (3, 6, 3),
    (5, 4, 1),
    (5, 5, 1);

-- PHẦN A – TRUY VẤN DỮ LIỆU CƠ BẢN
# Lấy danh sách tất cả danh mục sản phẩm trong hệ thống
SELECT * FROM categories;

# Lấy danh sách đơn hàng có trạng thái là COMPLETED
SELECT * FROM orders WHERE status = 'Completed';

# Lấy danh sách sản phẩm và sắp xếp theo giá giảm dần
SELECT * FROM products ORDER BY price DESC;

# Lấy 5 sản phẩm có giá cao nhất, bỏ qua 2 sản phẩm đầu tiên
SELECT * FROM products ORDER BY price DESC LIMIT 5 OFFSET 2;

-- PHẦN B – TRUY VẤN NÂNG CAO
# Lấy danh sách sản phẩm kèm tên danh mục
SELECT
    p.product_name,
    c.category_name
FROM products p
JOIN categories c on p.category_id = c.category_id;

# Lấy danh sách đơn hàng gồm:
# order_id
# order_date
# customer_name
# status
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    o.status
FROM orders o
JOIN customers c on o.customer_id = c.customer_id;

# Tính tổng số lượng sản phẩm trong từng đơn hàng
SELECT
    order_id,
    SUM(quantity) AS SoLuongSanPham
FROM order_items
GROUP BY order_id;

# Thống kê số đơn hàng của mỗi khách hàng
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS SoDonHang
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

# Lấy danh sách khách hàng có tổng số đơn hàng ≥ 2
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS SoDonHang
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 2;

# Thống kê giá trung bình, thấp nhất và cao nhất của sản phẩm theo danh mục
SELECT
    c.category_name,
    AVG(p.price) AS GiaTrungBinh,
    MIN(p.price) AS GiaThapNhat,
    MAX(p.price) AS GiaCaoNhat
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name;

-- PHẦN C – TRUY VẤN LỒNG (SUBQUERY)
# Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
SELECT
    product_id,
    product_name,
    price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

# Lấy danh sách khách hàng đã từng đặt ít nhất một đơn hàng
SELECT
    customer_id,
    customer_name
FROM customers
WHERE customer_id IN (SELECT DISTINCT customer_id FROM orders);

# Lấy đơn hàng có tổng số lượng sản phẩm lớn nhất
SELECT
    oi.order_id,
    SUM(oi.quantity) AS TongSoLuong
FROM order_items oi
GROUP BY oi.order_id
HAVING SUM(oi.quantity) = (
    SELECT MAX(TongSoLuong)
    FROM (
        SELECT SUM(quantity) AS TongSoLuong
        FROM order_items
        GROUP BY order_id
    ) AS max_quantity
);

# Lấy tên khách hàng đã mua sản phẩm thuộc danh mục có giá trung bình cao nhất
SELECT DISTINCT
    c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
WHERE cat.category_id = (
    SELECT category_id
    FROM products
    GROUP BY category_id
    ORDER BY AVG(price) DESC
    LIMIT 1
);

# Từ bảng tạm (subquery), thống kê tổng số lượng sản phẩm đã mua của từng khách hàng
SELECT
    customer_id,
    customer_name,
    TongSoLuong
FROM (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity) AS TongSoLuong
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
) AS CustomerStats;

# Viết lại truy vấn lấy sản phẩm có giá cao nhất
# Đảm bảo subquery chỉ trả về một giá trị, không gây lỗi "Subquery returns more than 1 row"
SELECT
    product_id,
    product_name,
    price
FROM products
WHERE price = (
    SELECT MAX(price) FROM products
);
