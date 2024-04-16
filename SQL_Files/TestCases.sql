USE GradeBookDB

/* Task 4. Retrieve average/highest/lowest score of an assignment (e.g., assignment_id = 2): */
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


--********************************
/*Task 5. List all of the students in a given course (e.g., course_id = 1):*/
SELECT s.*
FROM Student s
WHERE s.course_id = 1;

--********************************
/*Task 6. List all of the students in a course and all of their scores on every assignment (e.g., course_id = 1):*/
SELECT s.first_name, s.last_name, a.name AS assignment_name, g.score
FROM Student s
JOIN Grades g ON s.student_id = g.student_id
JOIN Assignment a ON g.assignment_id = a.assignment_id
JOIN Category c ON a.category_id = c.category_id
WHERE c.course_id = 1
ORDER BY s.last_name, s.first_name, a.assignment_id;


--********************************
/* Task 7: Add an assignment to a course (eg: New Assignment)*/
INSERT INTO Assignment (assignment_id, name, category_id)
VALUES (11, 'New Assignment', 1); 
SELECT * FROM Assignment;

--********************************
/* Task 8: Change the percentages of the categories for a course (e.g., change Homework to 20% for course_id = 1 and Final to 35%)*/
UPDATE Category
SET percentage = 20.0
WHERE name = 'Homework' AND course_id = 1;
UPDATE Category
SET percentage = 35.0
WHERE name = 'Final' AND course_id = 1;
SELECT * FROM Category

--********************************
/*Task 9: Add 2 points to the score of each student on an assignment and handle missing entries*/
/* Update existing grades */
UPDATE Grades
SET score = score + 2
WHERE assignment_id = 3;

/* Insert new grade entries for students who do not have a grade for assignment 3 */
DECLARE @maxGradeId INT;
SELECT @maxGradeId = COALESCE(MAX(grade_id), 0) FROM Grades; -- Get the current maximum grade_id

INSERT INTO Grades (grade_id, assignment_id, student_id, score)
SELECT
    @maxGradeId + ROW_NUMBER() OVER (ORDER BY s.student_id) AS new_grade_id,  -- Generates unique grade_id
    3 AS assignment_id,  -- Assuming you want to insert for assignment_id = 3
    s.student_id,
    2 AS score  -- Assuming starting grade is 2
FROM Student s
WHERE NOT EXISTS (
    SELECT 1
    FROM Grades g
    WHERE g.student_id = s.student_id AND g.assignment_id = 3
);


--This is to show updated grades
SELECT s.first_name, s.last_name, a.name AS assignment_name, g.score
FROM Student s
JOIN Grades g ON s.student_id = g.student_id
JOIN Assignment a ON g.assignment_id = a.assignment_id
JOIN Category c ON a.category_id = c.category_id
WHERE c.course_id = 1
ORDER BY s.last_name, s.first_name, a.assignment_id;


--********************************
/*Task 10: Add 2 points to the score of students whose last name contains a 'Q' and handle missing entries*/
/* Update existing grades for students with 'Q' in their last name for assignment_id = 1 */
UPDATE Grades
SET score = score + 2
WHERE assignment_id = 1 AND student_id IN (
    SELECT student_id FROM Student WHERE last_name LIKE '%Q%'
);

/* Insert new grade entries with unique grade_id for students whose last name contains 'Q' and do not have a grade for assignment_id = 1 */
INSERT INTO Grades (grade_id, assignment_id, student_id, score)
SELECT 
    (SELECT MAX(grade_id) FROM Grades) + ROW_NUMBER() OVER (ORDER BY s.student_id),  /* Generates unique grade_id */
    1,  /* assignment_id = 1 */
    s.student_id, 
    2  /* Assuming starting grade is 2 */
FROM Student s
WHERE last_name LIKE '%Q%' AND NOT EXISTS (
    SELECT 1
    FROM Grades g
    WHERE g.student_id = s.student_id AND g.assignment_id = 1
);

--This is to show updated grades
SELECT s.first_name, s.last_name, a.name AS assignment_name, g.score
FROM Student s
JOIN Grades g ON s.student_id = g.student_id
JOIN Assignment a ON g.assignment_id = a.assignment_id
JOIN Category c ON a.category_id = c.category_id
WHERE c.course_id = 1
ORDER BY s.last_name, s.first_name, a.assignment_id;

--********************************
/*Task 11: Compute the grade for a student */
-- Compute the grade for a specific student (e.g., student_id = 1)
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    SUM(weighted_score) AS final_grade
FROM (
    -- Subquery to calculate weighted scores for each category
    SELECT
        g.student_id,
        c.percentage,
        AVG(g.score) AS average_score,  -- Calculate average score per category
        (AVG(g.score) * c.percentage / 100.0) AS weighted_score  -- Apply category weight
    FROM Grades g
    INNER JOIN Assignment a ON g.assignment_id = a.assignment_id
    INNER JOIN Category c ON a.category_id = c.category_id
    GROUP BY g.student_id, c.category_id, c.percentage
) AS scores
INNER JOIN Student s ON scores.student_id = s.student_id
WHERE s.student_id = 1  -- Specify the student ID here
GROUP BY s.student_id, s.first_name, s.last_name;



--********************************
/*Task 12: Compute the grade for a student, where the lowest score for a given category is dropped (dropping the lowest score in the "Quizzes" category) */
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    SUM(weighted_score) AS final_grade
FROM (
    -- Subquery to calculate weighted scores for each category
    SELECT
        g.student_id,
        c.category_id,
        c.percentage,
        CASE 
            WHEN c.name = 'Quizzes' THEN 
                (AVG(g.score) * c.percentage / 100.0)  -- Apply category weight with lowest quiz score dropped
            ELSE 
                (AVG(g.score) * c.percentage / 100.0)  -- Normal weight calculation for other categories
        END AS weighted_score
    FROM Grades g
    INNER JOIN Assignment a ON g.assignment_id = a.assignment_id
    INNER JOIN Category c ON a.category_id = c.category_id
    LEFT JOIN (
        -- Subquery to find the lowest quiz score for the student
        SELECT
            g.student_id,
            MIN(g.score) as min_quiz_score
        FROM Grades g
        INNER JOIN Assignment a ON g.assignment_id = a.assignment_id
        INNER JOIN Category c ON a.category_id = c.category_id
        WHERE c.name = 'Quizzes'
        GROUP BY g.student_id
    ) AS min_scores ON g.student_id = min_scores.student_id AND g.score = min_scores.min_quiz_score
    WHERE min_scores.min_quiz_score IS NULL OR c.name <> 'Quizzes'
    GROUP BY g.student_id, c.category_id, c.percentage, c.name
) AS scores
INNER JOIN Student s ON scores.student_id = s.student_id
WHERE s.student_id = 1  -- Specify the student ID here
GROUP BY s.student_id, s.first_name, s.last_name;