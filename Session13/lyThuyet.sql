DROP DATABASE IF EXISTS DemoSession12;
CREATE DATABASE DemoSession12;
USE DemoSession12;

CREATE TABLE Students(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL ,
    sex bit,
    birthday DATE,
    phone VARCHAR(11) UNIQUE
);

-- Tạo trigger xủ lý kiểm tra ngày sinh trước khi chèn vào bảng student
-- Đối tượng OLD vè NEW được dùng để lưu trữ dữ liệu tạm thời trước và sau
DELIMITER //
CREATE TRIGGER before_insert_student
BEFORE INSERT
on Students
FOR EACH ROW
BEGIN
    IF NEW.birthday >=  CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT  = 'Không thể thêm ngày sinh sau ngày hiện tại';
    END IF ;
END // DELIMITER ;

INSERT INTO Students(name, sex, birthday, phone) VALUES
('Nguyễn Văn A', 1, '2026-1-13', '0987654321');

