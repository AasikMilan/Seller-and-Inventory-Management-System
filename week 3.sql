DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE customers (
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(255),
    Registration_Date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE categories (
    Category_ID INT PRIMARY KEY AUTO_INCREMENT,
    Category_Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT
);

CREATE TABLE products (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(200) NOT NULL,
    Category_ID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    Stock_Quantity INT NOT NULL CHECK (Stock_Quantity >= 0),
    FOREIGN KEY (Category_ID) REFERENCES categories(Category_ID)
);

CREATE TABLE sellers (
    Seller_ID INT PRIMARY KEY AUTO_INCREMENT,
    Seller_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL,
    Address VARCHAR(255)
);

CREATE TABLE inventory (
    Inventory_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_ID INT NOT NULL,
    Seller_ID INT NOT NULL,
    Stock_Quantity INT NOT NULL CHECK (Stock_Quantity >= 0),
    Stock_Status VARCHAR(20) DEFAULT 'Available' CHECK (Stock_Status IN ('Available', 'Out of Stock', 'Low Stock')),
    Last_Updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (Product_ID) REFERENCES products(Product_ID),
    FOREIGN KEY (Seller_ID) REFERENCES sellers(Seller_ID),
    UNIQUE KEY unique_product_seller (Product_ID, Seller_ID)
);

INSERT INTO categories (Category_Name, Description) VALUES
('Electronics', 'Electronic devices, gadgets, and accessories'),
('Clothing', 'Apparel, fashion items, and accessories'),
('Books', 'Printed and digital books'),
('Home Appliances', 'Home and kitchen appliances'),
('Footwear', 'Shoes, sandals, and sports footwear'),
('Furniture', 'Home and office furniture'),
('Beauty', 'Cosmetics, skincare, and beauty products'),
('Sports', 'Sports equipment and accessories');

INSERT INTO products (Product_Name, Category_ID, Price, Stock_Quantity) VALUES
('Laptop', 1, 55000.00, 20),
('Smartphone', 1, 35000.00, 50),
('Headphones', 1, 2500.00, 100),
('T-Shirt', 2, 800.00, 150),
('Jeans', 2, 1500.00, 80),
('Jacket', 2, 3000.00, 40),
('Novel', 3, 500.00, 200),
('Textbook', 3, 1200.00, 60),
('Biography', 3, 750.00, 90),
('Refrigerator', 4, 45000.00, 15),
('Washing Machine', 4, 32000.00, 20),
('Microwave Oven', 4, 15000.00, 30),
('Sneakers', 5, 4500.00, 70),
('Sandals', 5, 1200.00, 100),
('Formal Shoes', 5, 3500.00, 45),
('Sofa Set', 6, 55000.00, 10),
('Dining Table', 6, 25000.00, 15),
('Study Chair', 6, 8500.00, 25),
('Lipstick', 7, 500.00, 200),
('Face Cream', 7, 800.00, 150),
('Shampoo', 7, 450.00, 180),
('Cricket Bat', 8, 3000.00, 40),
('Football', 8, 1500.00, 60),
('Tennis Racket', 8, 4500.00, 35);

INSERT INTO sellers (Seller_Name, Email, Phone, Address) VALUES
('ABC Electronics', 'abc@electronics.com', '9876543210', '101, Electronics City, Bangalore'),
('TechWorld India', 'techworld@email.com', '8765432109', '45, Tech Park, Hyderabad'),
('Fashion Hub', 'fashion@hub.com', '7654321098', '789, Fashion Street, Mumbai'),
('BookNook Store', 'booknook@email.com', '6543210987', '234, Library Road, Delhi'),
('HomePlus Appliances', 'homeplus@email.com', '5432109876', '567, Home Town, Chennai'),
('ShoeMasters', 'shoemasters@email.com', '4321098765', '890, Footwear Lane, Pune'),
('Furniture World', 'furniture@world.com', '3210987654', '123, Furniture Market, Jaipur'),
('BeautyCare', 'beauty@care.com', '2109876543', '456, Beauty Street, Kolkata'),
('SportZone', 'sportzone@email.com', '1098765432', '789, Sports Complex, Ahmedabad'),
('MobileMasters', 'mobile@masters.com', '1987654321', '101, Mobile World, Noida');

INSERT INTO inventory (Product_ID, Seller_ID, Stock_Quantity, Stock_Status) VALUES
(1, 1, 20, 'Available'),
(1, 2, 10, 'Available'),
(2, 1, 50, 'Available'),
(2, 10, 30, 'Available'),
(3, 1, 100, 'Available'),
(3, 2, 50, 'Available'),
(4, 3, 150, 'Available'),
(5, 3, 80, 'Available'),
(6, 3, 40, 'Available'),
(7, 4, 200, 'Available'),
(8, 4, 60, 'Available'),
(9, 4, 90, 'Available'),
(10, 5, 15, 'Available'),
(11, 5, 20, 'Available'),
(12, 5, 30, 'Available'),
(13, 6, 70, 'Available'),
(14, 6, 100, 'Available'),
(15, 6, 45, 'Available'),
(16, 7, 10, 'Available'),
(17, 7, 15, 'Available'),
(18, 7, 25, 'Available'),
(19, 8, 200, 'Available'),
(20, 8, 150, 'Available'),
(21, 8, 180, 'Available'),
(22, 9, 40, 'Available'),
(23, 9, 60, 'Available'),
(24, 9, 35, 'Available');

SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM sellers;
SELECT * FROM inventory;

SELECT 
    s.Seller_Name,
    COUNT(i.Product_ID) AS Products_Supplied,
    SUM(i.Stock_Quantity) AS Total_Stock,
    GROUP_CONCAT(p.Product_Name SEPARATOR ', ') AS Product_List
FROM sellers s
LEFT JOIN inventory i ON s.Seller_ID = i.Seller_ID
LEFT JOIN products p ON i.Product_ID = p.Product_ID
GROUP BY s.Seller_ID
ORDER BY Products_Supplied DESC;

SELECT 
    p.Product_Name,
    i.Stock_Quantity,
    i.Stock_Status,
    s.Seller_Name
FROM products p
INNER JOIN inventory i ON p.Product_ID = i.Product_ID
INNER JOIN sellers s ON i.Seller_ID = s.Seller_ID
WHERE i.Stock_Quantity < 10
ORDER BY i.Stock_Quantity;

SELECT 
    'Total Products Available' AS Metric,
    COUNT(DISTINCT Product_ID) AS Value
FROM inventory
WHERE Stock_Status = 'Available'
UNION ALL
SELECT 
    'Products Out of Stock',
    COUNT(DISTINCT Product_ID)
FROM inventory
WHERE Stock_Status = 'Out of Stock'
UNION ALL
SELECT 
    'Products with Low Stock (< 10)',
    COUNT(DISTINCT Product_ID)
FROM inventory
WHERE Stock_Quantity < 10
UNION ALL
SELECT 
    'Total Inventory Records',
    COUNT(*)
FROM inventory
UNION ALL
SELECT 
    'Total Stock Items',
    SUM(Stock_Quantity)
FROM inventory
UNION ALL
SELECT 
    'Average Inventory Quantity',
    ROUND(AVG(Stock_Quantity), 2)
FROM inventory;