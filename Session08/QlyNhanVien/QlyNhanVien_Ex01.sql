DROP DATABASE IF EXISTS DatabaseEx01;
CREATE DATABASE DatabaseEx01;
USE DatabaseEx01;

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
(1, 'Phòng Nhân sự', 'Tầng 2'),
(2, 'Phòng Công nghệ thông tin', 'Tầng 3'),
(3, 'Phòng Kinh doanh', 'Tầng 4');
INSERT INTO Projects (project_id, project_name, start_date, end_date) VALUES
(1, 'Website công ty', '2024-01-01', '2024-06-30'),
(2, 'App mobile', '2024-03-01', '2024-09-30'),
(3, 'Hệ thống quản lý', '2024-02-01', '2024-08-31');
INSERT INTO Employees (employee_id, name, dob, department_id, salary) VALUES
(1, 'Nguyễn Văn An', '1990-05-15', 2, 15000000.00),
(2, 'Trần Thị Bình', '1992-08-20', 2, 14000000.00),
(3, 'Lê Văn Cường', '1988-03-10', 1, 12000000.00),
(4, 'Phạm Thị Dung', '1995-12-05', 3, 13000000.00),
(5, 'Hoàng Văn Em', '1991-07-25', 2, 16000000.00);
INSERT INTO Timesheets (timesheet_id, employee_id, project_id, work_date, hours_worked) VALUES
(1, 1, 1, '2024-04-01', 8.0),
(2, 1, 2, '2024-04-02', 7.5),
(3, 2, 1, '2024-04-01', 8.0),
(4, 3, 3, '2024-04-03', 6.0),
(5, 5, 2, '2024-04-02', 8.5);
INSERT INTO WorkReports (report_id, employee_id, report_date, report_content) VALUES
(1, 1, '2024-04-01', 'Đã hoàn thành thiết kế trang chủ'),
(2, 2, '2024-04-01', 'Sửa lỗi login page'),
(3, 3, '2024-04-03', 'Tuyển dụng 2 nhân viên mới'),
(4, 5, '2024-04-02', 'Phát triển tính năng push notification');

# Hãy cập nhật thông tin của một dự án bất kì
UPDATE Projects
SET project_name = 'Edit Project', start_date = '2026-01-01', end_date = '2026-01-04'
WHERE project_id = 1;
# Hãy cập nhật thông tin của một dự án bất kì
DELETE FROM Employees
WHERE employee_id = 1;