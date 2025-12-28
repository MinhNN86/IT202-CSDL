DROP DATABASE DatabaseEx03;
CREATE DATABASE DatabaseEx03;
USE DatabaseEx03;

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