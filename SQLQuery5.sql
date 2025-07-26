--CREATE DATABASE Teachers
-- USE Teachers


CREATE TABLE POSTS (
    Id INT PRIMARY KEY,
    Name NVARCHAR(20)
);

CREATE TABLE TEACHERS (
    Id INT PRIMARY KEY,
    Name NVARCHAR(15),
    Code CHAR(10),
    IdPost INT FOREIGN KEY REFERENCES POSTS(Id),
    Tel CHAR(7),
    Salary INT,
    Rise NUMERIC(6,2),
    HireDate DATETIME
);

--2. Delete the "POSTS" table.
DROP TABLE POSTS
--3. In the "TEACHERS" table, delete the "IdPost" column.
ALTER TABLE TEACHERS
DROP CONSTRAINT FK__TEACHERS__IdPost__4BAC3F29;

ALTER TABLE TEACHERS
DROP COLUMN IdPost

--4. For the "HireDate" column, create a limit: the date of hiring must be at least 01/01/1990.
ALTER TABLE TEACHERS
ADD CONSTRAINT CHK_HireDate CHECK(HireDate>='1990-01-01')
--5. Create a unique constraint for the "Code" column.
ALTER TABLE TEACHERS
ADD CONSTRAINT Unique_code UNIQUE(Code)
--6. Change the data type In the Salary field from INTEGER to NUMERIC (6,2).
ALTER TABLE TEACHERS 
ALTER COLUMN Salary NUMERIC(6,2)
--7. Add to the table "TEACHERS" the following restriction: the salary should not be less than
--1000, but also should not Exceed 5000.
ALTER TABLE TEACHERS
ADD CONSTRAINT CHK_Salary CHECK(Salary>1000 AND Salary <5000)
--8. Rename Tel column to Phone.
EXECUTE sp_rename 'TEACHERS.Tel', 'Phone', 'COLUMN';
--9. Change the data type in the Phone field from CHAR (7) to CHAR (11).
ALTER TABLE TEACHERS 
ALTER COLUMN Phone CHAR(11)
--10. Create again the "POSTS" table.
CREATE TABLE POSTS (
    Id INT PRIMARY KEY,
    Name NVARCHAR(20)
);
--11. For the Name field of the "POSTS" table, you must set a limit on the position (professor,
--assistant professor, teacher or assistant).
ALTER TABLE POSTS
ADD CONSTRAINT CHK_Name CHECK(Name IN('Professor', 'Docent', 'Teacher', 'Assistant'))
--12. For the Name field of the "TEACHERS" table, specify a restriction in which to prohibit the
--presence of figures in the teacher's surname.
ALTER TABLE TEACHERS
ADD CONSTRAINT CHK_Name_NoDigits CHECK (Name NOT LIKE '%[0-9]%');

--13. Add the IdPost (int) column to the "TEACHERS" table.
ALTER TABLE TEACHERS 
ADD IdPost INT ;
--14. Associate the field IdPost table "TEACHERS" with the field Id of the table "POSTS".
ALTER TABLE TEACHERS
ADD CONSTRAINT FK_ID FOREIGN KEY (IdPost) REFERENCES POSTS(id)

--15
INSERT INTO POSTS (Id, Name)
VALUES 
(1, N'Professor'),
(2, N'Docent'),
(3, N'Teacher'),
(4, N'Assistant');

INSERT INTO TEACHERS (Id, Name, Code, IdPost, Phone, Salary, Rise, HireDate)
VALUES 
(1, N'Sidorov', '0123456789', 1, NULL, 1070, 470, '1992-09-01'),
(2, N'Ramishevsky', '4567890123', 2, '4567890', 1110, 370, '1998-09-09'),
(3, N'Horenko', '1234567890', 3, NULL, 2000, 230, '2001-10-10'),
(4, N'Vibrovsky', '2345678901', 4, NULL, 4000, 170, '2003-09-01'),
(5, N'Voropaev', NULL, 4, NULL, 1500, 150, '2002-09-02'),
(6, N'Kuzintsev', '5678901234', 3, '4567890', 3000, 270, '1991-01-01');


-- 16

--16.1. All job titles.
CREATE VIEW View_AllPosts AS
SELECT Name FROM POSTS;

--16.2. All the names of teachers.
CREATE VIEW View_AllTeachers AS
SELECT Name FROM TEACHERS;
--16.3. The identifier, the name of the teacher, his position, the general s / n (sort by s \ n).
CREATE VIEW View_TeacherSalary AS
SELECT 
    T.Id, 
    T.Name, 
    P.Name AS Post,
    (T.Salary + T.Rise) AS TotalSalary
FROM TEACHERS T
JOIN POSTS P ON T.IdPost = P.Id;


--16.4. Identification number, surname, telephone number (only those who have a phone
--number).

CREATE VIEW View_TeachersWithPhone AS
SELECT Id, Name, Phone
FROM TEACHERS
WHERE Phone IS NOT NULL;

--16.5. Surname, position, date of admission in the format [dd/mm/yy].
CREATE VIEW View_HireDateShortFormat AS
SELECT 
    T.Name, 
    P.Name AS Post, 
    CONVERT(VARCHAR, HireDate, 3) AS HireDate -- 3 = dd/mm/yy
FROM TEACHERS T
JOIN POSTS P ON T.IdPost = P.Id;

--16.6. Surname, position, date of receipt in the format [dd month_text yyyy].

CREATE VIEW View_HireDateLongFormat AS
SELECT 
    T.Name, 
    P.Name AS Post, 
    FORMAT(HireDate, 'dd MMMM yyyy') AS HireDate
FROM TEACHERS T
JOIN POSTS P ON T.IdPost = P.Id;












