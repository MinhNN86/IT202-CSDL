DROP DATABASE DatabaseEx05;
CREATE DATABASE DatabaseEx05;
USE DatabaseEx05;

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



CREATE TABLE Enrollment(
   student_id INT NOT NULL ,
   subject_id INT NOT NULL ,
   enroll_data DATE NOT NULL ,
   PRIMARY KEY (student_id, subject_id),
   CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
   CONSTRAINT fk_enroll_subject FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
)
