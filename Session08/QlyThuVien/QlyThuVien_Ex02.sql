DROP DATABASE IF EXISTS DatabaseEx02;
CREATE DATABASE DatabaseEx02;
USE DatabaseEx02;

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

INSERT INTO Categories (category_id, category_name) VALUES
    (1, 'Science'),
    (2, 'Literature'),
    (3, 'History'),
    (4, 'Technology'),
    (5, 'Psychology');
INSERT INTO Books (book_id, title, author, publication_year, available_quantity, category_id) VALUES
    (1, 'The History of Vietnam', 'John Smith', 2001, 10, 1),
    (2, 'Python Programming', 'Jane Doe', 2020, 5, 4),
    (3, 'Famous Writers', 'Emily Johnson', 2018, 7, 2),
    (4, 'Machine Learning Basics', 'Michael Brown', 2022, 3, 4),
    (5, 'Psychology and Behavior', 'Sarah Davis', 2019, 6, 5);
INSERT INTO Readers (reader_id, name, phone_number, email) VALUES
    (1, 'Alice Williams', '123-456-7890', 'alice.williams@email.com'),
    (2, 'Bob Johnson', '987-654-3210', 'bob.johnson@email.com'),
    (3, 'Charlie Brown', '555-123-4567', 'charlie.brown@email.com');
INSERT INTO Borrowing (borrow_id, reader_id, book_id, borrow_date, due_date) VALUES
    (1, 1, 1, '2025-02-19', '2025-02-15'),
    (2, 2, 2, '2025-02-03', '2025-02-17'),
    (3, 3, 3, '2025-02-02', '2025-02-16'),
    (4, 1, 2, '2025-03-10', '2025-02-24'),
    (5, 2, 3, '2025-05-11', '2025-02-25'),
    (6, 2, 3, '2025-02-11', '2025-02-25');
INSERT INTO Returning (return_id, borrow_id, return_date) VALUES
    (1, 1, '2025-03-14'),
    (2, 2, '2025-02-28'),
    (3, 3, '2025-02-15'),
    (4, 4, '2025-02-20'),
    (5, 4, '2025-02-20');
INSERT INTO Fines (fine_id, return_id, fine_amount) VALUES
    (1, 1, 5.00),
    (2, 2, 0.00),
    (3, 3, 2.00);

# Hiển thị danh sách tất cả các sách
SELECT *
FROM Books;
# Hiển thị danh sách tất cả độc giả
SELECT *
FROM Readers;
# Viết câu truy vấn để lấy thông tin về các bạn đọc và các sách mà họ đã mượn, bao gồm tên bạn đọc, tên sách và ngày mượn.
SELECT
    r.name AS reader_name,
    bk.title AS book_title,
    br.borrow_date
FROM Borrowing br
JOIN Readers r ON br.reader_id = r.reader_id
JOIN Books bk ON br.book_id = bk.book_id
ORDER BY br.borrow_date;
# Viết câu truy vấn để lấy thông tin về các sách và thể loại của chúng, bao gồm tên sách, tác giả và tên thể loại
SELECT
    bk.title,
    bk.author,
    cate.category_name
FROM Books bk
INNER JOIN Categories cate ON bk.category_id = cate.category_id;
# Viết câu truy vấn để lấy thông tin về các bạn đọc và các khoản phạt mà họ phải trả, bao gồm tên bạn đọc, số tiền phạt và ngày trả sách.
SELECT
    r.name AS reader_name ,
    f.fine_amount AS fine_amount ,
    rtn.return_date AS return_date
FROM Fines f
JOIN Returning rtn ON f.return_id = rtn.return_id
JOIN Borrowing b ON rtn.borrow_id = b.borrow_id
JOIN Readers r ON b.reader_id = r.reader_id;
# Hãy cập nhật số lượng sách còn lại (cột available_quantity) của cuốn sách có book_id = 1 thành 15.
UPDATE Books
SET available_quantity = 15
WHERE book_id = 1;
# Hãy xóa bạn đọc có reader_id = 2 khỏi bảng Readers.
DELETE FROM Readers
WHERE reader_id = 2;
# thêm lại bạn đọc có reader_id = 2
INSERT INTO Readers VALUES
(2, 'Bob Johnson', '987-654-3210', 'bob.johnson@email.com');
