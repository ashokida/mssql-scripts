
--Ver con alejandro el tema de la fecha de venta. Ahora esta como parametro de entrada un date, habria que cambiarlo a datetimeoffset o a varchar
-- y validarlo


select * from ZONAXSUCURSAL
SELECT * FROM CIRCUITOXSUCURSAL
SELECT GETUTCDATE()
SELECT CONVERT(datetimeoffset,GETDATE())
SELECT GETDATE()
SELECT SYSUTCDATETIME()
SELECT SYSDATETIMEOFFSET()

SELECT CONVERT(datetimeoffset(0),GETDATE())
SELECT GETDATE()

DECLARE @TMP TABLE (HORA_UTC datetimeoffset(0))

INSERT INTO @TMP
  SELECT SWITCHOFFSET(GETDATE(),'-3:00')
  
  SELECT * FROM @TMP
  
  
  SELECT SWITCHOFFSET (CONVERT(datetimeoffset(0), '2016-04-01T12:45:10-03:00'), '-03:00');
  SELECT ToDateTimeOffset('2016-04-01T12:45:10-03:00', '-03:00')
  
  SELECT TODATETIMEOFFSET('2016-04-01T12:45:10-03:00', DATEPART(TZOFFSET, SYSDATETIMEOFFSET()))
  
  
  http://stackoverflow.com/questions/17866311/how-to-cast-datetime-to-datetimeoffset
  https://msdn.microsoft.com/en-us/library/bb630289.aspx
  https://msdn.microsoft.com/en-us/library/bb677244.aspx
  
  
  SELECT * FROM ERROR_PIEZA
INSERT INTO ERROR_PIEZA (ERR_ID,ERR_DESCRIPTION,ERR_COMMENT)
  SELECT 2006, 'Datos Invalidos', 'Campo Fecha de Venta invalida'

  SELECT
    Getdate=GETDATE()
    ,SysDateTimeOffset=SYSDATETIMEOFFSET()
    ,SWITCHOFFSET=SWITCHOFFSET(SYSDATETIMEOFFSET(),0)
    ,GetutcDate=GETUTCDATE()
    
    SELECT SWITCHOFFSET (CONVERT(datetimeoffset(0), GETDATE()), '-03:00');
    

  SELECT datediff(hour,GETUTCDATE(), getdate())
  SELECT DATEADD(second, DATEDIFF(second, GETDATE(), GETUTCDATE()), '2016-04-04 23:59:59');
  SELECT dbo.Fx_Fecha_Formateada_DATE(GETDATE(),'AAAA-MM-DDTHH:MM:SS-03:00')
  
  SELECT Tzdb.UtcToLocal('2015-07-01 00:00:00', 'America/Los_Angeles')
  
  DECLARE @FECHA VARCHAR(25)
  SET @FECHA = (SELECT SUBSTRING(dbo.Fx_Fecha_Formateada_DATE(GETDATE(),'AAAA-MM-DDTHH:MM:SS-03:00'),1,19))
 SELECT @FECHA  
  SELECT ISDATE(@FECHA)  