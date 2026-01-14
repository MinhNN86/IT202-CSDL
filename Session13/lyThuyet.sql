DROP DATABASE IF EXISTS DemoSession12;
CREATE DATABASE DemoSession12;
USE DemoSession12;

-- Tạo bảng orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    product VARCHAR(100) NOT NULL,
    quantity INT DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    order_date DATE NOT NULL
);

-- ========================================
-- KHUNG CÚ PHÁP TRIGGER
-- ========================================

-- 1. CÚ PHÁP CƠ BẢN
-- ----------------------------------------
# DELIMITER //
# CREATE TRIGGER trigger_name
#     {BEFORE | AFTER}        -- Thời điểm kích hoạt
# {INSERT | UPDATE | DELETE}  -- Hành động kích hoạt
#  ON table_name           -- Bảng áp dụng
#      FOR EACH ROW            -- Kích hoạt cho mỗi dòng
# BEGIN
#     -- Các câu lệnh SQL thực thi
#     -- NEW.col_name: Giá trị SAU khi thay đổi (INSERT/UPDATE)
#     -- OLD.col_name: Giá trị TRƯỚC khi thay đổi (UPDATE/DELETE)
#     END //
# DELIMITER ;

-- 2. VÍ DỤ: BEFORE INSERT
-- ----------------------------------------
-- Tạo bảng logs để theo dõi
CREATE TABLE order_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    action VARCHAR(20),
    old_quantity INT,
    new_quantity INT,
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Trigger: Ghi log trước khi insert
DELIMITER //
CREATE TRIGGER trg_before_insert_order
    BEFORE INSERT ON orders
    FOR EACH ROW
BEGIN
    -- Tự động điền quantity nếu NULL
    IF NEW.quantity IS NULL THEN
        SET NEW.quantity = 1;
    END IF;
END //
DELIMITER ;

-- 3. VÍ DỤ: AFTER INSERT
-- ----------------------------------------
DELIMITER //
CREATE TRIGGER trg_after_insert_order
    AFTER INSERT ON orders
    FOR EACH ROW
BEGIN
    INSERT INTO order_logs (order_id, action, new_quantity)
    VALUES (NEW.order_id, 'INSERT', NEW.quantity);
END //
DELIMITER ;

-- 4. VÍ DỤ: AFTER UPDATE
-- ----------------------------------------
DELIMITER //
CREATE TRIGGER trg_after_update_order
    AFTER UPDATE ON orders
    FOR EACH ROW
BEGIN
    -- Chỉ ghi log nếu quantity thay đổi
    IF OLD.quantity != NEW.quantity THEN
        INSERT INTO order_logs (order_id, action, old_quantity, new_quantity)
        VALUES (NEW.order_id, 'UPDATE', OLD.quantity, NEW.quantity);
    END IF;
END //
DELIMITER ;

-- 5. VÍ DỤ: BEFORE DELETE
-- ----------------------------------------
DELIMITER //
CREATE TRIGGER trg_before_delete_order
    BEFORE DELETE ON orders
    FOR EACH ROW
BEGIN
    INSERT INTO order_logs (order_id, action, old_quantity)
    VALUES (OLD.order_id, 'DELETE', OLD.quantity);
END //
DELIMITER ;

-- 6. XEM DANH SÁCH TRIGGERS
-- ----------------------------------------
SHOW TRIGGERS;
SHOW TRIGGERS LIKE 'orders';
SHOW CREATE TRIGGER trg_before_insert_order;

-- 7. XÓA TRIGGER
-- ----------------------------------------
DROP TRIGGER IF EXISTS trg_before_insert_order;

-- ========================================
-- BẢNG TỔNG HỢP: NEW vs OLD
-- ========================================
-- +---------+---------+---------+
-- | Event   | NEW     | OLD     |
-- +---------+---------+---------+
-- | INSERT  | ✅ Có   | ❌ Không|
-- | UPDATE  | ✅ Có   | ✅ Có   |
-- | DELETE  | ❌ Không| ✅ Có   |
-- +---------+---------+---------+

-- ========================================
-- VÍ DỤ THỰC TẾ: Tự động cập nhật tổng tiền
-- ========================================
-- Bảng customers
CREATE TABLE customers (
                           customer_id INT AUTO_INCREMENT PRIMARY KEY,
                           customer_name VARCHAR(100) NOT NULL,
                           total_spent DECIMAL(15, 2) DEFAULT 0
);

-- Trigger: Cập nhật total_spent khi có đơn hàng mới
DELIMITER //
CREATE TRIGGER trg_update_customer_spent
    AFTER INSERT ON orders
    FOR EACH ROW
BEGIN
    UPDATE customers
    SET total_spent = total_spent + (NEW.quantity * NEW.price)
    WHERE customer_name = NEW.customer_name;
END //
DELIMITER ;


-- Tạo trigger xủ lý kiểm tra ngày sinh trước khi chèn vào bảng student
-- Đối tượng OLD vè NEW được dùng để lưu trữ dữ liệu tạm thời trước và sau
DELIMITER //
CREATE TRIGGER before_insert_student
BEFORE INSERT
on Students
FOR EACH ROW
BEGIN
    IF NEW.birthday >=  CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT  = 'Không thể thêm ngày sinh sau ngày hiện tại';
    END IF ;
END // DELIMITER ;

INSERT INTO Students(name, sex, birthday, phone) VALUES
('Nguyễn Văn A', 1, '2026-1-13', '0987654321');

