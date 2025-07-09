
--Stored For generating random exam

alter PROC Create_Random_Exam 
@Duration TIME,
@start_date DATETIME,
@end_date DATETIME,
@Total_Grade INT,  --25 always
@passing_grade INT, -- 15 always
@No_MCQ int,
@No_TF int,
@ins_id INT,
@crs_id INT,
@is_corrective BIT  --0 or 1
AS 
BEGIN
BEGIN TRY
  declare @exam_id int
    IF NOT EXISTS(SELECT 1 FROM dbo.Instructor WHERE Instructor_ID = @ins_id)
	     begin
             SELECT 'The Instructor Doesn''t exist'
			 RETURN;
		  END
	 IF NOT EXISTS(SELECT 1 FROM dbo.Courses WHERE Course_ID = @crs_id)
	   begin
             SELECT 'The Course Doesn''t exist'
			 RETURN;
		END

	 IF  @No_MCQ > 10
    BEGIN
        SELECT 'The number of MCQ Questions doesn''t match the specified number of questions or exceeds 10' AS Message;
        RETURN;
    END
    ELSE IF @No_TF > 10
    BEGIN
        SELECT 'The number of T/F Questions doesn''t match the specified number of questions or exceeds 10' AS Message;
        RETURN;
    END
    ELSE
	  begin
	   INSERT INTO exam (Duration,Start_Date,End_Date,Total_Grade,Passing_Grade,Number_MCQ,Number_TF,Course_ID,Instructor_ID,Is_Corrective)
	   VALUES (@duration,@start_date,@end_date,@total_grade,@passing_grade,@No_MCQ,@No_TF,@crs_id,@ins_id,@is_corrective)
	   SET @exam_id = SCOPE_IDENTITY()
	   INSERT INTO exam_quastions (Exam_ID,Question_ID)
	   SELECT TOP 5 @exam_id,Question_ID
	    FROM dbo.Questions 
		WHERE type ='MCQ' and course_id = @crs_id
		ORDER BY NEWID()

		INSERT INTO exam_Quastions (Exam_ID,Question_ID)
		SELECT TOP 5 @exam_id,Question_ID
		FROM dbo.Questions
		WHERE type = 'True/False' and course_id = @crs_id
		ORDER BY NEWID()
	   end
END TRY
BEGIN CATCH
    SELECT 'An unexpected error occurred. Please try again.'
END CATCH
END


-----------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


--Stored for creating a manual exam

CREATE PROC create_manual_exam
    @examid INT OUTPUT,
    @total_grade INT,
    @start_date DATETIME,
    @end_date DATETIME,
    @ins_id INT,
    @crs_id INT,
    @Is_corrective BIT,
    @Duration time,
    @passing_grade INT,
    @NO_MCQ INT,
    @NO_TF INT,
    @MCQ_questions_ids VARCHAR(MAX),
    @TF_questions_ids VARCHAR(MAX)
AS
BEGIN TRY

    IF NOT EXISTS (SELECT 1 FROM Instructor WHERE Instructor_ID = @ins_id)
    BEGIN
        SELECT 'Instructor Doesn''t exist' AS Message;
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Courses WHERE Course_ID = @crs_id)
    BEGIN
        SELECT 'Course doesn''t exist' AS Message;
        RETURN;
    END

    IF LEN(@MCQ_questions_ids) - LEN(REPLACE(@MCQ_questions_ids, ',', '')) + 1 != @NO_MCQ OR @NO_MCQ > 10
    BEGIN
        SELECT 'The number of MCQ_ids doesn''t match the specified number of questions or exceeds 10' AS Message;
        RETURN;
    END
    ELSE IF LEN(@TF_questions_ids) - LEN(REPLACE(@TF_questions_ids, ',', '')) + 1 != @NO_TF OR @NO_TF > 10
    BEGIN
        SELECT 'The number of T/F_ids doesn''t match the specified number of questions or exceeds 10' AS Message;
        RETURN;
    END
    ELSE
    BEGIN
        -- Insert into Exam
        INSERT INTO Exam (Duration, Start_Date, End_Date, Total_Grade, Passing_Grade, Number_MCQ, Number_TF, Course_ID, Instructor_ID, Is_Corrective)
        VALUES (@Duration, @start_date, @end_date, @total_grade, @passing_grade, @NO_MCQ, @NO_TF, @crs_id, @ins_id, @Is_corrective);

        -- Set the output exam ID
        SET @examid = SCOPE_IDENTITY();

        -- Insert MCQ Questions
        INSERT INTO Exam_Quastions (Exam_ID, Question_ID)
        SELECT @examid, CAST(value AS INT)
        FROM STRING_SPLIT(@MCQ_questions_ids, ',') s
        JOIN Questions q ON CAST(s.value AS INT) = q.Question_ID
        WHERE q.Course_ID = @crs_id;

        -- Insert T/F Questions
        INSERT INTO Exam_Quastions (Exam_ID, Question_ID)
        SELECT @examid, CAST(value AS INT)
        FROM STRING_SPLIT(@TF_questions_ids, ',') s
        JOIN Questions q ON CAST(s.value AS INT) = q.Question_ID
        WHERE q.Course_ID = @crs_id;

        PRINT 'Exam created successfully with selected questions.';
    END

END TRY
BEGIN CATCH
    SELECT 'Unexpected error happened. Please try again.' AS Message;
END CATCH

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Stored for saving Student Answer

alter PROC save_student_answer 
@st_id INT,
@Questions_id NVARCHAR(MAX),
@exam_id INT,
@st_answers Nvarchar(max),
@student_enter_exam_date DATETIME
as
BEGIN
BEGIN TRY
IF NOT EXISTS(SELECT 1 FROM exam WHERE Exam_ID =@exam_id)
SELECT 'Exam doesn''t exist'

IF NOT EXISTS (SELECT 1 FROM student WHERE Student_ID =@st_id)
SELECT 'student doesn''t exist'

DECLARE  @end_date DATETIME
SELECT @end_date = End_Date
FROM dbo.Exam
WHERE Exam_ID = @exam_id

IF @student_enter_exam_date < @end_date
BEGIN
   SET @st_answers = REPLACE(@st_answers,',','')
   DECLARE @counter INT = 1 , @question_id INT, @answer NVARCHAR(1) 
   WHILE LEN(@Questions_id) > 0
   BEGIN
       IF CHARINDEX(',',@Questions_id) > 0
	begin
	    SET @question_id = CAST(LEFT(@Questions_id,CHARINDEX(',',@Questions_id)-1) AS int)
		SET @Questions_id = SUBSTRING(@Questions_id,CHARINDEX(',',@Questions_id) +1,LEN(@Questions_id))
   END
   ELSE
    BEGIN
	     SET @question_id = CAST(@Questions_id AS int)
		 SET @Questions_id = ''
    END
	   SET @answer = SUBSTRING(@st_answers, @counter,1)

	   insert INTO answer (Student_ID,Question_ID,Exam_ID,Student_Answer)
	   VALUES(@st_id,@question_id,@exam_id,@answer)

	   PRINT 'Answer saved sucessfully for ' +CAST(@question_id AS nvarchar(10))
	   SET @counter += 1
END
END
ELSE
  SELECT 'The exam deadline passed.' 
END TRY
BEGIN CATCH
    PRINT 'An unexpected error occurred. Details:';
    PRINT ERROR_MESSAGE();
    PRINT 'Line: ' + CAST(ERROR_LINE() AS NVARCHAR);
    PRINT 'Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'Unknown');
END CATCH

END


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

-- Stored for correcting the exam

CREATE PROC CorrectExam 
@exam_id int
AS 
BEGIN
BEGIN TRY
 UPDATE answer SET grade = CASE when Student_Answer = model_answer THEN marks
 ELSE 0 end
 FROM dbo.Answer a JOIN dbo.Questions q ON q.Question_ID = a.Question_ID
WHERE Exam_ID = @exam_id

PRINT 'Student exam Answers has correced Successfully.'
 END TRY
 BEGIN CATCH
   PRINT 'An unexpected error occurred. Please try again.';
 END CATCH
 END
 
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

--Stored for calculating the total grades 

alter PROC CalculateTotalgrades_andRate 
@st_id INT,
@exam_id INT
AS
BEGIN 
DECLARE @totalgrades DECIMAL(5,2)

DECLARE @TotalexamG INT = (SELECT SUM(marks) FROM questions q JOIN dbo.Exam_Quastions eq ON eq.Question_ID =q.Question_ID 
JOIN exam e ON e.Exam_ID = eq.Exam_ID
WHERE eq.Exam_ID = @exam_id
)

SELECT @totalgrades = SUM(grade) *100/ @TotalexamG  
FROM answer
WHERE Student_ID = @st_id AND Exam_ID = @exam_id

SELECT    cast(@totalgrades as varchar(10)) + '%' as [Student Exam Grade],CASE WHEN @totalgrades >= .85 * @TotalexamG THEN 'A'
   WHEN @totalgrades BETWEEN .76 * @TotalexamG AND .84 *  @TotalexamG THEN 'B'
   WHEN @totalgrades BETWEEN .5 * @TotalexamG AND .75 *  @TotalexamG THEN 'C'
   WHEN @totalgrades < .5 * @TotalexamG THEN 'Corrective' END AS Rate;
   END
   
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
