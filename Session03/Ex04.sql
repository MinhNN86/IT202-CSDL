DROP DATABASE DatabaseEx04;
CREATE DATABASE DatabaseEx04;
USE DatabaseEx04;

CREATE TABLE Subject(
    subject_id INT PRIMARY KEY ,
    subject_name VARCHAR(255) ,
    credit INT CHECK ( credit > 0 )
);

INSERT INTO Subject
VALUES
(1, 'Toán cao cấp', 3),
(2, 'Cơ sở dữ liệu', 4),
(3, 'Lập trình Python', 3),
(4, 'Tiếng Anh chuyên ngành', 2),
(5, 'Mạng máy tính', 3);


UPDATE Subject
SET credit = 4
WHERE subject_id = 1;

UPDATE Subject
SET subject_name = 'Edit Subject'
WHERE subject_id = 2;