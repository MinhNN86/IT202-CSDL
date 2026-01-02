DROP DATABASE IF EXISTS DemoSession07;
CREATE DATABASE DemoSession07;
USE DemoSession07;

CREATE TABLE Countries (
    Country_ID VARCHAR(5) PRIMARY KEY,
    Country_Name VARCHAR(50)
);
CREATE TABLE Locations (
    Location_ID INT PRIMARY KEY,
    Address VARCHAR(100),
    Country_ID VARCHAR(5),
    FOREIGN KEY (Country_ID) REFERENCES Countries(Country_ID)
);
CREATE TABLE Departments (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(50),
    Location_ID INT,
    FOREIGN KEY (Location_ID) REFERENCES Locations(Location_ID)
);

INSERT INTO Countries VALUES
    ('US', 'United States'),
    ('VN', 'Vietnam'),
    ('JP', 'Japan');
INSERT INTO Locations VALUES
    (1001, 'New York Office', 'US'),
    (1002, 'California Office', 'US'),
    (1003, 'Hanoi Office', 'VN'),
    (1004, 'Tokyo Office', 'JP');
INSERT INTO Departments VALUES
    (1, 'HR', 1001),
    (2, 'IT', 1002),
    (3, 'Finance', 1003),
    (4, 'Marketing', 1004);

-- TRUY VẤN LỒNG NHIỀU CẤP
SELECT Department_Name
FROM Departments
WHERE Location_ID IN (
    SELECT Location_ID
    FROM Locations
    WHERE Country_ID = (
        SELECT Country_ID
        FROM Countries
        WHERE Country_Name = 'United States'
    )
);

SELECT d.Department_Name, l.Address, c.Country_Name
FROM Departments d
JOIN Locations l ON d.Location_ID = l.Location_ID
JOIN Countries c ON l.Country_ID = c.Country_ID
WHERE c.Country_Name = 'United States';
