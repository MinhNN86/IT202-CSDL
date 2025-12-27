CREATE DATABASE DatabaseEx02;
USE DatabaseEx02;

CREATE TABLE Student(
    student_id INT PRIMARY KEY ,
    student_full_name VARCHAR(255) NOT NULL ,
    date_of_birth DATE,
    student_email VARCHAR(100) UNIQUE
);

INSERT INTO Student
VALUES
(1,  'MinhNN', '2006-06-08', 'minhnn@gmail.com'),
(2, 'Test', '2006-06-08', 'test@gmail.com'),
(3, 'Test1', '2006-06-08', 'test1@gmail.com');

SELECT * FROM Student;

SELECT student_id, student_full_name
FROM Student