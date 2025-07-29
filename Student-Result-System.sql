CREATE DATABASE STUDENT_RESULT_SYSTEM;
USE STUDENT_RESULT_SYSTEM;

CREATE TABLE STUDENTS(
    Student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    Department VARCHAR(50)
);

CREATE TABLE Courses (
    Course_id INT PRIMARY KEY AUTO_INCREMENT,
    Course_name VARCHAR(100),
    Credits INT
);

CREATE TABLE Semesters (
    Semester_id INT PRIMARY KEY AUTO_INCREMENT,
    year INT,
    Term VARCHAR(20)  -- e.g., "Spring", "Fall"
);

CREATE TABLE Grade(
    Grade_id INT PRIMARY KEY AUTO_INCREMENT,
    Student_id INT,
    Course_id INT,
    Semester_id INT,
    Marks_obtained FLOAT,
    Grade CHAR(2),
    FOREIGN KEY (STUDENT_ID) REFERENCES STUDENTS(STUDENT_ID),
    FOREIGN KEY (COURSE_ID) REFERENCES COURSES(COURSE_ID),
    FOREIGN KEY (SEMESTER_ID) REFERENCES SEMESTERS(SEMESTER_ID)
);

ALTER TABLE Grade RENAME TO Grades;

INSERT INTO Students (name, Department) VALUES 
('Alice Johnson', 'Computer Science'),
('Bob Smith', 'Information Technology'),
('Charlie Brown', 'Information Technology'),
('Diana Evans', 'Computer Science'),
('Ethan White', 'Information Technology'),
('Franklin Richards', 'Computer Science'),
('Gwen Stacy', 'Computer Science'),
('Hazel Barnes', 'Information Technology'),
('Issac Pitt', 'Information Technology'),
('James Gosling', 'Computer Science');

INSERT INTO Courses (Course_name, Credits) VALUES 
('Database Systems', 4),
('Operating Systems', 3),
('Cloud Computing', 3),
('Data Structures', 4),
('Image Processing', 4),
('Machine Learning', 4),
('Artificial Intelligence', 4),
('Natural Language Processing', 4),
('Game Programming', 3),
('Blockchain', 3);

INSERT INTO Semesters (year, Term) VALUES 
(2024, 'Fall'),
(2025, 'Spring');

-- Alice (student_id = 1) results in Fall 2024
INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained, grade) VALUES 
(1, 2, 1, 85, 'A'),
(1, 4, 1, 78, 'B'),
(1, 5, 1, 91, 'A');

-- Bob (student_id = 2) results in Fall 2024
INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained, grade) VALUES 
(2, 1, 1, 60, 'C'),
(2, 3, 1, 55, 'D'),
(2, 4, 1, 45, 'F');

-- Charlie (student_id = 3) results in Spring 2025
INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained, grade) VALUES 
(3, 7, 2, 70, 'B'),
(3, 10, 2, 66, 'C'),
(3, 8, 2, 89, 'A');

-- Diana (student_id = 4) results in Spring 2025
INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained, grade) VALUES 
(4, 8, 2, 93, 'A'),
(4, 9, 2, 88, 'A'),
(4, 6, 2, 76, 'B');

-- Ethan (student_id = 5) results in Fall 2024
INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained, grade) VALUES 
(5, 5, 1, 67, 'C'),
(5, 2, 1, 74, 'B'),
(5, 1, 1, 81, 'A');

-- Franklin (student_id = 6) results in Spring 2024
INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained, grade) VALUES 
(6, 6, 2, 85, 'A'),
(6, 7, 2, 78, 'B'),
(6, 10, 2, 91, 'A');

-- Gwen (student_id = 7) results in Fall 2024
INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained, grade) VALUES 
(7, 3, 2, 93, 'A'),
(7, 2, 2, 88, 'A'),
(7, 4, 2, 76, 'B');

-- Hazel (student_id = 8) results in Spring 2025
INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained, grade) VALUES 
(8, 6, 2, 70, 'B'),
(8, 8, 2, 66, 'C'),
(8, 10, 2, 89, 'A');

-- Issac (student_id = 9) results in Spring 2025
INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained, grade) VALUES 
(9, 7, 2, 60, 'C'),
(9, 9, 2, 55, 'D'),
(9, 6, 2, 45, 'F');

-- James (student_id = 10) results in Fall 2024
INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained, grade) VALUES 
(10, 1, 1, 67, 'C'),
(10, 4, 1, 74, 'B'),
(10, 5, 1, 81, 'A');


SELECT * FROM GRADES;

Delete FROM Grades WHERE student_id = 10;

TRUNCATE TABLE Grades;

SELECT 
    Student_id,
    SUM(CASE grade 
        WHEN 'A' THEN 10 
        WHEN 'B' THEN 8 
        WHEN 'C' THEN 6 
        WHEN 'D' THEN 4 
        ELSE 0 END * c.credits) / SUM(c.credits) AS GPA
FROM Grades G
JOIN Courses C ON G.Course_id = C.Course_id
GROUP BY Student_id
ORDER BY Student_id ASC;


SELECT 
    Student_id,
    COUNT(CASE WHEN grade IN ('A', 'B', 'C', 'D') THEN 1 END) AS Passed,
    COUNT(CASE WHEN grade = 'F' THEN 1 END) AS Failed
FROM Grades
GROUP BY Student_id;


SELECT 
    student_id,
    semester_id,
    RANK() OVER (PARTITION BY semester_id ORDER BY 
        SUM(CASE grade 
            WHEN 'A' THEN 10 
            WHEN 'B' THEN 8 
            WHEN 'C' THEN 6 
            WHEN 'D' THEN 4 
            ELSE 0 END * c.credits) / SUM(c.credits) DESC) AS TOP
FROM Grades G
JOIN Courses C ON G.Course_id = C.Course_id
GROUP BY Student_id, Semester_id;



DELIMITER //
CREATE TRIGGER Calculate_gpa AFTER INSERT ON Grades
FOR EACH ROW
BEGIN
  -- You may update GPA table or log GPA for the student after each insert
  -- Optional: Create a GPA table to store student GPAs
END;
//
DELIMITER ;

SELECT 
    s.name,
    sem.year,
    sem.term,
    c.course_name,
    g.grade,
    g.marks_obtained
FROM Grades G
JOIN Students S ON G.student_id = S.student_id
JOIN Courses C ON G.course_id = C.course_id
JOIN Semesters sem ON g.semester_id = sem.semester_id
ORDER BY s.name, sem.year, sem.term;




