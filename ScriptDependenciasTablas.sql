-- Declare Variables
DECLARE @mastertable VARCHAR(100)
DECLARE @TableCompleteName VARCHAR(100)
DECLARE @tablesname VARCHAR(1000)
-- declare temp table which is used for storing table name and dependent table list
CREATE TABLE #temptable
    (
      tablecompletename VARCHAR(100),
      tablename VARCHAR(1000)
    )
 
--  get all table name from sys objects 
DECLARE tmp_cur CURSOR static
    FOR SELECT  s.name + '.' + o.name,
                o.name
        FROM    sys.objects o
                INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
        WHERE   type = 'U'
        ORDER BY s.name,
                o.name
 -- fetch all table name    
OPEN tmp_cur
      --FETCH
 
-- get fetch one by one table name and it's dependent table name     
FETCH FIRST FROM tmp_cur INTO @TableCompleteName, @mastertable
WHILE @@FETCH_STATUS = 0
    BEGIN
 
        --
        SELECT  @tablesname = COALESCE(@tablesname + ',', '') + s.name + '.'
                + OBJECT_NAME(FKEYID)
        FROM    SYSFOREIGNKEYS
                INNER JOIN sys.objects o ON o.object_id = SYSFOREIGNKEYS.fkeyid
                INNER JOIN sys.schemas s ON s.schema_id = o.schema_id
        WHERE   OBJECT_NAME(RKEYID) = @mastertable
                 
        INSERT  INTO #temptable
                (
                  tablecompletename,
                  tablename
                )
                SELECT  @TableCompleteName,
                        COALESCE(@tablesname, '')
        SELECT  @tablesname = NULL
        FETCH NEXT FROM tmp_cur INTO @TableCompleteName, @mastertable
    END
   
SELECT  tablecompletename AS TableName, tablename AS DependentTables
FROM    #temptable 
 
DROP TABLE #temptable
 
CLOSE tmp_cur
DEALLOCATE tmp_cur