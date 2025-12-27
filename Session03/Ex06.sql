DROP DATABASE DatabaseEx06;
CREATE DATABASE DatabaseEx06;
USE DatabaseEx06;

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

CREATE TABLE Score(
    student_id INT ,
    subject_id INT ,
    mid_score DECIMAL(4,2),
    final_score DECIMAL(4, 2),
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_score_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_score_subject FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

INSERT INTO Student (student_id, student_full_name, date_of_birth, student_email) VALUES
(1, 'Nguyen Van A', '2004-01-15', 'vana@example.com'),
(2, 'Tran Thi B', '2004-05-20', 'thib@example.com');

INSERT INTO Subject (subject_id, subject_name, credit) VALUES
(101, 'Toán cao cấp', 3),
(102, 'Cơ sở dữ liệu', 4);

INSERT INTO Score(student_id, subject_id, mid_score, final_score) VALUES
(1, 101, 8.5, 9.5),
(1, 102, 10, 5.5),
(2, 101, 6, 7.5);

-- Lấy bảng điểm gồm cả tên học sinh
SELECT sc.student_id, st.student_full_name, sc.subject_id, sc.mid_score, sc.final_score
FROM Score sc
JOIN Student st ON sc.student_id = st.student_id;

-- Lấy điểm cuối kỳ 8 trở lên
SELECT sc.student_id, st.student_full_name, sc.subject_id, sc.final_score
FROM Score sc
JOIN Student st ON sc.student_id = st.student_id
WHERE final_score >= 8;
