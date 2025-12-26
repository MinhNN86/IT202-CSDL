CREATE DATABASE DatabaseEx06;
USE DatabaseEx06;

CREATE TABLE Student(
    student_id INT PRIMARY KEY ,
    student_name VARCHAR(255)
);

CREATE TABLE TEACHER(
    teacher_id INT PRIMARY KEY ,
    teacher_name VARCHAR(255) NOT NULL ,
    teacher_email VARCHAR(255) UNIQUE
);

CREATE TABLE Subject(
    subject_id INT PRIMARY KEY ,
    subject_name VARCHAR(255) ,
    teacher_id INT,
    credit INT NOT NULL,
    CONSTRAINT chk_credit_positive CHECK (credit > 0),
    CONSTRAINT fk_subject_teacher FOREIGN KEY (teacher_id) REFERENCES TEACHER(teacher_id)
);

CREATE TABLE Score(
    student_id INT NOT NULL ,
    subject_id INT NOT NULL ,
    process_score DECIMAL(4, 2) NOT NULL ,
    final_score DECIMAL(4, 2) NOT NULL ,
    PRIMARY KEY (student_id, subject_id),

    CONSTRAINT chk_process_score CHECK ( process_score BETWEEN 0 AND 10),
    CONSTRAINT chk_final_score CHECK (final_score BETWEEN 0 AND 10),
    CONSTRAINT fk_score_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_score_subject FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);


CREATE TABLE Enrollment(
   student_id INT NOT NULL ,
   subject_id INT NOT NULL ,
   enroll_date DATE NOT NULL ,
   PRIMARY KEY (student_id, subject_id),
   CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
   CONSTRAINT fk_enroll_subject FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
)
