-- Tạo bảng
DROP DATABASE IF EXISTS DemoSession02;
CREATE DATABASE DemoSession02;

USE DemoSession02;

-- Tạo bảng person
CREATE TABLE Persons(
    personId INT NOT NULL  ,
    lastName VARCHAR(255) NOT NULL ,
    firstName VARCHAR(255) NOT NULL ,
    email VARCHAR(100) UNIQUE ,
    addressName VARCHAR(255) NULL,
    city VARCHAR(255) DEFAULT 'HN',
    PRIMARY KEY(personId)
);
-- Tạo bảng sở thích
CREATE TABLE Hobbies(
    id INT PRIMARY KEY,
    name VARCHAR(100) CHECK ( length(name) > 4 ),
    personId INT,
    FOREIGN KEY (personId) REFERENCES Persons(personId)
);

-- Thêm mới cột
ALTER TABLE Persons
ADD COLUMN phone varchar(11) UNIQUE;
-- Xóa cột
ALTER TABLE Persons
DROP COLUMN phone;
-- Chỉnh sửa kiểu dữ liệu
ALTER TABLE Persons
MODIFY phone char(11);

-- Chỉnh sửa ràng buộc
ALTER TABLE Hobbies
ADD CONSTRAINT fk_to_hobbies FOREIGN KEY (personId) REFERENCES Persons(personId);

