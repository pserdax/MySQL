USE dbms;

SELECT p.*, c.name AS category_name
FROM products AS p, categories AS c
WHERE c.id = p.category_id;

ALTER TABLE categories ADD parent_id TINYINT UNSIGNED AFTER id;
ALTER TABLE categories ADD CONSTRAINT fk_subcategory
FOREIGN KEY (parent_id) REFERENCES categories(id)
ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE product_categories(
product_id INT UNSIGNED NOT NULL,
category_id TINYINT UNSIGNED NOT NULL,
PRIMARY KEY(product_id, category_id),
CONSTRAINT fkey_product FOREIGN KEY(product_id)
REFERENCES products(id) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT fkey_category FOREIGN KEY(category_id)
REFERENCES categories(id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO product_categories SELECT id, category_id FROM products;
ALTER TABLE products DROP FOREIGN KEY fk_category, DROP category_id;

INSERT INTO categories VALUES
(NULL,
(SELECT id FROM (SELECT id FROM categories WHERE name = 'TV') AS temp),
'Smart TV');

INSERT INTO categories VALUES
(NULL,
(SELECT id FROM (SELECT id FROM categories WHERE name = 'TV') AS temp),
'Full HD');
INSERT INTO categories VALUES
(NULL,
(SELECT id FROM (SELECT id FROM categories WHERE name = 'TV') AS temp),
'Ultra HD 4K');

SELECT c.name AS category, sc.name AS subcategory
FROM categories AS c, categories AS sc WHERE c.id = sc.parent_id
UNION
SELECT c.name AS category, NULL AS subcategory
FROM categories AS c
WHERE c.parent_id IS NULL
AND c.id NOT IN (SELECT DISTINCT parent_id FROM categories WHERE
parent_id IS NOT NULL);