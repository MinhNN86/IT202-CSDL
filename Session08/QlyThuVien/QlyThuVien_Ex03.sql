DROP DATABASE IF EXISTS DatabaseEx03;
CREATE DATABASE DatabaseEx03;
USE DatabaseEx03;

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

# Lấy tên sách, tác giả và tên thể loại của sách, sắp xếp theo tên sách
SELECT
    b.title,
    b.author,
    cate.category_name
FROM Books b
JOIN Categories cate ON b.category_id = cate.category_id
ORDER BY b.title ;

# Lấy tên bạn đọc và số lượng sách mà mỗi bạn đọc đã mượn.
SELECT
    r.name,
    COALESCE(COUNT(b.borrow_id), 0) AS SoLuongSachDaMuon
FROM Readers r
LEFT JOIN Borrowing b ON r.reader_id = b.reader_id
GROUP BY r.reader_id, r.name;

# Lấy số tiền phạt trung bình mà các bạn đọc phải trả.
SELECT
    ROUND(AVG(fine_amount), 2) AS TienPhatTrungBinh
FROM Fines;

# Lấy tên sách và số lượng có sẵn của các sách có số lượng tồn kho cao nhất.
SELECT title, available_quantity
FROM Books
WHERE available_quantity = (
    SELECT MAX(available_quantity)
    FROM Books
);

# Lấy tên bạn đọc và số tiền phạt mà họ phải trả, chỉ những bạn đọc có khoản phạt lớn hơn 0.
SELECT
    r.name,
    ROUND(SUM(f.fine_amount), 2) AS TongTienPhat
FROM Readers r
JOIN Borrowing b ON r.reader_id = b.reader_id
JOIN Returning ret ON b.borrow_id = ret.borrow_id
JOIN Fines f ON ret.return_id = f.return_id
GROUP BY r.reader_id, r.name
HAVING SUM(f.fine_amount) > 0;

# Lấy tên sách và số lần mượn của mỗi sách, chỉ sách có số lần mượn nhiều nhất
SELECT
    b.title,
    (
        SELECT COUNT(*) AS book_count
        FROM Borrowing
        WHERE book_id = b.book_id
    ) AS SoLanMuon
FROM Books b
WHERE b.book_id = (
    SELECT book_id
    FROM Borrowing
    GROUP BY book_id
    HAVING COUNT(*) = (
        SELECT MAX(book_count)
        FROM (
            SELECT COUNT(*) AS book_count
            FROM Borrowing
            GROUP BY book_id
        ) AS temp
    )
);

SELECT b.title, COUNT(*) AS cnt
FROM Borrowing br
JOIN Books b ON br.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY cnt DESC
LIMIT 1;

# Lấy tên sách, tên bạn đọc và ngày mượn của các sách chưa trả, sắp xếp theo ngày mượn.
SELECT
    b.title,
    r.name,
    bor.borrow_date
FROM Borrowing bor
JOIN Books b ON bor.book_id = b.book_id
JOIN Readers r ON bor.reader_id = r.reader_id
WHERE bor.borrow_id NOT IN (
    SELECT borrow_id FROM Returning
)
ORDER BY bor.borrow_date;

# Lấy tên bạn đọc và tên sách của các bạn đọc đã trả sách đúng hạn
SELECT
    r.name ,
    b.title
FROM Returning rtn
JOIN Borrowing bor ON bor.borrow_id = rtn.borrow_id
JOIN Books b ON b.book_id = bor.book_id
JOIN Readers r ON r.reader_id = bor.reader_id
WHERE rtn.return_date <= bor.due_date;

# Lấy tên sách và năm xuất bản của sách có số lần mượn lớn nhất.
SELECT
    b.title,
    b.publication_year
FROM Books b
WHERE b.book_id IN (
    SELECT book_id
    FROM Borrowing
    GROUP BY book_id
    HAVING COUNT(*) = (
        SELECT MAX(bookCount) FROM (
            SELECT COUNT(*) AS bookCount
            FROM Borrowing
            GROUP BY book_id
        ) AS temp
    )
)


