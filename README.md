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
   The system is implemented in SQL. The code is split up into three different queries (all mean't to be ran in that order)
   1. GradebookDB_Creation.sql
   2. TableCreation.sql
   3. TestCases.sql
##### Please read below to compile and execute the program...
   
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




Insertions for Category table:
```
INSERT INTO Category (category_id, name, percentage, course_id)
VALUES (1, 'Homework', 15.00, 1),
       (2, 'Quizzes', 10.00, 1),
       (3, 'Midterm', 20.00, 1),
       (4, 'Project', 15.00, 1),
       (5, 'Final', 40.00, 1);
```
| category_id | name | percentage | course_id |
| --- | --- | --- | --- |
| 1 | Homework | 15.00 | 1 |
| 2 | Quizzes | 10.00 | 1 |
| 3 | Midterm | 20.00 | 1 |
| 4 | Project | 15.00 | 1 |
| 5 | Final | 40.00 | 1 |




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
| assignment_id | name | category |
| --- | --- | --- |
| 1 | Homework 1 | 1 |
| 2 | Homework 2 | 1 |
| 3 | Homework 3 | 1 |
| 4 | Quiz 1 | 2 |
| 5 | Quiz 2 | 2 |
| 6 | Quiz 3 | 2 |
| 7 | Midterm Exam | 3 |
| 8 | Project 1 | 4 |
| 9 | Project 2 | 4 |
| 10 | Final Exam | 5 |






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
| 1 |	1 | 1 | 85.00 |
| 2 | 2 | 1 | 78.00 |
| 3 | 3 | 1 | 92.00 |
| 4 | 4 | 1 | 88.00 |
| 5 | 5 | 1 | 95.00 |
| 6 | 6 | 1 | 82.00 |
| 7 | 7 | 1 | 90.00 |
| 8 | 8 | 1 | 87.00 |
| 9 | 9 | 1 | 91.00 |
| 10 | 10 | 1 | 93.00 |
| 11 | 1 | 2 | 74.00 |
| 12 | 2 | 2 | 84.50 |
| 13 | 3 | 2 | 89.00 |
| 14 | 4 | 2 | 79.00 |
| 15 | 5 | 2 | 88.00 |
| 16 | 6 | 2 | 81.00 |
| 17 | 7 | 2 | 85.00 |
| 18 | 8 | 2 | 80.00 |
| 19 | 9 | 2 | 78.00 |
| 20 | 10 | 2 | 86.00 |
| 21 | 1 | 3 | 90.00 |
| 22 | 2 | 3 | 91.00 |
| 23 | 3 | 3 | 88.00 |
| 24 | 4 | 3 | 85.00 |
| 25 | 5 | 3 | 94.00 |
| 26 | 6 | 3 | 90.00 |
| 27 | 7 | 3 | 87.00 |
| 28 | 8 | 3 | 82.00 |
| 29 | 9 | 3 | 89.00 |
| 30 | 10 | 3 | 91.00 |
| 31 | 2 | 4 | 78.00 |
| 32 | 3 | 4 | 77.00 |
| 33 | 4 | 4 | 83.00 |
| 34 | 5 | 4 | 86.00 |
| 35 | 6 | 4 | 88.00 |
| 36 | 7 | 4 | 92.00 |
| 37 | 8 | 4 | 75.00 |
| 38 | 9 | 4 | 81.00 |
| 39 | 10 | 4 | 84.00 |


## Test cases and Result
### Compute the average/highest/lowest score of an assignment
```
Test case:
assignment_id=2
```
```
Output:
```
| average_score |
| --- |
| 82.87500 |

| highest_score |
| --- |
| 91.00 |

| average_score |
| --- |
| 78.00 |

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
|first_name|last_name|assignment_name|score|
|---|---|---|---|
|Monae|Adams|Homework 1|74.00|
|Monae|Adams|Homework 2|84.50|
|Monae|Adams|Homework 3|89.00|
|Monae|Adams|Quiz 1|79.00|
|Monae|Adams|Quiz 2|88.00|
|Monae|Adams|Quiz 3|81.00|
|Monae|Adams|Midterm Exam|85.00|
|Monae|Adams|Project 1|80.00|
|Monae|Adams|Project 2|78.00|
|Monae|Adams|Final Exam|86.00|
|Alliston|Dunn|Homework 1|90.00|
|Alliston|Dunn|Homework 2|91.00|
|Alliston|Dunn|Homework 3|88.00|
|Alliston|Dunn|Quiz 1|85.00|
|Alliston|Dunn|Quiz 2|94.00|
|Alliston|Dunn|Quiz 3|90.00|
|Alliston|Dunn|Midterm Exam|87.00|
|Alliston|Dunn|Project 1|82.00|
|Alliston|Dunn|Project 2|89.00|
|Alliston|Dunn|Final Exam|91.00|
|Sam|McQueen|Homework 2|78.00|
|Sam|McQueen|Homework 3|77.00|
|Sam|McQueen|Quiz 1|83.00|
|Sam|McQueen|Quiz 2|86.00|
|Sam|McQueen|Quiz 3|88.00|
|Sam|McQueen|Midterm Exam|92.00|
|Sam|McQueen|Project 1|75.00|
|Sam|McQueen|Project 2|81.00|
|Sam|McQueen|Final Exam|84.00|
|Jamie|Stevens|Homework 1|85.00|
|Jamie|Stevens|Homework 2|78.00|
|Jamie|Stevens|Homework 3|92.00|
|Jamie|Stevens|Quiz 1|88.00|
|Jamie|Stevens|Quiz 2|95.00|
|Jamie|Stevens|Quiz 3|82.00|
|Jamie|Stevens|Midterm Exam|90.00|
|Jamie|Stevens|Project 1|87.00|
|Jamie|Stevens|Project 2|91.00|
|Jamie|Stevens|Final Exam|93.00|
### Add an assignment to a course
```
Testcase:
course_id=1
```
```      
Output:
```
|assignment_id|name|category_id|
|---|---|---|
|1|Homework 1|1|
|2|Homework 2|1|
|3|Homework 3|1|
|4|Quiz 1|2|
|5|Quiz 2|2|
|6|Quiz 3|2|
|7|Midterm Exam|3|
|8|Project 1|4|
|9|Project 2|4|
|10|Final Exam|5|
|11|New Assignment|1|

### Change the percentages of the categories for a course
```
Test case:
category = 'Homework', course_id = 1
category = 'Final', course_id = 1
```
```
Output:
```
|category_id|name|percentage|course_id|
|---|---|---|---|
|1|Homework|20.00|1|
|2|Quizzes|10.00|1|
|3|Midterm|20.00|1|
|4|Project|15.00|1|
|5|Final|35.00|1|

### Add 2 points to the score of each student on an assignment
```
Testcase:
assignment_id=3
```
```
Output:
```
|grade_id|assignment_id|student_id|score|
|---|---|---|---|
|1|1|1|85.00|
|2|2|1|78.00|
|3|3|1|94.00|
|4|4|1|88.00|
|5|5|1|95.00|
|6|6|1|82.00|
|7|7|1|90.00|
|8|8|1|87.00|
|9|9|1|91.00|
|10|10|1|93.00|
|11|1|2|74.00|
|12|2|2|84.50|
|13|3|2|91.00|
|14|4|2|79.00|
|15|5|2|88.00|
|16|6|2|81.00|
|17|7|2|85.00|
|18|8|2|80.00|
|19|9|2|78.00|
|20|10|2|86.00|
|21|1|3|90.00|
|22|2|3|91.00|
|23|3|3|90.00|
|24|4|3|85.00|
|25|5|3|94.00|
|26|6|3|90.00|
|27|7|3|87.00|
|28|8|3|82.00|
|29|9|3|89.00|
|30|10|3|91.00|
|31|2|4|78.00|
|32|3|4|79.00|
|33|4|4|83.00|
|34|5|4|86.00|
|35|6|4|88.00|
|36|7|4|92.00|
|37|8|4|75.00|
|38|9|4|81.00|
|39|10|4|84.00|


### Add 2 points just to those students whose last name contains a ‘Q’
```
Testcase:
assignment_id=1
```
```
Output:
```
|first_name|last_name|assignment_name|score|
|---|---|---|---|
|Monae|Adams|Homework 1|74.00|
|Monae|Adams|Homework 2|84.50|
|Monae|Adams|Homework 3|91.00|
|Monae|Adams|Quiz 1|79.00|
|Monae|Adams|Quiz 2|88.00|
|Monae|Adams|Quiz 3|81.00|
|Monae|Adams|Midterm Exam|85.00|
|Monae|Adams|Project 1|80.00|
|Monae|Adams|Project 2|78.00|
|Monae|Adams|Final Exam|86.00|
|Alliston|Dunn|Homework 1|90.00|
|Alliston|Dunn|Homework 2|91.00|
|Alliston|Dunn|Homework 3|90.00|
|Alliston|Dunn|Quiz 1|85.00|
|Alliston|Dunn|Quiz 2|94.00|
|Alliston|Dunn|Quiz 3|90.00|
|Alliston|Dunn|Midterm Exam|87.00|
|Alliston|Dunn|Project 1|82.00|
|Alliston|Dunn|Project 2|89.00|
|Alliston|Dunn|Final Exam|91.00|
|Sam|McQueen|Homework 1|2.00|
|Sam|McQueen|Homework 2|78.00|
|Sam|McQueen|Homework 3|79.00|
|Sam|McQueen|Quiz 1|83.00|
|Sam|McQueen|Quiz 2|86.00|
|Sam|McQueen|Quiz 3|88.00|
|Sam|McQueen|Midterm Exam|92.00|
|Sam|McQueen|Project 1|75.00|
|Sam|McQueen|Project 2|81.00|
|Sam|McQueen|Final Exam|84.00|
|Jamie|Stevens|Homework 1|85.00|
|Jamie|Stevens|Homework 2|78.00|
|Jamie|Stevens|Homework 3|94.00|
|Jamie|Stevens|Quiz 1|88.00|
|Jamie|Stevens|Quiz 2|95.00|
|Jamie|Stevens|Quiz 3|82.00|
|Jamie|Stevens|Midterm Exam|90.00|
|Jamie|Stevens|Project 1|87.00|
|Jamie|Stevens|Project 2|91.00|
|Jamie|Stevens|Final Exam|93.00|
### Compute the grade for a student
```
Testcase:
student_id=1
```
```
Output:
```
|student_id|first_name|last_name|final_grade|
|---|---|---|---|
|1|Jamie|Stevens|89.866666|

### Compute the grade for a student, where the lowest score for a given category is dropped
```
Testcase:
student_id=1
```
```
Output:
```
|student_id|first_name|last_name|final_grade|
|---|---|---|---|
|1|Jamie|Stevens|90.183333|
