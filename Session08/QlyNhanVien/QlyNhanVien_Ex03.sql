DROP DATABASE IF EXISTS DatabaseEx03;
CREATE DATABASE DatabaseEx03;
USE DatabaseEx03;

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

# Lấy tên nhân viên và phòng ban của họ, sắp xếp theo tên nhân viên
SELECT
    e.name,
    d.department_name
FROM Employees e
JOIN Departments d on e.department_id = d.department_id
ORDER BY e.name;

# Lấy tên nhân viên và lương của các nhân viên có lương trên 5000, sắp xếp theo lương giảm dần.
SELECT
    name,
    salary
FROM Employees
WHERE salary > 5000
ORDER BY salary;

# Lấy tên nhân viên và tổng số giờ làm việc của mỗi nhân viên.
SELECT
    e.name,
    SUM(hours_worked) AS SoGioLamViec
FROM Timesheets time
JOIN Employees e ON e.employee_id = time.employee_id
GROUP BY time.employee_id, e.name;

# Lấy tên phòng ban và lương trung bình của các nhân viên trong phòng ban đó.
SELECT
    d.department_name,
    AVG(e.salary) AS LuongTrungBinh
FROM Departments d
JOIN Employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

# Lấy tên dự án và tổng số giờ làm việc cho mỗi dự án, chỉ tính những báo cáo công việc trong tháng 2 năm 2025.
SELECT
    p.project_name,
    SUM(hours_worked) AS TongGioLamViec
FROM Timesheets
JOIN Projects p ON Timesheets.project_id = p.project_id
WHERE Timesheets.work_date LIKE '2025-02-%'
GROUP BY Timesheets.project_id, p.project_name;

# Lấy tên nhân viên, tên dự án và tổng số giờ làm việc cho mỗi nhân viên trong từng dự án.
SELECT
    e.name,
    p.project_name,
    SUM(t.hours_worked) AS TongGioLamViec
FROM Timesheets t
JOIN Employees e ON t.employee_id = e.employee_id
JOIN Projects p ON t.project_id = p.project_id
GROUP BY e.employee_id, p.project_id;

# Lấy tên phòng ban và số lượng nhân viên trong mỗi phòng ban, chỉ lấy các phòng ban có hơn 1 nhân viên.
SELECT
    d.department_name,
    COUNT(*) AS SoLuongNhanVien
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(*) > 1;

# Lấy thông tin ngày báo cáo, tên nhân viên và nội dung báo cáo của 2 báo cáo, bắt đầu từ bản ghi thứ 2, sắp xếp theo ngày báo cáo giảm dần.
SELECT
    wr.report_date,
    e.name,
    wr.report_content
FROM WorkReports wr
JOIN Employees e ON wr.employee_id = e.employee_id
ORDER BY wr.report_date DESC
LIMIT 2 OFFSET 1;

# Lấy ngày báo cáo, tên nhân viên và số lượng báo cáo được gửi vào mỗi ngày, chỉ lấy báo cáo không có giá trị NULL trong nội dung và báo cáo được gửi trong khoảng thời gian từ '2025-01-01' đến '2025-02-01'.
SELECT
    wr.report_date,
    e.name,
    COUNT(*) AS SoLuongBaoCao
FROM WorkReports wr
JOIN Employees e ON wr.employee_id = e.employee_id
WHERE wr.report_content IS NOT NULL
  AND wr.report_date BETWEEN '2025-01-01' AND '2025-02-01'
GROUP BY wr.report_date, e.name;

# Lấy thông tin về nhân viên, dự án, giờ làm việc, và số tiền lương của nhân viên (lương = giờ làm việc * mức lương), chỉ lấy nhân viên có tổng số giờ làm việc lớn hơn 5, sắp xếp theo tổng lương. Tiền lương được làm tròn.
SELECT
    e.name,
    p.project_name,
    SUM(t.hours_worked) AS TongGioLamViec,
    ROUND(SUM(t.hours_worked * e.salary)) AS TongLuong
FROM Timesheets t
JOIN Employees e ON t.employee_id = e.employee_id
JOIN Projects p ON t.project_id = p.project_id
GROUP BY e.employee_id, p.project_id
HAVING SUM(t.hours_worked) > 5
ORDER BY TongLuong;