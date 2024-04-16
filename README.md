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
Install Docker, MSSQL, Azure Data Studio (or Visual Studio Code) and run on your local machine/remote server
#### Docker Setup
1. Install Docker (https://docs.docker.com/desktop/install/mac-install/)
2. Run Docker using command

   ```
   docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=VeryStr0ngP@ssw0rd" -p 1433:1433 --name sql --hostname sql --platform linux/amd64 -d mcr.microsoft.com/mssql/server:2022-latest
   ```
3. Run `docker ps` in terminal to check on status (if succesfull move forward)

#### Connection to SQL CLI to Docker
1. Run `mssql -u sa -p` in terminal (make sure mssql is already installed)
2. Insert you specific password. For this tutorial, it is 'VeryStr0ngP@ssw0rd' (see Step 2 of Docker Setup)
3. Launch designated SQL CLI (either Visual Code or Azure Data Studio)
4. Connect to Docker using below credentials
   
   ```
   Server - > localhost

   Username -> sa

   Password - > dockerStrongPwd123
   ```

### Creating The Database
Connect to your DBMS using a SQL client (e.g., Azure Data Studio, Visual Studio Code). 
<br>
Create the Initial GradeBook DB using the below code
<br>
```
-- Create a new database called 'GradeBookDB'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'GradeBookDB'
)
CREATE DATABASE GradeBookDB
GO
```

### Creating Tables
Connect to your DBMS using a SQL client (e.g., Azure Data Studio, Visual Studio Code).  
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
Category Table:
```
CREATE TABLE Category (
  category_id INT PRIMARY KEY,
  name VARCHAR(255),
  percentage DECIMAL(5,2),
  course_id INT,
  FOREIGN KEY (course_id) REFERENCES Course(course_id)
);
```
Assignment table:
```
CREATE TABLE Assignment (
  assignment_id INT PRIMARY KEY,
  name VARCHAR(255),
  category_id INT,
  FOREIGN KEY (category_id) REFERENCES Category(category_id)
);
```
Grades table:
```
CREATE TABLE Grades (
  grade_id INT PRIMARY KEY,
  assignment_id INT,
  student_id INT,
  score DECIMAL(5,2),
  FOREIGN KEY (assignment_id) REFERENCES Assignment(assignment_id),
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




Inseertions for Category table:
```
INSERT INTO Category (category_id, name, percentage, course_id)
VALUES (1, 'Homework', 15.00, 1),
       (2, 'Quizzes', 10.00, 1),
       (3, 'Midterm', 20.00, 1),
       (4, 'Project', 15.00, 1),
       (5, 'Final', 40.00, 1);
```




Insertions for Student table:
```
INSERT INTO Student (student_id, first_name, last_name, course_id)
VALUES (1, 'Jamie', 'Stevens', 1),
       (2, 'Monae', 'Adams', 1),
       (3, 'Alliston', 'Dunn', 1),
       (4, 'Sam', 'McQueen', 1);
```
| student_id | first_name | last_name | course_id |
| --- | --- | --- | --- |
| 1 | Jamie | Stevens | 1 |
| 2 | Monae | Adams | 1 |
| 3 | Alliston | Dunn | 1 |
| 4 | Sam | McQueen | 1 |





Insertions for Assignment table:
```
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
```
| assignment_id | category | percentage | course_id |
| --- | --- | --- | --- |
| 1 | Assignments | 15 | 1 |
| 2 | Midterm | 30 | 1 |
| 3 | Project | 15 | 1 |
| 4 | Final Exam | 40 | 1 |






Insertions for Grades table:
```
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
```
Test case:
assignment_id=2
```
```
Output:
average_score=83.125
highest_score=92
lowest_score=78
```
### List all of the students in a given course
```
Test Case:
course_id=1
```
```
Output:
```
| student_id | first_name | last_name | course_id |
| --- | --- | --- | --- |
| 1 | Jaime | Stevens | 1 |
| 2 | Monae | Adams | 1 |
| 3 | Alliston | Dunn | 1 |
| 4 | Sam | McQueen | 1 |

### List all of the students in a course and all of their scores on every assignment
```
Test Case:
Course_id=1
```
```
Output:
```
| first_name | last_name | assignment_id | category | score |
| --- | --- | --- | --- | --- |
| Monae | Adams | 1 | Assignments | 9 |
| Monae | Adams | 2 | Midterm | 84.5 |
| Monae | Adams | 3 | Project | 82 |
| Monae | Adams | 4 | Final | 92 |
| Alliston | Dunn | 1 | Assignments | 7 |
| Alliston | Dunn | 2 | Midterm | 78 |
| Alliston | Dunn | 3 | Project | 90 |
| Alliston | Dunn | 4 | Final | 95 |
| Sam | McQueen | 2 | Midterm | 78 |
| Sam | McQueen | 3 | Project | 70 |
| Sam | McQueen | 4 | Final | 85 |
| Jaime | Stevens | 1 | Assignments | 6.5 |
| Jaime | Stevens | 2 | Midterm | 92 |
| Jaime | Stevens | 3 | Project | 75 |
| Jaime | Stevens | 4 | Final | 88 |
### Add an assignment to a course
```
Testcase:
course_id=1
```
```      
Output:
```
| assignment_id | category | percentage | course_id |
| --- | --- | --- | --- |
| 1 | Assignments | 15 | 1 |
| 2 | Midterm | 30 | 1 |
| 3 | Project | 15 | 1 |
| 4 | Final Exam | 40 | 1 |
| 5 | Lab | 10 | 1 |

### Change the percentages of the categories for a course
```
Test case:
category = 'Assignments', course_id = 1
```
```
Output:
```
| assignment_id | category | percentage | course_id |
| --- | --- | --- | --- |
| 1 | Assignments | 15 | 1 |
| 2 | Midterm | 20 | 1 |
| 3 | Project | 15 | 1 |
| 4 | Final Exam | 40 | 1 |
| 5 | Lab | 10 | 1 |

### Add 2 points to the score of each student on an assignment
```
Testcase:
assignment_id=3
```
```
Output:
```
| first_name | last_name | assignment_id | category | score |
| --- | --- | --- | --- | --- |
| Monae | Adams | 1 | Assignments | 9 |
| Monae | Adams | 2 | Midterm | 84.5 |
| Monae | Adams | 3 | Project | 84 |
| Monae | Adams | 4 | Final | 92 |
| Alliston | Dunn | 1 | Assignments | 7 |
| Alliston | Dunn | 2 | Midterm | 78 |
| Alliston | Dunn | 3 | Project | 92 |
| Alliston | Dunn | 4 | Final | 95 |
| Sam | McQueen | 2 | Midterm | 78 |
| Sam | McQueen | 3 | Project | 72 |
| Sam | McQueen | 4 | Final | 85 |
| Jaime | Stevens | 1 | Assignments | 6.5 |
| Jaime | Stevens | 2 | Midterm | 92 |
| Jaime | Stevens | 3 | Project | 77 |
| Jaime | Stevens | 4 | Final | 88 |


### Add 2 points just to those students whose last name contains a ‘Q’
```
Testcase:
assignment_id=1
```
```
Output:
```

### Compute the grade for a student
```
Testcase:
student_id=1
```
```
Output:
```
| first_name | last_name | grade |
| --- | --- | --- |
| Jamie | Stevens | 74.95 |

### Compute the grade for a student, where the lowest score for a given category is dropped
```
Testcase:
student_id=2
```
```
Output:
```
| first_name | last_name | grade |
| --- | --- | --- |
| Monae | Adams | 5.7 |
