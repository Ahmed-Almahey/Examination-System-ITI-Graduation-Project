--ETL Using SQL to move the data from Examination sys Database to the DWH for the Dim_Instructor

INSERT INTO [Examination Sys_DWH].dbo.Dim_Instructor (Name, Gender, Phone, Start_Date, BirthDate, Address, SupervisorID_bk, DepartmentID_bk,InstructorID_bk)
SELECT 
    CONCAT(FName, ' ', LName) AS Name,
    Gender,
    Phone,
    Start_Date,
    BirthDate,
    Address,
    Supervisor_ID,
    Department_ID,
	Instructor_ID
FROM [Examination System].dbo.Instructor;

--ETL for Dim_Student

INSERT INTO [Examination Sys_DWH].dbo.Dim_Student (
    Name,
    Gender,
    Company_Name,
    Position,
    Address,
    Phone,
    Graduation_year,
    BirthDate,
    Freelance,
    TrackID_bk,
    Email,
    BranchID_bk,
	StudentID_bk
)
SELECT 
    CONCAT(s.FName, ' ', s.lName) AS Name,
    s.Gender,
    s.Company_Name,
    s.Position,
    s.Address,
    s.Phone,
    s.Graduation_Year,
    s.BirthDate,
    s.Freelance,
    s.Track_ID,
    s.Email,
    s.Branch_ID,
	s.Student_ID
FROM 
   [Examination System].dbo.Student s
LEFT JOIN 
    [Examination System].dbo.Student_Certificate sc ON s.Student_ID = sc.Student_ID;

--ETL for Dim_Intake

INSERT INTO [Examination Sys_DWH].dbo.Dim_Intake (
    IntakeID_bk,
    Start_Date,
    Intake_NO
)
SELECT
    Intake_ID ,
    Start_Date ,
    Intake_Number 
FROM [Examination System].dbo.Intake;


--ETL for Dim_Course

INSERT INTO [Examination Sys_DWH].dbo.Dim_Course (
    CourseID_BK,
    Course_Name,
    Passing_Garde,
    Max_Grade,
    Credit_Hours,
    Prerequisite,
    Weekly_Hours,
    Student_Number,
    Topic_Name,
    InstructorID_BK
)
SELECT
    c.Course_ID ,
    c.Course_Name,
    c.Passing_Grade,
    c.Max_Grade,
    c.Credit_Hours,
    c.Prerequisite,
    c.Weekly_Hours,
    c.Number_Of_Student,
    t.Topic_Name,
    c.Instructor_ID AS Instructor_ID_BK
FROM [Examination System].dbo.Courses c
LEFT JOIN [Examination System].dbo.Topic t
    ON c.Course_ID = t.Course_ID;

	--ETL for Dim_Track

	INSERT INTO [Examination Sys_DWH].dbo.Dim_Track (
    TrackID_BK,
    Track_Name
)
SELECT
    Track_ID ,
    Track_Name
FROM [Examination System].dbo.Track;

update  t set DepartmentID_bk = tt.department_id 
from
[Examination Sys_DWH].dbo.Dim_Track t join [Examination System].dbo.Track tt
on t.TrackID_bk = tt.Track_ID

--ETL for Dim_Branch

INSERT INTO [Examination Sys_DWH].dbo.Dim_Branch (
    BranchID_BK,
    Branch_Name
)
SELECT
    Branch_ID,
    Branch_Name
FROM [Examination System].dbo.Branch;


--ETL for Dim_Department

INSERT INTO [Examination Sys_DWH].dbo.Dim_Department (
    DepartmentID_BK,
    Department_Name
)
SELECT
    Department_ID,
    Department_Name
FROM [Examination System].dbo.Department;


--ETL for Dim_Exam

INSERT INTO [Examination Sys_DWH].dbo.Dim_Exam (
    ExamID_BK,
    Duration,
    Start_Date,
    End_Date,
    TotalGrades,
    NO_MCQ,
    [NO_T/F],
    Passing_Grade,
    CourseID_BK,
    InstructorID_BK,
    Is_Corrective
)
SELECT
    Exam_ID ,
    Duration,
    Start_Date,
    End_Date,
    Total_Grade ,
    Number_MCQ ,
    Number_TF ,
    Passing_Grade,
    Course_ID ,
    Instructor_ID ,
    Is_Corrective
FROM [Examination System].dbo.Exam;


--ETL for Dim_Questions  

INSERT INTO [Examination Sys_DWH].dbo.Dim_Question (
    Question_Text,
    Marks,
    [Model Answer],
    Type,
    Difficulity_Score,
    CourseID_BK,
    QuestionID_BK
)
SELECT
    Question_Text,
    Marks,
    Model_Answer,
    Type,
    Difficulty_Score,
    Course_ID ,
    Question_ID 
FROM [Examination System].dbo.Questions;


--ETL for Dim_DepartmentBranch

INSERT INTO [Examination Sys_DWH].dbo.Dim_DepartmentBranch(
DepartmentID_fk,
BranchID_fk
)
select  d.departmentID_sk, b.branchID_sk
from  [Examination Sys_DWH].dbo.Dim_Department d
join [Examination System].dbo.[Department Branch]  db
on d.DepartmentID_bk = db.Department_ID  join [Examination Sys_DWH].dbo.Dim_Branch b
on db.Branch_ID = b.BranchID_bk

--ETL for Dim_CourseTrack

Insert into [Examination Sys_DWH].dbo.Dim_CourseTrack(
CourseID_fk,
TrackID_fk
) 
select  c.CourseID_SK, t.trackID_sk
from  [Examination System].dbo.Course_Track ct join  [Examination Sys_DWH].dbo.Dim_Track t
on ct.Track_ID = t.TrackID_bk join (select courseID_bk, min(courseID_sk) as [courseID_sk] from[Examination Sys_DWH].dbo.Dim_Course   group by CourseID_bk)as c
on ct.Course_ID = c.CourseID_bk


--ETL for Dim_ExamQuestions

insert into [Examination Sys_DWH].dbo.[Dim_ExamQuestions]  (ExamID_fk,QuestionID_fk)
select e.examID_sk,q.questionID_sk
from [Examination Sys_DWH].dbo.Dim_Exam e  join [Examination System].dbo.Exam_Quastions eq
on e.ExamID_bk = eq.Exam_ID  join [Examination Sys_DWH].dbo.Dim_Question q
on q.QuestionID_bk = eq.Question_ID

--ETL for Fact_StudentExam

--Step1 Summarization of Answer table
insert into [Examination Sys_DWH].dbo.Fact_StudentExam(StudentID_fk,ExamID_fk,totalgrades)
select s.studentID_sk, e.examID_sk, sum(a.grade)
from [Examination System].dbo.Answer a join [Examination Sys_DWH].dbo.Dim_Exam e 
on a.Exam_ID = e.ExamID_bk join [Examination Sys_DWH].dbo.Dim_Student s 
on s.StudentID_bk = a.Student_ID
group by s.studentID_sk, e.examID_sk

--	Step2 Inserting the TotalMarks and Average_DifficulityScore
update f
set [Sum of marks] = agg.TotalMarks,
 Average_DifficulityScore_FromInstructors = agg.avg_score
 from
[Examination Sys_DWH].dbo.Fact_StudentExam f
join(
select e.examID_sk,sum(q.marks) as TotalMarks, avg(q.Difficulity_Score) as avg_score
from [Examination Sys_DWH].dbo.Dim_Question q join [Examination Sys_DWH].dbo.Dim_ExamQuestions eq
on q.QuestionID_SK = eq.QuestionID_fk join  [Examination Sys_DWH].dbo.Dim_Exam e
on eq.ExamID_fk = e.ExamID_SK
group by e.ExamID_SK
) as agg
on f.ExamID_fk = agg.examID_sk

--step3 insert avg_difficulityscore , avg_clairtyscore, avg_relevancescore
UPDATE f 
SET 
  Average_ClarityScore = se.Clarity_Score,
  Average_DifficulityScore_FromStudents = se.Difficulty_Score,
  Average_RelevanceScore = se.Relevances_Score
FROM Fact_StudentExam f
JOIN Dim_Student s ON f.StudentID_fk = s.StudentID_SK
JOIN Dim_Exam e ON f.ExamID_fk = e.ExamID_SK
JOIN [Examination System].[dbo].Student_Exam se 
  ON s.StudentID_bk = se.Student_ID 
 AND e.ExamID_bk = se.Exam_ID


--Look up the instructorID_fk  
update f
set InstructorID_fk = i.InstructorID_SK
from [Examination Sys_DWH].dbo.Fact_StudentExam  f join [Examination Sys_DWH].dbo.Dim_Exam e
on f.ExamID_fk = e.ExamID_SK join [Examination Sys_DWH].dbo.Dim_Instructor i
on i.InstructorID_bk = e.InstructorID_bk

--Look up the IntakeID_fk
update f 
set IntackID_fk = i.intakeID_sk 
from [Examination Sys_DWH].dbo.Fact_StudentExam  f join [Examination Sys_DWH].dbo.Dim_Student s 
on f.StudentID_fk = s.StudentID_SK join [Examination System].dbo.Branch b
on b.Branch_ID = s.BranchID_bk join  [Examination System].dbo.Intake ii   
on ii.Branch_ID = b.Branch_ID join
[Examination Sys_DWH].dbo.Dim_Intake i
on i.IntakeID_bk = ii.Intake_ID

--Look up the CourseTrackID_FK  
UPDATE f
SET f.CourseTrackID_FK = ct.CourseTrackID_SK
FROM [Examination Sys_DWH].dbo.Fact_StudentExam f
JOIN [Examination Sys_DWH].dbo.Dim_Student s 
    ON f.StudentID_FK = s.StudentID_SK
JOIN [Examination Sys_DWH].dbo.Dim_Exam e 
    ON f.ExamID_FK = e.ExamID_SK
JOIN [Examination Sys_DWH].dbo.Dim_Track t 
    ON s.TrackID_BK = t.TrackID_BK
JOIN [Examination Sys_DWH].dbo.Dim_Course c 
    ON e.CourseID_BK = c.CourseID_BK
JOIN [Examination Sys_DWH].dbo.Dim_CourseTrack ct 
    ON ct.TrackID_FK = t.TrackID_SK
   AND ct.CourseID_FK = c.CourseID_SK

 ------------------------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------------------------ 

 --Checking for missing values
SELECT DISTINCT 
    d.DepartmentID_SK,
    b.BranchID_SK
FROM [Examination Sys_DWH].dbo.Dim_Student s
JOIN [Examination Sys_DWH].dbo.Dim_Track t ON s.TrackID_BK = t.TrackID_BK
JOIN [Examination Sys_DWH].dbo.Dim_Department d ON t.DepartmentID_BK = d.DepartmentID_BK
JOIN [Examination Sys_DWH].dbo.Dim_Branch b ON s.BranchID_BK = b.BranchID_BK
WHERE NOT EXISTS (
    SELECT 1
    FROM [Examination Sys_DWH].dbo.Dim_DepartmentBranch db
    WHERE db.DepartmentID_FK = d.DepartmentID_SK
      AND db.BranchID_FK = b.BranchID_SK
);


-- Add DepartmentID 2 (Data Science) at Branch 8
INSERT INTO [Examination Sys_DWH].dbo.Dim_DepartmentBranch (DepartmentID_FK, BranchID_FK)
VALUES (2, 8);

-- Add DepartmentID 3 (Cybersecurity) at Branch 8
INSERT INTO [Examination Sys_DWH].dbo.Dim_DepartmentBranch (DepartmentID_FK, BranchID_FK)
VALUES (3, 8);


UPDATE f
SET f.DeptBranchID_FK = db.DeptBranchID_SK
FROM [Examination Sys_DWH].dbo.Fact_StudentExam f
JOIN [Examination Sys_DWH].dbo.Dim_Student s ON f.StudentID_FK = s.StudentID_SK
JOIN [Examination Sys_DWH].dbo.Dim_Track t   ON s.TrackID_BK = t.TrackID_BK
JOIN [Examination Sys_DWH].dbo.Dim_Department d ON t.DepartmentID_BK = d.DepartmentID_BK
JOIN [Examination Sys_DWH].dbo.Dim_Branch b ON s.BranchID_BK = b.BranchID_BK
JOIN [Examination Sys_DWH].dbo.Dim_DepartmentBranch db
  ON db.DepartmentID_FK = d.DepartmentID_SK
 AND db.BranchID_FK = b.BranchID_SK;
 ------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------

 --ETL for Dim_Certificate

 insert into [Examination Sys_DWH].dbo.Dim_Certificate (
 Certificate_Name
 )
 select distinct sc.certificate
 from  [Examination System].dbo.Student_Certificate sc

 --ETL for Dim_StudentCertificate

 insert into [Examination Sys_DWH].dbo.Dim_StudentCertificate(
 StudentID_fk,CertificateID_fk
 )
 select s.StudentID_sk, c.certificateID_sk
 from [Examination Sys_DWH].dbo.Dim_Student s join [Examination System].dbo.Student_Certificate sc
 on s.StudentID_bk = sc.Student_ID join 
 [Examination Sys_DWH].dbo.Dim_Certificate c
 on sc.Certificate = c.Certificate_Name

 ---------------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------------

 --ETL for Fact_CourseRate

 with courseMapping as (
 select courseID_bk , min(courseID_sk) AS courseID_sk
 from [Examination Sys_DWH].dbo.Dim_Course
 group by CourseID_bk
 )

 INSERT INTO [Examination Sys_DWH].dbo.Fact_CourseRate (
    DifficulityScore,
    IndustryRelevance_Score,
    InstructorEffectivness_Score,
    StudentID_FK,
    CourseID_FK
)
select sc.Difficulty_Score, sc.Industry_Relevance_Score , sc.Instructor_Effectiveness_Score, s.StudentID_SK , cm.courseID_sk                
from [Examination System].dbo.Student_Courses sc join  [Examination Sys_DWH].dbo.Dim_student s 
on s.studentID_bk = sc.student_id join courseMapping cm 
on sc.Course_ID = cm.courseID_bk

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
