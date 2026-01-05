DROP DATABASE IF EXISTS DatabaseEx02;
CREATE DATABASE DatabaseEx02;
USE DatabaseEx02;

# Phòng ban
CREATE TABLE Departments(
    department_id INT PRIMARY KEY ,
    department_name VARCHAR(255) ,
    location VARCHAR(255)
);
# Dự án
CREATE TABLE Projects(
    project_id INT PRIMARY KEY ,
    project_name VARCHAR(255) ,
    start_date DATE ,
    end_date DATE
);
# Nhân viên
CREATE TABLE Employees(
    employee_id INT PRIMARY KEY ,
    name VARCHAR(255) ,
    dob DATE ,
    department_id INT,
    salary DECIMAL(10, 2) ,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE
);
# Chấm công
CREATE TABLE Timesheets(
    timesheet_id INT PRIMARY KEY ,
    employee_id INT ,
    project_id INT ,
    work_date DATE,
    hours_worked DECIMAL(5, 2) ,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE
);
# Báo cáo công việc
CREATE TABLE WorkReports(
    report_id INT PRIMARY KEY ,
    employee_id INT ,
    report_date DATE ,
    report_content TEXT,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id) ON DELETE CASCADE
);

INSERT INTO Departments (department_id, department_name, location) VALUES
    (1, 'IT', 'Building A'),
    (2, 'HR', 'Building B'),
    (3, 'Finance', 'Building C');
INSERT INTO Employees (employee_id, name, dob, department_id, salary) VALUES
    (1, 'Alice Williams', '1985-06-15', 1, 5000.00),
    (2, 'Bob Johnson', '1990-03-22', 2, 4500.00),
    (3, 'Charlie Brown', '1992-08-10', 1, 5500.00),
    (4, 'David Smith', '1988-11-30', NULL, 4700.00);
INSERT INTO Projects (project_id, project_name, start_date, end_date) VALUES
    (1, 'Project A', '2025-01-01', '2025-12-31'),
    (2, 'Project B', '2025-02-01', '2025-11-30');
INSERT INTO WorkReports (report_id, employee_id, report_date, report_content) VALUES
    (1, 1, '2025-01-31', 'Completed initial setup for Project A.'),
    (2, 2, '2025-02-10', 'Completed HR review for Project A.'),
    (3, 3, '2025-01-20', 'Worked on debugging and testing for Project A.'),
    (4, 4, '2025-02-05', 'Worked on financial reports for Project B.'),
    (5, NULL, '2025-02-15', 'No report submitted.');
INSERT INTO Timesheets (timesheet_id, employee_id, project_id, work_date, hours_worked) VALUES
    (1, 1, 1, '2025-01-10', 8),
    (2, 1, 2, '2025-02-12', 7),
    (3, 2, 1, '2025-01-15', 6),
    (4, 3, 1, '2025-01-20', 8),
    (5, 4, 2, '2025-02-05', 5);

# Hiển thị thông tin của tất cả các nhân viên
SELECT * FROM Employees;
# Hiển thị thông tin của tất cả các dự án
SELECT * FROM Projects;
# Lấy tên nhân viên và tên phòng ban mà họ đang làm việc.
SELECT
    e.name,
    d.department_name
FROM Employees e
LEFT JOIN Departments d ON d.department_id = e.department_id;
# Lấy tên nhân viên và nội dung báo cáo công việc của họ.
SELECT
    e.name,
    report_content
FROM WorkReports wp
JOIN Employees e ON e.employee_id = wp.employee_id;
# Lấy tên nhân viên, tên dự án và số giờ làm việc cho mỗi dự án.
SELECT
    e.name,
    p.project_name,
    hours_worked
FROM Timesheets t
JOIN Employees e ON e.employee_id = t.employee_id
JOIN Projects p on t.project_id = p.project_id;
# Lấy tên nhân viên và số giờ làm việc của họ cho dự án "Project A".
SELECT
    e.name,
    hours_worked
FROM Timesheets t
JOIN Employees e ON t.employee_id = e.employee_id
WHERE t.project_id = (
    SELECT project_id FROM Projects
    WHERE project_name = 'Project A'
);

# Cập nhật lương
UPDATE Employees
SET salary = 6500.00
WHERE name LIKE '%Alice%';

# Xóa báo cáo
DELETE FROM WorkReports
WHERE employee_id IN (
    SELECT employee_id
    FROM Employees
    WHERE name LIKE '%Brown%'
);

# Thêm một nhân viên mới
INSERT INTO Employees (employee_id, name, dob, department_id, salary)
VALUES (5, 'James Lee', '1996-05-20', 1, 5000.00);