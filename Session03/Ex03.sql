DROP DATABASE DatabaseEx03;
CREATE DATABASE DatabaseEx03;
USE DatabaseEx03;

CREATE TABLE Student(
    student_id INT PRIMARY KEY ,
    student_full_name VARCHAR(255) NOT NULL ,
    date_of_birth DATE,
    student_email VARCHAR(100) UNIQUE
);

INSERT INTO Student
VALUES
(1,  'MinhNN', '2006-06-08', 'minhnn@gmail.com'),
(2, 'Test', '2006-06-08', 'test@gmail.com'),
(3, 'Test1', '2006-06-08', 'test1@gmail.com'),
(5, 'Test2', '2006-06-08', 'test2@gmail.com');

-- Cập nhật email cho một sinh viên cụ thể (student_id = 3)
UPDATE Student
SET student_email = 'edit@gamil.com'
WHERE student_id = 3;

-- Cập nhật ngày sinh cho một sinh viên khác (student_id = 2)
UPDATE Student
SET date_of_birth = '2000-01-01'
WHERE student_id = 2;

-- Xóa một sinh viên đã nhập nhầm (student_id = 5)
DELETE FROM Student
WHERE student_id = 5;

SELECT * FROM Student