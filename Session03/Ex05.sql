DROP DATABASE DatabaseEx05;
CREATE DATABASE DatabaseEx05;
USE DatabaseEx05;

CREATE TABLE Student(
    student_id INT PRIMARY KEY ,
    student_full_name VARCHAR(255) NOT NULL ,
    date_of_birth DATE,
    student_email VARCHAR(100) UNIQUE
);

CREATE TABLE Subject(
    subject_id INT PRIMARY KEY ,
    subject_name VARCHAR(255) ,
    credit INT CHECK ( credit > 0 )
);

CREATE TABLE Enrollment(
    student_id INT,
    subject_id INT,
    enroll_date DATE,
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_enroll_subject FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

-- Thêm dữ liệu mẫu cho Student
INSERT INTO Student (student_id, student_full_name, date_of_birth, student_email) VALUES
    (1, 'Nguyen Van A', '2004-01-15', 'vana@example.com'),
    (2, 'Tran Thi B', '2004-05-20', 'thib@example.com');

-- Thêm dữ liệu mẫu cho Subject
INSERT INTO Subject (subject_id, subject_name, credit) VALUES
    (101, 'Toán cao cấp', 3),
    (102, 'Cơ sở dữ liệu', 4);

-- Thêm dữ liệu đăng ký môn học cho 2 sinh viên
INSERT INTO Enrollment (student_id, subject_id, enroll_date) VALUES
    (1, 101, '2025-09-01'),
    (1, 102, '2025-09-01'),
    (2, 101, '2025-09-02');

-- Lấy ra tất cả các lượt đăng ký
SELECT * FROM Enrollment;

-- Lấy ra các lượt đăng ký của một sinh viên cụ thể (ví dụ: student_id = 1)
SELECT * FROM Enrollment WHERE student_id = 1;



