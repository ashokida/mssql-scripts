set nocount on
DECLARE @Test TABLE (Id INT IDENTITY(1,1), Code varchar(max))
INSERT INTO @Test (Code)
SELECT 'IF object_ID(N''[' + schema_name(schema_id) + '].[' + Name + ']'') IS NOT NULL 
           DROP PROCEDURE ['+ schema_name(schema_id) +' ].[' + Name + ']' + char(13) + char(10) + 'GO' + 
           OBJECT_DEFINITION(OBJECT_ID) + char(13) +char(10) + 'GO' + char(13) + char(10)
            from sys.procedures
            where is_ms_shipped = 0
            and name not like 'sp_%'
            order by 1

DECLARE @lnCurrent int, @lnMax int
DECLARE @LongName varchar(max)

SELECT @lnMax = MAX(Id) FROM @Test
SET @lnCurrent = 1
WHILE @lnCurrent <= @lnMax
      BEGIN
            SELECT @LongName = Code FROM @Test WHERE Id = @lnCurrent
            WHILE @LongName <> ''
               BEGIN
                   print LEFT(@LongName,8000)
                   SET @LongName = SUBSTRING(@LongName, 8001, LEN(@LongName))
               END
            SET @lnCurrent = @lnCurrent + 1
      END