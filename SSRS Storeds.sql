--Report1

ALTER PROCEDURE sp_GetStudentsByDepartmentNo
    @DepartmentID INT 
AS
BEGIN
    BEGIN TRY
        -- Validate department exists
        IF NOT EXISTS (SELECT 1 FROM Department WHERE Department_ID = @DepartmentID)
        BEGIN
            PRINT 'The department doesn''t exist.'
            RETURN;
        END

        SELECT 
            s.Student_ID,
            CONCAT(s.fname, ' ', s.Lname) AS FullName,
            s.Company_Name,
            s.Email,
            s.Gender,
            s.Age,
            s.freelance AS IsFreelance,
            s.Position,
            d.Department_Name,
            b.Branch_Name,
            t.Track_Name
        FROM
            Student s
        INNER JOIN Track t ON t.Track_ID = s.Track_ID
        INNER JOIN Department d ON t.Department_ID = d.Department_ID
        LEFT JOIN Branch b ON s.Branch_ID = b.Branch_ID
        WHERE 
            d.Department_ID = @DepartmentID
        ORDER BY 
            s.Lname, s.fname;
    END TRY
    BEGIN CATCH
        PRINT 'Unexpected error happened. Please try again.'
    END CATCH
END


sp_GetStudentsByDepartmentNo 1   --287
sp_GetStudentsByDepartmentNo 2   --243
sp_GetStudentsByDepartmentNo 3   --150
sp_GetStudentsByDepartmentNo 4   --167
sp_GetStudentsByDepartmentNo 5   --85


--Report2

USE [Examination System]
GO

/****** Object:  StoredProcedure [dbo].[StudGrades]    Script Date: 6/21/2025 3:40:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter proc [dbo].[StudGrades]
@stud_id int
as 
SELECT MIN(CONCAT(fname, ' ', lname)) AS FullName,
       MIN(course_name) AS Course,
      cast(SUM(grade) * 100/ 25   as varchar(10)) + '%' as [Total Grades]
FROM student s
JOIN Answer a ON s.Student_ID = a.Student_ID
JOIN Questions q ON q.Question_ID = a.Question_ID
JOIN Courses c ON q.Course_ID = c.Course_ID
where a.student_id = @stud_id
GROUP BY a.Student_ID, a.Exam_ID;
GO


--Report3

CREATE PROCEDURE GetCoursesAndStudentCountByInstructor
    @InstructorID INT
AS
BEGIN
    SELECT 
        c.Course_Name,
        COUNT(sc.Student_ID) AS Student_Count
    FROM 
        Courses c
    INNER JOIN 
        Instructor i ON c.Instructor_ID = i.Instructor_ID
    INNER JOIN 
        Student_Courses sc ON c.Course_ID = sc.Course_ID
    WHERE 
        i.Instructor_ID = @InstructorID
    GROUP BY 
        c.Course_Name;
END


--Report4

CREATE PROCEDURE GetCourseWithTopics
    @CourseID INT
AS
BEGIN
    SELECT 
        c.Course_Name,
        t.Topic_Name
    FROM 
        Courses c
    INNER JOIN 
        Topic t ON c.Course_ID = t.Course_ID
    WHERE 
        c.Course_ID = @CourseID

END
 GetCourseWithTopics @CourseID = 1;

 --Report5

 USE [Examination System]
GO

/****** Object:  StoredProcedure [dbo].[getQuestions]    Script Date: 6/21/2025 3:46:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[getQuestions] 
@ExamID int
as
SELECT 
    E.Exam_ID,
    Q.Question_ID,
    Q.Question_Text
   
    
FROM Exam E
JOIN Exam_Quastions EQ ON E.Exam_ID = EQ.Exam_ID
JOIN Questions Q ON EQ.Question_ID = Q.Question_ID
WHERE E.Exam_ID = @ExamID
ORDER BY Q.Question_ID
GO


 --Report6

 
create proc getQuestions_WithAnswers
@exam_id int,
@student_id int
as
SELECT 
    Q.Question_ID,
    Q.Question_Text,
    Q.Marks,
    Q.Model_Answer,
    A.Student_Answer
FROM Exam_Quastions EQ
JOIN Questions Q ON EQ.Question_ID = Q.Question_ID
LEFT JOIN Answer A ON A.Exam_ID = EQ.Exam_ID AND A.Question_ID = EQ.Question_ID AND A.Student_ID = @student_id
WHERE EQ.Exam_ID = @exam_id
ORDER BY Q.Question_ID


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
