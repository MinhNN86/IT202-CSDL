/*
 * DATABASE SETUP - SESSION 15 EXAM
 * Database: StudentManagement
 */

DROP DATABASE IF EXISTS StudentManagement;
CREATE DATABASE StudentManagement;
USE StudentManagement;

-- =============================================
-- 1. TABLE STRUCTURE
-- =============================================

-- Table: Students
CREATE TABLE Students (
    StudentID CHAR(5) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    TotalDebt DECIMAL(10,2) DEFAULT 0
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID CHAR(5) PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL,
    Credits INT CHECK (Credits > 0)
);

-- Table: Grades
CREATE TABLE Grades (
    StudentID CHAR(5),
    SubjectID CHAR(5),
    Score DECIMAL(4,2) CHECK (Score BETWEEN 0 AND 10),
    PRIMARY KEY (StudentID, SubjectID),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Grades_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Table: GradeLog
CREATE TABLE GradeLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID CHAR(5),
    OldScore DECIMAL(4,2),
    NewScore DECIMAL(4,2),
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 2. SEED DATA
-- =============================================

-- Insert Students
INSERT INTO Students (StudentID, FullName, TotalDebt) VALUES
    ('SV01', 'Ho Khanh Linh', 5000000),
    ('SV03', 'Tran Thi Khanh Huyen', 0);

-- Insert Subjects
INSERT INTO Subjects (SubjectID, SubjectName, Credits) VALUES
    ('SB01', 'Co so du lieu', 3),
    ('SB02', 'Lap trinh Java', 4),
    ('SB03', 'Lap trinh C', 3);

-- Insert Grades
INSERT INTO Grades (StudentID, SubjectID, Score) VALUES
    ('SV01', 'SB01', 8.5), -- Passed
    ('SV03', 'SB02', 3.0); -- Failed


-- CÂU 1:
DELIMITER //
CREATE TRIGGER tg_CheckScore
BEFORE INSERT ON Grades
FOR EACH ROW
BEGIN
    IF NEW.Score < 0 THEN
        SET NEW.Score = 0;
    ELSEIF NEW.Score > 10 THEN
        SET NEW.Score = 10;
    END IF;
END // DELIMITER ;

-- CÂU 2:
START TRANSACTION;
INSERT INTO Students (StudentID, FullName)
VALUES ('SV02', 'Ha Bich Ngoc');
UPDATE Students
SET TotalDebt = 5000000
WHERE StudentID = 'SV02';
COMMIT;

-- CÂU 3:
DELIMITER //
CREATE TRIGGER tg_LogGradeUpdate
AFTER UPDATE ON Grades
FOR EACH ROW
BEGIN
    IF OLD.Score <> NEW.Score THEN
        INSERT INTO GradeLog (StudentID, OldScore, NewScore, ChangeDate)
        VALUES (OLD.StudentID, OLD.Score, NEW.Score, NOW());
    END IF;
END // DELIMITER ;

-- CÂU 4:
DELIMITER //
CREATE PROCEDURE sp_PayTuition()
BEGIN
    START TRANSACTION;
    UPDATE Students
    SET TotalDebt = TotalDebt - 2000000
    WHERE StudentID = 'SV01';
    IF (SELECT TotalDebt FROM Students WHERE StudentID = 'SV01') < 0 THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END // DELIMITER ;

-- CÂU 5:
DELIMITER //
CREATE TRIGGER tg_PreventPassUpdate
BEFORE UPDATE ON Grades
FOR EACH ROW
BEGIN
    IF OLD.Score >= 4.0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sinh viên đã qua môn, không được phép sửa điểm';
    END IF;
END // DELIMITER ;

-- CÂU 6:
DELIMITER //
CREATE PROCEDURE sp_DeleteStudentGrade(
    p_StudentID INT,
    p_SubjectID INT
)
BEGIN
    DECLARE v_OldScore DECIMAL(4,2);

    START TRANSACTION ;
    -- Lấy điểm cũ
    SELECT Score INTO v_OldScore
    FROM Grades
    WHERE StudentID = p_StudentID
    AND SubjectID = p_SubjectID;

    -- Ghi log trước khi xóa
    INSERT INTO GradeLog (StudentID, OldScore, NewScore, ChangeDate)
    VALUES (p_StudentID, v_OldScore, NULL, NOW());

    -- Xóa điểm
    DELETE FROM Grades
    WHERE StudentID = p_StudentID
    AND SubjectID = p_SubjectID;

    -- Kiểm tra kết quả
    IF ROW_COUNT() = 0 THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;

END // DELIMITER ;