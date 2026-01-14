DROP DATABASE IF EXISTS DatabaseEx05;
CREATE DATABASE DatabaseEx05;
USE DatabaseEx05;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATE,
    follower_count INT DEFAULT 0,
    post_count INT DEFAULT 0
);

DELIMITER //
CREATE TRIGGER trg_before_insert_users
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email không hợp lệ';
    END IF;

    IF NEW.username NOT REGEXP '^[A-Za-z0-9_]+$' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username chỉ được chứa chữ cái, số và dấu gạch dưới (_)';
    END IF;
END // DELIMITER ;

DELIMITER //
CREATE PROCEDURE add_user(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_created_at DATE
)
BEGIN
    INSERT INTO users (username, email, created_at)
    VALUES (p_username, p_email, p_created_at);
END // DELIMITER ;

CALL add_user('john_doe', 'john.doe@gmail.com', '2025-01-01');
CALL add_user('alice_123', 'alice123@yahoo.com', '2025-01-02');

CALL add_user('bademail', 'bademailgmail.com', '2025-01-03');
CALL add_user('bad@name', 'badname@gmail.com', '2025-01-04');
CALL add_user('bad name', 'badname2@gmail.com', '2025-01-05');

SELECT * FROM users;