DROP DATABASE IF EXISTS DemoSession07;
CREATE DATABASE DemoSession07;
USE DemoSession07;

CREATE TABLE phongban (
    id INT PRIMARY KEY,
    ten_phongban VARCHAR(50)
);
CREATE TABLE nhanvien (
    id INT PRIMARY KEY,
    ten VARCHAR(50),
    luong DECIMAL(10,2),
    chuc_vu VARCHAR(50),
    phongban_id INT,
    FOREIGN KEY (phongban_id) REFERENCES phongban(id)
);
CREATE TABLE sanpham (
    id INT PRIMARY KEY,
    ten VARCHAR(50),
    gia DECIMAL(10,2)
);
CREATE TABLE khachhang (
    id INT PRIMARY KEY,
    ten VARCHAR(50),
    thanhpho VARCHAR(50)
);
CREATE TABLE donhang (
    id INT PRIMARY KEY,
    khachhang_id INT,
    ngay_dat DATE,
    tong_tien DECIMAL(10,2),
    FOREIGN KEY (khachhang_id) REFERENCES khachhang(id)
);
CREATE TABLE chitietdonhang (
    id INT PRIMARY KEY,
    donhang_id INT,
    sanpham_id INT,
    so_luong INT,
    gia_ban DECIMAL(10,2),
    FOREIGN KEY (donhang_id) REFERENCES donhang(id),
    FOREIGN KEY (sanpham_id) REFERENCES sanpham(id)
);

-- ============================================
-- DỮ LIỆU MẪU (SAMPLE DATA)
-- ============================================
INSERT INTO phongban VALUES
    (1, 'IT'),
    (2, 'HR'),
    (3, 'Finance'),
    (4, 'Marketing'),
    (5, 'Sales');
INSERT INTO nhanvien VALUES
    (1, 'Nguyễn Văn An', 15000000, 'Trưởng phòng', 1),
    (2, 'Trần Thị Bình', 12000000, 'Senior Dev', 1),
    (3, 'Lê Văn Chi', 10000000, 'Dev', 1),
    (4, 'Phạm Thị Dung', 8000000, 'Junior Dev', 1),
    (5, 'Hoàng Văn Em', 9000000, 'Nhân viên', 2),
    (6, 'Vũ Thị Gái', 7500000, 'Nhân viên', 2),
    (7, 'Đỗ Văn Hùng', 18000000, 'Trưởng phòng', 3),
    (8, 'Ngô Lan', 14000000, 'Kế toán trưởng', 3),
    (9, 'Lê Văn Nam', 20000000, 'Trưởng phòng', 4),
    (10, 'Phạm Thị Oanh', 11000000, 'Marketing Specialist', 4),
    (11, 'Trần Văn Phát', 16000000, 'Trưởng phòng', 5),
    (12, 'Nguyễn Thị Quỳnh', 8500000, 'Sales Exec', 5);
INSERT INTO sanpham VALUES
    (1, 'Laptop Dell XPS', 25000000),
    (2, 'iPhone 15 Pro', 28000000),
    (3, 'Samsung Galaxy S24', 18000000),
    (4, 'MacBook Air M2', 23000000),
    (5, 'iPad Pro', 15000000),
    (6, 'Tai nghe Sony WH-1000XM5', 7000000),
    (7, 'Loa JBL Flip 6', 3000000),
    (8, 'Chuột Logitech MX Master', 2000000),
    (9, 'Bàn phím cơ Keychron', 3500000),
    (10, 'Màn hình Dell 27英寸', 8000000);
INSERT INTO khachhang VALUES
    (1, 'Công ty ABC', 'Hà Nội'),
    (2, 'Công ty XYZ', 'TP Hồ Chí Minh'),
    (3, 'Công ty DEF', 'Đà Nẵng'),
    (4, 'Công ty GHI', 'Hà Nội'),
    (5, 'Công ty KLM', 'TP Hồ Chí Minh'),
    (6, 'Công ty NOP', 'Cần Thơ'),
    (7, 'Công ty QRS', 'Hải Phòng'),
    (8, 'Công ty TUV', 'Hà Nội');
INSERT INTO donhang VALUES
    (1, 1, '2024-01-15', 55000000),
    (2, 2, '2024-02-20', 43000000),
    (3, 3, '2024-03-10', 28000000),
    (4, 1, '2024-04-05', 75000000),
    (5, 4, '2024-05-12', 52000000),
    (6, 2, '2024-06-18', 35000000),
    (7, 5, '2024-07-22', 67000000),
    (8, 6, '2024-08-30', 19000000),
    (9, 3, '2024-09-14', 44000000),
    (10, 7, '2024-10-25', 31000000);
INSERT INTO chitietdonhang VALUES
    (1, 1, 1, 2, 25000000),
    (2, 1, 2, 1, 28000000),
    (3, 2, 3, 1, 18000000),
    (4, 2, 5, 1, 15000000),
    (5, 2, 6, 1, 7000000),
    (6, 3, 2, 1, 28000000),
    (7, 4, 4, 3, 23000000),
    (8, 5, 1, 1, 25000000),
    (9, 5, 3, 1, 18000000),
    (10, 5, 6, 1, 7000000),
    (11, 6, 7, 5, 3000000),
    (12, 7, 2, 2, 28000000),
    (13, 7, 4, 1, 23000000),
    (14, 8, 9, 1, 3500000),
    (15, 8, 10, 2, 8000000),
    (16, 9, 1, 1, 25000000),
    (17, 10, 3, 1, 18000000),
    (18, 10, 5, 1, 15000000);

-- PHÂN LOẠI THEO KẾT QUẢ TRẢ VỀ
-- Scalar Subquery (Truy vấn con vô hướng)
# Lấy sản phẩm có giá cao nhất
SELECT *
FROM sanpham
WHERE gia = (
    SELECT MAX(gia)
    FROM sanpham
);
-- Column Subquery (Truy vấn con một cột)
# Tìm đơn hàng của khách hàng ở Hà Nội
SELECT *
FROM donhang
WHERE khachhang_id IN (
    SELECT id
    FROM khachhang
    WHERE thanhpho = 'Hà Nội'
);
-- Row Subquery (Truy vấn con 1 hàng – nhiều cột)
# Tìm nhân viên có lương + chức vụ giống nhân viên ID = 10
SELECT *
FROM nhanvien
WHERE (luong, chuc_vu) = (
    SELECT luong, chuc_vu
    FROM nhanvien
    WHERE id = 10
);
-- Table Subquery (Truy vấn con dạng bảng)
# Lấy nhân viên lương > 1000 từ bảng tạm
SELECT *
FROM (
    SELECT *
    FROM nhanvien
    WHERE luong > 10000000
) AS nv_luong_cao;

-- PHÂN LOẠI THEO CƠ CHẾ HOẠT ĐỘNG
-- Independent Subquery (Độc lập)
# Nhân viên có lương cao hơn lương trung bình toàn công ty
SELECT *
FROM nhanvien
WHERE luong > (
    SELECT AVG(luong)
    FROM nhanvien
);
-- Correlated Subquery (Tương quan)
# Nhân viên có lương cao hơn trung bình phòng ban của họ
SELECT *
FROM nhanvien nv
WHERE luong > (
    SELECT AVG(luong)
    FROM nhanvien
    WHERE phongban_id = nv.phongban_id
);

-- PHÂN LOẠI THEO VỊ TRÍ ĐẶT
-- Subquery trong WHERE
SELECT *
FROM nhanvien
WHERE luong > (
    SELECT AVG(luong)
    FROM nhanvien
);
-- Subquery trong FROM (Derived Table)
SELECT nv.ten, nv.luong
FROM (
     SELECT *
     FROM nhanvien
     WHERE luong > 1000
) AS nv;
-- Subquery trong SELECT (CHỈ Scalar)
# Hiển thị tên phòng ban cho từng nhân viên
SELECT
    nv.ten,
    nv.luong,
    (
        SELECT ten_phongban
        FROM phongban pb
        WHERE pb.id = nv.phongban_id
    ) AS ten_phongban
FROM nhanvien nv;

-- SESSION03
-- Subquery trong HAVING – So sánh nhóm
# Tìm phòng ban có lương trung bình cao hơn lương trung bình toàn công ty
SELECT pb.ten_phongban, AVG(nv.Luong) AS LuongTBPhong
FROM nhanvien nv
JOIN phongban pb ON nv.phongban_id = pb.id
GROUP BY pb.ten_phongban
HAVING AVG(nv.Luong) > (
    SELECT AVG(Luong)
    FROM nhanvien
);
-- Subquery trong SELECT – Hiển thị chênh lệch
# Hiển thị tên nhân viên, lương và chênh lệch so với lương cao nhất
SELECT
    ten,
    luong,
    luong - (
        SELECT MAX(luong)
        FROM nhanvien
    ) AS ChenhLech
FROM nhanvien;