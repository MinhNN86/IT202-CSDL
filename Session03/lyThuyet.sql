CREATE DATABASE DemoSession03;
USE DemoSession03;

CREATE TABLE Task(
    task_id INT PRIMARY KEY ,
    task_name VARCHAR(50) NOT NULL ,
    detail TEXT,
    status BIT,
    deadline INT CHECK(deadline > 0) DEFAULT (4)
);

-- !Thêm dữ liệu
-- Chèn dữ liệu vào bảng
INSERT INTO Task(task_id, task_name, detail, status)
VALUES (4, 'Làm bài tập', 'làm bài tập ss02', 1);
-- Chèn nhiều dữ liệu vào bảng
INSERT INTO Task(task_id, task_name, detail, status)
VALUES
(1, 'Làm bài tập', 'làm bài tập ss03', 1),
(2, 'Làm bài tập', 'làm bài tập ss04', 1);
--  Copy dữ liệu của bảng này qua bảng khác
INSERT INTO Task(task_id, task_name, detail, status)
SELECT 3, task_name, detail, 0
FROM Task
WHERE task_id = 2;
-- Các điều kiện cơ bản với mệnh đề WHERE(BOOLEAN) : so sánh (=, >, < , >=, <=), logic (and, or, not)

-- !Sửa dữ liệu ở trong bảng
UPDATE Task
SET task_name = 'Đi học', detail = 'Học mySQL', status = 1
WHERE task_id = 9; -- Sử nhật dụng để giới hạn dữ liệu cập nhật trong bảng

-- !Xóa dữ liệu ở trong bảng
DELETE FROM Task
WHERE task_id = 4;
-- Xóa lan truyền: Thêm "ON DELETE CASCADE" ở phần liên kết khóa ngoại trong bảng

-- !Lấy dữ liệu từ trong bảng
SELECT task_id, task_name, detail -- Lấy ra các cột. "*": lấy ra tất cả các cột
FROM Task -- Lấy từ bảng
WHERE status = 1; -- Lọc dữ liệu lấy ra