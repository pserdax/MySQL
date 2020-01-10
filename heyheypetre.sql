


USE p_trusca_store;DROP TABLE IF EXISTS price_history;CREATE TABLE price_history(
id_pri INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
ID_product INT UNSIGNED NOT NULL,
DT DATETIME,
old_pri DECIMAL UNSIGNED NOT NULL,CONSTRAINT fk_product_price FOREIGN KEY (ID_product) REFERENCES products(id));DESCRIBE products;

DROP TRIGGER up_date;
DELIMITER //
CREATE TRIGGER up_date
BEFORE UPDATE ON products FOR EACH ROW 
BEGIN
DECLARE old_price DECIMAL UNSIGNED;
SELECT price INTO old_price FROM products WHERE new.id=products.id;
IF (NEW.price != old_price) THEN
INSERT INTO price_history (ID_product,old_pri,DT) VALUES (new.id,old_price,NOW());
END IF;END //
DELIMITER ;

SHOW TABLES;SELECT * FROM products;UPDATE products SET price=19 WHERE products.id=2;SELECT * FROM price_history;

DROP procedure changes;
DELIMITER //
CREATE PROCEDURE changes(IN prices DECIMAL UNSIGNED,IN prodid INT UNSIGNED)BEGIN
DECLARE var INT UNSIGNED;
SELECT id INTO var FROM products WHERE prodid=products.id ;
IF (var IS NULL) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PRODUCT not found';
ELSE
UPDATE products SET price=prices WHERE products.id=prodid;
END IF;
END //
DELIMITER ;

CALL changes(10,8);

SELECT `name`,price,MIN(price),MAX(price) FROM products , price_history WHERE id=ID_product;








#comments 
USE R12_store;
DROP TABLE IF EXISTS comments;
CREATE TABLE IF NOT EXISTS comments(
id_comm INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
comm TEXT,
user_id INT UNSIGNED NOT NULL,
product_ID INT UNSIGNED NOT NULL,
DT DATETIME,
CONSTRAINT fk_user_comm FOREIGN KEY (user_id) REFERENCES users(id),
CONSTRAINT fk_product_comm FOREIGN KEY (product_ID) REFERENCES products(id)
);

DROP TRIGGER adding_comm;
DELIMITER //
CREATE TRIGGER adding_comm
BEFORE INSERT ON comments FOR EACH ROW
BEGIN
IF (LENGTH(new.comm) <10) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'size less than ten!';
END IF;
END //
DELIMITER ;
INSERT INTO comments (id_comm, comm, user_id, product_ID,DT) VALUES(NULL, 'fuckupetr' ,1 , 1,now()); -- out of interval
INSERT INTO comments (id_comm, comm, user_id, product_ID,DT) VALUES(NULL, 'fuck you ali abboud' ,1 , 1,now());
INSERT INTO comments (id_comm, comm, user_id, product_ID,DT) VALUES(NULL, 'fuckupetre' ,1 , 1,now());
DROP VIEW product_comments;
CREATE VIEW product_comments AS SELECT
CONCAT(u.first_name, ' ', u.last_name) as full_name,
p.name AS product_name,
c.comm AS comm,
c.DT AS `TIME`FROM users AS u JOIN comments AS c ON u.id=c.id_comm
JOIN products AS p on c.product_ID=p.id;

SELECT * FROM product_comments;

SELECT product_ID ,p.name, COUNT(product_ID) as no_comm FROM comments AS c JOIN products
AS p on c.product_ID=p.id;





#ratings
DROP TABLE IF EXISTS ratings;
CREATE TABLE IF NOT EXISTS ratings(
id_rating INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
rating FLOAT UNSIGNED NOT NULL,
user_id INT UNSIGNED NOT NULL,
product_ID INT UNSIGNED NOT NULL,
CONSTRAINT fk_user_rating FOREIGN KEY (user_id) REFERENCES users(id),
CONSTRAINT fk_product_rating FOREIGN KEY (product_ID) REFERENCES products(id)
);


/*[CONSTRAINT constraint_name] FOREIGN KEY (key_attribute)REFERENCES refered_relation (candidate_key)[ON UPDATE { RESTRICT | CASCADE | SET NULL | NO ACTION }][ON DELETE { RESTRICT | CASCADE | SET NULL | NO ACTION }]; *//*CREATE [DEFINER = { user | CURRENT_USER }] TRIGGER trigger_name{ BEFORE | AFTER } { INSERT | UPDATE | DELETE }ON table_name FOR EACH ROW [{ FOLLOWS | PRECEDES } other_trigger]trigger_body;*/


-- DROP TRIGGER [ IF EXISTS ] [schema_name.]trigger_name [ ,...n ] [ ; ] DROP TRIGGER adding_new_rating;
DELIMITER //
CREATE TRIGGER adding_new_rating
BEFORE INSERT ON ratings FOR EACH ROW
BEGIN
DECLARE existing_rating INT;
SELECT ratings.id_rating INTO existing_rating
FROM ratings WHERE ratings.user_id = new.user_id AND ratings.product_ID=new.product_ID;
IF (existing_rating IS NOT NULL) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rating already exists you fool!';
END IF;
IF (new.rating > 5 OR new.rating < 1) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rating out of interval 1-5 !';
END IF;
END //
DELIMITER ;


-- INSERT INTO table_name [(col_1, col_2, …, col_n)] VALUES (val_1,val_2, …, val_n);
INSERT INTO ratings (id_rating, rating, user_id, product_ID) VALUES(NULL, 5.5 ,1 , 1); -- out of interval
INSERT INTO ratings (id_rating, rating, user_id, product_ID) VALUES(NULL, 2 ,1 , 1);
INSERT INTO ratings (id_rating, rating, user_id, product_ID) VALUES(NULL, 3 ,1 , 2);
INSERT INTO ratings (id_rating, rating, user_id, product_ID) VALUES(NULL, 5 ,2, 2);
INSERT INTO ratings (id_rating, rating, user_id, product_ID) VALUES(NULL, 5 ,3 , 2);


TRUNCATE ratings;
SELECT * FROM users;
SELECT * FROM products;
SELECT * FROM ratings;




/*CREATE [OR REPLACE] [DEFINER = { user | CURRENT_USER }][SQL SECURITY {DEFINER | INVOKER}]VIEW view_name [(column_list)] AS select_statement;*/


DROP VIEW user_ratings;
CREATE VIEW user_ratings AS SELECT
CONCAT(u.first_name, ' ', u.last_name) as full_name,
u.email AS email,
p.name AS product_name,
p.id AS product_id,
r.rating AS rating
FROM users AS u JOIN ratings AS r ON u.id=r.id_rating
JOIN products AS p on r.product_ID=p.id;


SELECT * FROM user_ratings;


SELECT AVG(r.rating) AS avg_rating , p.name AS product_name
FROM ratings AS r JOIN products AS p ON r.product_ID=p.id
GROUP BY r.product_ID ORDER BY avg_rating DESC;

/* 
1NF = 1st normal form
2NF = 2nd normal form
3NF = 3rd normal form
prime attribute =  Attributes that form a candidate key of a relation
non prime =  And rest of the attributes of the relation are non prime.
candidate key = set of attributes with unique rows
partial dependency = a column only depends on part of the primary key (should be composite key)
composite key



1st normal form:
if the domain of each attribute contains only atomic (indivisible) values
the value for each attribute contains only a single value from that domain
each tuple is identified with a primary key

but having multiple attributes with the same meaning still violates the first 2 rules


2nd normal form:
it is 1NF
attributes that are not CK don't depend on all candidate keys of the relation

3rd normal form
it is 2NF
all the attributes in a table are determined only by the candidate keys of the relation and not by any non-prime attributes
*/