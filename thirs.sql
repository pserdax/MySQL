CREATE DATABASE db;
USE db;

CREATE TABLE doctors(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(255),
last_name VARCHAR(255),
speciality VARCHAR(255)
);

CREATE TABLE patients(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(255),
last_name VARCHAR(255),
date_of_birth DATE,
email VARCHAR(255),
telephone_number INT 
);
DROP TABLE appointments;

CREATE TABLE appointments(
id_doctors INT,
id_patients INT,
`date` DATE,
start_hour TIME,
end_hour TIME,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT pk_appointments PRIMARY KEY (id_doctors, id_patients),
CONSTRAINT fk_patients FOREIGN KEY(id_patients) 
REFERENCES patients(id) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT fk_doctors FOREIGN KEY(id_doctors)
REFERENCES doctors(id) ON UPDATE CASCADE ON DELETE CASCADE
);
SELECT*FROM doctors;

INSERT INTO doctors VALUE (1, 'Serdar', 'Parahatgeldiyev', 'dis');
INSERT INTO doctors VALUE (2, 'Hajy', 'Parahadow', 'dis');
INSERT INTO doctors VALUE (3, 'Meylis', 'Gelenow', 'dis');
INSERT INTO doctors VALUE (4, 'Merdan', 'Parow', 'dis');

INSERT INTO patients VALUES
(1,"Ion", "Popescu", "1975-01-29", "l_p@yahoo.com", "0723417892"), 
(2,"Vasile", "Mare", "1965-05-05", "l_p@yahoo.com", "0723417892"),
(3,"Liviu", "Nae", "1975-07-13", "l_p@yahoo.com", "0723417892"),
(4,"Alex", "Bana", "1995-01-02", "l_p@yahoo.com", "0723417892"),
(5,"Ion", "Lana", "1985-01-10", "l_p@yahoo.com", "0723417892");

INSERT INTO appointments VALUES
(1, 3, '2019-11-10', '23:39:42', '23:55:50', default ),
(2, 3, '2019-11-11', '12:00:00', '13:00:00', default ),
(3, 4, '2019-11-15', '12:40:00', '14:00:00', default ),
(4, 2, '2019-11-11', '12:30:00', '13:30:00', default ),
(4, 1, '2019-11-11', '14:40:00', '15:50:00', default );




SELECT * FROM doctors;
SELECT *FROM patients;
SELECT*FROM appointments;

SELECT p.first_name, p.last_name,  a.id_patients, a.`date`, a.start_hour FROM appointments AS a RIGHT JOIN 
patients AS p ON p.id = a.id_patients WHERE a.`date`='2019-11-11' ORDER BY a.start_hour ASC;

DELETE from doctors WHERE id = (SELECT id_doctors FROM appointments WHERE `date`='2019:11:15');
