DROP TABLE chocolates; 
DROP TABLE orders; 
DROP TABLE customers, contact_info;

USE chocolate; 

create table chocolates(
    chocolate_id int not null auto_increment, 
    chocolate_name varchar(255),
    price_per_ounce_dollars float(5,2),
    primary key (chocolate_id)
);

create table customers(
    customer_id int not null auto_increment,
    first_name varchar(255), 
    last_name varchar(255),
    contact_info_id int,
    primary key (customer_id)
);

create table orders(
    order_id int not null auto_increment,
    order_timestamp date, 
    customer_id int, 
    chocolate_id int, 
    order_amount_ounces float(5,2), 
    order_price float(5,2),
    primary key (order_id)
);

create table contact_info(
    contact_info_id int not null auto_increment,
    customer_id int,
    address_number int, 
    street varchar(255), 
    city varchar(255),
    zip int,
    phone_number int, 
    email varchar(255),
    primary key (contact_info_id)
);

INSERT INTO chocolates (chocolate_name, price_per_ounce_dollars) VALUES 
('Dark Chocolate', 2.50),
('Milk Chocolate', 2.00),
('White Chocolate', 2.75),
('Semisweet Chocolate', 2.75),
('Bittersweet Chocolate', 2.85),
('Unsweetened Chocolate', 2.50),
('Cocoa Powder', 1.95),
('German Chocolate', 3.20),
('Couverture Chocolate', 3.50),
('Ruby Chocolate', 3.75);

SELECT * from chocolates; 
SELECT * from customers; 
SELECT * from orders; 

INSERT INTO customers (first_name, last_name, contact_info_id) VALUES 
('John', 'Doe', 1),
('Jane', 'Smith', 2),
('Michael', 'Johnson', 3),
('Alice', 'Johnson', 4),
('Bob', 'Smith', 5),
('Emily', 'Davis', 6),
('James', 'Wilson', 7),
('Sophia', 'Martinez', 8),
('Daniel', 'Anderson', 9),
('Olivia', 'Taylor', 10);

INSERT INTO orders (order_timestamp, customer_id, chocolate_id, order_amount_ounces, order_price) VALUES 
('2024-05-09', 1, 1, 10.0, 25.00),
('2024-05-09', 2, 2, 8.0, 16.00),
('2024-05-09', 3, 3, 6.0, 16.50),
('2024-05-10', 2, 1, 5.0, 12.50),
('2024-05-10', 3, 3, 4.0, 11.00),
('2024-05-11', 1, 5, 3.0, 9.60),
('2024-05-12', 4, 2, 7.0, 19.95),
('2024-05-12', 5, 6, 2.5, 8.75),
('2024-05-13', 6, 4, 6.0, 13.80),
('2024-05-14', 7, 7, 3.5, 13.13);

INSERT INTO contact_info (customer_id, address_number, street, city, zip, phone_number, email) VALUES 
(1, 123, 'Main St', 'Anytown', 12345, 1551234567, 'john@example.com'),
(2, 456, 'Broadway', 'Othertown', 54321, 1559876543, 'jane@example.com'),
(3, 789, 'Oak St', 'Somewhere', 98765, 1555555555, 'michael@example.com'),
(4, 321, 'Maple Ave', 'Somewhere', 54321, 1553334444, 'bob@example.com'),
(5, 654, 'Elm St', 'Othertown', 98765, 1554445555, 'emily@example.com'),
(6, 987, 'Pine Rd', 'Anytown', 12345, 1555556666, 'james@example.com'),
(7, 123, 'Oak St', 'Somewhere', 54321, 1556667777, 'sophia@example.com'),
(8, 456, 'Cedar Ln', 'Anytown', 12345, 1557778888, 'daniel@example.com'),
(9, 789, 'Birch Dr', 'Othertown', 98765, 1558889999, 'olivia@example.com'),
(10, 987, 'Spruce Ct', 'Somewhere', 54321, 1559990000, 'customer@example.com');

SELECT * FROM contact_info; 

alter table customers add foreign key (contact_info_id) references contact_info(contact_info_id);
alter table contact_info add foreign key (customer_id) references customers(customer_id);

-- Retrieve all chocolates with a price per ounce greater than $3.00, ordered by chocolate name: 
SELECT chocolate_name, price_per_ounce_dollars
FROM chocolates
WHERE price_per_ounce_dollars > 3.00
ORDER BY chocolate_name;

-- Retrieve all customers who have placed an order, along with their contact information, ordered by last name:
SELECT c.first_name, c.last_name, ci.street, ci.city, ci.phone_number, ci.email
FROM customers c
JOIN contact_info ci ON c.contact_info_id = ci.contact_info_id
WHERE c.customer_id IN (SELECT DISTINCT customer_id FROM orders)
ORDER BY c.last_name;

-- Retrieve the top 5 customers with the highest total order amounts, 
-- along with the total order amount for each customer, ordered by total order amount (descending):
SELECT c.first_name, c.last_name, SUM(o.order_price) AS total_order_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_order_amount DESC
LIMIT 5;

-- Retrieve the orders placed on May 10, 2024, along with the customer's first name, 
-- last name, and order amount, ordered by order amount (descending):
SELECT c.first_name, c.last_name, o.order_amount_ounces, o.order_price
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_timestamp = '2024-05-10'
ORDER BY o.order_amount_ounces DESC;

-- Retrieve the contact information for customers who have placed orders for cocoa powder, ordered by city:
SELECT ci.*
FROM contact_info ci
JOIN customers c ON ci.customer_id = c.customer_id
JOIN orders o ON c.customer_id = o.customer_id
JOIN chocolates ch ON o.chocolate_id = ch.chocolate_id
WHERE ch.chocolate_name = 'Cocoa Powder'
ORDER BY ci.city;

-- Retrieve the details of all orders, including the customer's first and last name:
SELECT orders.order_id, orders.order_timestamp, customers.first_name, customers.last_name
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id;

-- Retrieve the total order amount and customer's email for each order placed on a specific date:
SELECT orders.order_id, SUM(orders.order_price) AS total_order_amount, contact_info.email
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
JOIN contact_info ON customers.contact_info_id = contact_info.contact_info_id
WHERE orders.order_timestamp = '2024-05-10'
GROUP BY orders.order_id;

-- Retrieve the details of customers who ordered a specific chocolate, along with their address information:
SELECT customers.first_name, customers.last_name, contact_info.address_number, contact_info.street, contact_info.city, contact_info.zip
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
JOIN chocolates ON orders.chocolate_id = chocolates.chocolate_id
JOIN contact_info ON customers.contact_info_id = contact_info.contact_info_id
WHERE chocolates.chocolate_name = 'Semisweet Chocolate';

-- Retrieve the order details for a specific customer, including the chocolate name and price per ounce:
SELECT orders.order_id, orders.order_timestamp, chocolates.chocolate_name, chocolates.price_per_ounce_dollars
FROM orders
JOIN chocolates ON orders.chocolate_id = chocolates.chocolate_id
WHERE orders.customer_id = 1;

-- Retrieve the total revenue generated by each chocolate type:
SELECT chocolates.chocolate_name, SUM(orders.order_price) AS total_revenue
FROM orders
JOIN chocolates ON orders.chocolate_id = chocolates.chocolate_id
GROUP BY chocolates.chocolate_name;

-- Calculate the total number of orders placed by each customer:
SELECT customers.customer_id, customers.first_name, customers.last_name, COUNT(orders.order_id) AS total_orders
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id;

-- Find the average order price for each chocolate:
SELECT chocolates.chocolate_name, AVG(orders.order_price) AS average_order_price
FROM chocolates
LEFT JOIN orders ON chocolates.chocolate_id = orders.chocolate_id
GROUP BY chocolates.chocolate_name;

-- Determine the maximum order amount (in ounces) placed by each customer:
SELECT customers.customer_id, customers.first_name, customers.last_name, MAX(orders.order_amount_ounces) AS max_order_amount_ounces
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id;

-- Calculate the total revenue generated for each city:
SELECT contact_info.city, SUM(orders.order_price) AS total_revenue
FROM contact_info
LEFT JOIN customers ON contact_info.contact_info_id = customers.contact_info_id
LEFT JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY contact_info.city;

-- Find the minimum and maximum prices per ounce for each chocolate:

SELECT chocolates.chocolate_name, MIN(chocolates.price_per_ounce_dollars) AS min_price_per_ounce, MAX(chocolates.price_per_ounce_dollars) AS max_price_per_ounce
FROM chocolates
GROUP BY chocolates.chocolate_name;

-- Customer Orders View:

CREATE VIEW customer_orders AS
SELECT c.first_name, c.last_name, ci.email, o.order_id, o.order_timestamp, ch.chocolate_name, o.order_amount_ounces, o.order_price
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN chocolates ch ON o.chocolate_id = ch.chocolate_id
JOIN contact_info ci ON c.contact_info_id = ci.contact_info_id;

-- Total Revenue by Chocolate View:

CREATE VIEW total_revenue_by_chocolate AS
SELECT ch.chocolate_name, SUM(o.order_price) AS total_revenue
FROM chocolates ch
JOIN orders o ON ch.chocolate_id = o.chocolate_id
GROUP BY ch.chocolate_name;

-- High-Value Customers View:

CREATE VIEW high_value_customers AS
SELECT c.customer_id, c.first_name, c.last_name, ci.email, SUM(o.order_price) AS total_order_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN contact_info ci ON c.contact_info_id = ci.contact_info_id
GROUP BY c.customer_id
ORDER BY total_order_amount DESC;

-- Inventory Status View:
CREATE VIEW inventory_status AS
SELECT ch.chocolate_name, ch.inventory_quantity, ch.min_threshold,
       CASE
           WHEN ch.inventory_quantity <= ch.min_threshold THEN 'Low Inventory'
           ELSE 'In Stock'
       END AS status
FROM chocolates ch;
-- Error Code: 1054. Unknown column 'ch.inventory_quantity' in 'field list'

-- Top-Selling Chocolates View:
CREATE VIEW top_selling_chocolates AS
SELECT ch.chocolate_name, SUM(o.order_amount_ounces) AS total_quantity_sold, SUM(o.order_price) AS total_revenue
FROM chocolates ch
JOIN orders o ON ch.chocolate_id = o.chocolate_id
GROUP BY ch.chocolate_name
ORDER BY total_quantity_sold DESC;

-- Monthly Revenue Trend View:
CREATE VIEW monthly_revenue_trend AS
SELECT YEAR(o.order_timestamp) AS year, MONTH(o.order_timestamp) AS month, SUM(o.order_price) AS total_revenue
FROM orders o
GROUP BY YEAR(o.order_timestamp), MONTH(o.order_timestamp)
ORDER BY year, month;

-- Customer Location View: 
CREATE VIEW customer_location AS
SELECT ci.city, ci.zip, COUNT(*) AS customer_count
FROM contact_info ci
JOIN customers c ON ci.contact_info_id = c.contact_info_id
GROUP BY ci.city, ci.zip;

-- Unfulfilled Orders View:
CREATE VIEW unfulfilled_orders AS
SELECT o.order_id, c.first_name, c.last_name, o.order_timestamp, o.order_amount_ounces, o.order_price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Pending';
-- Error Code: 1054. Unknown column 'o.status' in 'where clause'

-- Add the inventory_quantity column to the chocolates table
ALTER TABLE chocolates ADD COLUMN inventory_quantity INT DEFAULT 0;

-- Populate the inventory_quantity column for each row
UPDATE chocolates SET inventory_quantity = 
    CASE
        WHEN chocolate_name = 'Semisweet Chocolate' THEN 50
        WHEN chocolate_name = 'Dark Chocolate' THEN 45  
        WHEN chocolate_name = 'Milk Chocolate' THEN 55 
        WHEN chocolate_name = 'White Chocolate' THEN 35 
        WHEN chocolate_name = 'Bittersweet Chocolate' THEN 40
        WHEN chocolate_name = 'Unsweetened Chocolate' THEN 30
        WHEN chocolate_name = 'Cocoa Powder' THEN 60
        WHEN chocolate_name = 'German Chocolate' THEN 45
        WHEN chocolate_name = 'Couverture Chocolate' THEN 55
        WHEN chocolate_name = 'Ruby Chocolate' THEN 35
        ELSE 0 -- Handle any other rows that might exist
    END
WHERE chocolate_id IS NOT NULL;
-- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.


-- Begin a new transaction
START TRANSACTION;

-- Perform database operations within the transaction
INSERT INTO orders (customer_id, chocolate_id, order_amount_ounces, order_price) VALUES (1, 3, 2.5, 15.00);
UPDATE chocolates SET inventory_quantity = inventory_quantity - 2.5 WHERE chocolate_id = 3;

-- Commit the transaction to make its changes permanent
COMMIT;

-- Begin another transaction
START TRANSACTION;

-- Perform more database operations within the transaction
INSERT INTO orders (customer_id, chocolate_id, order_amount_ounces, order_price) VALUES (2, 1, 3.0, 20.00);
UPDATE chocolates SET inventory_quantity = inventory_quantity - 3.0 WHERE chocolate_id = 1;

-- Set a savepoint within the transaction
SAVEPOINT after_first_order;

-- Perform additional operations
INSERT INTO orders (customer_id, chocolate_id, order_amount_ounces, order_price) VALUES (2, 4, 1.5, 12.00);
UPDATE chocolates SET inventory_quantity = inventory_quantity - 1.5 WHERE chocolate_id = 4;

-- Rollback to the savepoint to undo changes made after it
ROLLBACK TO SAVEPOINT after_first_order;

-- Commit the transaction to make its changes permanent
COMMIT;


SELECT * FROM chocolates; 

-- Subquery Example:
-- Find customers who have placed orders for chocolates with a price higher than the average price
SELECT DISTINCT customer_id
FROM orders
WHERE order_id IN (
    SELECT order_id
    FROM orders
    WHERE order_price > (SELECT AVG(order_price) FROM orders)
);

-- Common Table Expression (CTE) Example:
-- Find the top 3 customers by total order amount
WITH customer_order_totals AS (
    SELECT customer_id, SUM(order_price) AS total_amount
    FROM orders
    GROUP BY customer_id
)
SELECT customer_id
FROM customer_order_totals
ORDER BY total_amount DESC
LIMIT 3;

-- Window Function Example:
-- Rank customers by their total order amount
SELECT customer_id, total_order_amount,
       RANK() OVER (ORDER BY total_order_amount DESC) AS rank
FROM (
    SELECT customer_id, SUM(order_price) AS total_order_amount
    FROM orders
    GROUP BY customer_id
) AS customer_totals;
-- Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'rank FROM (     SELECT customer_id, SUM(order_price) AS total_order_amount     F' at line 2

-- Subquery and Window Function Example:
-- Find customers who have placed orders for chocolates with a price higher than the average price,
-- along with their rank based on total order amount
WITH customer_order_totals AS (
    SELECT customer_id, SUM(order_price) AS total_amount
    FROM orders
    GROUP BY customer_id
)
SELECT customer_id, total_amount,
       RANK() OVER (ORDER BY total_amount DESC) AS total_order_rank
FROM customer_order_totals
WHERE EXISTS (
    SELECT 1
    FROM orders
    WHERE customer_id = customer_order_totals.customer_id
    AND order_price > (SELECT AVG(order_price) FROM orders)
);

-- Create a composite index on (order_timestamp, customer_id) columns in the orders table
CREATE INDEX idx_order_timestamp_customer_id ON orders(order_timestamp, customer_id);
-- hold

-- Create a composite index on (customer_id, chocolate_id) columns in the orders table
CREATE INDEX idx_customer_id_chocolate_id ON orders(customer_id, chocolate_id);
-- hold 


CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';

GRANT SELECT, INSERT, UPDATE, DELETE ON chocolate.chocolates TO role;

GRANT role TO 'username'@'localhost';

SELECT * FROM mysql.role_edges;

-- Create the user account without granting privileges
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';

-- Grant privileges to the user account
GRANT SELECT, INSERT, UPDATE ON chocolate.* TO 'username'@'localhost';

GRANT role TO 'username'@'localhost';

SELECT * FROM mysql.role_edges;

alter table customers add foreign key (contact_info_id) references contact_info(contact_info_id);
alter table contact_info add foreign key (customer_id) references customers(customer_id);


SHOW GRANTS; 

GRANT GRANT OPTION ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

SELECT * FROM chocolate.top_selling_chocolates;

GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;



