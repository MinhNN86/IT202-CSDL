CREATE DATABASE DemoSession06;
USE DemoSession06;

CREATE TABLE KhachHang (
    ID INT PRIMARY KEY,
    Ten VARCHAR(50)
);

INSERT INTO KhachHang (ID, Ten) VALUES
(1, 'An'),
(2, 'Binh'),
(3, 'Cuong');

CREATE TABLE DonHang (
    ID INT PRIMARY KEY,
    NgayDat DATE,
    KhachHangID INT
);

INSERT INTO DonHang (ID, NgayDat, KhachHangID) VALUES
(101, '2024-01-01', 1),
(102, '2024-02-01', 2),
(103, '2024-03-01', 5);

-- MỆNH ĐỀ JOIN - LIÊN KẾT DỮ LIỆU TRONG MYSQL
# INNER JOIN – Chỉ lấy dữ liệu khớp ở 2 bảng
SELECT kh.Ten, dh.ID AS MaDon
FROM KhachHang kh
INNER JOIN DonHang dh
ON kh.ID = dh.KhachHangID;

# LEFT JOIN – Ưu tiên bảng bên trái (KhachHang)
SELECT kh.Ten, dh.ID AS MaDon
FROM KhachHang kh
LEFT JOIN DonHang dh
ON kh.ID = dh.KhachHangID;

# RIGHT JOIN – Ưu tiên bảng bên phải (DonHang)
SELECT kh.Ten, dh.ID AS MaDon
FROM KhachHang kh
RIGHT JOIN DonHang dh
ON kh.ID = dh.KhachHangID;

# FULL OUTER JOIN
SELECT kh.Ten, dh.ID
FROM KhachHang kh
LEFT JOIN DonHang dh
ON kh.ID = dh.KhachHangID
UNION
SELECT kh.Ten, dh.ID
FROM KhachHang kh
RIGHT JOIN DonHang dh
ON kh.ID = dh.KhachHangID;

-- CÁC HÀM TỔ HỢP (AGGREGATE FUNCTIONS) TRONG MYSQL
CREATE TABLE NhanVien (
    ID INT PRIMARY KEY,
    Ten VARCHAR(50),
    PhongBan VARCHAR(20),
    Luong INT
);

INSERT INTO NhanVien (ID, Ten, PhongBan, Luong) VALUES
    (1, 'An',    'IT',   1000),
    (2, 'Binh',  'Sale', 500),
    (3, 'Cuong', 'IT',   1200),
    (4, 'Dung',  'HR',   800),
    (5, 'Lan',   'Sale', NULL);


# COUNT() – Đếm số dòng
SELECT COUNT(*) AS TongNhanVien
FROM NhanVien;

# SUM() – Tính tổng lương
SELECT SUM(Luong) AS TongLuong
FROM NhanVien;

# AVG() – Tính lương trung bình
SELECT AVG(Luong)  AS LuongTrungBinh
FROM NhanVien;

# Nếu muốn tính Lan = 0 lương
SELECT AVG(IFNULL(Luong, 0)) AS LuongTB_CoTinhNULL
FROM NhanVien;

# MIN() – Lương thấp nhất
SELECT MIN(Luong) AS LuongThapNhat
FROM NhanVien;

# MAX() – Lương cao nhất
SELECT MAX(Luong) AS LuongCaoNhat
FROM NhanVien;

# GROUP BY – Thống kê theo phòng ban
SELECT
    PhongBan,
    COUNT(*) AS SoNhanVien,
    SUM(Luong) AS TongLuong,
    AVG(Luong) AS LuongTB
FROM NhanVien
GROUP BY PhongBan;


-- MỆNH ĐỀ GROUP BY VÀ HÀM GỘP TRONG MYSQL
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    Product VARCHAR(50),
    Amount INT
);

INSERT INTO Orders (OrderID, CustomerID, Product, Amount) VALUES
(1, 101, 'Laptop', 1500),
(2, 102, 'Mouse', 20),
(3, 101, 'Mouse', 20),
(4, 103, 'Keyboard', 50),
(5, 102, 'Laptop', 1500);

SELECT CustomerID, SUM(Amount) AS TongTien
FROM Orders
GROUP BY CustomerID;

SELECT Product, COUNT(*) AS SoDon
FROM Orders
GROUP BY Product;

# HAVING – LỌC SAU KHI GROUP BY
SELECT CustomerID, SUM(Amount) AS TongTien
FROM Orders
GROUP BY CustomerID
HAVING SUM(Amount) > 100;


-- MỆNH ĐỀ HAVING - LỌC DỮ LIỆU SAU KHI NHÓM
CREATE TABLE Sales (
    Product VARCHAR(50),
    Year INT,
    Amount INT
);
INSERT INTO Sales (Product, Year, Amount) VALUES
('Laptop',   2024, 3000),
('Laptop',   2024, 2500),
('Laptop',   2023, 2000),
('Mouse',    2024, 1000),
('Mouse',    2024, 2000),
('Keyboard', 2024, 4000),
('Keyboard', 2023, 1500);

# VÍ DỤ 1 – HAVING CƠ BẢN
SELECT Product, SUM(Amount) AS TongDoanhThu
FROM Sales
GROUP BY Product
HAVING SUM(Amount) > 5000;

# VÍ DỤ 2 – KẾT HỢP WHERE + HAVING
SELECT Product, SUM(Amount) AS TongDoanhThu
FROM Sales
WHERE Year = 2024
GROUP BY Product
HAVING SUM(Amount) > 5000;

