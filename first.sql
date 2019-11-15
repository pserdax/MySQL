CREATE DATABASE dbms;
USE dbms;

CREATE TABLE categories(
id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE products(
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
category_id TINYINT UNSIGNED,
name VARCHAR(255) NOT NULL,
description TEXT,
price DECIMAL(10,2) UNSIGNED NOT NULL,
stock INT,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_category FOREIGN KEY(category_id)
REFERENCES categories(id) ON UPDATE CASCADE ON DELETE SET NULL
);

INSERT INTO categories VALUES(1, 'TV');
INSERT INTO categories VALUES(2, 'Smartphone');
INSERT INTO categories VALUES(3, 'Laptop');
INSERT INTO categories VALUES(4, 'Camera');

INSERT INTO products VALUES(1, 2, 'iPhone XS 64GB', 'Smartphone iPhone
XS, 64GB storage, Space Grey', 5499.99, 23, DEFAULT);

INSERT INTO products VALUES(2, 2, 'Huawei P20 Pro 128GB', 'Smartphone
Huawei P20 Pro, Dual SIM, 128GB storage, black', 3409.99, 47, DEFAULT);

INSERT INTO products VALUES(3, 1, 'LED Smart TV Philips 108 cm 4K', 'LED
Smart TV Philips, 108 cm, Ultra HD 4K resolution, Wi-Fi', 1689.99, 5, DEFAULT);

INSERT INTO products VALUES(4, 1, 'LED Smart TV Samsung 123 cm 4K', 'LED
Smart TV Samsung, 123 cm, Ultra HD 4K, curved screen', 2399.99, 7, DEFAULT);

INSERT INTO products VALUES(5, 3, 'Laptop Lenovo IdeaPad', 'Laptop Lenovo
IdeaPad 330-15IKB with Intel Core i5-7200U processor, 3.10 GHz, 15.6",
Full HD, 4GB, 1TB, Intel HD Graphics 620', 2299.99, 12, DEFAULT);

INSERT INTO products VALUES(6, 3, 'Laptop Gaming Lenovo Legion', 'Laptop
Gaming Lenovo Legion Y520-15IKBN with Intel Core i5-7300HQ processor,
2.50 GHz, 15.6", Full HD, IPS, 4GB, 1TB, nVIDIA GeForce GTX 1050 2GB',
2799.99, 3, DEFAULT);

INSERT INTO products VALUES(7, 3, 'Laptop Apple MacBook Air', 'Laptop
Apple MacBook Air with Intel Dual Core i5 processor, 1.80GHz, 13.3",
8GB, 128GB SSD, Intel HD Graphics 6000', 4499.99, 34, DEFAULT);

SELECT * FROM products;
SELECT * FROM products WHERE category_id = 3 ORDER BY price ASC;
SELECT * FROM products WHERE name LIKE 'Lenovo';
SELECT * FROM products WHERE price BETWEEN 2000 AND 3000;
SELECT * FROM products WHERE stock < 5;

SELECT category_id, COUNT(*) AS num_products FROM products GROUP BY category_id;
SELECT SUM(stock) AS total_stock FROM products;
SELECT category_id, SUM(stock) AS total_stock
FROM products GROUP BY category_id;

UPDATE products SET stock = 15 WHERE id = 3;

UPDATE products SET price = (1 - 0.05) * price WHERE category_id = 2;

UPDATE categories SET id = 25 WHERE id = 2;
SELECT * FROM products;

SELECT * FROM products WHERE category_id IS NULL;

DELETE FROM categories WHERE id = 25;

ALTER TABLE products DROP FOREIGN KEY fk_category;
ALTER TABLE products ADD CONSTRAINT fk_category
FOREIGN KEY (category_id) REFERENCES categories(id)
ON UPDATE CASCADE ON DELETE RESTRICT;
DELETE FROM categories WHERE id = 1;