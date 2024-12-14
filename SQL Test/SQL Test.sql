-- Task 1

-- Create Patients table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(255)
);

-- Create Doctors table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(255)
);

-- Create Treatments table
CREATE TABLE Treatments (
    treatment_id INT PRIMARY KEY,
    treatment_name VARCHAR(255),
    treatment_cost DECIMAL(10, 2)
);
-- Create Appointments table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    treatment_id INT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (treatment_id) REFERENCES Treatments(treatment_id)
);

-- Insert data into Patients table
INSERT INTO Patients (patient_id, patient_name) VALUES
(1, 'Alice Brown'),
(2, 'Bob Smith'),
(3, 'Carol White');

-- Insert data into Doctors table
INSERT INTO Doctors (doctor_id, doctor_name) VALUES
(1, 'Dr. Emily Clark'),
(2, 'Dr. John Doe'),
(3, 'Dr. Sarah Lee');

-- Insert data into Treatments table
INSERT INTO Treatments (treatment_id, treatment_name, treatment_cost) VALUES
(201, 'MRI Scan', 700.00),
(202, 'Blood Test', 300.00),
(203, 'X-Ray', 600.00),
(204, 'Physical Therapy', 450.00);

-- Insert data into Appointments table
INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, treatment_id) VALUES
(101, 1, 1, '2024-01-15', 201),
(102, 2, 2, '2024-05-22', 202),
(103, 1, 3, '2024-07-10', 203),
(104, 3, 1, '2024-08-25', 204);

SELECT 
	patient_name,
	doctor_name,
	appointment_date,
	treatment_name,
	treatment_cost
FROM
	Patients p
INNER JOIN Appointments a
ON p.patient_id = a.patient_id
INNER JOIN Doctors d
ON d.doctor_id = a.doctor_id
INNER JOIN Treatments t
ON t.treatment_id = a.treatment_id
WHERE YEAR(appointment_date) = 2024
AND treatment_cost > 500
ORDER BY patient_name ASC, treatment_cost DESC;


-- Task 2

-- Create the Posts table
CREATE TABLE Posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    post_date DATE
);

-- Create the Likes table
CREATE TABLE Likes (
    like_id INT PRIMARY KEY,
    post_id INT
);


-- Insert data into the Posts table
INSERT INTO Posts (post_id, user_id, post_date) VALUES
(101, 1, '2024-01-10'),
(102, 2, '2024-03-15'),
(103, 1, '2024-05-20'),
(104, 3, '2024-07-25'),
(105, 1, '2024-08-05');

-- Insert data into the Likes table
INSERT INTO Likes (like_id, post_id) VALUES
(201, 101),
(202, 101),
(203, 103),
(204, 105),
(205, 105),
(206, 105);

WITH CTE (post, likes, post_date) AS (
	SELECT
			p.post_id post,
			count(*) likes,
			p.post_date post_date
	FROM
		Posts p
	INNER JOIN Likes l
	ON l.post_id = p.post_id
	GROUP BY
		p.post_id,
		p.post_date
)

SELECT TOP 1
	post,
	likes,
	post_date
FROM
	CTE
ORDER BY
	post desc;


-- Task 3

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    sale_amount DECIMAL(10, 2),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);


INSERT INTO Categories (category_id, category_name)
VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Clothing');


INSERT INTO Products (product_id, product_name, category_id)
VALUES
(101, 'Product A', 1),
(102, 'Product B', 2),
(103, 'Product C', 1),
(104, 'Product D', 3);


INSERT INTO Sales (sale_id, product_id, sale_amount)
VALUES
(1, 101, 150.00),
(2, 101, 100.00),
(3, 102, 200.00),
(4, 103, 120.00),
(5, 104, 170.00);


CREATE PROCEDURE GenerateSalesReportByCategory AS 
BEGIN
SELECT
	category_name as Category_Name,
	sum(sale_amount) Total_Sales_by_Product_Category
FROM    
	Categories c
	INNER JOIN Products p ON c.category_id = p.category_id
	INNER JOIN Sales s ON p.product_id = s.product_id
GROUP BY 
	category_name
ORDER BY
	Total_Sales_by_Product_Category DESC
END;

EXECUTE GenerateSalesReportByCategory;




CREATE VIEW SalesReportView AS (
SELECT
	category_name as Category_Name,
	sum(sale_amount) Total_Sales_by_Product_Category
FROM    
	Categories c
	INNER JOIN Products p ON c.category_id = p.category_id
	INNER JOIN Sales s ON p.product_id = s.product_id
GROUP BY 
	category_name);

SELECT * 
FROM SalesReportView
ORDER BY
	Total_Sales_by_Product_Category DESC;



CREATE INDEX index_prod_category_id
ON Products(category_id);

select category_id
from Products;