CREATE TABLE categories(
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(200) NOT NULL UNIQUE
);
CREATE TABLE products(
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
category_id TINYINT UNSIGNED,
name VARCHAR(200) NOT NULL,
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
INSERT INTO products VALUES(1, 2, 'iPhone XS 64GB', 'Smartphone iPhone XS, 64GB storage, Space Grey', 5499.99, 23, DEFAULT);
INSERT INTO products VALUES(2, 2, 'Huawei P20 Pro 128GB', 'Smartphone Huawei P20 Pro, Dual SIM, 128GB storage, black', 3409.99, 47, DEFAULT);
INSERT INTO products VALUES(3, 1, 'LED Smart TV Philips 108 cm 4K', 'LED Smart TV Philips, 108 cm, Ultra HD 4K resolution, Wi-Fi', 1689.99, 5, DEFAULT);
INSERT INTO products VALUES(4, 1, 'LED Smart TV Samsung 123 cm 4K', 'LED Smart TV Samsung, 123 cm, Ultra HD 4K, curved screen', 2399.99, 7, DEFAULT);
INSERT INTO products VALUES(5, 3, 'Laptop Lenovo IdeaPad', 'Laptop Lenovo IdeaPad 330-15IKB with Intel Core i5-7200U processor, 3.10 GHz, 15.6", Full HD, 4GB, 1TB, Intel HD Graphics 620', 2299.99, 12, DEFAULT);
INSERT INTO products VALUES(6, 3, 'Laptop Gaming Lenovo Legion', 'Laptop Gaming Lenovo Legion Y520-15IKBN with Intel Core i5-7300HQ processor, 2.50 GHz, 15.6", Full HD, IPS, 4GB, 1TB, nVIDIA GeForce GTX 1050 2GB', 2799.99, 3, DEFAULT);
INSERT INTO products VALUES(7, 3, 'Laptop Apple MacBook Air', 'Laptop Apple MacBook Air with Intel Dual Core i5 processor, 1.80GHz, 13.3", 8GB, 128GB SSD, Intel HD Graphics 6000', 4499.99, 34, DEFAULT);

UPDATE products SET stock = 15 WHERE id = 3;
/*UPDATE products SET price = (1 - 0.05) * price WHERE category_id = 2;*/
UPDATE categories SET id = 25 WHERE id = 2;
DELETE FROM categories WHERE id = 25;
ALTER TABLE products DROP FOREIGN KEY fk_category;
ALTER TABLE products ADD CONSTRAINT fk_category
FOREIGN KEY (category_id) REFERENCES categories(id)
ON UPDATE CASCADE ON DELETE RESTRICT;

DELETE FROM categories WHERE id = 1;


CREATE TABLE users(
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(200) NOT NULL,
last_name VARCHAR(200) NOT NULL,
email varchar(200)
);
INSERT INTO users VALUES(NULL, 'Jhon', 'Doe','jon_doe1@sd.com');
INSERT INTO users VALUES(NULL, 'Jhon1', 'Doe1', NULL);
INSERT INTO users VALUES(NULL, 'Jhon2', 'Doe2', NULL);



/*
commnets
*/





CREATE TABLE comments(
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
id_user int unsigned not null,
id_product int unsigned not null,

content text,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fkey_product FOREIGN KEY(id_product) REFERENCES products(id) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT fkey_user FOREIGN KEY(id_user) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO comments VALUES(NULL, 1, 2, 'comment1',default);

INSERT INTO comments VALUES(NULL, 2, 3, 'comment2',default);
INSERT INTO comments VALUES(NULL, 2, 1, 'comment3',default);
INSERT INTO comments VALUES(NULL, 3, 4, 'comment4',default);
INSERT INTO comments VALUES(NULL, 3, 4, 'comment5',default);
INSERT INTO comments VALUES(NULL, 3, 4, 'comment6',default);


DELIMITER //
CREATE TRIGGER check_comment BEFORE INSERT ON comments FOR EACH ROW
BEGIN
DECLARE nr_char INT;
SELECT length(new.content) INTO nr_char;
IF (nr_char < 10) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'comment too short';
END IF;
END//
DELIMITER ;
INSERT INTO comments VALUES(NULL, 3, 4, 'comment7will not fail this is a long comment',default);
/*INSERT INTO comments VALUES(NULL, 3, 4, 'shrt',default);*/

create view product_comments AS 
select p.name,c.content,  c.created_at, u.first_name, u.last_name from products as p, comments as c, users as u where p.id=c.id_product and u.id=c.id_user ;

/*
select* from product_comments;

select p.id, p.name, count(c.id) from products as p, comments as c where p.id=c.id_product group by p.id;


/*
ratings 
*/


CREATE TABLE ratings(
id int unsigned  primary key auto_increment, 
product_id INT UNSIGNED NOT NULL,
user_id TINYINT UNSIGNED NOT NULL,
score int,

CONSTRAINT fkey_product FOREIGN KEY(product_id)
REFERENCES products(id) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT fkey_user FOREIGN KEY(user_id)
REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

insert into ratings values (null,1,1,5);
insert into ratings values (null,2,1,5);
insert into ratings values (null,3,1,5);

DROP TRIGGER IF EXISTS check_rating;
DELIMITER //
CREATE TRIGGER check_rating BEFORE INSERT ON ratings FOR EACH ROW
BEGIN
DECLARE dup_check int;
SELECT id from ratings as r where r.user_id=new.user_id and r.product_id=new.product_id INTO dup_check;
IF (dup_check is not NULL ) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'duplicate entry';
END IF;
IF ( new.score<1 or new.score>5 ) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid score ';
END IF;
END //
DELIMITER ;

insert into ratings values (null,3,2,1);
insert into ratings values (null,2,3,3);
insert into ratings values (null,1,2,2);
insert into ratings values (null,3,3,4);

CREATE or replace VIEW user_ratings AS
SELECT u.first_name, u.last_name, u.email, p.id, p.name, r.score FROM 
ratings AS r
JOIN users AS u ON r.user_id = u.id
join products as p on r.product_id=p.id;
/*
SELECT * FROM user_ratings;

select p.name, sum(r.score)/count(r.id) as average from products as p, ratings as r where p.id=r.product_id group by p.id order by average desc;



/*
1.Create a table price_history with the appropriate attributes and relationships to store the price of the store products and the date at which it was changed.
2.Create a trigger which will be activated for the UPDATE operation on the products table and, if the price is changed, store the previous price in the table price_history. 
Choose the appropriate time for the activation of the trigger (BEFORE or AFTER).
3.Create a procedure to change the price of a product. Choose the appropriate parameters for the procedure and check if the product exists before making the change. 
If the product does not exist, an error will be signaled.
4.Display the products name, current price, minimum price and maximum price.
*/


CREATE TABLE price_history(
id int unsigned primary key auto_increment,
product_id INT UNSIGNED NOT NULL,
change_date timestamp not null default current_timestamp,
price DECIMAL(10,2) UNSIGNED NOT NULL,
CONSTRAINT fkey_product FOREIGN KEY(product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE CASCADE

);

DROP TRIGGER IF EXISTS store_price;
DELIMITER //
CREATE TRIGGER store_price after update ON products FOR EACH ROW
BEGIN
if old.price != new.price then
    insert into price_history values (null, old.id, null, old.price );
end if; 
END //
DELIMITER ;
update products set price= 666 where id=1;
delimiter //
CREATE PROCEDURE change_price(IN product_id INT,IN new_price INT)
BEGIN
DECLARE id_check INT;
SELECT products.id INTO id_check FROM products WHERE products.id = product_id;
IF (id_check IS NULL) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product not found';
ELSE
update products set price=new_price where id=product_id;
END IF;
END//
DELIMITER ;

CALL change_price (7, 9999);
CALL change_price (1, 10);
CALL change_price (1, 88);
CALL change_price (1, 2);
select p.name, p.price, least(p.price,min(ph.price)), greatest(p.price,max(ph.price)) from products as p  join  price_history as ph on p.id=ph.product_id group by p.id;
/* presupun ca vrea doar produse la care a fost schimbat pretul (?) altfel e complicat sa faci sa afiseze minimul din history sau pretul lor

