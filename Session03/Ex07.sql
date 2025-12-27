DROP DATABASE DatabaseEx07;
CREATE DATABASE DatabaseEx07;
USE DatabaseEx07;

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

CREATE TABLE Score(
    student_id INT ,
    subject_id INT ,
    mid_score DECIMAL(4,2),
    final_score DECIMAL(4, 2),
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_score_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_score_subject FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

-- Thêm một sinh viên mới
INSERT INTO Student (student_id, student_full_name, date_of_birth, student_email)
VALUES (3, 'Le Thi C', '2004-08-10', 'letc@example.com');

-- Thêm dữ liệu mẫu cho Subject nếu chưa có
INSERT INTO Subject (subject_id, subject_name, credit) VALUES
(201, 'Lập trình Java', 3),
(202, 'Hệ điều hành', 4);

-- Đăng ký ít nhất 2 môn học cho sinh viên đó
INSERT INTO Enrollment (student_id, subject_id, enroll_date) VALUES
(3, 201, '2025-09-10'),
(3, 202, '2025-09-10');

-- Thêm điểm cho sinh viên vừa thêm
INSERT INTO Score (student_id, subject_id, mid_score, final_score) VALUES
(3, 201, 7.5, 8.0),
(3, 202, 6.0, 7.0);

-- Cập nhật điểm cho sinh viên vừa thêm (ví dụ cập nhật điểm môn 201)
UPDATE Score
SET mid_score = 8.0, final_score = 8.5
WHERE student_id = 3 AND subject_id = 201;

-- Xóa một lượt đăng ký không hợp lệ (ví dụ: đăng ký nhầm môn 202 cho sinh viên 3)
DELETE FROM Enrollment
WHERE student_id = 3 AND subject_id = 202;

-- Lấy ra danh sách sinh viên và điểm số tương ứng
SELECT s.student_id, s.student_full_name, sub.subject_name, sc.mid_score, sc.final_score
FROM Score sc
JOIN Student s ON sc.student_id = s.student_id
JOIN Subject sub ON sc.subject_id = sub.subject_id;