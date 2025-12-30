CREATE DATABASE library_management;
USE library_management;

CREATE TABLE Reader (
    reader_id INT AUTO_INCREMENT PRIMARY KEY,
    reader_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    register_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Book(
    book_id INT PRIMARY KEY ,
    book_title VARCHAR(150) NOT NULL ,
    author VARCHAR(100),
    publish_year INT check ( publish_year >= 1900 )
);

CREATE TABLE Borrow (
    reader_id INT,
    book_id INT,
    borrow_date DATE DEFAULT (CURRENT_DATE),
    return_date DATE,
    PRIMARY KEY (reader_id, book_id, borrow_date),
    FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

-- Câu 2.
-- 1. Thêm cột email vào bảng Reader
ALTER TABLE Reader
ADD COLUMN email VARCHAR(100) UNIQUE;
-- 2. Sửa kiểu dữ liệu cột author
ALTER TABLE Book
MODIFY author VARCHAR(150);
-- 3. Ràng buộc return_date >= borrow_date
ALTER TABLE Borrow
ADD CONSTRAINT chk_return_date
CHECK (return_date IS NULL OR return_date >= borrow_date);

-- Câu 3.
-- 1. Thêm dữ liệu
INSERT INTO Reader (reader_id, reader_name, phone, email, register_date) VALUES
(1, 'Nguyễn Văn An', '0901234567', 'an.nguyen@gmail.com', '2024-09-01'),
(2, 'Trần Thị Bình', '0912345678', 'binh.tran@gmail.com', '2024-09-05'),
(3, 'Lê Minh Châu', '0923456789', 'chau.le@gmail.com', '2024-09-10');
INSERT INTO Book (book_id, book_title, author, publish_year) VALUES
(101, 'Lập trình C căn bản', 'Nguyễn Văn A', 2018),
(102, 'Cơ sở dữ liệu', 'Trần Thị B', 2020),
(103, 'Lập trình Java', 'Lê Minh C', 2019),
(104, 'Hệ quản trị MySQL', 'Phạm Văn D', 2021);
INSERT INTO Borrow (reader_id, book_id, borrow_date, return_date) VALUES
(1, 101, '2024-09-15', NULL),
(1, 102, '2024-09-15', '2024-09-25'),
(2, 103, '2024-09-18', NULL);

-- 2. Cập nhật dữ liệu
UPDATE Borrow
SET return_date = '2024-10-01'
WHERE reader_id = 1;

-- 3. Xóa dữ liệu
DELETE FROM Borrow
WHERE borrow_date < '2024-09-18';

-- 4. Truy vấn dữ liệu
SELECT * FROM Reader;
SELECT * FROM Book;
SELECT * FROM Borrow;