DROP DATABASE IF EXISTS DatabaseEx01;
CREATE DATABASE DatabaseEx01;
USE DatabaseEx01;

CREATE TABLE Categories( # Thể loại sách
    category_id INT PRIMARY KEY ,
    category_name VARCHAR(255)
);
CREATE TABLE Books( # Sách
    book_id INT PRIMARY KEY ,
    title VARCHAR(255) ,
    author VARCHAR(255) ,
    publication_year INT ,
    available_quantity INT ,
    category_id INT ,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Readers( # Độc giả
    reader_id INT PRIMARY KEY ,
    name VARCHAR(255) ,
    phone_number VARCHAR(15) ,
    email VARCHAR(255)
);
CREATE TABLE Borrowing( # Mượn sách
    borrow_id INT PRIMARY KEY ,
    reader_id INT ,
    book_id INT ,
    borrow_date DATE ,
    due_date DATE ,
    FOREIGN KEY (reader_id) REFERENCES Readers(reader_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Returning( # Trả sách
    return_id INT PRIMARY KEY ,
    borrow_id INT ,
    return_date DATE ,
    FOREIGN KEY (borrow_id) REFERENCES Borrowing(borrow_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Fines( # Khoản phạt
    fine_id INT PRIMARY KEY ,
    return_id INT ,
    fine_amount DECIMAL(10, 2) ,
    FOREIGN KEY (return_id) REFERENCES Returning(return_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================
-- DỮ LIỆU MẪU (SAMPLE DATA)
-- ============================================
INSERT INTO Categories (category_id, category_name) VALUES
(1, 'Văn học'),
(2, 'Khoa học'),
(3, 'Kinh tế'),
(4, 'Lịch sử'),
(5, 'Kỹ thuật'),
(6, 'Nghệ thuật'),
(7, 'Thiếu nhi'),
(8, 'Tâm lý học');
INSERT INTO Books (book_id, title, author, publication_year, available_quantity, category_id) VALUES
(1, 'Đắc Nhân Tâm', 'Dale Carnegie', 2016, 5, 3),
(2, 'Nhà Giả Kim', 'Paulo Coelho', 2015, 3, 1),
(3, 'Tây Du Ký', 'Ngô Thừa Ân', 2017, 2, 1),
(4, 'Lược Sử Thời Gian', 'Stephen Hawking', 2018, 4, 2),
(5, 'Tư Duy Nhanh Và Chậm', 'Daniel Kahneman', 2016, 6, 3),
(6, 'Đảo Kinh Hoàng', 'J.D. Salinger', 2014, 2, 1),
(7, 'Giết Con Chim Nhại', 'Harper Lee', 2015, 3, 1),
(8, 'Lược Sử Loài Người', 'Yuval Noah Harari', 2019, 7, 4),
(9, 'Giải Mã Cuộc Sống', 'David Deutsch', 2020, 2, 2),
(10, 'Sapiens: Lược Sử Loài Người', 'Yuval Noah Harari', 2018, 5, 4),
(11, 'Tuổi Trẻ Đáng Giá Bao Nhiêu', 'Rosie Nguyễn', 2017, 8, 3),
(12, 'Dạy Con Làm Giàu', 'Robert Kiyosaki', 2016, 4, 3),
(13, 'Đắc Nhân Tâm 2', 'Dale Carnegie', 2017, 3, 6),
(14, 'Sapiens: Hóm Sapiens', 'Yuval Noah Harari', 2020, 6, 4),
(15, 'Doraemon - Tập 1', 'Fujiko F. Fujio', 2015, 10, 7);
INSERT INTO Readers (reader_id, name, phone_number, email) VALUES
(1, 'Nguyễn Văn An', '0901234567', 'an.nguyen@example.com'),
(2, 'Trần Thị Bình', '0912345678', 'binh.tran@example.com'),
(3, 'Lê Văn Cường', '0923456789', 'cuong.le@example.com'),
(4, 'Phạm Thị Dung', '0934567890', 'dung.pham@example.com'),
(5, 'Hoàng Văn Em', '0945678901', 'em.hoang@example.com'),
(6, 'Ngô Thị Hoa', '0956789012', 'hoa.ngo@example.com'),
(7, 'Đỗ Văn Hùng', '0967890123', 'hung.do@example.com'),
(8, 'Vũ Thị Lan', '0978901234', 'lan.vu@example.com'),
(9, 'Nguyễn Văn Minh', '0989012345', 'minh.nguyen@example.com'),
(10, 'Trần Thị Ngọc', '0990123456', 'ngoc.tran@example.com');
INSERT INTO Borrowing (borrow_id, reader_id, book_id, borrow_date, due_date) VALUES
(1, 1, 1, '2024-01-05', '2024-01-20'),
(2, 2, 2, '2024-01-08', '2024-01-23'),
(3, 3, 3, '2024-01-10', '2024-01-25'),
(4, 1, 4, '2024-01-12', '2024-01-27'),
(5, 4, 5, '2024-01-15', '2024-01-30'),
(6, 5, 6, '2024-01-18', '2024-02-02'),
(7, 2, 7, '2024-01-20', '2024-02-04'),
(8, 6, 8, '2024-01-22', '2024-02-06'),
(9, 7, 9, '2024-01-25', '2024-02-09'),
(10, 3, 10, '2024-01-28', '2024-02-12'),
(11, 8, 11, '2024-02-01', '2024-02-16'),
(12, 9, 12, '2024-02-05', '2024-02-20'),
(13, 4, 13, '2024-02-08', '2024-02-23'),
(14, 10, 14, '2024-02-10', '2024-02-25'),
(15, 5, 15, '2024-02-12', '2024-02-27');
INSERT INTO Returning (return_id, borrow_id, return_date) VALUES
(1, 1, '2024-01-18'),
(2, 2, '2024-01-22'),
(3, 3, '2024-01-28'),  -- Trả muộn 3 ngày
(4, 4, '2024-01-25'),
(5, 5, '2024-01-29'),
(6, 6, '2024-02-05'),  -- Trả muộn 3 ngày
(7, 7, '2024-02-02'),
(8, 8, '2024-02-10'),  -- Trả muộn 4 ngày
(9, 9, '2024-02-15'),  -- Trả muộn 6 ngày
(10, 10, '2024-02-25'), -- Trả muộn 13 ngày
(11, 11, '2024-02-20'), -- Trả muộn 4 ngày
(12, 12, '2024-02-25'),
(13, 13, '2024-02-28'), -- Trả muộn 5 ngày
(14, 14, NULL),         -- Chưa trả
(15, 15, NULL);         -- Chưa trả
INSERT INTO Fines (fine_id, return_id, fine_amount) VALUES
(1, 3, 30000),   -- 3 ngày x 10,000
(2, 6, 30000),   -- 3 ngày x 10,000
(3, 8, 40000),   -- 4 ngày x 10,000
(4, 9, 60000),   -- 6 ngày x 10,000
(5, 10, 130000), -- 13 ngày x 10,000
(6, 11, 40000),  -- 4 ngày x 10,000
(7, 13, 50000);  -- 5 ngày x 10,000

-- cập nhật thông tin của một sinh viên bất kì
UPDATE Readers
SET name = 'Edit Reader', phone_number = '0987654321', email = 'editReader@example.com'
WHERE reader_id = 1;

-- xóa thông tin của một quyển sách bất kì
DELETE FROM Books
WHERE book_id = 15;

