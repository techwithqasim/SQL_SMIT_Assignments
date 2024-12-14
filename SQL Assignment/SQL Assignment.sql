--Question No 01
--Employees Earning More Than Their Managers


CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary INT,
    managerId INT
);

INSERT INTO Employee (id, name, salary, managerId) VALUES
(1, 'Obed', 5000, NULL),   -- Obed is a manager
(2, 'Jawad', 6000, 1),     -- Jawad earns more than Obed
(3, 'Fahad', 4000, 1),     -- Fahad earns less than Obed
(4, 'Zohed', 4500, 2),     -- Zohed earns less than Jawad
(5, 'Qasim', 7000, 2);     -- Qasim earns more than Jawad

SELECT * FROM EMPLOYEE;

SELECT e1.name AS employee_earning_more_than_manager
FROM Employee e1
JOIN Employee e2 ON e2.id = e1.managerId
WHERE e1.salary > e2.salary;


--Question No 02
---Duplicate Emails


DELETE FROM Person;


INSERT INTO Person (id, email) VALUES
(1, 'obed@example.com'),
(2, 'jawad@example.com'),
(3, 'obed@example.com'),  -- Duplicate email
(4, 'fahad@example.com'),
(5, 'jawad@example.com');  -- Duplicate email


WITH CTE AS (
    SELECT
        id,
        email,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS row_num
    FROM Person
)
DELETE FROM Person
WHERE id NOT IN (
    SELECT id
    FROM CTE
    WHERE row_num = 1
);

SELECT * FROM Person;


--Question No 04
--Replace Employee ID With The Unique Identifier

DELETE FROM Employees;

CREATE TABLE Employees (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

DELETE FROM EmployeeUNI;
CREATE TABLE EmployeeUNI (
    id INT,
    uniqueid INT,
    PRIMARY KEY (id, uniqueid)
);


INSERT INTO Employees (id, name) VALUES
(1, 'Obed'),
(2, 'Jawad'),
(3, 'Fahad');

INSERT INTO EmployeeUNI (id, uniqueid) VALUES
(1, 1001),
(2, 1002);

SELECT e.id, e.name, u.uniqueid
FROM Employees e
LEFT JOIN EmployeeUNI u ON e.id = u.id;


--Question No 05
--Minimum Salary in Each Department

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Employees';

ALTER TABLE Employees
ADD EmployeeID INT;

WITH MinSalaries AS (
    SELECT DepartmentID, MIN(Salary) AS MinSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT e.EmployeeID, e.Name AS Name, e.DepartmentID AS DepartmentID, e.Salary AS Salary
FROM Employees e
JOIN MinSalaries ms
ON e.DepartmentID = ms.DepartmentID AND e.Salary = ms.MinSalary;


---Question No 06
---Customer with the Highest Total Order

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderItems (
    OrderID INT,
    ItemID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ItemID)
);


INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1, 100, '2024-07-01'),
(2, 101, '2024-07-02'),
(3, 100, '2024-07-03');

INSERT INTO OrderItems (OrderID, ItemID, Quantity) VALUES
(1, 1, 5),
(1, 2, 3),
(2, 1, 10),
(3, 1, 7);


SELECT * FROM Orders;


SELECT * FROM OrderItems;

SELECT TOP 1
    o.CustomerID,
    SUM(oi.Quantity) AS TotalQuantity
FROM
    Orders o
JOIN
    OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY
    o.CustomerID
ORDER BY
    TotalQuantity DESC;



---Question No 07
---Customers who placed their first order within the last 30 days


DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;


CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(255),
    JoinDate DATE
);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


INSERT INTO Customers (CustomerID, Name, JoinDate) VALUES
(1, 'Alice', '2024-06-01'),
(2, 'Bob', '2024-07-15'),
(3, 'Charlie', '2024-05-20'),
(4, 'David', '2024-07-20');  


INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1, 1, '2024-07-25'),
(2, 2, '2024-07-16'),
(3, 3, '2024-06-10'),
(4, 4, '2024-07-22');  


SELECT * FROM Customers;


SELECT * FROM Orders;


SELECT c.CustomerID, c.Name, c.JoinDate, MIN(o.OrderDate) AS FirstOrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name, c.JoinDate
HAVING MIN(o.OrderDate) >= DATEADD(DAY, -30, GETDATE());



---Question No 08
---Second Highest Salary


DROP TABLE IF EXISTS Employee;


CREATE TABLE Employee (
    id INT PRIMARY KEY,
    salary INT
);


INSERT INTO Employee (id, salary) VALUES
(1, 60000),
(2, 70000),
(3, 80000),
(4, 90000);


SELECT MAX(salary) AS SecondHighestSalary
FROM Employee
WHERE salary < (SELECT MAX(salary) FROM Employee);


----Question No 09
----Department Highest Salary


DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;


CREATE TABLE Department (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);


CREATE TABLE Employee (
    id INT PRIMARY KEY,
    salary INT,
    name VARCHAR(255),
    departmentId INT,
    FOREIGN KEY (departmentId) REFERENCES Department(id)
);


INSERT INTO Department (id, name) VALUES
(1, 'HR'),
(2, 'Engineering'),
(3, 'Marketing');


INSERT INTO Employee (id, salary, name, departmentId) VALUES
(1, 60000, 'Alice', 1),
(2, 70000, 'Bob', 2),
(3, 80000, 'Charlie', 2),
(4, 90000, 'David', 3),
(5, 75000, 'Eve', 1);


SELECT 
    d.name AS DepartmentName, 
    e.name AS EmployeeName, 
    e.salary AS Salary
FROM 
    Employee e
JOIN 
    Department d ON e.departmentId = d.id
WHERE 
    e.salary = (
        SELECT MAX(salary) 
        FROM Employee 
        WHERE departmentId = e.departmentId
    );


---Question No 10
---Customers Who Bought All Products


DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Product;

CREATE TABLE Product (
    Product_key INT PRIMARY KEY
);

CREATE TABLE Customer (
    Customer_id INT,
    Product_key INT,
    FOREIGN KEY (Product_key) REFERENCES Product(Product_key)
);

INSERT INTO Product (Product_key) VALUES
(1),
(2),
(3);


INSERT INTO Customer (Customer_id, Product_key) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 2),
(3, 1),
(3, 2),
(3, 3);


WITH ProductCount AS (
    SELECT COUNT(DISTINCT Product_key) AS TotalProducts
    FROM Product
),

CustomerProductCount AS (
    SELECT 
        Customer_id, 
        COUNT(DISTINCT Product_key) AS ProductsBought
    FROM Customer
    GROUP BY Customer_id
)

SELECT 
    cpc.Customer_id
FROM 
    CustomerProductCount cpc
JOIN 
    ProductCount pc ON cpc.ProductsBought = pc.TotalProducts;