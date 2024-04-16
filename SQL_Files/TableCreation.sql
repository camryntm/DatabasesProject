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

/* Create Category Table */
CREATE TABLE Category (
  category_id INT PRIMARY KEY,
  name VARCHAR(255),
  percentage DECIMAL(5,2),
  course_id INT,
  FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

/* Insert values into Course table */
INSERT INTO Course (course_id, department, course_number, course_name, semester, year)
VALUES (1, 'CSCI', 432, 'Database Systems', 'Spring', 2024);

/* Populate Category table with predefined categories and percentages */
INSERT INTO Category (category_id, name, percentage, course_id)
VALUES (1, 'Homework', 15.00, 1),
       (2, 'Quizzes', 10.00, 1),
       (3, 'Midterm', 20.00, 1),
       (4, 'Project', 15.00, 1),
       (5, 'Final', 40.00, 1);

/* Create Assignment table */
CREATE TABLE Assignment (
  assignment_id INT PRIMARY KEY,
  name VARCHAR(255),
  category_id INT,
  FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

/* Update Grades table to reference the Assignment table */
CREATE TABLE Grades (
  grade_id INT PRIMARY KEY,
  assignment_id INT,
  student_id INT,
  score DECIMAL(5,2),
  FOREIGN KEY (assignment_id) REFERENCES Assignment(assignment_id),
  FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

/* Insert values into Student table */
INSERT INTO Student (student_id, first_name, last_name, course_id)
VALUES (1, 'Jamie', 'Stevens', 1),
       (2, 'Monae', 'Adams', 1),
       (3, 'Alliston', 'Dunn', 1),
       (4, 'Sam', 'McQueen', 1);

/* Insert values into Assignment table */
INSERT INTO Assignment (assignment_id, name, category_id)
VALUES 
  /* Homework Assignments */
  (1, 'Homework 1', (SELECT category_id FROM Category WHERE name = 'Homework')),
  (2, 'Homework 2', (SELECT category_id FROM Category WHERE name = 'Homework')),
  (3, 'Homework 3', (SELECT category_id FROM Category WHERE name = 'Homework')),
  
  /* Quizzes */
  (4, 'Quiz 1', (SELECT category_id FROM Category WHERE name = 'Quizzes')),
  (5, 'Quiz 2', (SELECT category_id FROM Category WHERE name = 'Quizzes')),
  (6, 'Quiz 3', (SELECT category_id FROM Category WHERE name = 'Quizzes')),

  /* Midterm */
  (7, 'Midterm Exam', (SELECT category_id FROM Category WHERE name = 'Midterm')),

  /* Projects */
  (8, 'Project 1', (SELECT category_id FROM Category WHERE name = 'Project')),
  (9, 'Project 2', (SELECT category_id FROM Category WHERE name = 'Project')),

  /* Final Exam */
  (10, 'Final Exam', (SELECT category_id FROM Category WHERE name = 'Final'));


/* Inserting Values for Grades*/
INSERT INTO Grades (grade_id, assignment_id, student_id, score)
VALUES
  /* Jamie's Grades */
  (1, 1, 1, 85.0),  /* Homework 1 */
  (2, 2, 1, 78.0),  /* Homework 2 */
  (3, 3, 1, 92.0),  /* Homework 3 */
  (4, 4, 1, 88.0),  /* Quiz 1 */
  (5, 5, 1, 95.0),  /* Quiz 2 */
  (6, 6, 1, 82.0),  /* Quiz 3 */
  (7, 7, 1, 90.0),  /* Midterm */
  (8, 8, 1, 87.0),  /* Project 1 */
  (9, 9, 1, 91.0),  /* Project 2 */
  (10, 10, 1, 93.0), /* Final Exam */
  
  /* Monae's Grades */
  (11, 1, 2, 74.0),  /* Homework 1 */
  (12, 2, 2, 84.5),  /* Homework 2 */
  (13, 3, 2, 89.0),  /* Homework 3 */
  (14, 4, 2, 79.0),  /* Quiz 1 */
  (15, 5, 2, 88.0),  /* Quiz 2 */
  (16, 6, 2, 81.0),  /* Quiz 3 */
  (17, 7, 2, 85.0),  /* Midterm */
  (18, 8, 2, 80.0),  /* Project 1 */
  (19, 9, 2, 78.0),  /* Project 2 */
  (20, 10, 2, 86.0), /* Final Exam */
  
  /* Alliston's Grades */
  (21, 1, 3, 90.0),  /* Homework 1 */
  (22, 2, 3, 91.0),  /* Homework 2 */
  (23, 3, 3, 88.0),  /* Homework 3 */
  (24, 4, 3, 85.0),  /* Quiz 1 */
  (25, 5, 3, 94.0),  /* Quiz 2 */
  (26, 6, 3, 90.0),  /* Quiz 3 */
  (27, 7, 3, 87.0),  /* Midterm */
  (28, 8, 3, 82.0),  /* Project 1 */
  (29, 9, 3, 89.0),  /* Project 2 */
  (30, 10, 3, 91.0), /* Final Exam */
  
  /* Sam's Grades - Missing Homework 1 */
  (31, 2, 4, 78.0),  /* Homework 2 */
  (32, 3, 4, 77.0),  /* Homework 3 */
  (33, 4, 4, 83.0),  /* Quiz 1 */
  (34, 5, 4, 86.0),  /* Quiz 2 */
  (35, 6, 4, 88.0),  /* Quiz 3 */
  (36, 7, 4, 92.0),  /* Midterm */
  (37, 8, 4, 75.0),  /* Project 1 */
  (38, 9, 4, 81.0),  /* Project 2 */
  (39, 10, 4, 84.0); /* Final Exam */


/* 3. Show the tables with the contents that you have inserted */ 
SELECT * FROM Course;
SELECT * FROM Student;
SELECT * FROM Category
SELECT * FROM Assignment;
SELECT * FROM Grades;

