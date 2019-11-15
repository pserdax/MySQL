USE dbms;
CREATE TABLE teachers(
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255) NOT NULL,
office VARCHAR(50)
);
CREATE TABLE students(
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255) NOT NULL,
date_of_birth DATE,
`group` VARCHAR(50)
);
CREATE TABLE bachelor_projects(
teacher_id INT,
student_id INT,
CONSTRAINT pk PRIMARY KEY(teacher_id, student_id),
CONSTRAINT fk_teachers FOREIGN KEY(teacher_id)
REFERENCES teachers(id) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT fk_students FOREIGN KEY(student_id)
REFERENCES students(id) ON UPDATE CASCADE ON DELETE CASCADE,
assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELETE FROM bachelor_projects WHERE teacher_id = 1 AND assigned_at =
CURRENT_TIMESTAMP;
SELECT bp.teacher_id,t.first_name, t.last_name, COUNT(bp.teacher_id)
AS projects FROM bachelor_projects AS bp, teachers AS t WHERE
bp.teacher_id = t.id GROUP BY bp.teacher_id ORDER BY projects ASC,
t.last_name ASC;