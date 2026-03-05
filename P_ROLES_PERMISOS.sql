USE [ECOM]
GO

/****** Object:  StoredProcedure [dbo].[P_ROLES_PERMISOS]    Script Date: 09/19/2016 10:36:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[P_ROLES_PERMISOS]
@ROL VARCHAR(60)
AS


DECLARE @DatabaseRoleName [sysname]
SET @DatabaseRoleName = LTRIM(RTRIM(@ROL))

SET NOCOUNT ON
DECLARE
@errStatement [varchar](8000),
@msgStatement [varchar](8000),
@DatabaseRoleID [smallint],
@IsApplicationRole [bit],
@ObjectID [int],
@ObjectName [sysname],
@DatabaseID [int]

SELECT
@DatabaseRoleID = [uid],
@IsApplicationRole = CAST([isapprole] AS bit)
FROM [dbo].[sysusers]
WHERE
[name] = @DatabaseRoleName
AND [issqlrole] = 1

select @DatabaseID = database_id from sys.databases where name =db_name()


IF @DatabaseRoleID IS NULL
BEGIN
SET @errStatement = 'El rol ' + @DatabaseRoleName + ' no existe en la base ' + DB_NAME() + '.'
RAISERROR(@errStatement, 16, 1)
END

ELSE
BEGIN
PRINT '---------------------------------------------------------------------------------------------'
SET @msgStatement = '--PERMISOS DEL ROL ' + @DatabaseRoleName + CHAR(10)

IF @IsApplicationRole = 1
SET @msgStatement = @msgStatement + 'EXEC sp_addapprole' + CHAR(13) +
CHAR(9) + '@rolename = ''' + @DatabaseRoleName + '''' + CHAR(13) +
CHAR(9) + '@password = ''{Please provide the password here}''' + CHAR(13)
ELSE
BEGIN
SET @msgStatement = @msgStatement + 'EXEC sp_addrole ' + '@rolename = ''' + @DatabaseRoleName + ''''
PRINT 'GO'
END

SET @msgStatement = @msgStatement + CHAR(10) + '--Permisos especificos'
PRINT @msgStatement
DECLARE _sysobjects
CURSOR
LOCAL
FORWARD_ONLY
READ_ONLY
FOR
SELECT
DISTINCT([sysobjects].[id]),
'[' + [sys].[schemas].[name] 
 + '].[' +  [sysobjects].[name] + ']'
FROM [dbo].[sysprotects]
INNER JOIN [dbo].[sysobjects]
ON [sysprotects].[id] = [sysobjects].[id]
INNER JOIN [sys].[schemas]
ON [sys].[schemas].[schema_id]=[sysobjects].[uid] 
OPEN _sysobjects
FETCH
NEXT
FROM _sysobjects
INTO
@ObjectID,
@ObjectName
WHILE @@FETCH_STATUS = 0
BEGIN
SET @msgStatement = ''
IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseRoleID AND [action] = 193 AND [protecttype] = 205)
SET @msgStatement = @msgStatement + 'SELECT,'
IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseRoleID AND [action] = 195 AND [protecttype] = 205)
SET @msgStatement = @msgStatement + 'INSERT,'
IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseRoleID AND [action] = 197 AND [protecttype] = 205)
SET @msgStatement = @msgStatement + 'UPDATE,'
IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseRoleID AND [action] = 196 AND [protecttype] = 205)
SET @msgStatement = @msgStatement + 'DELETE,'
IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseRoleID AND [action] = 224 AND [protecttype] = 205)
SET @msgStatement = @msgStatement + 'EXECUTE,'
IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseRoleID AND [action] = 26 AND [protecttype] = 205)
SET @msgStatement = @msgStatement + 'REFERENCES,'
IF LEN(@msgStatement) > 0
BEGIN
IF RIGHT(@msgStatement, 1) = ','
SET @msgStatement = LEFT(@msgStatement, LEN(@msgStatement) - 1)
SET @msgStatement = 'GRANT' + CHAR(13) +
CHAR(9) + @msgStatement + CHAR(13) +
CHAR(9) + 'ON ' + @ObjectName + CHAR(13) +
CHAR(9) + 'TO [' + @DatabaseRoleName + ']'
PRINT @msgStatement
END
SET @msgStatement = ''
IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseRoleID AND [action] = 193 AND [protecttype] = 206)
SET @msgStatement = @msgStatement + 'SELECT,'
IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseRoleID AND [action] = 195 AND [protecttype] = 206)
SET @msgStatement = @msgStatement + 'INSERT,'
IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseRoleID AND [action] = 197 AND [protecttype] = 206)
SET @msgStatement = @msgStatement + 'UPDATE,'
IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseRoleID AND [action] = 196 AND [protecttype] = 206)
SET @msgStatement = @msgStatement + 'DELETE,'
IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseRoleID AND [action] = 224 AND [protecttype] = 206)
SET @msgStatement = @msgStatement + 'EXECUTE,'
IF EXISTS(SELECT * FROM [dbo].[sysprotects] WHERE [id] = @ObjectID AND [uid] = @DatabaseRoleID AND [action] = 26 AND [protecttype] = 206)
SET @msgStatement = @msgStatement + 'REFERENCES,'
IF LEN(@msgStatement) > 0
BEGIN
IF RIGHT(@msgStatement, 1) = ','
SET @msgStatement = LEFT(@msgStatement, LEN(@msgStatement) - 1)
SET @msgStatement = 'DENY' + CHAR(13) +
CHAR(9) + @msgStatement + CHAR(13) +
CHAR(9) + 'ON ' + @ObjectName + CHAR(13) +
CHAR(9) + 'TO ' + @DatabaseRoleName
PRINT @msgStatement
END
FETCH
NEXT
FROM _sysobjects
INTO
@ObjectID,
@ObjectName
END
CLOSE _sysobjects
DEALLOCATE _sysobjects
PRINT 'GO'
END


GO


