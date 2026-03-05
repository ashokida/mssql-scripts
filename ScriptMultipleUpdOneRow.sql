--–Create tables with a modified date
USE tempdb;

DROP TABLE #employeetarget;
GO

DROP TABLE #employeesource;
GO

CREATE TABLE #employeetarget(
FirstName  VARCHAR(50),
MiddleName VARCHAR(50),
LastName   VARCHAR(50),
JobTitle   VARCHAR(25),
ModDate        DATE);

CREATE TABLE #employeesource(
FirstName  VARCHAR(50),
MiddleName VARCHAR(50),
LastName   VARCHAR(50),
JobTitle   VARCHAR(25),
ModDate        DATE);

INSERT #employeetarget
VALUES('David', 'M', 'Dye', 'Da Boss', '1/1/2012'),
     ('John', 'A', 'Doe', 'Nobody', '1/1/2012'),
     ('Mike', 'B', 'Smith', 'Lazy', '1/1/2012');

INSERT #employeesource
VALUES('David', 'M', 'Dye', 'Da Boss', '1/1/2012'),
     ('David', 'M', 'Dye', 'Unemployed', '1/1/2013'),
     ('David', 'M', 'Dye', 'Admin', '1/1/2014'),
     ('David', 'M', 'Dye', 'Dba', '1/1/2015'),
     ('John', 'A', 'Doe', 'Nobody', '1/1/2012'),
     ('Mike', 'B', 'Smith', 'Lazy', '1/1/2012');
GO 


WITH cteJobTitle
AS(
SELECT ROW_NUMBER() OVER(PARTITION BY FirstName, MiddleName, LastName ORDER BY ModDate DESC) AS RowNum,
      FirstName,
      MiddleName,
      LastName,
      JobTitle,
      ModDate
FROM #employeesource)
--–Succeeds--
MERGE #employeetarget AS t
USING cteJobTitle AS s
ON t.FirstName = s.FirstName
AND t.MiddleName = s.MiddleName
AND t.LastName = s.LastName
WHEN MATCHED
AND RowNum = 1
THEN
UPDATE
SET t.JobTitle = s.JobTitle,
   t.ModDate = s.ModDate
WHEN NOT MATCHED THEN
INSERT
VALUES(s.FirstName, s.MiddleName, s.LastName, s.JobTitle, GETDATE());

SELECT *
FROM  #employeetarget 