
CREATE DATABASE Advising_Team_32;---Note:Our team is 122, i named it at the very beginning and i had no time to change so i hope i dont get marks deduced
-- Adding 10 records to the Course table
GO;
CREATE PROCEDURE CreateAllTables
AS
    CREATE TABLE Student (
        student_id INT IDENTITY(1,1) PRIMARY KEY,
        f_name VARCHAR(40),
        l_name VARCHAR(40),
        gpa DECIMAL(10, 2),
        faculty VARCHAR(40),
        email VARCHAR(40),
        major VARCHAR(40),
        password VARCHAR(40),
        financial_status BIT,
        semester INT,
        acquired_hours INT,
        assigned_hours INT,
        advisor_id INT,
        UNIQUE(email) -- constraint as each student must have unique email
    );
  
    CREATE TABLE Student_Phone (
        student_id INT,
        phone_number VARCHAR(40),
        PRIMARY KEY (student_id, phone_number),
        FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE NO ACTION
    );
    CREATE TABLE Course (
        course_id INT IDENTITY(1,1) PRIMARY KEY,
        name VARCHAR(40),
        major VARCHAR(40),
        is_offered BIT,
        credit_hours INT,
        semester INT
    );
    CREATE TABLE PreqCourse_course (
        prerequisite_course_id INT,
        course_id INT,
        PRIMARY KEY (prerequisite_course_id, course_id),
        FOREIGN KEY (prerequisite_course_id ) REFERENCES Course( course_id) ON DELETE NO ACTION,
        FOREIGN KEY (course_id ) REFERENCES Course( course_id)ON DELETE NO ACTION--
    );
    DROP TABLE PreqCourse_course;
    CREATE TABLE Instructor (
        instructor_id INT IDENTITY(1,1) PRIMARY KEY,
        name VARCHAR(40),
        email VARCHAR(40),
        faculty VARCHAR(40),
        office VARCHAR(40)
    );
    CREATE TABLE Instructor_Course (
        course_id INT,
        instructor_id INT,
        PRIMARY KEY (course_id, instructor_id),
        FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE NO ACTION,
        FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id) ON DELETE NO ACTION
    );
    DROP TABLE IF EXISTS Instructor_Course;
    CREATE TABLE Student_Instructor_Course_Take (
        student_id INT,
        course_id INT,
        instructor_id INT,
        semester_code VARCHAR(40),
        exam_type VARCHAR(40),
        grade VARCHAR(40),
        PRIMARY KEY (student_id, course_id, semester_code),
        FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE NO ACTION,
        FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE NO ACTION,
        FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id) ON DELETE NO ACTION
    );
    DROP TABLE IF EXISTS Student_Instructor_Course_Take;
    CREATE TABLE Semester (
        semester_code VARCHAR(40) PRIMARY KEY,
        start_date DATE,
        end_date DATE
    );
    CREATE TABLE Course_Semester (
        course_id INT,
        semester_code VARCHAR(40),
        PRIMARY KEY (course_id, semester_code),
        FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE NO ACTION,
        FOREIGN KEY (semester_code) REFERENCES Semester(semester_code) ON DELETE NO ACTION
    );
    DROP TABLE IF EXISTS Course_Semester;
    CREATE TABLE Advisor (
        advisor_id INT IDENTITY(1,1) PRIMARY KEY,
        name VARCHAR(40),
        email VARCHAR(40),
        office VARCHAR(40),
        password VARCHAR(40)
    );
    CREATE TABLE Slot (
        slot_id INT IDENTITY(1,1) PRIMARY KEY,
        day VARCHAR(40),
        time VARCHAR(40),
        location VARCHAR(40),
        course_id INT,
        instructor_id INT,
        FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE NO ACTION,
        FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id) ON DELETE NO ACTION
    );
    CREATE TABLE Graduation_Plan (
        plan_id INT identity(1,1),
        semester_code VARCHAR(40),
        semester_credit_hours INT,
        expected_grad_date DATE,
        advisor_id INT,
        student_id INT,
        PRIMARY KEY(plan_id, semester_code),
        FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id) ON DELETE NO ACTION,
        FOREIGN KEY (student_id) REFERENCES Student(student_id)  ON DELETE NO ACTION
    );
   CREATE TABLE GradPlan_Course (--prob
        plan_id INT,
        semester_code VARCHAR(40),
        course_id INT,
        PRIMARY KEY (plan_id, semester_code, course_id),
        FOREIGN KEY (plan_id,semester_code) REFERENCES Graduation_Plan(plan_id,semester_code)  ON DELETE NO ACTION
    );
    DROP TABLE IF EXISTS GradPlan_Course;
    CREATE TABLE Request (
        request_id INT IDENTITY(1,1) PRIMARY KEY,
        type VARCHAR(40),
        comment VARCHAR(40),
        status VARCHAR(40),
        credit_hours INT,
        student_id INT,
        advisor_id INT,
        course_id INT,
        FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE NO ACTION,
        FOREIGN KEY (advisor_id) REFERENCES Advisor(advisor_id) ON DELETE NO ACTION,
        FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE NO ACTION

    );
    CREATE TABLE MakeUp_Exam (
        exam_id INT IDENTITY(1,1) PRIMARY KEY,
        date DATETIME,
        type VARCHAR(40),
        course_id INT,
        FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE NO ACTION
    );
    CREATE TABLE Exam_Student (
        exam_id INT,
        student_id INT,
        course_id INT,
        PRIMARY KEY (exam_id, student_id),
        FOREIGN KEY (exam_id) REFERENCES MakeUp_Exam(exam_id) ,
        FOREIGN KEY (student_id) REFERENCES Student(student_id)  ON DELETE NO ACTION,
        FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE NO ACTION
    );
    DROP TABLE IF EXISTS Exam_Student;
    CREATE TABLE Payment (
        payment_id INT IDENTITY(1,1) PRIMARY KEY,
        amount INT,
        deadline DATETIME,
        n_installments INT,
        status VARCHAR(40),
        fund_percentage DECIMAL(5, 2),
        start_date DATETIME,
        student_id INT,
        semester_code VARCHAR(40),
        FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE NO ACTION,
        FOREIGN KEY (semester_code) REFERENCES Semester(semester_code) ON DELETE NO ACTION
    );
    CREATE TABLE Installment (
        payment_id INT,
        deadline DATETIME,
        amount INT,
        status VARCHAR(40),
        start_date DATETIME,
        PRIMARY KEY (payment_id, deadline),
        FOREIGN KEY (payment_id) REFERENCES Payment(payment_id) ON DELETE NO ACTION
    );
GO;

CREATE PROCEDURE DropAllTables
AS
    DROP TABLE IF EXISTS GradPlan_Course;
    DROP TABLE IF EXISTS Graduation_Plan;
    DROP TABLE IF EXISTS Request;
    DROP TABLE IF EXISTS Exam_Student;
    DROP TABLE IF EXISTS MakeUp_Exam;
    DROP TABLE IF EXISTS Course_Semester;
    DROP TABLE IF EXISTS Slot;
    DROP TABLE IF EXISTS Instructor_Course;
    DROP TABLE IF EXISTS PreqCourse_course;
    DROP TABLE IF EXISTS Student_Phone;
    DROP TABLE IF EXISTS Installment;
    DROP TABLE IF EXISTS Payment;
    DROP TABLE IF EXISTS Student_Instructor_Course_Take;
    DROP TABLE IF EXISTS Advisor;
    DROP TABLE IF EXISTS Semester;
    DROP TABLE IF EXISTS Instructor;
    DROP TABLE IF EXISTS Course;
    DROP TABLE IF EXISTS Student;
    EXEC DropAllTables
GO;

CREATE PROCEDURE clearAllTables
AS

    DELETE FROM GradPlan_Course;
    DELETE FROM Graduation_Plan;
    DELETE FROM Request;
    DELETE FROM Exam_Student;
    DELETE FROM MakeUp_Exam;
    DELETE FROM Course_Semester;
    DELETE FROM Slot;
    DELETE FROM Instructor_Course;
    DELETE FROM PreqCourse_course;
    DELETE FROM Installment;
    DELETE FROM Payment;
    DELETE FROM Student_Instructor_Course_Take;
    DELETE FROM Advisor;
    DELETE FROM Semester;
    DELETE FROM Instructor;
    DELETE FROM Course;
    DELETE FROM Student;
    EXEC clearAllTables
GO;

CREATE VIEW view_Students AS
SELECT *
FROM Student
WHERE financial_status = 1; 
GO;
SELECT * FROM view_Students;
GO;
DROP VIEW IF EXISTS view_Students;
GO;
CREATE VIEW view_Course_prerequisites AS
SELECT
    c.*,
    p.prerequisite_course_id
FROM
    Course c
LEFT JOIN
    PreqCourse_course p ON c.course_id = p.course_id;

    GO;
    SELECT * FROM view_Course_prerequisites;
    GO;
CREATE VIEW Instructors_AssignedCourses AS
SELECT
    I.*,
    Inc_course.course_id,
    C.name AS course_name,
    C.major AS course_major,
    C.credit_hours,
    C.semester
FROM
    Instructor I
JOIN
    Instructor_Course Inc_course ON I.instructor_id = Inc_course.instructor_id
JOIN
    Course C ON Inc_course.course_id = C.course_id;
    GO;
    SELECT * FROM Instructors_AssignedCourses;
    GO;
CREATE VIEW Student_Payment AS
SELECT
    p.*,
    s.student_id AS student_payment_id,
    s.f_name AS student_first_name,
    s.l_name AS student_last_name,
    s.gpa,
    s.faculty AS student_faculty,
    s.major AS student_major,
    s.email AS student_email
FROM Payment p
INNER JOIN Student s ON p.student_id = s.student_id;
GO;
SELECT * FROM Student_Payment;
GO;
CREATE VIEW Courses_Slots_Instructor AS
SELECT
    c.course_id,
    c.name AS course_name,
    s.slot_id,
    s.day AS slot_day,
    s.time AS slot_time,
    s.location AS slot_location,
    i.name AS instructor_name
FROM Course c
JOIN Course_Semester csem ON c.course_id = csem.course_id
JOIN Slot s ON csem.course_id = s.course_id
JOIN Instructor_Course Inc_course ON c.course_id = Inc_course.course_id AND s.instructor_id = Inc_course.instructor_id
JOIN Instructor i ON Inc_course.instructor_id = i.instructor_id;
GO;
SELECT * FROM Courses_Slots_Instructor;
GO;
CREATE VIEW Courses_MakeupExams AS---details
SELECT
    c.name AS course_name,
    csem.semester_code AS course_semester,
    m_exam.*
FROM Course c
JOIN Course_Semester csem ON c.course_id = csem.course_id
LEFT JOIN MakeUp_Exam m_exam ON c.course_id = m_exam.course_id;
GO;
SELECT * FROM Courses_MakeupExams;
GO;
CREATE VIEW Students_Courses_transcript AS
SELECT
    s.student_id,
    s.f_name+' '+ s.l_name AS student_name,
    student_course.course_id,
    c.name AS course_name,
    c.major,
    c.credit_hours,
    student_course.exam_type,
    student_course.grade AS course_grade,
    csem.semester_code AS course_semester,
    i.name AS instructor_name
FROM Student s
JOIN Student_Instructor_Course_Take student_course ON s.student_id = student_course.student_id
JOIN Course_Semester csem ON student_course.course_id = csem.course_id AND student_course.semester_code = csem.semester_code
JOIN Course c ON student_course.course_id = c.course_id
JOIN Instructor_Course ins_course ON student_course.course_id = ins_course.course_id AND student_course.instructor_id = ins_course.instructor_id
JOIN Instructor i ON ins_course.instructor_id = i.instructor_id;
GO;
SELECT * FROM Students_Courses_transcript;
GO;
CREATE VIEW Semster_offered_Courses AS
SELECT
    CS.course_id,
    C.name AS course_name,
    CS.semester_code
FROM Course_Semester CS
JOIN Course C ON CS.course_id = C.course_id;
GO;
SELECT * FROM Semster_offered_Courses;
GO;
CREATE VIEW Advisors_Graduation_Plan AS
SELECT
    gp.*,
    a.advisor_id AS advisor_id_in_plan,
    a.name AS advisor_name
FROM Graduation_Plan gp
JOIN Advisor a ON gp.advisor_id = a.advisor_id;
GO;
SELECT * FROM Advisors_Graduation_Plan;
GO;
CREATE PROCEDURE Procedures_StudentRegistration
    @firstname VARCHAR(40),
    @lastname VARCHAR(40),
    @password VARCHAR(40),
    @faculty VARCHAR(40),
    @email VARCHAR(40),
    @major VARCHAR(40),
    @semester INT
AS
BEGIN
    DECLARE @regStudent INT;

    INSERT INTO Student (f_name, l_name, password, faculty, email, major, semester)
    VALUES (@firstname, @lastname, @password, @faculty, @email, @major, @semester);

    -- Retrieve the last generated identity value
    SET @regStudent = SCOPE_IDENTITY();

    SELECT @regStudent AS student_id;
END;
DECLARE @regStudentID INT;
EXEC Procedures_StudentRegistration
    @firstname = 'Marwan',
    @lastname = 'Allam',
    @password = 'secure123',
    @faculty = 'met',
    @email = 'marwan.allam@example.com',
    @major = 'Physics',
    @semester = 1;
SELECT @regStudentID AS student_id;
GO;
CREATE PROCEDURE Procedures_AdvisorRegistration
    @advisorname VARCHAR(40),
    @password VARCHAR(40),
    @email VARCHAR(40),
    @office VARCHAR(40)
AS
BEGIN
    
    DECLARE @regAdvisor INT
    INSERT INTO Advisor (name, password, email, office)
    VALUES (@advisorname, @password, @email, @office);

    SET @regAdvisor = SCOPE_IDENTITY();
    SELECT @regAdvisor AS advisor_id;
END;
DECLARE @AdvisorName VARCHAR(40) = 'Slim';
DECLARE @Password VARCHAR(40) = 'Password';
DECLARE @Email VARCHAR(40) = 'Slim@email.com';
DECLARE @Office VARCHAR(40) = 'c2210';
EXEC Procedures_AdvisorRegistration
    @advisorname = @AdvisorName,
    @password = @Password,
    @email = @Email,
    @office = @Office;
GO;
CREATE PROCEDURE Procedures_AdminListStudents
AS
BEGIN
    SELECT
    s.*
    FROM Student s
    WHERE s.student_id IN (SELECT DISTINCT student_id FROM Student_Instructor_Course_Take);
END;
EXEC Procedures_AdminListStudents;
GO;
CREATE PROCEDURE Procedures_AdminListAdvisors
AS
BEGIN
    SELECT
        a.*
    FROM Advisor a;
END;
EXEC Procedures_AdminListAdvisors;
GO;
CREATE PROCEDURE AdminListStudentsWithAdvisors
AS
BEGIN
    SELECT
        s.student_id,
        s.f_name+' '+s.l_name AS student_name,
        s.email AS student_email,
        s.major,
        a.advisor_id,
        a.name AS advisor_name,
        a.email AS advisor_email,
        a.office AS advisor_office
    FROM Student s
    LEFT JOIN Advisor a ON s.advisor_id = a.advisor_id;
END;
EXEC AdminListStudentsWithAdvisors;
GO;
CREATE PROCEDURE AdminAddingSemester
    @start_date DATE,
    @end_date  DATE,
    @semesterCode VARCHAR(10)
AS
BEGIN
    INSERT INTO Semester (start_date, end_date, semester_code)
    VALUES (@start_date, @end_date, @semesterCode);
END;
DECLARE @startDate DATE = '2023-05-01';
DECLARE @endDate DATE = '2023-10-31';
DECLARE @semesterCode VARCHAR(10) = 's25';
EXEC AdminAddingSemester @startDate, @endDate, @semesterCode;
GO;
CREATE PROCEDURE Procedures_AdminAddingCourse
    @major VARCHAR(40),
    @semester INT,
    @credit_hours INT,
    @course_name VARCHAR(40),
    @offered BIT
AS
BEGIN
    INSERT INTO Course (major, semester, credit_hours, name, is_offered)
    VALUES (@major, @semester, @credit_hours, @course_name, @offered);
END;
DECLARE @major VARCHAR(40) = 'cs';
DECLARE @semester INT = 1;
DECLARE @credit_hours INT = 3;
DECLARE @course_name VARCHAR(40) = 'csen501';
DECLARE @offered BIT = 1;
EXEC Procedures_AdminAddingCourse @major, @semester, @credit_hours, @course_name, @offered;
 GO;
CREATE PROCEDURE Procedures_AdminLinkInstructor
    @InstructorId INT,
    @CourseId INT,
    @SlotId INT
AS
BEGIN
    DECLARE @CurrentSemester VARCHAR(40);
    IF EXISTS (
        SELECT 1
        FROM Slot S
        WHERE S.slot_id = @SlotId
            AND S.course_id IS NULL
            AND S.instructor_id IS NULL
    )
    BEGIN
        UPDATE Slot
        SET course_id = @CourseId, instructor_id = @InstructorId
        WHERE slot_id = @SlotId;

        PRINT 'Instructor linked to the course on the specific slot successfully.';
    END
    ELSE
    BEGIN
        PRINT 'The slot is not available for the given course and instructor in the current semester.';
    END
END;

DECLARE @InstructorId INT = 1; 
DECLARE @CourseId INT = 5;
DECLARE @SlotId INT = 5;

EXEC Procedures_AdminLinkInstructor
    @InstructorId = @InstructorId,
    @CourseId = @CourseId,
    @SlotId = @SlotId;

GO;
CREATE PROCEDURE Procedures_AdminLinkStudents
    @InstructorId INT,
    @StudentId INT,
    @CourseId INT,
    @SemesterCode VARCHAR(40)
AS
BEGIN
    INSERT INTO Student_Instructor_Course_Take (student_id, course_id, instructor_id, semester_code)
    VALUES (@StudentId, @CourseId, @InstructorId, @SemesterCode);
END;
DROP PROC IF EXISTS Procedures_AdminLinkStudents;
EXEC Procedures_AdminLinkStudents
    @InstructorId = 1,
    @StudentId = 10,
    @CourseId = 3,
    @SemesterCode = 's25';----

GO;
CREATE PROCEDURE Procedures_AdminLinkStudentToAdvisor
    @StudentID INT,
    @AdvisorID INT
AS
BEGIN
    UPDATE Student
    SET advisor_id = @AdvisorID
    WHERE student_id = @StudentID;
END;
DECLARE @StudentID INT = 1;
DECLARE @AdvisorID INT = 5; 
EXEC Procedures_AdminLinkStudentToAdvisor
    @StudentID = @StudentID,
    @AdvisorID = @AdvisorID;
GO;
CREATE PROCEDURE Procedures_AdminAddExam
    @Type VARCHAR(40),
    @Date DATETIME,
    @CourseID INT
AS
BEGIN
    INSERT INTO MakeUp_Exam (type, date, course_id)
    VALUES (@Type, @Date, @CourseID);
END;
DECLARE @CourseID INT = 5;
IF EXISTS (SELECT 1 FROM Course WHERE course_id = @CourseID)-----
BEGIN
    EXEC Procedures_AdminAddExam
        @Type = 'Final',
        @Date = '2023-12-01 09:00:00',
        @CourseID = @CourseID;
END
ELSE
BEGIN
    PRINT 'Invalid Course ID';
END;
GO;
CREATE PROCEDURE Procedures_AdminIssueInstallment
    @PaymentID INT
AS
BEGIN
    DECLARE @allInstallments INT;
    DECLARE @Amount DECIMAL(10, 2);
    DECLARE @Date DATETIME;

    SELECT
        @allInstallments = n_installments,
        @Amount = amount,
        @Date = start_date
    FROM Payment
    WHERE payment_id = @PaymentID;


    IF @allInstallments > 0
    BEGIN
        DECLARE @Counter INT = 1;
    
        WHILE @Counter <= @allInstallments
        BEGIN
            INSERT INTO Installment (payment_id, deadline, amount, status)
            VALUES (
                @PaymentID,
                DATEADD(MONTH, @Counter - 1, @Date),
                @Amount,
                'notPaid'
            );

            SET @Counter = @Counter + 1;
        END;
    END;

END;
DECLARE @PaymentID INT = 1;
EXEC Procedures_AdminIssueInstallment @PaymentID;
GO;
CREATE PROCEDURE Procedures_AdminDeleteCourse
    @CourseID INT
AS
BEGIN
    DELETE FROM Slot
    WHERE course_id = @CourseID;

    DELETE FROM Course_Semester
    WHERE course_id = @CourseID;

    DELETE FROM Instructor_Course
    WHERE course_id = @CourseID;

    DELETE FROM Student_Instructor_Course_Take
    WHERE course_id = @CourseID;


    DELETE FROM GradPlan_Course
    WHERE course_id = @CourseID;

    DELETE FROM PreqCourse_course
    WHERE course_id = @CourseID;

    DELETE FROM Course
    WHERE course_id = @CourseID;
END;
DECLARE @CourseID INT = 10;
EXEC Procedures_AdminDeleteCourse @CourseID;
GO;
CREATE PROCEDURE Procedure_AdminUpdateStudentStatus
    @StudentID INT
AS
BEGIN
    DECLARE @StudentStatus BIT;
    IF EXISTS (
        SELECT 1
        FROM Student s
        JOIN Payment p ON s.student_id = p.student_id
        JOIN Installment i ON p.payment_id = i.payment_id
        WHERE s.student_id = @StudentID
            AND s.financial_status = '0' -- means not paid
            AND i.deadline < GETDATE() 
    )
    BEGIN
        SET @StudentStatus = 0;
    END
    ELSE
    BEGIN
        SET @StudentStatus = 1; 
    END
    UPDATE Student
    SET financial_status = @StudentStatus
    WHERE student_id = @StudentID;
END;
DECLARE @StudentID INT = 1;
EXEC Procedure_AdminUpdateStudentStatus @StudentID;
GO;

CREATE VIEW all_Pending_Requests
AS
SELECT
    R.*,
    S.f_name + ' ' + S.l_name AS studentName,
    A.name AS advisorName
FROM Request R
JOIN Student S ON R.student_id = S.student_id
JOIN Advisor A ON R.advisor_id = A.advisor_id
WHERE R.status = 'pending';
GO;
SELECT * FROM all_Pending_Requests;
GO;
CREATE PROCEDURE Procedures_AdminDeleteSlots
    @CurrentSemester VARCHAR(40)
AS
BEGIN
    DELETE FROM Slot
    WHERE course_id IN (
        SELECT C.course_id
        FROM Course C
        WHERE C.is_offered = 0
            OR NOT EXISTS (
                SELECT 1
                FROM Course_Semester CS
                WHERE CS.course_id = C.course_id
                    AND CS.semester_code = @CurrentSemester
            )
    );
END;
EXEC Procedures_AdminDeleteSlots @CurrentSemester = 'w';
GO;

CREATE FUNCTION FN_AdvisorLogin
(
    @ID INT,
    @Password VARCHAR(40)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Success BIT;

    IF EXISTS (
        SELECT 1
        FROM Advisor
        WHERE advisor_id = @ID
            AND password = @Password
    )
    BEGIN
        SET @Success = 1; -- Login success
    END
    ELSE
    BEGIN
        SET @Success = 0; -- Login failed
    END

    RETURN @Success;
END;

GO;
DECLARE @AdvisorID INT = 2;
DECLARE @Password VARCHAR(40) = 'password2';

DECLARE @LoginSuccess BIT;

SET @LoginSuccess = dbo.FN_AdvisorLogin(@AdvisorID, @Password);

SELECT @LoginSuccess AS 'LoginSuccess';

GO;
CREATE PROCEDURE Procedures_AdvisorCreateGP
    @SemCode VARCHAR(40),
    @expected_graduation_date DATE,
    @sem_credit_hours INT,
    @AdvID INT,
    @StudentID INT
AS
BEGIN
    INSERT INTO Graduation_Plan (semester_code, expected_grad_date, semester_credit_hours, advisor_id, student_id)
    VALUES (@SemCode, @expected_graduation_date, @sem_credit_hours, @AdvID, @StudentID);
END;
GO;
DECLARE @SemCode VARCHAR(40) = 's25';-----
DECLARE @ExpectedGraduationDate DATE = '2023-12-31';
DECLARE @SemCreditHours INT = 80; 
DECLARE @AdvID INT = 11;
DECLARE @StudentID INT = 11;

EXEC Procedures_AdvisorCreateGP
    @SemCode = @SemCode,
    @expected_graduation_date = @ExpectedGraduationDate,
    @sem_credit_hours = @SemCreditHours,
    @AdvID = @AdvID,
    @StudentID = @StudentID;

GO;
CREATE PROCEDURE Procedures_AdvisorAddCourseGP
    @studentID INT,
    @semCode VARCHAR(40),
    @courseName VARCHAR(40)
AS
BEGIN
    DECLARE @PlanID INT;
    DECLARE @CourseID INT;
    SELECT @PlanID = plan_id
    FROM Graduation_Plan
    WHERE student_id = @studentID AND semester_code = @semCode;

    SELECT @CourseID = course_id
    FROM Course
    WHERE name = @courseName;
    IF @PlanID IS NOT NULL AND @CourseID IS NOT NULL
    BEGIN
        INSERT INTO GradPlan_Course (plan_id, semester_code, course_id)
        VALUES (@PlanID, @semCode, @CourseID);
    END
    ELSE
    BEGIN
        PRINT 'Unable to retrieve plan_id or course_id.';
    END
END;
DECLARE @StudentID INT = 13;
DECLARE @SemCode VARCHAR(40) = 'w25';
DECLARE @CourseName VARCHAR(40) = 'csen605';
EXEC Procedures_AdvisorAddCourseGP
    @studentID = @StudentID,
    @semCode = @SemCode,
    @courseName = @CourseName;
    GO;
CREATE PROCEDURE Procedures_AdvisorUpdateGP
    @expected_grad_date DATE,
    @studentID INT
AS
BEGIN
    UPDATE Graduation_Plan
    SET expected_grad_date = @expected_grad_date
    WHERE student_id = @studentID;

    PRINT 'Expected graduation date updated successfully.';
END;
DECLARE @ExpectedGradDate DATE = '2023-12-31';
DECLARE @StudentID INT =1 ; 
EXEC Procedures_AdvisorUpdateGP
    @expected_grad_date = @ExpectedGradDate,
    @studentID = @StudentID;
GO;
CREATE PROCEDURE Procedures_AdvisorDeleteFromGP
    @StudentID INT,
    @SemesterCode VARCHAR(40),
    @CourseID INT
AS
BEGIN
    DECLARE @PlanID INT;
    SELECT @PlanID = plan_id
    FROM Graduation_Plan
    WHERE student_id = @StudentID AND semester_code = @SemesterCode;

    IF @PlanID IS NOT NULL
    BEGIN
        DELETE FROM GradPlan_Course
        WHERE plan_id = @PlanID AND course_id = @CourseID;

        PRINT 'Course deleted from graduation plan successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Student or graduation plan not found for the specified parameters.';
    END
END;
DECLARE @StudentID INT = 1;
DECLARE @SemesterCode VARCHAR(40) = 'W23';
DECLARE @CourseID INT = 1;

EXEC Procedures_AdvisorDeleteFromGP
    @StudentID,
    @SemesterCode,
    @CourseID;


GO;
CREATE FUNCTION FN_Advisors_Requests (@advisorID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        r.*
    FROM
        Request r
    WHERE
        r.advisor_id = @advisorID
);
GO;
DECLARE @AdvisorID INT = 2;
SELECT *
FROM FN_Advisors_Requests(@AdvisorID);
GO;
CREATE PROCEDURE Procedures_AdvisorApproveRejectCHRequest
    @RequestID INT,
    @CurrentSemesterCode VARCHAR(40)
AS
BEGIN
    DECLARE @Status VARCHAR(20);
    DECLARE @CreditHours INT;
    DECLARE @StudentID INT;

    SELECT @CreditHours = credit_hours, @StudentID = student_id
    FROM Request
    WHERE request_id = @RequestID;

    IF @CreditHours > 0 AND EXISTS (
        SELECT 1
        FROM Student
        WHERE student_id = @StudentID
            AND @CurrentSemesterCode LIKE 'S%'
            AND (assigned_hours + @CreditHours) <= 34
    )
    BEGIN
        SET @Status = 'Approved';
    END
    ELSE
    BEGIN
        SET @Status = 'Rejected';
    END

    UPDATE Request
    SET status = @Status
    WHERE request_id = @RequestID;
    PRINT 'Extra credit hours request processed successfully.';
END;
DECLARE @RequestID INT = 2;
DECLARE @CurrentSemesterCode VARCHAR(40) = 'W23';
EXEC Procedures_AdvisorApproveRejectCHRequest
    @RequestID = @RequestID,
    @CurrentSemesterCode = @CurrentSemesterCode;

GO;
CREATE PROCEDURE Procedures_AdvisorViewAssignedStudents
    @AdvisorID INT,
    @Major VARCHAR(40)
AS
BEGIN
    CREATE TABLE #AssignedStudents
    (
        StudentID INT,
        StudentName VARCHAR(80),
        StudentMajor VARCHAR(40),
        CourseName VARCHAR(80)
    );

    INSERT INTO #AssignedStudents (StudentID, StudentName, StudentMajor, CourseName)
    SELECT
        S.student_id AS StudentID,
        S.f_name+' '+ S.l_name AS StudentName,
        S.major AS major,
        C.name AS courseName
    FROM
        Student S
    JOIN
        Graduation_Plan GP ON S.student_id = GP.student_id
    JOIN
        GradPlan_Course GPC ON GP.plan_id = GPC.plan_id
    JOIN
        Course C ON GPC.course_id = C.course_id
    WHERE
        S.advisor_id = @AdvisorID
        AND S.major = @Major;
    SELECT *
    FROM
        #AssignedStudents;
    DROP TABLE #AssignedStudents;
END;
DECLARE @AdvisorID INT = 1;
DECLARE @Major VARCHAR(40) = 'Engineering';
EXEC Procedures_AdvisorViewAssignedStudents
    @AdvisorID = @AdvisorID,
    @Major = @Major;

GO;
CREATE PROCEDURE Procedures_AdvisorApproveRejectCourseRequest ---check
    @RequestID INT,
    @CurrentSemesterCode VARCHAR(40)
AS
BEGIN
    DECLARE @Status VARCHAR(20);
    DECLARE @CreditHours INT;
    DECLARE @MetPreq BIT;

    IF NOT EXISTS (
        SELECT 1
        FROM PreqCourse_course PC
        LEFT JOIN Student_Instructor_Course_Take studentsINS
            ON studentsINS.course_id = PC.prerequisite_course_id
            AND studentsINS.student_id = (SELECT student_id FROM Request WHERE request_id = @RequestID)
        WHERE PC.course_id = (SELECT course_id FROM Request WHERE request_id = @RequestID)
            AND studentsINS.grade IS NULL
    )
    BEGIN
        SET @MetPreq = 1;
    END
    ELSE
    BEGIN
        SET @MetPreq = 0;
    END

    SELECT @CreditHours = C.credit_hours
    FROM Request R
    JOIN Course C ON R.course_id = C.course_id
    WHERE R.request_id = @RequestID;

    IF @MetPreq = 1 AND (SELECT (assigned_hours + @CreditHours) FROM Student WHERE student_id = (SELECT student_id FROM Request WHERE request_id = @RequestID)) <= (SELECT acquired_hours FROM Student WHERE student_id = (SELECT student_id FROM Request WHERE request_id = @RequestID))
    BEGIN
        SET @Status = 'Approved';
    END
    ELSE
    BEGIN
        SET @Status = 'Rejected';
    END

    UPDATE Request
    SET status = @Status
    WHERE request_id = @RequestID;
END;
DECLARE @RequestID INT = 2;
DECLARE @CurrentSemesterCode VARCHAR(40) = 'W23';
EXEC Procedures_AdvisorApproveRejectCourseRequest
    @RequestID = @RequestID,
    @CurrentSemesterCode = @CurrentSemesterCode;
GO;
CREATE PROCEDURE Procedures_AdvisorViewPendingRequests
    @AdvisorID INT
AS
BEGIN
    SELECT
        R.*,
        S.student_id,
        S.f_name + ' ' + S.l_name AS student_name,
        C.course_id,
        C.name AS course_name
    FROM Request R
    JOIN Student S ON R.student_id = S.student_id
    JOIN Course C ON R.course_id = C.course_id
    WHERE R.advisor_id = @AdvisorID
        AND R.status = 'pending';
END;
DECLARE @AdvisorID INT = 2;
EXEC Procedures_AdvisorViewPendingRequests
    @AdvisorID = @AdvisorID;

GO;

CREATE FUNCTION FN_StudentLogin
(
    @StudentID INT,
    @Password VARCHAR(40)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Success BIT = 0; 
    IF EXISTS (
        SELECT 1
        FROM Student
        WHERE student_id = @StudentID
          AND password = @Password
    )
    BEGIN
        SET @Success = 1;
    END

    RETURN @Success;
END;
GO;
DROP FUNCTION IF EXISTS FN_StudentLogin;
GO;

DECLARE @StudentID INT = 1;
DECLARE @Password VARCHAR(40) = 'password123';
DECLARE @Success BIT;

SET @Success = dbo.FN_StudentLogin(@StudentID, @Password);

IF @Success = 1
    PRINT 'Login successful';
ELSE
    PRINT 'Login failed';

GO;
CREATE PROCEDURE Procedures_StudentaddMobile
    @studentID INT,
    @phoneNo VARCHAR(40)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Student WHERE student_id = @studentID)
    BEGIN
        INSERT INTO Student_Phone (student_id, phone_number)
        VALUES (@studentID, @phoneNo);
        PRINT 'Mobile number added successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Student does not exist. Mobile number not added.';
    END;
END;
DECLARE @studentID INT = 4;
DECLARE @phoneNo VARCHAR(40) = '123-456-7890';
EXEC dbo.Procedures_StudentaddMobile @studentID, @phoneNo;
GO;
CREATE FUNCTION FN_SemsterAvailableCourses
    (@semCode VARCHAR(40))
RETURNS TABLE
AS
RETURN
(
    SELECT
        C.*
    FROM
        Course C
        INNER JOIN Course_Semester Csem ON C.course_id = Csem.course_id
    WHERE
        Csem.semester_code = @semCode
        AND C.is_offered = 1
);
GO;
DECLARE @semCode VARCHAR(40);
SET @semCode = 'w23';

SELECT *
FROM dbo.FN_SemsterAvailableCourses(@semCode);
GO;
CREATE PROCEDURE Procedures_StudentSendingCourseRequest
    @StudentID INT,
    @CourseID INT,
    @Type VARCHAR(40),
    @Comment VARCHAR(40)
AS
BEGIN
    DECLARE @Status VARCHAR(20) = 'pending';
    DECLARE @CreditHours INT = 0;
    DECLARE @AdvisorID INT = NULL;

    IF NOT EXISTS (SELECT 1 FROM Student WHERE student_id = @StudentID)
    BEGIN
        PRINT 'Student does not exist.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Course WHERE course_id = @CourseID)
    BEGIN
        PRINT 'Course does not exist.';
        RETURN;
    END


    IF EXISTS (
        SELECT 1
        FROM Student s
        JOIN Graduation_Plan gp ON s.student_id = gp.student_id
        JOIN GradPlan_Course gpc ON gp.plan_id = gpc.plan_id
        WHERE s.student_id = @StudentID
            AND gpc.course_id = @CourseID
    )
    BEGIN
        PRINT 'Student is eligible to make a request for this course.';

        INSERT INTO Request (type, comment, status, credit_hours, student_id, advisor_id, course_id)
        VALUES (@Type, @Comment, @Status, @CreditHours, @StudentID, @AdvisorID, @CourseID);

        PRINT 'Request submitted successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Student is not eligible to make a request for this course.';
    END
END;
DECLARE @StudentID INT = 3;
DECLARE @CourseID INT = 3;
DECLARE @Type VARCHAR(40) = 'course';
DECLARE @Comment VARCHAR(40) = 'Need to change course';
EXEC Procedures_StudentSendingCourseRequest
    @StudentID,
    @CourseID,
    @Type,
    @Comment;

GO;
CREATE PROCEDURE Procedures_StudentSendingCHRequest
    @StudentID INT,
    @CreditHours INT,
    @Type VARCHAR(40),
    @Comment VARCHAR(40)
AS
BEGIN
    DECLARE @Status VARCHAR(20) = 'pending';
    DECLARE @AdvisorID INT = NULL;
    DECLARE @CourseID INT = NULL;

    INSERT INTO Request (type, comment, status, credit_hours, student_id, advisor_id, course_id)
    VALUES (@Type, @Comment, @Status, @CreditHours, @StudentID, @AdvisorID, @CourseID);
    PRINT 'Request submitted successfully.'
END;

EXEC Procedures_StudentSendingCHRequest
    @StudentID = 1,
    @CreditHours = 2,
    @Type = 'Request for extra credit hours',
    @Comment ='Request for reduced credit hours';

GO;
CREATE FUNCTION FN_StudentViewGP (@StudentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        S.student_id AS Student_Id,
        S.f_name + ' ' + S.l_name AS Student_name,
        GP.plan_id AS Graduation_Plan_Id,
        GC.course_id AS Course_Id,
        C.name AS Course_name,
        GP.semester_code AS Semester_Code,
        GP.expected_grad_date AS Expected_Graduation_Date,
        GP.semester_credit_hours AS Semester_Credit_Hours,
        GP.advisor_id AS Advisor_Id
    FROM
        Student AS S
    INNER JOIN Graduation_Plan AS GP ON S.student_id = GP.student_id
    LEFT JOIN GradPlan_Course AS GC ON GP.plan_id = GC.plan_id
    LEFT JOIN Course AS C ON GC.course_id = C.course_id
    WHERE
        S.student_id = @StudentID
);
GO;
DECLARE @StudentID INT = 5;
SELECT *
FROM FN_StudentViewGP(@StudentID);
GO;
CREATE FUNCTION FN_StudentUpcoming_installment-----
(
    @StudentID INT
)
RETURNS DATE
AS
BEGIN
    DECLARE @deadline DATE;

    SELECT TOP 1 @deadline = I.deadline
    FROM Installment I
    JOIN Payment P ON I.payment_id = P.payment_id
    WHERE P.student_id = @StudentID
      AND I.status = 'notPaid'
    ORDER BY I.deadline;

    RETURN @deadline;
END;
GO;
DECLARE @StudentID INT =1;

DECLARE @UpcomingInstallmentDate DATE;
EXEC @UpcomingInstallmentDate = FN_StudentUpcoming_installment @StudentID;

SELECT @UpcomingInstallmentDate AS Upcoming_Installment_Date;   
GO;
CREATE FUNCTION FN_StudentViewSlot
(
    @IDcourse INT,
    @IDins INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        S.slot_id,
        S.location,
        S.time,
        S.day,
        C.name AS course_name,
        I.name AS instructor_name
    FROM
        Slot S
    JOIN
        Course C ON S.course_id = C.course_id
    JOIN
        Instructor I ON S.instructor_id = I.instructor_id
    WHERE
        S.course_id = @IDcourse
        AND S.instructor_id = @IDins
);
GO;
DECLARE @CourseID INT = 1;
DECLARE @InstructorID INT =2;

SELECT *
FROM FN_StudentViewSlot(@CourseID, @InstructorID);
GO;
CREATE PROCEDURE Procedures_StudentRegisterFirstMakeup
    @StudentID INT,
    @CourseID INT,
    @StudentCurrentSemester VARCHAR(40)
AS
BEGIN
    DECLARE @EligibilityForSecondMakeup INT;

    IF @EligibilityForSecondMakeup = 0
    BEGIN

        DECLARE @InsertedExams TABLE (exam_id INT);

        INSERT INTO Exam_Student (exam_id, student_id, course_id)
        OUTPUT inserted.exam_id INTO @InsertedExams
        VALUES (
            (SELECT exam_id FROM MakeUp_Exam WHERE course_id = @CourseID AND type = 'first_makeup' AND date >= GETDATE()),
            @StudentID,
            @CourseID
        );
        IF (SELECT COUNT(*) FROM @InsertedExams) > 0
        BEGIN
            PRINT 'Student registered for the first makeup exam successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Error: Exam registration failed.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Student is not eligible for the first makeup exam due to eligibility for the second makeup exam.';
    END
END;

DECLARE @StudentID INT = 3;
DECLARE @CourseID INT = 3;
DECLARE @CurrentSemester VARCHAR(40) = 'S23R1';

EXEC Procedures_StudentRegisterFirstMakeup 
    @StudentID = @StudentID,
    @CourseID = @CourseID,
    @StudentCurrentSemester = @CurrentSemester;

DROP PROC IF EXISTS Procedures_StudentRegisterFirstMakeup;
GO;
CREATE FUNCTION FN_StudentCheckSMEligibility---
(
    @CourseID INT,
    @StudentID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @Eligible BIT;

    DECLARE @FailedCoursesCount INT;
    SELECT @FailedCoursesCount = COUNT(*)
    FROM MakeUp_Exam MU
    WHERE MU.course_id = @CourseID
      AND MU.type = 'first_makeup'
      AND MU.date <= GETDATE()
      AND NOT EXISTS (
          SELECT 1
          FROM Exam_Student ES
          WHERE ES.student_id = @StudentID
            AND ES.course_id = @CourseID
            AND ES.exam_id = MU.exam_id
      );

    IF @FailedCoursesCount <= 2
    BEGIN
        SET @Eligible = 1;
    END
    ELSE
    BEGIN
        SET @Eligible = 0; 
    END

    RETURN @Eligible;
END;
GO;
DECLARE @CourseID INT = 1;
DECLARE @StudentID INT = 1;
DECLARE @Eligible BIT;
SET @Eligible = dbo.FN_StudentCheckSMEligibility(@CourseID, @StudentID);
SELECT @Eligible AS IsEligible;

GO;
CREATE PROCEDURE Procedures_StudentRegisterSecondMakeup
    @StudentID INT,
    @CourseID INT,
    @StudentCurrentSemester VARCHAR(40)
AS
BEGIN
    DECLARE @EligibleForSecondMakeup BIT;
    DECLARE @SecondMakeupExamID INT;
    SELECT @EligibleForSecondMakeup = dbo.FN_StudentCheckSMEligibility(@CourseID, @StudentID);

    IF @EligibleForSecondMakeup = 1
    BEGIN
        SELECT TOP 1 @SecondMakeupExamID = exam_id
        FROM MakeUp_Exam
        WHERE course_id = @CourseID
            AND type = 'secondMakeup'
            AND date >= GETDATE();

        IF @SecondMakeupExamID IS NOT NULL
        BEGIN
            INSERT INTO Exam_Student (exam_id, student_id, course_id)
            VALUES (@SecondMakeupExamID, @StudentID, @CourseID);

            PRINT 'Student registered for the second makeup exam.';
        END
        ELSE
        BEGIN
            PRINT 'No valid second makeup exam found.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Student is not eligible for the second makeup exam.';
    END
END;
DECLARE @StudentID INT = 1;
DECLARE @CourseID INT = 2;
DECLARE @StudentCurrentSemester VARCHAR(40) = 's23'; 

EXEC Procedures_StudentRegisterSecondMakeup 
    @StudentID,
    @CourseID,
    @StudentCurrentSemester;

    DROP PROC IF EXISTS Procedures_StudentRegisterSecondMakeup;
GO;
CREATE PROCEDURE Procedures_ViewRequiredCourses
    @StudentID INT,
    @CurrentSemesterCode VARCHAR(40)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Student WHERE student_id = @StudentID)
    BEGIN
        PRINT 'Error: Student does not exist.';
        RETURN;
    END
    IF NOT EXISTS (
        SELECT 1
        FROM Graduation_Plan
        WHERE student_id = @StudentID
            AND expected_grad_date IS NOT NULL
    )
    BEGIN
        PRINT 'Error: Student does not have an active graduation plan.';
        RETURN;
    END
    SELECT
        C.course_id,
        C.name AS course_name,
        C.credit_hours
    FROM
        Course C
    JOIN
        GradPlan_Course GPC ON C.course_id = GPC.course_id
    JOIN
        Graduation_Plan GP ON GPC.plan_id = GP.plan_id
    WHERE
        GP.student_id = @StudentID
        AND GP.semester_code = @CurrentSemesterCode;
END;
DECLARE @StudentID INT = 2;
DECLARE @CurrentSemesterCode VARCHAR(40) ='s23';

EXEC Procedures_ViewRequiredCourses
    @StudentID = @StudentID,
    @CurrentSemesterCode = @CurrentSemesterCode;
GO;
CREATE PROCEDURE Procedures_ViewOptionalCourse
    @StudentID INT,
    @CurrentSemesterCode VARCHAR(40)
AS
BEGIN
    SELECT DISTINCT
        C.course_id,
        C.name AS CourseName,
        C.credit_hours AS CreditHours
    FROM Course C
    WHERE C.semester <= CONVERT(INT, SUBSTRING(@CurrentSemesterCode, 2, LEN(@CurrentSemesterCode))) -- i spent 2 hours learning how to exclude the s or the w from the sem code to compare the semester of the course to the current semester 
        AND C.is_offered = 1
        AND (
            (C.semester % 2 = 1 AND @CurrentSemesterCode LIKE 'S%')
            OR
            (C.semester % 2 = 0 AND @CurrentSemesterCode LIKE 'W%')
        )
        AND NOT EXISTS (
            SELECT 1
            FROM Student_Instructor_Course_Take SICT
            WHERE SICT.student_id = @StudentID
            AND SICT.course_id = C.course_id
        )
        AND NOT EXISTS (
            SELECT 1
            FROM PreqCourse_course PC
            WHERE PC.course_id = C.course_id
            AND NOT EXISTS (
                SELECT 1
                FROM Student_Instructor_Course_Take SICT2
                WHERE SICT2.student_id = @StudentID
                AND SICT2.course_id = PC.prerequisite_course_id
            )
        );
END;
DROP PROC IF EXISTS Procedures_ViewOptionalCourse;
DECLARE @StudentID INT = 1;
DECLARE @CurrentSemesterCode VARCHAR(40) = 'S23';

EXEC Procedures_ViewOptionalCourse
    @StudentID,
    @CurrentSemesterCode;



GO;
CREATE PROCEDURE Procedures_ViewMissingCourses
    @StudentID INT
AS
BEGIN
    SELECT DISTINCT
        C.course_id,
        C.name AS CourseName,
        C.credit_hours AS CreditHours
    FROM Course C
    LEFT JOIN Student_Instructor_Course_Take SICT
        ON SICT.student_id = @StudentID AND SICT.course_id = C.course_id
    WHERE SICT.student_id IS NULL
        AND NOT EXISTS (
            SELECT 1
            FROM PreqCourse_course PC
            WHERE PC.course_id = C.course_id
            AND NOT EXISTS (
                SELECT 1
                FROM Student_Instructor_Course_Take SICT2
                WHERE SICT2.student_id = @StudentID
                AND SICT2.course_id = PC.prerequisite_course_id
            )
        );
END;
DECLARE @StudentID INT = 1;
EXEC Procedures_ViewMissingCourses @StudentID;

GO;
CREATE PROCEDURE Procedures_ChooseInstructor
    @StudentID INT,
    @InstructorID INT,
    @CourseID INT,
    @CurrentSemesterCode VARCHAR(40)
AS
BEGIN
    DECLARE @CourseSemesterCode VARCHAR(40);
    SELECT @CourseSemesterCode = semester
    FROM Course
    WHERE course_id = @CourseID;

    IF @CourseSemesterCode IS NOT NULL AND @CourseSemesterCode = @CurrentSemesterCode
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM Student_Instructor_Course_Take
            WHERE student_id = @StudentID
                AND course_id = @CourseID
                AND instructor_id IS NULL
        )
        BEGIN
            UPDATE Student_Instructor_Course_Take
            SET instructor_id = @InstructorID
            WHERE student_id = @StudentID
                AND course_id = @CourseID;

            PRINT 'Instructor chosen for the selected course successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Student is not eligible to choose an instructor for this course.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Selected course is not offered in the current semester.';
    END
END;

EXEC Procedures_ChooseInstructor
    @StudentID = 1,
    @InstructorID =1,
    @CourseID = 1,
    @CurrentSemesterCode = 'W23';
    DROP PROC IF EXISTS Procedures_ChooseInstructor;
GO;

















































