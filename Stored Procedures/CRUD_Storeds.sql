
-- stored procedure for Course Table
-- Insert into Course

CREATE PROC Insert_Courses
    @Course_ID INT,
    @Course_Name NVARCHAR(50),
    @Passing_Grade INT,
	@Max_Grade INT,
	@Credit_Hours INT,
	@Prerequisite NVARCHAR(50),
	@Weekly_Hours tinyint,
	@Number_Of_Student INT,
	@Instructor_ID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Courses WHERE Course_ID = @Course_ID)
        SELECT 'The Course already exists'
    ELSE
        INSERT INTO Courses(Course_ID, Course_Name, Passing_Grade, Max_Grade, Credit_Hours, Prerequisite, Weekly_Hours, Number_Of_Student, Instructor_ID)
        VALUES (@Course_ID, @Course_Name, @Passing_Grade, @Max_Grade, @Credit_Hours, @Prerequisite, @Weekly_Hours, @Number_Of_Student, @Instructor_ID)
END

-- Update Course

CREATE PROC Update_Courses
    @Course_ID INT,
    @Course_Name NVARCHAR(50)=null,
    @Passing_Grade INT=null,
	@Max_Grade INT=null,
	@Credit_Hours INT=null,
	@Prerequisite NVARCHAR(50)=null,
	@Weekly_Hours tinyint=null,
	@Number_Of_Student INT=null,
	@Instructor_ID INT=null
AS
BEGIN TRY
    IF EXISTS (SELECT 1 FROM Courses WHERE Course_ID = @Course_ID)
    BEGIN
        UPDATE Courses
        SET Course_Name = ISNULL(@Course_Name, Course_Name),
		    Passing_Grade = ISNULL(@Passing_Grade, Passing_Grade),
			Max_Grade = ISNULL(@Max_Grade, Max_Grade),
			Credit_Hours = ISNULL(@Credit_Hours, Credit_Hours),			
			Prerequisite = ISNULL(@Prerequisite, Prerequisite),
			Weekly_Hours = ISNULL(@Weekly_Hours, Weekly_Hours),
			Number_Of_Student = ISNULL(@Number_Of_Student, Number_Of_Student),
			Instructor_ID = ISNULL(@Instructor_ID, Instructor_ID)
        WHERE Course_ID = @Course_ID

        SELECT 'Course updated successfully'
    END
    ELSE
        SELECT 'Course not found'
END TRY
BEGIN CATCH
  SELECT 'An unexpected error occurred. Please try again.';
END CATCH



-- Delete Course

CREATE PROC Delete_Course @ID INT
AS
BEGIN try
    IF EXISTS (SELECT 1 FROM Courses WHERE Course_ID = @ID)
    BEGIN
        DELETE FROM Courses WHERE Course_ID = @ID
        SELECT 'Course deleted successfully'
    END
    ELSE
        SELECT 'Course does not exist'
END try
BEGIN CATCH
  SELECT 'An unexpected error occurred. Please try again.';
END CATCH



-- Select From Course 

CREATE PROC Select_Course
    @Course_ID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Courses WHERE Course_ID = @Course_ID)
    BEGIN
        SELECT 
            Course_ID,
            Course_Name,
            Passing_Grade,
            Max_Grade,
            Credit_Hours,
            Prerequisite,
            Weekly_Hours,
            Number_Of_Student,
            Instructor_ID
        FROM Courses
        WHERE Course_ID = @Course_ID
    END
    ELSE
    BEGIN
        SELECT 'Course not found' AS Message
    END
END


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- stored procedure for CourserATE Table
-- Insert into CourseRate

CREATE PROC Insert_CourseRate
    @Course_ID INT,
    @Student_ID INT,
    @Difficulty_Score INT,
    @Industry_Relevance_Score INT,
	@Instructor_Effectiveness_Score INT

AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course_Rate WHERE Course_ID = @Course_ID AND Student_ID = @Student_ID)
        SELECT 'Course_Rate already exists'
    ELSE
        INSERT INTO Course_Rate (Course_ID, Student_ID, Difficulty_Score , Industry_Relevance_Score , Instructor_Effectiveness_Score)
        VALUES (@Course_ID, @Student_ID,@Difficulty_Score ,@Industry_Relevance_Score,@Instructor_Effectiveness_Score )
END



-- Update CourseRate

CREATE PROC Update_CourseRate
    @Course_ID INT,
    @Student_ID INT,
    @Difficulty_Score INT =NULL,
    @Industry_Relevance_Score INT =NULL,
	@Instructor_Effectiveness_Score INT =NULL
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course_Rate WHERE Course_ID = @Course_ID AND Student_ID = @Student_ID)
    BEGIN
        UPDATE Course_Rate
        SET Difficulty_Score = ISNULL(@Difficulty_Score, Difficulty_Score),
            Industry_Relevance_Score = ISNULL(@Industry_Relevance_Score, Industry_Relevance_Score),
			Instructor_Effectiveness_Score = ISNULL(@Instructor_Effectiveness_Score, Instructor_Effectiveness_Score)
        WHERE Course_ID = @Course_ID AND Student_ID = @Student_ID

        SELECT 'Course_Rate updated successfully'
    END
    ELSE
        SELECT 'Course_Rate not found'
END


-- select From course rate

CREATE PROC Select_CourseRate
    @Course_ID INT,
    @Student_ID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course_Rate WHERE Course_ID = @Course_ID AND Student_ID = @Student_ID)
    BEGIN
        SELECT 
            Course_ID,
            Student_ID,
            Difficulty_Score,
            Industry_Relevance_Score,
            Instructor_Effectiveness_Score
        FROM Course_Rate
        WHERE Course_ID = @Course_ID AND Student_ID = @Student_ID
    END
    ELSE
    BEGIN
        SELECT 'Course_Rate not found' AS Message
    END
END


-- Delete CourseRate

CREATE PROC Delete_CourseRate
    @Course_ID INT,
    @Student_ID INT
AS
BEGIN TRY 
    IF EXISTS (SELECT 1 FROM Course_Rate WHERE Course_ID = @Course_ID AND Student_ID = @Student_ID)
    BEGIN
        DELETE FROM Course_Rate
        WHERE Course_ID = @Course_ID AND Student_ID = @Student_ID
        SELECT 'Course_Rate deleted successfully'
    END
    ELSE
        SELECT 'Course_Rate not found'
END TRY
BEGIN CATCH
  SELECT 'An unexpected error occurred. Please try again.';
END CATCH


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- stored procedure for Question Table
-- Insert into Question 

CREATE PROC Insert_Question
    @Question_ID INT,
    @Marks INT,
    @Model_Answer NVARCHAR(250),
	@Type NVARCHAR(50),
	@Difficulty_Score INT,
	@Course_ID INT,
	@Question_Text VARCHAR(500)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Questions WHERE Question_ID = @Question_ID)
        SELECT 'Question already exists'
    ELSE
        INSERT INTO Questions (Question_ID, Marks,  Model_Answer, Type,Difficulty_Score, Course_ID, Question_Text)
        VALUES (@Question_ID, @Marks, @Model_Answer, @Type, @Difficulty_Score, @Course_ID, @Question_Text)
END

-- Update Question

CREATE PROC Update_Question
    @Question_ID INT,
    @Marks INT =NULL,
    @Model_Answer NVARCHAR(250) =NULL,
	@Type NVARCHAR(50) =NULL,
	@Difficulty_Score INT =NULL,
	@Course_ID INT =NULL,
	@Question_Text VARCHAR(500) =NULL
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Questions WHERE Question_ID = @Question_ID)
    BEGIN
        UPDATE Questions
        SET Marks = ISNULL(@Marks, Marks),
            Model_Answer = ISNULL(@Model_Answer, Model_Answer),
			Type = ISNULL(@Type, Type),
			Difficulty_Score = ISNULL(@Difficulty_Score, Difficulty_Score),
			Course_ID = ISNULL(@Course_ID, Course_ID),
			Question_Text=ISNULL(@Question_Text, Question_Text)
        WHERE Question_ID = @Question_ID
        SELECT 'Question updated successfully'
    END
    ELSE
        SELECT 'Question not found'
END

-- Select From Question

CREATE PROC Select_Question
    @Question_ID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Questions WHERE Question_ID = @Question_ID)
    BEGIN
        SELECT 
            Question_ID,
            Marks,
            Model_Answer,
            Type,
            Difficulty_Score,
            Course_ID,
            Question_Text
        FROM Questions
        WHERE Question_ID = @Question_ID
    END
    ELSE
    BEGIN
        SELECT 'Question not found' AS Message
    END
END


-- Delete Question

CREATE PROC Delete_Question @ID INT
AS
BEGIN TRY
    IF EXISTS (SELECT 1 FROM Questions WHERE Question_ID = @ID)
    BEGIN
        DELETE FROM Questions WHERE Question_ID = @ID
        SELECT 'Question deleted successfully'
    END
    ELSE
        SELECT 'Question not found'
END TRY
BEGIN CATCH
  SELECT 'An unexpected error occurred. Please try again.';
END CATCH


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- stored procedure for  Intake Table
-- Insert into Intake  


CREATE PROC Insert_Intake
    @Intake_ID INT,
    @StartDate DATE,
    @Intake_Number INT,
	@Branch_id INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Intake WHERE Intake_ID = @Intake_ID)
        SELECT 'Intake already exists'
    ELSE
        INSERT INTO Intake (Intake_ID, Start_Date, Intake_Number,Branch_ID)
        VALUES (@Intake_ID, @StartDate, @Intake_Number, @Branch_id)
END


-- Update Intake


CREATE PROC Update_Intake
    @Intake_ID INT,
    @StartDate DATE =NULL,
    @Intake_Number INT =NULL,
	@Branch_id INT =NULL
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Intake WHERE Intake_ID = @Intake_ID)
    BEGIN
        UPDATE Intake
        SET Start_Date = ISNULL(@StartDate, Start_Date),
            Intake_Number = ISNULL(@Intake_Number, Intake_Number),
            Branch_ID = ISNULL(@Branch_id, Branch_ID)
        WHERE Intake_ID = @Intake_ID
        SELECT 'Intake updated successfully'
    END
    ELSE
        SELECT 'Intake not found'
END

--Select from Intake

CREATE PROC Select_Intake
    @Intake_ID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Intake WHERE Intake_ID = @Intake_ID)
    BEGIN
        SELECT 
            Intake_ID,
            Start_Date,
            Intake_Number,
            Branch_ID
        FROM Intake
        WHERE Intake_ID = @Intake_ID
    END
    ELSE
    BEGIN
        SELECT 'Intake not found' AS Message
    END
END

-- Delete Intake

CREATE PROC Delete_Intake @ID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Intake WHERE Intake_ID = @ID)
    BEGIN
        DELETE FROM Intake WHERE Intake_ID = @ID
        SELECT 'Intake deleted successfully'
    END
    ELSE
        SELECT 'Intake not found'
END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 -- stored procedures for Track table
--delete procedure for Track table

create proc delete_track @id int
AS
if exists(select * from Track where Track_ID=@id)
Begin 
delete from dbo.Track 
where Track_ID = @id
 SELECT 'Track Deleted Successfully'
End
Else
 SELECT 'Track Does Not Exist Successfully'

 ------------------------------------------

 --update procedure for track table
 
 create proc update_Track 
 @id int,
 @Track_name nvarchar(50)=null
 AS 
 if Exists ( select 1 from Track where Track_ID=@id)
 Begin
  Begin TRY
      IF EXISTS (SELECT 1 FROM Track WHERE Track_ID = @id)
	  Begin 
	  update Track
	  set 
	  Track_ID=ISNULL(@id,Track_ID),
	  Track_Name=isnull(@Track_name,Track_Name)
	  where Track_id=@id
	 SELECT 1 AS Status, 'Track updated successfully' AS Message
	  END
        ELSE
        BEGIN
            SELECT 0 AS Status, 'Student not found' AS Message
        END
		   END TRY
    BEGIN CATCH
        SELECT -1 AS Status, ERROR_MESSAGE() AS Message
    END CATCH
End

------------------------------------------------

Select  procedure for track table

create proc select_Track 
@id int
AS
Begin
if exists(select 1 from Track where Track_ID=@id)

SELECT * FROM Track WHERE Track_ID = @id
else
 SELECT 'Track not found' AS Message
End

----------------------------------

----insert procedure for track table

create proc insert_track 
@id int,
@Track_name nvarchar(50)
AS 
Begin
if Exists( Select 1 from Track where Track_ID= @id)

 SELECT 'The Track Already exists'
 else
 Begin
 insert into Track (Track_ID, Track_Name)
 values(@id , @Track_name)
 End
End

---------------------------------------------
--## stored procedures for Branch table

--delete procedure for Branch table

create proc delete_Branch @id int
AS
if exists(select * from Branch where Branch_ID=@id)
Begin 
delete from dbo.Branch 
where Branch_ID = @id
 SELECT 'Branch Deleted Successfully'
End
Else
 SELECT 'Branch Does Not Exist Successfully'

 ----------------------------------------------------
  --update procedure for Branch table
 
 create proc update_Branch 
 @id int,
 @Track_name nvarchar(50)=null
 AS 
 if Exists ( select 1 from Track where Branch_ID=@id)
 Begin
  Begin TRY
      IF EXISTS (SELECT 1 FROM Track WHERE Branch_ID=@id)
	  Begin 
	  update Branch
	  set 
	  Branch_ID=ISNULL(@id,Branch_ID),
	  Track_Name=isnull(@Track_name,Track_Name)
	  where Branch_ID=@id
	 SELECT 1 AS Status, 'Branch updated successfully' AS Message
	  END
        ELSE
        BEGIN
            SELECT 0 AS Status, 'Branch not found' AS Message
        END
		   END TRY
    BEGIN CATCH
        SELECT -1 AS Status, ERROR_MESSAGE() AS Message
    END CATCH
End

----------------------------------
--Select  procedure for Branch table

create proc select_Branch 
@id int
AS
Begin
if exists(select 1 from Branch where Branch_ID=@id)

SELECT * FROM Branch WHERE Branch_ID=@id
else
 SELECT 'Branch not found' AS Message
End

----------------------------------
--insert procedure for Branch table

create proc insert_Branch 
@id int,
@Track_name nvarchar(50)
AS 
Begin
if Exists( Select 1 from Branch where Branch_ID=@id)

 SELECT 'The Branch Already exists'
 else
 Begin
 insert into Branch(Branch_ID, Track_Name)
 values(@id , @Track_name)
 End
End

-----------------------------------
--## Stored procedure for Branch_Track table


--delete procedure for Branch_track table

create proc delete_Branch_Track 
@Branch_id int,
@Track_id int
AS
if exists(select * from Branch_Track where Branch_ID=@Branch_id AND Track_ID=@Track_id)
Begin 
delete from dbo.Branch_Track 
where Branch_ID=@Branch_id AND Track_ID=@Track_id
 SELECT 'Branch_Track Deleted Successfully'
End
Else
 SELECT 'Branch_Track Does Not Exist Successfully'

------------------------------------------
--insert procedure for Branch_Track table

create proc insert_Branch_Track 
@Track_id int,
@Branch_id int
AS 
Begin
if Exists( Select 1 from Branch_Track where Branch_ID=@Branch_id AND Track_ID=@Track_id)

 SELECT 'The Branch Already exists'
 else
 Begin
 insert into Branch_Track(Branch_ID, Track_ID)
 values(@Branch_id,@Track_id)
 End
End

-------------------------------
--## Stored procedures for Course_Track Table


--delete procedure for Course_track table

create proc delete_Course_Track 
@Course_id int,
@Track_id int
AS
if exists(select * from Course_Track where Course_ID=@Course_id AND Track_ID=@Track_id)
Begin 
delete from dbo.Course_Track 
where Course_ID=@Course_id AND Track_ID=@Track_id
 SELECT 'course_Track Deleted Successfully'
End
Else
 SELECT 'Course_Track Does Not Exist Successfully'

------------------------------------------
--insert procedure for Course_Track table

create proc insert_Course_Track 
@Track_id int,
@Course_id int
AS 
Begin
if Exists( Select 1 from Course_Track where Course_ID=@Course_id AND Track_ID=@Track_id)

 SELECT 'The Course_Track Already exists'
 else
 Begin
 insert into Course_Track(Course_ID, Track_ID)
 values(@Course_id,@Track_id)
 End
End


--------------------------------------------------------------------------------------------------------------------------------------------


-- ========================================
-- STORED PROCEDURES FOR ANSWER
-- ========================================
CREATE PROCEDURE Select_Answer_ByStudent
    @Student_ID INT
AS
BEGIN
    SELECT * FROM Answer WHERE Student_ID = @Student_ID;
END
GO


CREATE PROCEDURE Insert_Answer
    @Student_ID INT,
    @Question_ID INT,
    @Exam_ID INT,
    @Grade INT,
    @Student_Answer NVARCHAR(255)
AS
BEGIN
    INSERT INTO Answer (Student_ID, Question_ID, Exam_ID, Grade, Student_Answer)
    VALUES (@Student_ID, @Question_ID, @Exam_ID, @Grade, @Student_Answer);
END
GO

CREATE PROCEDURE Update_Answer
   @Student_ID INT,
   @Question_ID INT,
   @Exam_ID INT,
   @Grade INT,
   @Student_Answer NVARCHAR(255)
AS
BEGIN
    UPDATE Answer
    SET Grade = @Grade,
        Student_Answer = @Student_Answer
    WHERE Student_ID = @Student_ID AND Question_ID = @Question_ID AND Exam_ID = @Exam_ID;
END
GO

CREATE PROCEDURE Delete_Answer
   @Student_ID INT,
   @Question_ID INT,
   @Exam_ID INT
AS
BEGIN
    DELETE FROM Answer
    WHERE  Student_ID = @Student_ID AND Question_ID = @Question_ID AND Exam_ID = @Exam_ID;
END
GO

-- ========================================
-- STORED PROCEDURES FOR DEPARTMENT
-- ========================================
CREATE PROCEDURE Select_Department_ByID
    @Department_ID INT
AS
BEGIN
    SELECT * FROM Department WHERE Department_ID = @Department_ID;
END
GO


CREATE PROCEDURE Insert_Department
    @Department_Name NVARCHAR(100),
    @Department_ID INT

AS
BEGIN
    INSERT INTO Department (Department_Name, Department_ID)
    VALUES (@Department_Name, @Department_ID);
END
GO

CREATE PROCEDURE Update_Department
    @Department_ID INT,
    @Department_Name NVARCHAR(100)
  
AS
BEGIN
    UPDATE Department
    SET Department_Name = @Department_Name
    WHERE Department_ID = @Department_ID;
END
GO

CREATE PROCEDURE Delete_Department
    @Department_ID INT
AS
BEGIN
    DELETE FROM Department
    WHERE Department_ID = @Department_ID;
END
GO

-- ========================================
-- STORED PROCEDURES FOR Department Branch
-- ========================================

CREATE PROCEDURE Select_Department_Branch_ByDepartment
    @Department_ID INT
AS
BEGIN
    SELECT * FROM [Department Branch]
    WHERE Department_ID = @Department_ID;
END
GO



CREATE PROCEDURE Insert_Department_Branch
    @Department_ID INT,
    @Branch_ID INT
AS
BEGIN
    INSERT INTO [Department Branch] (Department_ID, Branch_ID)
    VALUES (@Department_ID, @Branch_ID);
END
GO


CREATE PROCEDURE Delete_Department_Branch
    @Department_ID INT,
    @Branch_ID INT
AS
BEGIN
    DELETE FROM [Department Branch]
    WHERE Department_ID = @Department_ID AND Branch_ID = @Branch_ID;
END
GO




-- ========================================
-- STORED PROCEDURES FOR Exam_Quastions
-- ========================================

CREATE PROCEDURE Select_Exam_Questions_ByExam
    @Exam_ID INT
AS
BEGIN
    SELECT * FROM Exam_Quastions
    WHERE Exam_ID = @Exam_ID;
END
GO


CREATE PROCEDURE Delete_Exam_Question
    @Exam_ID INT,
    @Question_ID INT
AS
BEGIN
    DELETE FROM Exam_Quastions
    WHERE Exam_ID = @Exam_ID AND Question_ID = @Question_ID;
END
GO


CREATE PROCEDURE Insert_Exam_Question
    @Exam_ID INT,
    @Question_ID INT
AS
BEGIN
    INSERT INTO Exam_Quastions (Exam_ID, Question_ID)
    VALUES (@Exam_ID, @Question_ID);
END
GO


-- ========================================
-- STORED PROCEDURES FOR STUDENT_COURSES
-- ========================================
CREATE PROCEDURE Select_StudentCourses_ByStudent
    @Student_ID INT
AS
BEGIN
    SELECT * FROM Student_Courses WHERE Student_ID = @Student_ID;
END
GO


CREATE PROCEDURE Insert_StudentCourse
    @Student_ID INT,
    @Course_ID INT,
    @Difficulty_Score INT,
    @Industry_Relevance_Score INT,
    @Instructor_Effectiveness_Score INT
AS
BEGIN
    INSERT INTO Student_Courses (Student_ID, Course_ID, Difficulty_Score, Industry_Relevance_Score, Instructor_Effectiveness_Score)
    VALUES (@Student_ID, @Course_ID, @Difficulty_Score, @Industry_Relevance_Score, @Instructor_Effectiveness_Score);
END
GO

CREATE PROCEDURE Update_StudentCourse
    @Student_ID INT,
    @Course_ID INT,
    @Difficulty_Score INT,
    @Industry_Relevance_Score INT,
    @Instructor_Effectiveness_Score INT
AS
BEGIN
    UPDATE Student_Courses
    SET 
        Difficulty_Score = @Difficulty_Score,
        Industry_Relevance_Score = @Industry_Relevance_Score,
        Instructor_Effectiveness_Score = @Instructor_Effectiveness_Score
    WHERE Student_ID = @Student_ID AND Course_ID = @Course_ID;
END
GO


CREATE PROCEDURE Delete_StudentCourse
    @Student_ID INT,
    @Course_ID INT
AS
BEGIN
    DELETE FROM Student_Courses
    WHERE Student_ID = @Student_ID AND Course_ID = @Course_ID;
END
GO

-- ========================================
-- STORED PROCEDURES FOR TOPIC
-- ========================================
CREATE PROCEDURE Select_Topic_ByCourse
    @Course_ID INT
AS
BEGIN
    SELECT * FROM Topic WHERE Course_ID = @Course_ID;
END
GO


CREATE PROCEDURE sp_Insert_Topic
    @Topic_Name NVARCHAR(100),
    @Course_ID INT
AS
BEGIN
    INSERT INTO Topic (Topic_Name, Course_ID)
    VALUES (@Topic_Name, @Course_ID);
END
GO

CREATE PROCEDURE Update_Topic
    @Topic_ID INT,
    @Topic_Name NVARCHAR(100),
    @Course_ID INT
AS
BEGIN
    UPDATE Topic
    SET Topic_Name = @Topic_Name,
        Course_ID = @Course_ID
    WHERE Topic_ID = @Topic_ID;
END
GO

CREATE PROCEDURE Delete_Topic
    @Topic_ID INT
AS
BEGIN
    DELETE FROM Topic
    WHERE Topic_ID = @Topic_ID;
END
GO

-- ========================================
-- STORED PROCEDURES FOR STUDENT_EXAM
-- ========================================
CREATE PROCEDURE Select_StudentExam_ByStudent
    @Student_ID INT
AS
BEGIN
    SELECT * FROM Student_Exam WHERE Student_ID = @Student_ID;
END
GO


CREATE PROCEDURE sp_Insert_StudentExam
    @Student_ID INT,
    @Exam_ID INT,
    @Difficulty_Score NVARCHAR(50),
    @Clarity_Score NVARCHAR(50),
    @Relevances_Score NVARCHAR(50)
AS
BEGIN
    INSERT INTO Student_Exam (Student_ID, Exam_ID,Difficulty_Score, Clarity_Score, Relevances_Score)
    VALUES (@Student_ID, @Exam_ID,@Difficulty_Score, @Clarity_Score, @Relevances_Score);
END
GO

CREATE PROCEDURE Update_StudentExam
    @Student_ID INT,
    @Exam_ID INT,
    @Difficulty_Score NVARCHAR(50),
    @Clarity_Score NVARCHAR(50),
    @Relevances_Score NVARCHAR(50)

AS
BEGIN
    UPDATE Student_Exam
    SET 
        Difficulty_Score = @Difficulty_Score,
        Clarity_Score = @Clarity_Score,
        Relevances_Score = @Relevances_Score
    WHERE Student_ID = @Student_ID AND Exam_ID = @Exam_ID;
END
GO

CREATE PROCEDURE Delete_StudentExam
    @Student_ID INT,
    @Exam_ID INT
AS
BEGIN
    DELETE FROM Student_Exam
    WHERE Student_ID = @Student_ID AND Exam_ID = @Exam_ID;
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Stored for delete a student

CREATE PROC DeleteStudent @id int
AS 
BEGIN TRY 
   IF EXISTS(SELECT 1 FROM student WHERE Student_ID = @id)
   BEGIN
     DELETE FROM student WHERE Student_ID = @id
	 SELECT 'Student has been deleted successfully'
   END
   ELSE 
      SELECT 'Error The student doesn''t exist'
END TRY
BEGIN CATCH
  SELECT 'An unexpected error occurred. Please try again.';
   END CATCH

--Stored for Inserting a student 

create PROC InsertStudent @id INT, @fname NVARCHAR(20), @lname NVARCHAR(20), @gender NVARCHAR(10),
@company_name NVARCHAR(30),@position  NVARCHAR(50), @address NVARCHAR(50),@phone VARCHAR(50),
@Grad_year DATE, @birthdate DATE,@freelance BIT,@track_id INT, @Email VARCHAR(100), @PASSWORD VARCHAR(100)
AS
IF EXISTS (SELECT 1 FROM student WHERE Student_ID = @id)
  BEGIN
    SELECT 'Error Student  already Exists'
  END
ELSE
   begin
   INSERT INTO student 
   VALUES( @fname, @lname, @gender ,
@company_name,@position, @address ,@phone ,
@Grad_year , @birthdate ,@freelance ,@track_id, @Email, @PASSWORD)
  END

--Stored for selecting from Student 

CREATE PROC SelectStudent @id INT
AS
begin
  IF EXISTS (SELECT 1 FROM student WHERE student_id = @id)
    BEGIN
	  SELECT * FROM student WHERE student_id = @id
	END
 ELSE 
    SELECT 'Student not found'
END

--Stored for updating student table

CREATE PROC UpdateStudent @id INT, @fname NVARCHAR(20) = NULL, @lname NVARCHAR(20)= NULL, @gender NVARCHAR(10)= NULL,
@company_name NVARCHAR(30)= NULL,@position  NVARCHAR(50)= NULL, @address NVARCHAR(50)= NULL,@phone VARCHAR(50)= NULL,
@Grad_year DATE= NULL, @birthdate DATE= NULL,@freelance BIT= NULL,@track_id INT= NULL, @Email VARCHAR(100)= NULL, @PASSWORD VARCHAR(100)= NULL
AS 
begin
BEGIN TRY
   IF EXISTS(SELECT 0 FROM dbo.Student WHERE Student_ID =@id)
     BEGIN
	   UPDATE student 
	   SET fname = ISNULL(@fname,fname),
            lname = ISNULL(@lname, lname),
            gender = ISNULL(@gender, gender),
            company_name = ISNULL(@company_name, company_name),
            position = ISNULL(@position, position),
            address = ISNULL(@address, address),
            phone = ISNULL(@phone, phone),
            Graduation_Year= ISNULL(@Grad_year, Graduation_Year),
            birthdate = ISNULL(@birthdate, birthdate),
            freelance = ISNULL(@freelance, freelance),
            track_id = ISNULL(@track_id, track_id),
            Email = ISNULL(@Email, Email),
            PASSWORD = ISNULL(@PASSWORD, PASSWORD)
	      WHERE Student_ID = @id
	  SELECT'Student Updated Successfully'  
     END
	 ELSE
       SELECT 'Student Doesn''t Exist'
END TRY
BEGIN CATCH
    SELECT 'An unexpected error occurred. Please try again.'
END CATCH
END



--Stored for delete an Exam

CREATE PROC DeleteExam @id INT
as 
   BEGIN
       BEGIN TRY
	     IF EXISTS( SELECT NULL FROM dbo.Exam WHERE Exam_ID = @id)
	       DELETE FROM dbo.Exam WHERE Exam_ID = @id
		 ELSE
           SELECT 'Exam Doesn''t exist'
	   END TRY
	   BEGIN CATCH
	     SELECT 'An unexpected error occurred. Please try again.'
	   END CATCH
   END


--Stored for Inserting an Exam

CREATE PROC InsertExam @ID INT,@Duration TIME,@Start_Date DATETIME,@End_Date DATETIME,
@Total_Grade int,@Passing_Grade int	,@Number_MCQ int,@Number_TF int	,@Course_ID INT ,@Instructor_ID int	,@Is_Corrective BIT
AS 
begin
BEGIN TRY
    IF EXISTS(SELECT 0 FROM exam WHERE Exam_ID = @id)
	   SELECT 'The Exam Already Exists'
	ELSE
      BEGIN
	     INSERT INTO exam 
		 VALUES(@Duration,@Start_Date,@End_Date ,
@Total_Grade,@Passing_Grade ,@Number_MCQ ,@Number_TF ,@Course_ID ,@Instructor_ID ,@Is_Corrective )
	  END
END TRY
BEGIN CATCH
     SELECT 'An unexpected error occurred. Please try again.'
	  ,ERROR_MESSAGE();
END CATCH
END


--Stored for selecting an exam

CREATE PROC SelectExam @id int
AS 
if EXISTS(SELECT 1 FROM dbo.Exam WHERE Exam_ID=@id)
   SELECT * FROM exam WHERE Exam_ID = @id
ELSE 
 SELECT 'Exam Doesn''t Exist'


 --Stored for update exam

 CREATE PROC UpdateExam  @id INT,@Duration TIME = null,@Start_Date DATETIME=null,@End_Date DATETIME=null,
@Total_Grade int=null,@Passing_Grade int=null	,@Number_MCQ int=null,@Number_TF INT =null,@Course_ID INT=null ,@Instructor_ID int	=null,@Is_Corrective BIT=null
 AS 
 begin
 BEGIN TRY
    IF EXISTS(SELECT 1 FROM exam WHERE Exam_ID =@id)
	  UPDATE dbo.Exam
	      SET Duration   = ISNULL(@duration,duration),
		     start_date  = ISNULL(@Start_Date, Start_Date),
            End_Date     = ISNULL(@End_Date, End_Date),
            Total_Grade  = ISNULL(@Total_Grade, Total_Grade),
            Passing_Grade= ISNULL(@Passing_Grade, Passing_Grade),
            Number_MCQ   = ISNULL(@Number_MCQ, Number_MCQ),
            Number_TF    = ISNULL(@Number_TF, Number_TF),
            Course_ID    = ISNULL(@Course_ID, Course_ID),
            Instructor_ID= ISNULL(@Instructor_ID, Instructor_ID),
            Is_Corrective= ISNULL(@Is_Corrective, Is_Corrective)
			WHERE Exam_ID = @id
		ELSE
          SELECT 'Exam Doesn''t Exist'
 END TRY
 BEGIN CATCH
          SELECT 'An unexpected error occurred. Please try again.'
 END CATCH
 END 


 --Stored for deleting from Student_Certificate
 
 CREATE PROC DeleteCertificate @id INT , @certificate NVARCHAR(50)
 AS 
 BEGIN TRY
   IF EXISTS(SELECT 1 FROM dbo.Student_Certificate WHERE Student_ID = @id AND Certificate = @certificate)
        begin
	 DELETE FROM dbo.Student_Certificate WHERE Student_ID = @id AND Certificate =@certificate
	     SELECT 'Deleted Successfully'
         END
        ELSE 
		  SELECT 'The Row doesn''t Exist'
 END TRY
   BEGIN CATCH
      SELECT 'An unexpected error occurred. Please try again.'
   END CATCH


--Stored to Insert into Student_Certificate

CREATE PROC InsertCertificate @id INT, @certificate NVARCHAR(50)
AS
begin
BEGIN TRY
     IF EXISTS(SELECT 1 FROM dbo.Student_Certificate WHERE Student_ID = @id AND Certificate = @certificate)
	     SELECT 'The Row already exists'
	 ELSE
        BEGIN
		  INSERT INTO student_certificate
		  VALUES(@id,@certificate)
        END
END TRY
BEGIN CATCH
       SELECT 'An unexpected error occurred. Please try again.'
END CATCH
END


--Stored to delete Instructor

CREATE PROC DeleteInstructor @id INT
AS 
BEGIN
  BEGIN try
     IF EXISTS (SELECT 1 FROM dbo.Instructor WHERE Instructor_ID = @id)
	   BEGIN
		DELETE FROM dbo.Instructor WHERE Instructor_ID = @id
		SELECT 'Instructor has been deleted successfully'
       END
	 ELSE
       SELECT 'Instructor Doesn''t exist'
  END TRY
  BEGIN CATCH
      SELECT 'An unexpected error occurred. Please try again.'
  END CATCH
END


--Stored to Insert an Instructor

CREATE PROC InsertInstructor  
    @ID INT,
    @Fname NVARCHAR(30),
    @Lname NVARCHAR(30),
    @Gender NVARCHAR(30),
    @Phone TINYINT,
    @Start_Date DATE,
    @Birthdate DATE,
    @Address NVARCHAR(50),
    @Supervisor_ID INT,
    @Department_ID INT
AS 
BEGIN
   BEGIN TRY
       IF EXISTS(SELECT 1 FROM dbo.Instructor WHERE Instructor_ID = @ID)
       BEGIN
           SELECT 'The Instructor already exists.';
       END
       INSERT INTO Instructor 
           (Fname, Lname, Gender, Phone, Start_Date, Birthdate, Address, Supervisor_ID, Department_ID)
       VALUES 
           (@Fname, @Lname, @Gender, @Phone, @Start_Date, @Birthdate, @Address, @Supervisor_ID, @Department_ID);
   END TRY
   BEGIN CATCH
       SELECT 'An unexpected error occurred. Please try again.';
   END CATCH
END;

--Stored to select an Instructor

CREATE PROC SelectInstructor @id int
AS 
if EXISTS(SELECT 1 FROM dbo.Instructor WHERE Instructor_ID=@id)
   SELECT * FROM exam WHERE Instructor_ID = @id
ELSE 
 SELECT 'Instructor Doesn''t Exist'


 --Stored to update instructor
 CREATE PROC UpdateInstructor 
  @ID INT,
    @Fname NVARCHAR(30)=NULL,
    @Lname NVARCHAR(30)=NULL,
    @Gender NVARCHAR(30)=NULL,
    @Phone TINYINT=NULL,
    @Start_Date DATE=NULL,
    @Birthdate DATE=NULL,
    @Address NVARCHAR(50)=NULL,
    @Supervisor_ID INT=NULL,
    @Department_ID INT=NULL
AS
 BEGIN
    BEGIN TRY
	    IF EXISTS(SELECT 1 FROM dbo.Instructor WHERE Instructor_ID=@id)
		 BEGIN 
		  UPDATE dbo.Instructor
			SET Fname = ISNULL(@fname,fname),
	        Lname = ISNULL(@Lname, Lname),
            Gender = ISNULL(@Gender, Gender),
            Phone = ISNULL(@Phone, Phone),
            Start_Date = ISNULL(@Start_Date, Start_Date),
            Birthdate = ISNULL(@Birthdate, Birthdate),
            Address = ISNULL(@Address, Address),
            Supervisor_ID = ISNULL(@Supervisor_ID, Supervisor_ID),
            Department_ID = ISNULL(@Department_ID, Department_ID)
           WHERE Instructor_ID = @ID;
		END
		ELSE
          SELECT'The Instructor Doesn''t exist'
	END TRY
	BEGIN CATCH
	    SELECT 'An unexpected error occurred. Please try again.';
	END CATCH
 END
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
