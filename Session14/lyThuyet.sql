-- ====================================================================
-- LÝ THUYẾT TRANSACTION TRONG MYSQL
-- ====================================================================

-- ====================================================================
-- 1. TRANSACTION LÀ GÌ?
-- ====================================================================
/*
    Transaction (Giao dịch) là một tập hợp các câu lệnh SQL được thực thi
    như một đơn vị duy nhất. Hoặc là tất cả thành công, hoặc là tất cả thất bại.

    Ví dụ thực tế: Chuyển tiền
        - Bước 1: Trừ tiền từ tài khoản A
        - Bước 2: Cộng tiền vào tài khoản B
        -> Nếu bước 1 thành công nhưng bước 2 thất bại thì tiền bị mất!
        -> Transaction đảm bảo cả 2 bước đều thành công hoặc đều được hoãn.
*/

-- ====================================================================
-- 2. TÍNH CHẤT ACID CỦA TRANSACTION
-- ====================================================================
/*
    A - Atomicity (Tính nguyên tử)
        -> Tất cả các thao tác phải thành công hoặc tất cả đều bị hủy bỏ
        -> Không có trường hợp "một phần thành công"

    C - Consistency (Tính nhất quán)
        -> Database phải chuyển từ trạng thái hợp lệ sang trạng thái hợp lệ
        -> Các ràng buộc (constraints) luôn được đảm bảo

    I - Isolation (Tính cô lập)
        -> Các transaction độc lập không ảnh hưởng lẫn nhau
        -> Kết quả của transaction này không nhìn thấy bởi transaction khác
           cho đến khi hoàn tất

    D - Durability (Tính bền vững)
        -> Khi transaction đã được commit, dữ liệu được lưu vĩnh viễn
        -> Ngay cả khi hệ thống bị crash, dữ liệu vẫn được giữ nguyên
*/

-- ====================================================================
-- 3. CÁC LỆNH TRANSACTION CƠ BẢN
-- ====================================================================

/*
    START TRANSACTION (hoặc BEGIN)
        -> Bắt đầu một transaction mới

    COMMIT
        -> Lưu tất cả các thay đổi vào database
        -> Kết thúc transaction thành công

    ROLLBACK
        -> Hoàn tác tất cả các thay đổi
        -> Quay lại trạng thái trước khi bắt đầu transaction
*/

-- ====================================================================
-- 4. VÍ DỤ CƠ BẢN VỀ TRANSACTION
-- ====================================================================

DROP DATABASE IF EXISTS DemoSession14;
CREATE DATABASE DemoSession14;
USE DemoSession14;

-- Tạo bảng tài khoản ngân hàng
CREATE TABLE accounts(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00
);

-- Thêm dữ liệu mẫu
INSERT INTO accounts(name, balance) VALUES
('Nguyễn Văn A', 500.00),
('Nguyễn Văn B', 300.00),
('Trần Thị C', 1000.00);

-- Xem dữ liệu ban đầu
SELECT '=== DỮ LIỆU BAN ĐẦU ===' AS ThongTin;
SELECT * FROM accounts;


-- ====================================================================
-- 5. VÍ DỤ 1: TRANSACTION THÀNH CÔNG (COMMIT)
-- ====================================================================

SELECT '=== VÍ DỤ 1: CHUYỂN TIỀN THÀNH CÔNG ===' AS ThongTin;

-- Bắt đầu transaction
START TRANSACTION;

-- Trừ tiền từ tài khoản A (id=1)
UPDATE accounts
SET balance = balance - 100
WHERE id = 1;

-- Cộng tiền vào tài khoản B (id=2)
UPDATE accounts
SET balance = balance + 100
WHERE id = 2;

-- Xem trạng thái trong transaction (chưa commit)
SELECT '=== TRONG TRANSACTION (CHƯA COMMIT) ===' AS ThongTin;
SELECT * FROM accounts;

-- Lưu thay đổi
COMMIT;

-- Xem kết quả sau commit
SELECT '=== SAU KHI COMMIT ===' AS ThongTin;
SELECT * FROM accounts;


-- ====================================================================
-- 6. VÍ DỤ 2: TRANSACTION THẤT BẠI (ROLLBACK)
-- ====================================================================

SELECT '=== VÍ DỤ 2: CHUYỂN TIỀN BỊ HỦY (ROLLBACK) ===' AS ThongTin;

-- Trả lại dữ liệu ban đầu
UPDATE accounts SET balance = 500 WHERE id = 1;
UPDATE accounts SET balance = 300 WHERE id = 2;
UPDATE accounts SET balance = 1000 WHERE id = 3;

-- Bắt đầu transaction
START TRANSACTION;

-- Trừ tiền từ tài khoản A
UPDATE accounts
SET balance = balance - 200
WHERE id = 1;

-- Cộng tiền vào tài khoản C (nhưng chúng ta sẽ rollback)
UPDATE accounts
SET balance = balance + 200
WHERE id = 3;

-- Xem trạng thái trong transaction
SELECT '=== TRONG TRANSACTION ===' AS ThongTin;
SELECT * FROM accounts;

-- HỦY tất cả thay đổi
ROLLBACK;

-- Xem kết quả sau rollback (về lại trạng thái ban đầu)
SELECT '=== SAU KHI ROLLBACK (KHÔNG CÓ THAY ĐỔI) ===' AS ThongTin;
SELECT * FROM accounts;


-- ====================================================================
-- 7. VÍ DỤ 3: TRANSACTION VỚI XỬ LÝ LỖI
-- ====================================================================

SELECT '=== VÍ DỤ 3: CHUYỂN TIỀN VỚI KIỂM TRA SỐ DƯ ===' AS ThongTin;

DELIMITER //

-- Tạo stored procedure chuyển tiền an toàn
CREATE PROCEDURE transfer_money(
    IN p_sender_id INT,
    IN p_receiver_id INT,
    IN p_amount DECIMAL(15,2),
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE v_sender_balance DECIMAL(15,2);

    -- Kiểm tra số dư người gửi
    SELECT balance INTO v_sender_balance
    FROM accounts
    WHERE id = p_sender_id;

    -- Bắt đầu transaction
    START TRANSACTION;

    -- Kiểm tra điều kiện: số dư đủ và số tiền > 0
    IF v_sender_balance >= p_amount AND p_amount > 0 THEN

        -- Trừ tiền người gửi
        UPDATE accounts
        SET balance = balance - p_amount
        WHERE id = p_sender_id;

        -- Cộng tiền người nhận
        UPDATE accounts
        SET balance = balance + p_amount
        WHERE id = p_receiver_id;

        -- Lưu thay đổi
        COMMIT;
        SET p_result = 'Chuyển tiền thành công!';

    ELSE
        -- Không đủ số dư hoặc số tiền không hợp lệ
        ROLLBACK;
        SET p_result = 'Lỗi: Không đủ số dư hoặc số tiền không hợp lệ!';

    END IF;

END //

DELIMITER ;

-- Thử chuyển tiền thành công
SELECT '=== THỬ CHUYỂN 50 ĐỀN TỪ A SANG B ===' AS ThongTin;
SELECT * FROM accounts;
CALL transfer_money(1, 2, 50.00, @result);
SELECT @result AS KetQua;
SELECT * FROM accounts;

-- Thử chuyển tiền thất bại (A chỉ còn 350, thử chuyển 500)
SELECT '=== THỬ CHUYỂN 500 ĐỀN TỪ A SANG C (SẼ THẤT BẠI) ===' AS ThongTin;
CALL transfer_money(1, 3, 500.00, @result);
SELECT @result AS KetQua;
SELECT * FROM accounts;


-- ====================================================================
-- 8. TRANSACTION VỚI SAVEPOINT (ĐIỂM LƯU)
-- ====================================================================

/*
    Savepoint cho phép tạo điểm lưu trong transaction
    Có thể rollback về một savepoint cụ thể thay vì rollback toàn bộ
*/

DELIMITER //

CREATE PROCEDURE demo_savepoint()
BEGIN
    DECLARE v_result VARCHAR(100);

    -- Bắt đầu transaction
    START TRANSACTION;

    -- Thao tác 1: Cộng 100 vào tài khoản A
    UPDATE accounts SET balance = balance + 100 WHERE id = 1;

    -- Tạo savepoint 1
    SAVEPOINT sp1;

    -- Thao tác 2: Trừ 200 từ tài khoản B
    UPDATE accounts SET balance = balance - 200 WHERE id = 2;

    -- Kiểm tra: nếu B bị âm thì rollback về sp1
    SELECT balance INTO v_result FROM accounts WHERE id = 2;

    IF v_result < 0 THEN
        -- Rollback về savepoint sp1 (chỉ hủy thao tác 2)
        ROLLBACK TO sp1;
        SELECT 'Đã rollback về sp1, B không bị trừ tiền' AS ThongBao;
    ELSE
        SELECT 'Tất cả thao tác thành công' AS ThongBao;
    END IF;

    -- Commit transaction
    COMMIT;

END //

DELIMITER ;

-- Trả lại dữ liệu ban đầu
UPDATE accounts SET balance = 500 WHERE id = 1;
UPDATE accounts SET balance = 300 WHERE id = 2;

SELECT '=== DEMO SAVEPOINT ===' AS ThongTin;
SELECT 'Trước khi thực hiện:' AS ThongTin;
SELECT * FROM accounts;

CALL demo_savepoint();

SELECT 'Sau khi thực hiện (A cộng 100, B không đổi do rollback về sp1):' AS ThongTin;
SELECT * FROM accounts;


-- ====================================================================
-- 9. TỔNG KẾT
-- ====================================================================

/*
    +-------------------+---------------------------------------------+
    | LỆNH             | CHỨC NĂNG                                   |
    +-------------------+---------------------------------------------+
    | START TRANSACTION | Bắt đầu một transaction mới                |
    | BEGIN             | Tương tự START TRANSACTION                  |
    | COMMIT            | Lưu tất cả thay đổi vào database            |
    | ROLLBACK          | Hủy tất cả thay đổi, quay lại ban đầu       |
    | SAVEPOINT name    | Tạo điểm lưu trong transaction              |
    | ROLLBACK TO name  | Rollback về savepoint                       |
    | RELEASE SAVEPOINT | Xóa savepoint                               |
    +-------------------+---------------------------------------------+

    LƯU Ý QUAN TRỌNG:
    1. Dùng Transaction khi cần thực hiện nhiều câu lệnh liên quan
    2. Luôn kiểm tra điều kiện trước khi COMMIT
    3. Dùng ROLLBACK khi có lỗi xảy ra
    4. Transaction giúp bảo toàn tính toàn vẹn dữ liệu
    5. Trong MySQL, chỉ các bảng dùng InnoDB mới hỗ trợ Transaction
*/

-- Xem engine của bảng
SELECT
    TABLE_NAME,
    ENGINE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'DemoSession14';
