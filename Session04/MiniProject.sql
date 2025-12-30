DROP DATABASE MiniProject_online_learning;
CREATE DATABASE MiniProject_online_learning;
USE MiniProject_online_learning;

CREATE TABLE Student(
    student_id INT PRIMARY KEY ,
    full_name VARCHAR(255) NOT NULL ,
    birth_date DATE ,
    email VARCHAR(255) UNIQUE
);

CREATE TABLE Teacher(
    teacher_id INT PRIMARY KEY ,
    full_name VARCHAR(255) NOT NULL ,
    email VARCHAR(255) UNIQUE
);

CREATE TABLE Course(
    course_id INT PRIMARY KEY ,
    name VARCHAR(255) ,
    description TEXT,
    total_session INT CHECK (total_session > 0) ,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);

CREATE TABLE Enrollment(
    student_id INT ,
    course_id INT ,
    enrollment_date DATE ,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Score (
    student_id INT,
    course_id INT,
    midterm_score DECIMAL(4,2) CHECK (midterm_score BETWEEN 0 AND 10),
    final_score DECIMAL(4,2) CHECK (final_score BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

-- Sample data: Teachers (>=5)
INSERT INTO Teacher (teacher_id, full_name, email) VALUES
(101, 'Nguyen Van A', 'a.nguyen@example.com'),
(102, 'Tran Thi B', 'b.tran@example.com'),
(103, 'Le Van C', 'c.le@example.com'),
(104, 'Pham Thi D', 'd.pham@example.com'),
(105, 'Hoang Van E', 'e.hoang@example.com');

-- Sample data: Students (>=5)
INSERT INTO Student (student_id, full_name, birth_date, email) VALUES
(1, 'Tran Minh', '2000-05-12', 'minh.tran@example.com'),
(2, 'Le Thi Hoa', '1999-11-03', 'hoa.le@example.com'),
(3, 'Nguyen Van B', '2001-02-20', 'vanb.nguyen@example.com'),
(4, 'Pham Thi Lan', '2000-08-30', 'lan.pham@example.com'),
(5, 'Hoang Anh', '1998-12-15', 'anh.hoang@example.com');

-- Sample data: Courses (>=5)
INSERT INTO Course (course_id, name, description, total_session, teacher_id) VALUES
(201, 'Intro to Databases', 'Basics of relational databases', 10, 101),
(202, 'Web Development', 'HTML/CSS/JS basics', 12, 102),
(203, 'Data Structures', 'Algorithms and data structures', 14, 103),
(204, 'Operating Systems', 'OS fundamentals', 10, 104),
(205, 'Networks', 'Computer networks basics', 8, 105);

-- Sample data: Enrollments
INSERT INTO Enrollment (student_id, course_id, enrollment_date) VALUES
(1, 201, '2025-09-01'),
(1, 202, '2025-09-05'),
(2, 201, '2025-09-02'),
(2, 203, '2025-09-06'),
(3, 202, '2025-09-03'),
(3, 204, '2025-09-07'),
(4, 203, '2025-09-04'),
(4, 205, '2025-09-08'),
(5, 204, '2025-09-05'),
(5, 205, '2025-09-09');

-- Sample data: Scores (matching enrollments)
INSERT INTO Score (student_id, course_id, midterm_score, final_score) VALUES
(1, 201, 8.50, 9.00),
(1, 202, 7.00, 7.50),
(2, 201, 6.75, 8.00),
(2, 203, 9.00, 8.50),
(3, 202, 8.25, 8.75),
(3, 204, 7.50, 7.80),
(4, 203, 5.50, 6.00),
(4, 205, 8.00, 8.20),
(5, 204, 9.20, 9.50),
(5, 205, 6.00, 6.50);


-- 1) Cập nhật email cho sinh viên có student_id = 3
UPDATE Student
SET email = 'nguyen.b.new@example.com'
WHERE student_id = 3;

-- 2) Cập nhật mô tả cho khóa học có course_id = 202
UPDATE Course
SET description = 'Front-end and back-end fundamentals using modern JavaScript, plus practical projects.'
WHERE course_id = 202;

-- 3) Cập nhật điểm cuối kỳ cho sinh viên (student_id = 4) trong khóa 203
UPDATE Score
SET final_score = 7.25
WHERE student_id = 4 AND course_id = 203;

-- Xóa một lượt đăng ký học không hợp lệ và kết quả tương ứng
DELETE FROM Score
WHERE student_id = 4 AND course_id = 203;
DELETE FROM Enrollment
WHERE student_id = 4 AND course_id = 203;

-- Truy vấn dữ liệu
SELECT * FROM Student;
SELECT * FROM Teacher;
SELECT * FROM Course;
SELECT * FROM Enrollment;
SELECT * FROM Score;

