# Databases Project

## Problem Statement
   
You are asked to implement a grade book to keep track student grades for several courses that a professor teaches. Courses should have the information of department, course number, course name, semester, and year. For each course, the grade is calculated on various categories, including course participation, homework, tests, projects, etc. The total percentages of the categories should add to 100% and the total perfect grade should be 100. The number of assignments from each category is unspecified, and can change at any time. For example, a course may be graded by the distribution: 10% participation, 20% homework, 50% tests, 20% projects. Please note that if there are 5 homework, each homework is worth 20%/5=4% of the grade.

## Tasks

- Design the ER diagram;
- Write the commands for creating tables and inserting values;
- Show the tables with the contents that you have inserted;
- Compute the average/highest/lowest score of an assignment;
- List all of the students in a given course;
- List all of the students in a course and all of their scores on every assignment;
- Add an assignment to a course;
- Change the percentages of the categories for a course;
- Add 2 points to the score of each student on an assignment;
- Add 2 points just to those students whose last name contains a ‘Q’.
- Compute the grade for a student;
- Compute the grade for a student, where the lowest score for a given category is dropped.

## Instructions
   The system is implemented in SQL. Please read below to compile and execute the program:
   
### Prerequisites
Install an SQL DBMS (e.g., MySQL) and run on your local machine/remote server.

### Creating Tables
Connect to your DBMS using a SQL client (e.g., MySQL Workbench, pgAdmin).  
<br>
Use the following commands to create their respective tables:  
<br>
Course table: 
```
CREATE TABLE Course (
course_id INT PRIMARY KEY,
department VARCHAR(255),
course_number INT,
course_name VARCHAR(255),
semester VARCHAR(255),
year INT
);
```
Student table:
```
CREATE TABLE Student (
student_id INT PRIMARY KEY,
first_name VARCHAR(255),
last_name VARCHAR(255),
course_id INT,
FOREIGN KEY (course_id) REFERENCES Course(course_id)
);
```
Assignment table:
```
CREATE TABLE Assignment (
assignment_id INT PRIMARY KEY,
category VARCHAR(255),
percentage DECIMAL(5,2),
course_id INT,
FOREIGN KEY (course_id) REFERENCES Course(course_id)
);
```
Grades table:
```
CREATE TABLE Grades (
grade_id INT PRIMARY KEY,
assignment_id INT,
student_id INT,
score DECIMAL(5,2),
FOREIGN KEY (assignment_id) REFERENCES
Assignment(assignment_id),
FOREIGN KEY (student_id) REFERENCES Student(student_id)
);
```
### Inserting Values
Use the following commands to insert values into the tables using the following examples:  
<br>
Insertions for Course table:  
```
INSERT INTO Course (course_id, department, course_number, course_name, semester, year)
VALUES (1, 'CSCI', 432, 'Database Systems', 'Spring', 2024);
```
| course_id | department | course_number | course_name | semester | year |
| --- | --- | --- | --- | --- | --- |
| 1 | CSCI | 432 | Database Systems | Spring | 2024 |





 Insertions for Student table:
```
INSERT INTO Student (student_id, first_name, last_name, course_id)
VALUES (1, 'Jamie', 'Stevens', 1),
(2, 'Monae', 'Adams', 1),
(3, 'Alliston', 'Dunn', 1);
```
| student_id | first_name | last_name | course_id |
| --- | --- | --- | --- |
| 1 | Jamie | Stevens | 1 |
| 2 | Monae | Adams | 1 |
| 3 | Alliston | Dunn | 1 |
| 4 | Sam | McQueen | 1 |





Insertions for Assignment table:
```
INSERT INTO Assignment (assignment_id, category, percentage, course_id)
VALUES (1, 'Assignments', 15.0, 1),
(2, 'Midterm', 30.0, 1),
(3, 'Project', 15.0, 1),
(4, 'Final Exam', 40.0, 1);
```
| assignment_id | category | percentage | course_id |
| --- | --- | --- | --- |
| 1 | Assignments | 15 | 1 |
| 2 | Midterm | 20 | 1 |
| 3 | Project | 15 | 1 |
| 4 | Final Exam | 40 | 1 |






Insertions for Grades table:
```
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
(12, 4, 3, 95.0);
```
| grade_id | assignment_id | student_id | score |
| --- | --- | --- | --- |
| 1 | 1 | 1 | 6.5 |
| 2 | 2 | 1 | 92.0 |
| 3 | 3 | 1 | 75.0 |
| 4 | 4 | 1 | 88.0 |
| 5 | 1 | 2 | 9.0 |
| 6 | 2 | 2 | 84.5 |
| 7 | 3 | 2 | 82.0 |
| 8 | 4 | 2 | 92.0 |
| 9 | 1 | 3 | 7.0 |
| 10 | 2 | 3 | 78.0 |
| 11 | 3 | 3 | 90.0 |
| 12 | 4 | 3 | 95.0 |





## Test cases and Result
### Compute the average/highest/lowest score of an assignment
