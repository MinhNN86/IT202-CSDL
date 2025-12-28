DROP DATABASE DatabaseEx02;
CREATE DATABASE DatabaseEx02;
USE DatabaseEx02;

CREATE TABLE Class(
    class_id INT PRIMARY KEY ,
    class_name VARCHAR(100) NOT NULL ,
    school_year VARCHAR(20) NOT NULL
);

CREATE TABLE Student(
    student_id INT PRIMARY KEY ,
    full_name VARCHAR(100) NOT NULL,
    data_of_birth DATE NOT NULL ,
    class_id INT,
    CONSTRAINT fk_student_class FOREIGN KEY (class_id) REFERENCES Class(class_id)
);