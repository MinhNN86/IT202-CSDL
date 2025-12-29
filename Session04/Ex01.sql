CREATE DATABASE DatabaseEx01;
USE DatabaseEx01;

CREATE TABLE Student(
    student_id INT PRIMARY KEY ,
    student_name VARCHAR(255) ,
    student_dob DATE ,
    student_email VARCHAR(255) UNIQUE
);

CREATE TABLE Teacher(
    teacher_id INT PRIMARY KEY ,
    teacher_name VARCHAR(255) ,
    teacher_dob DATE,
    teacher_email VARCHAR(255) UNIQUE
);

CREATE TABLE Course(
    course_id INT PRIMARY KEY ,
    course_name VARCHAR(255) ,
    course_detail VARCHAR(255),
    number_of_lessons INT
);

CREATE TABLE Course_Teacher(
    course_id INT ,
    teacher_id INT ,
    PRIMARY KEY (course_id, teacher_id),
    CONSTRAINT fk_ct_course FOREIGN KEY (course_id) REFERENCES Course(course_id),
    CONSTRAINT fk_ct_teacher FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);

CREATE TABLE Enrollment(
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enroll_date DATE NOT NULL,
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_enrollment_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_enrollment_course FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Score(
    student_id INT,
    course_id INT ,
    mid_score DECIMAL (2, 1) ,
    final_score DECIMAL (2, 1) ,
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_score_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_score_course FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

-- Phần II - Nhập dữ liệu ban đầu
INSERT INTO Student(student_id, student_name, student_dob, student_email) VALUES
(1, 'Nguyen Van A', '2000-01-15', 'nva@example.com'),
(2, 'Tran Thi B', '2001-03-22', 'ttb@example.com'),
(3, 'Le Van C', '1999-07-10', 'lvc@example.com'),
(4, 'Pham Thi D', '2000-11-05', 'ptd@example.com'),
(5, 'Hoang Van E', '2002-05-19', 'hve@example.com');

INSERT INTO Teacher(teacher_id, teacher_name, teacher_dob, teacher_email) VALUES
(1, 'Dr. Tran X', '1975-04-02', 'tranx@example.com'),
(2, 'Prof. Le Y', '1980-08-12', 'ley@example.com'),
(3, 'Ms. Nguyen Z', '1985-02-28', 'nguyenz@example.com'),
(4, 'Mr. Pham W', '1978-09-30', 'phamw@example.com'),
(5, 'Dr. Hoang Q', '1972-12-11', 'hoangq@example.com');

INSERT INTO Course(course_id, course_name, course_detail, number_of_lessons) VALUES
(101, 'Database Systems', 'Intro to relational DBs and SQL', 45),
(102, 'Data Structures', 'Algorithms and data structures', 40),
(103, 'Operating Systems', 'Processes, threads, scheduling', 50),
(104, 'Computer Networks', 'Network layers and protocols', 35),
(105, 'Web Development', 'HTML, CSS, JavaScript basics', 30);

INSERT INTO Course_Teacher(course_id, teacher_id) VALUES
(101, 1),
(101, 2),
(102, 2),
(103, 3),
(104, 4),
(105, 5),
(104, 1);

INSERT INTO Enrollment(student_id, course_id, enroll_date) VALUES
(1, 101, '2025-09-01'),
(1, 102, '2025-09-02'),
(2, 101, '2025-09-03'),
(2, 103, '2025-09-04'),
(2, 104, '2025-09-05'),
(3, 102, '2025-09-06'),
(3, 104, '2025-09-07'),
(4, 101, '2025-09-08'),
(4, 105, '2025-09-09'),
(5, 103, '2025-09-10'),
(5, 105, '2025-09-11');

INSERT INTO Score(student_id, course_id, mid_score, final_score) VALUES
(1, 101, 7.5, 8.0),
(1, 102, 6.8, 7.2),
(2, 101, 8.5, 8.7),
(2, 103, 7.0, 7.5),
(2, 104, 6.5, 6.9),
(3, 102, 7.8, 8.1),
(3, 104, 5.5, 6.0),
(4, 101, 9.0, 9.2),
(4, 105, 8.0, 8.4),
(5, 103, 6.0, 6.7),
(5, 105, 7.2, 7.9);

-- Phần III - Cập nhật dữ liệu
-- Cập nhật email cho sinh viên có student_id = 3
UPDATE Student
SET student_email = 'lvc_new@example.com'
WHERE student_id = 3;
-- Cập nhật mô tả cho khóa học có course_id = 102
UPDATE Course
SET course_detail = 'Advanced algorithms and in-depth data structures'
WHERE course_id = 102;
-- Cập nhật điểm cuối kỳ cho sinh viên (student_id = 1) trong khóa (course_id = 101)
UPDATE Score
SET final_score = 8.5
WHERE student_id = 1 AND course_id = 101;

-- Phần IV - Xóa dữ liệu
DELETE FROM Score WHERE student_id = 3 AND course_id = 104;
DELETE FROM Enrollment WHERE student_id = 3 AND course_id = 104;

-- Phần V - Truy vấn dữ liệu
# Lấy danh sách tất cả sinh viên (Student)
SELECT * FROM Student;
# Lấy danh sách giảng viên (Teacher)
SELECT * FROM Teacher;
# Lấy danh sách các khóa học (Course)
SELECT * FROM Course;
# Lấy thông tin các lượt đăng ký khóa học (Enrollment)
SELECT * FROM Enrollment;
# Lấy thông tin các lần đánh giá kết quả (Score)
SELECT * FROM Score;
