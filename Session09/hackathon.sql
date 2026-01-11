DROP DATABASE IF EXISTS Database_Hackathon;
CREATE DATABASE Database_Hackathon;
USE Database_Hackathon;

-- PHẦN 1: Tạo CSDL và các bảng:
# 1
CREATE TABLE Customers( # Khách hàng
    customer_id VARCHAR(10) PRIMARY KEY ,
    full_name VARCHAR(100) NOT NULL ,
    phone VARCHAR(15) NOT NULL UNIQUE ,
    address VARCHAR(200) NOT NULL
);
# Nhân viên bảo hiểm
CREATE TABLE InsuranceAgents(
    agent_id VARCHAR(10) PRIMARY KEY ,
    full_name VARCHAR(100) NOT NULL ,
    region VARCHAR(50) NOT NULL ,
    years_of_experience INT CHECK ( years_of_experience >= 0 ),
    commission_rate DECIMAL(5, 2) CHECK ( commission_rate >= 0 )
);
# Hợp đồng bảo hiểm
CREATE TABLE Policies(
    policy_id INT AUTO_INCREMENT PRIMARY KEY ,
    customer_id VARCHAR(10) ,
    agent_id VARCHAR(10) ,
    start_date TIMESTAMP NOT NULL ,
    end_date TIMESTAMP NOT NULL ,
    status ENUM('Active', 'Expired', 'Cancelled') DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE ,
    FOREIGN KEY (agent_id) REFERENCES InsuranceAgents(agent_id) ON DELETE CASCADE
);
# Chi trả bồi thường
CREATE TABLE ClaimPayments(
    payment_id INT AUTO_INCREMENT PRIMARY KEY ,
    policy_id INT ,
    payment_method VARCHAR(50) NOT NULL ,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(15, 2) CHECK ( amount >= 0 ),
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id) ON DELETE CASCADE
);

# 2
INSERT INTO Customers (customer_id, full_name, phone, address) VALUES
('C001', 'Nguyen Van An', '0912345678', 'Hanoi, Vietnam'),
('C002', 'Tran Thi Binh', '0923456789', 'Ho Chi Minh, Vietnam'),
('C003', 'Le Minh Chau', '0934567890', 'Da Nang, Vietnam'),
('C004', 'Pham Hoang Duc', '0945678901', 'Can Tho, Vietnam'),
('C005', 'Vu Thi Hoa', '0956789012', 'Hai Phong, Vietnam');
INSERT INTO InsuranceAgents (agent_id, full_name, region, years_of_experience, commission_rate) VALUES
('A001', 'Nguyen Van Minh', 'Mien Bac', 10, 5.50),
('A002', 'Tran Thi Lan', 'Mien Nam', 15, 7.00),
('A003', 'Le Hoang Nam', 'Mien Trung', 8, 4.50),
('A004', 'Pham Quang Huy', 'Mien Tay', 20, 8.00),
('A005', 'Vu Thi Mai', 'Mien Bac', 5, 3.50);
INSERT INTO Policies (policy_id, customer_id, agent_id, start_date, end_date) VALUES
(1, 'C001', 'A001', '2024-01-01 08:00:00', '2025-01-01 08:00:00'),
(2, 'C002', 'A002', '2024-02-01 09:30:00', '2025-02-01 09:30:00'),
(3, 'C003', 'A003', '2023-03-02 10:00:00', '2024-03-02 10:00:00'),
(4, 'C004', 'A004', '2024-05-02 14:00:00', '2025-05-02 14:00:00'),
(5, 'C005', 'A005', '2024-06-03 15:30:00', '2025-06-03 15:30:00');
INSERT INTO ClaimPayments (payment_id, policy_id, payment_method, payment_date, amount) VALUES
(1, 1, 'Bank Transfer', '2024-05-01 08:45:00', 5000000.00),
(2, 2, 'Bank Transfer', '2024-06-01 10:00:00', 7500000.00),
(3, 4, 'Cash', '2024-08-02 15:00:00', 2000000.00),
(4, 1, 'Bank Transfer', '2024-09-04 11:00:00', 3000000.00),
(5, 3, 'Credit Card', '2023-10-05 14:00:00', 1500000.00);

# 3
UPDATE Customers
SET address = 'District 1, Ho Chi Minh City'
WHERE customer_id = 'C002';

# 4
UPDATE InsuranceAgents
SET years_of_experience = years_of_experience + 2, commission_rate = commission_rate + 1.5
WHERE agent_id = 'A001';

# 5
DELETE FROM Policies
WHERE status = 'Cancelled' AND start_date < '2024-06-15';

-- PHẦN 2: Truy vấn dữ liệu cơ bản
# 6
SELECT
    agent_id,
    full_name,
    region
FROM InsuranceAgents
WHERE years_of_experience > 8;

# 7
SELECT customer_id, full_name, phone
FROM Customers
WHERE full_name LIKE 'Nguyen%';

# 8
SELECT policy_id, start_date, status
FROM Policies
ORDER BY start_date DESC;

# 9
SELECT *
FROM ClaimPayments
WHERE payment_method = 'Bank Transfer'
LIMIT 3;

# 10
SELECT agent_id, full_name
FROM InsuranceAgents
LIMIT 3 OFFSET 2;

-- Phần 3: Truy vấn dữ liệu nâng cao
# 11
SELECT
    p.policy_id,
    c.full_name AS customer_name,
    ia.full_name AS agent_name
FROM Policies p
JOIN Customers c ON p.customer_id = c.customer_id
JOIN InsuranceAgents ia ON p.agent_id = ia.agent_id
WHERE p.status = 'Active';

# 12
SELECT
    p.agent_id,
    ia.full_name,
    p.policy_id
FROM InsuranceAgents ia
LEFT JOIN Policies p ON ia.agent_id = p.agent_id;

# 13
SELECT
    payment_method,
    SUM(amount) AS Total_Payout
FROM ClaimPayments
GROUP BY payment_method;

# 14
SELECT
    ia.agent_id,
    ia.full_name,
    COUNT(p.policy_id) AS Total_Policies
FROM InsuranceAgents ia
JOIN Policies p ON ia.agent_id = p.agent_id
GROUP BY ia.agent_id, ia.full_name
HAVING Total_Policies >= 1;

# 15
SELECT
    agent_id,
    full_name,
    commission_rate
FROM InsuranceAgents
WHERE commission_rate > (
    # Tính mức hoa hồng trung bình
    SELECT AVG(commission_rate)
    FROM InsuranceAgents
);

# 16
SELECT
    c.customer_id,
    c.full_name
FROM Customers c
JOIN Policies p ON c.customer_id = p.customer_id
JOIN ClaimPayments cp ON p.policy_id = cp.policy_id
WHERE cp.amount > 5000000;

# 17
SELECT
    cp.policy_id,
    c.full_name AS customer_name,
    ia.full_name AS agent_name,
    cp.payment_method,
    cp.amount
FROM ClaimPayments cp
JOIN Policies p ON cp.policy_id = p.policy_id
JOIN Customers c ON p.customer_id = c.customer_id
JOIN InsuranceAgents ia ON p.agent_id = ia.agent_id;







