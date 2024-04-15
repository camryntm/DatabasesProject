USE GradeBookDB

/* Create Course table */
CREATE TABLE Course (
  course_id INT PRIMARY KEY,
  department VARCHAR(255),
  course_number INT,
  course_name VARCHAR(255),
  semester VARCHAR(255),
  year INT
);

/* Create Student table */
CREATE TABLE Student (
  student_id INT PRIMARY KEY,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  course_id INT,
  FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

/* Create Assignment table */
CREATE TABLE Assignment (
  assignment_id INT PRIMARY KEY,
  category VARCHAR(255),
  percentage DECIMAL(5,2),
  course_id INT,
  FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

/* Create Grades table */ 
CREATE TABLE Grades (
  grade_id INT PRIMARY KEY,
  assignment_id INT,
  student_id INT,
  score DECIMAL(5,2),
  FOREIGN KEY (assignment_id) REFERENCES 
  Assignment(assignment_id),
  FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

/* Insert values into Student table */
INSERT INTO Student (student_id, first_name, last_name, course_id)
VALUES (1, 'Jamie', 'Stevens', 1),
       (2, 'Monae', 'Adams', 1),
       (3, 'Alliston', 'Dunn', 1),
       (4, 'Sam', 'McQueen', 1);

/* Insert values into Assignment table */
INSERT INTO Assignment (assignment_id, category, percentage, course_id)
VALUES (1, 'Assignments', 15.0, 1),
       (2, 'Midterm', 30.0, 1),
       (3, 'Project', 15.0, 1),
       (4, 'Final Exam', 40.0, 1);

/* Insert values into Grades table */
INSERT INTO Grades (grade_id, assignment_id, student_id, score)
VALUES (1, 1, 1, 6.5),
       (2, 2, 1, 92.0),
       (3, 3, 1, 75.0),
       (4, 4, 1, 88.0),
       (5, 1, 2, 9.0),
       (6, 2, 2, 84.5),
       (7, 3, 2, 82.0),
       (8, 4, 2, 92.0),
       (9, 1, 3, 7.0),
       (10, 2, 3, 78.0),
       (11, 3, 3, 90.0),
       (12, 4, 3, 95.0),
       (13, 2, 4, 78.0),
       (14, 3, 4, 70.0),
       (15, 4, 4, 85.0);

/* 3. Show the tables with the contents that you have inserted */ 

SELECT * FROM Course;
SELECT * FROM Student;
SELECT * FROM Assignment;
SELECT * FROM Grades;