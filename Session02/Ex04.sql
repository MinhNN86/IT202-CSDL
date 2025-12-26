CREATE DATABASE DatabaseEx04;
USE DatabaseEx04;

CREATE TABLE Student(
    student_id INT PRIMARY KEY ,
    student_name VARCHAR(255)
);

CREATE TABLE Subject(
    subject_id INT PRIMARY KEY ,
    subject_name VARCHAR(255) ,
    credit INT NOT NULL CHECK ( credit > 0 )
    -- CONSTRAINT chk_credit_positive CHECK (credit > 0)
);

CREATE TABLE Enrollment(
    student_id INT NOT NULL ,
    subject_id INT NOT NULL ,
    enroll_data DATE NOT NULL ,
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_enroll_subject FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
)
