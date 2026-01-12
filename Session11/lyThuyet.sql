CREATE DATABASE DemoSession11;
USE DemoSession11;

CREATE TABLE persons (
    personId INT AUTO_INCREMENT PRIMARY KEY,
    lastName VARCHAR(255),
    firstName VARCHAR(255),
    email VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(255),
    phone CHAR(11)
);
INSERT INTO persons (lastName, firstName, email, address, city, phone) VALUES
('Nguyen', 'An', 'an.nguyen@gmail.com', '123 Le Loi', 'Ha Noi', '0912345678'),
('Tran', 'Binh', 'binh.tran@gmail.com', '45 Nguyen Trai', 'Ha Noi', '0987654321'),
('Le', 'Chi', 'chi.le@yahoo.com', '78 Hai Ba Trung', 'Da Nang', '0901122334'),
('Pham', 'Dung', 'dung.pham@outlook.com', '12 Vo Van Tan', 'Ho Chi Minh', '0933445566'),
('Hoang', 'Em', 'em.hoang@gmail.com', '9 Tran Hung Dao', 'Hue', '0977889900');

-- Tạo thủ tục
# Tạo thủ túc lấy tất cả thông tin của bảng Person
DELIMITER //
CREATE PROCEDURE getAllPersons()
BEGIN
    SELECT * FROM persons;
END // DELIMITER ;

# Tạo thủ tục thêm mới person
DELIMITER //
CREATE PROCEDURE insertPersons(id_in INT, last_name VARCHAR(255), first_name VARCHAR(255), email_in VARCHAR(100))
BEGIN
    INSERT INTO persons(personId, lastName, firstName, email) VALUES
    (id_in,last_name, first_name, email_in);
END // DELIMITER ;

# Gọi thủ tục
CALL getAllPersons();
CALL insertPersons(7, 'Minh', 'Nguyen', 'minhnn@gmail.com');

-- Tham số trong thủ tục
# Tạo 1 thủ tục xử lý chức năng:
DELIMITER //
CREATE PROCEDURE calTotalPersonByCity(IN city_IN VARCHAR(50),
                                    OUT totalPerson INT)
BEGIN
    SELECT COUNT(*) INTO totalPerson
    FROM persons
    WHERE city = city_IN;
END // DELIMITER ;

CALL calTotalPersonByCity('Ha noi', @total);
SELECT @total;

# Cú pháp tạo biễn trong thủ tục
DELIMITER //
CREATE PROCEDURE call_avg()
BEGIN
    -- Khai báo biến
    DECLARE avg_var DOUBLE;
    DECLARE ranked varchar(25);

    -- Thay đổi giá trị cho biến
    SET avg_var = 7.5;

    -- Câu lệnh điều kiện
    IF avg_var < 5 THEN
        SET ranked = 'Yếu';
    ELSEIF avg_var < 6.5 THEN
        SET ranked = 'Trung bình';
    ELSEIF avg_var < 8 THEN
        SET ranked = 'Khá';
    ELSE SET ranked = 'Giỏi';
    END IF;

    SELECT ranked;
END // DELIMITER ;

CALL call_avg();