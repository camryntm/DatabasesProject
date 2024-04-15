/* 5. Retrieve all students in a given course (e.g., course_id = 1): */

SELECT s.* FROM Student s
JOIN Course c ON s.course_id = c.course_id
WHERE c.course_id = 1;

/* 4. Retrieve average/highest/lowest score of an assignment (e.g., assignment_id = 2): */

/* Average score */
SELECT AVG(score) AS average_score
FROM Grades
WHERE assignment_id = 2;

/* Highest score */
SELECT MAX(score) AS highest_score
FROM Grades
WHERE assignment_id = 2;

/* Lowest score */
SELECT MIN(score) AS lowest_score
FROM Grades
WHERE assignment_id = 2;

/* 6. Retrieve all students in a given course and all of their scores on every assignmnet (e.g., course_id = 1): */
SELECT s.first_name, s.last_name, a.assignment_id, a.category, g.score
FROM Student s
JOIN Grades g ON s.student_id = g.student_id
JOIN Assignment a ON g.assignment_id = a.assignment_id
WHERE a.course_id = 1
ORDER BY s.last_name, s.first_name, a.assignment_id;

/* Run "SELECT * FROM Assignment;" first!! */
/* 7. Add an assignment to a course (e.g., course_id = 1): */
INSERT INTO Assignment (assignment_id, category, percentage, course_id)
VALUES (5, 'Lab', 10.0, 1);

/* 8. Change the percentages of categories for a course (e.g., course_id = 1, new percentage for Midterm = 20%): */
UPDATE Assignment
SET percentage = 20.0
WHERE category = 'Midterm' AND course_id = 1;

/* 9. Add 2 points to the score of each student on an assignment (e.g., assignment_id = 3) */
UPDATE Grades
SET score = score + 2
WHERE assignment_id = 3;

-- Insert new grade entries for students who do not have a grade for assignment 3
INSERT INTO Grades (assignment_id, student_id, score)
SELECT 3 AS assignment_id, s.student_id, 2 AS score
FROM Student s
JOIN Assignment a ON s.course_id = a.course_id
WHERE a.assignment_id = 3
AND NOT EXISTS (
    SELECT 1
    FROM Grades g
    WHERE g.student_id = s.student_id AND g.assignment_id = 3
);



/* 10. Add 2 points to the score of students whose last name contains a 'Q' */
UPDATE Grades
SET score = score + 2
WHERE assignment_id = 1 AND student_id IN (
    SELECT student_id FROM Student
    WHERE last_name LIKE '%Q%'
);

-- Insert new grade entries for students whose last name contains 'Q' and do not have a grade for assignment 1
INSERT INTO Grades (grade_id, assignment_id, student_id, score)
SELECT (
    SELECT COALESCE(MAX(grade_id), 0) + 1 FROM Grades
), 1 AS assignment_id, s.student_id, 2 AS score
FROM Student s
WHERE s.last_name LIKE '%Q%'
AND NOT EXISTS (
    SELECT 1
    FROM Grades g
    WHERE g.student_id = s.student_id AND g.assignment_id = 1
);


/* 11. Compute the grade for a student (e.g., student_id = 1): */
SELECT s.first_name, s.last_name, SUM(a.percentage * g.score / 100) AS grade
FROM Student s
JOIN Grades g ON s.student_id = g.student_id
JOIN Assignment a ON g.assignment_id = a.assignment_id
WHERE s.student_id = 2
GROUP BY s.first_name, s.last_name;



