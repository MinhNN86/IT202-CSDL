DROP DATABASE IF EXISTS DemoSession07;
CREATE DATABASE DemoSession07;
USE DemoSession07;

-- TỔNG QUAN VỀ TRUY VẤN LỒNG (SUBQUERY)
CREATE TABLE Departments(
    department_id INT PRIMARY KEY ,
    department_name VARCHAR(50)
);

CREATE TABLE Employees(
    employees_id INT PRIMARY KEY ,
    employees_name VARCHAR(255) ,
    salary INT ,
    department_id INT ,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

INSERT INTO Departments VALUES
    (1, 'IT'),
    (2, 'HR'),
    (3, 'Finance');

INSERT INTO Employees VALUES
    (1, 'An', 12000000, 1),
    (2, 'Bình', 8000000, 1),
    (3, 'Chi', 15000000, 1),

    (4, 'Dũng', 7000000, 2),
    (5, 'Hà', 9000000, 2),

    (6, 'Khanh', 20000000, 3),
    (7, 'Lan', 14000000, 3);

# Subquery trong mệnh đề WHERE
SELECT *
FROM Employees
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
);
SELECT *
FROM Employees
WHERE department_id = (
    SELECT department_id
    FROM Departments
    WHERE department_name = 'IT'
);

# Subquery với toán tử IN
# Nhân viên thuộc các phòng ban có lương trung bình > 10 triệu
SELECT *
FROM Employees
WHERE department_id IN (
    SELECT department_id
    FROM Employees
    GROUP BY department_id
    HAVING AVG(salary) > 10000000
);

# Subquery trong mệnh đề FROM (Bảng tạm)
# Phòng ban có tổng lương cao nhất
SELECT *
FROM (
         SELECT department_id, SUM(salary) AS total_salary
         FROM Employees
         GROUP BY department_id
     ) AS temp
WHERE total_salary = (
    SELECT MAX(total_salary)
    FROM (
             SELECT SUM(salary) AS total_salary
             FROM Employees
             GROUP BY department_id
         ) AS temp2
);

# CORRELATED SUBQUERY (NÂNG CAO)
# Nhân viên có lương cao hơn trung bình phòng ban của chính họ
SELECT *
FROM Employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
    WHERE department_id = e.department_id
);

# SUBQUERY NHIỀU CẤP (NESTED SUBQUERY)
# Phòng ban có lương trung bình cao nhất
SELECT department_id, AVG(salary) AS avg_salary
FROM Employees
GROUP BY department_id
HAVING AVG(salary) = (
    # LỚP 2 (CÔNG THỨC CON): Tìm giá trị lương trung bình LỚN NHẤT
    SELECT MAX(avg_salary)
    FROM (
        # LỚP 3 (LỒNG NHẤT): Tính lương trung bình của TỪNG phòng ban
        # Kết quả tạm:
        # + IT: (12000000 + 8000000 + 15000000) / 3 = 11666667
        # + HR: (7000000 + 9000000) / 2 = 8000000
        # + Finance: (20000000 + 14000000) / 2 = 17000000
        SELECT AVG(salary) AS avg_salary
        FROM Employees
        GROUP BY department_id
        # => Bảng tạm 'temp' có 3 dòng: IT(11.67M), HR(8M), Finance(17M)
    ) AS temp
    # => Lớp 2 sẽ lấy MAX từ 3 giá trị trên => 17000000 (Finance)
);

# LỚP 1 (CÔNG THỨC CHÍNH):
# 1. GROUP BY department_id => gom nhóm theo phòng ban
# 2. Tính AVG(salary) cho từng phòng (IT: 11.67M, HR: 8M, Finance: 17M)
# 3. HAVING so sánh từng avg_salary với kết quả từ subquery (17M)
# 4. Chỉ giữ lại dòng có avg_salary = 17M => department_id = 3 (Finance)
# => KẾT QUẢ: Finance - 17,000,000

