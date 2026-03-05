/**********************************************************************************************************************************************
*    Descripcion: Script de ejemplo que permite obtener la cantidad de registros de un archivo	
* Fecha creacion: 05/08/2014
*          Autor: AShokida
*           Nota: Esta es una forma alternativa de contar lineas, en vez abrir el archivo y contar una por una, solo cuenta las lineas en las
*                 que no encuentro determinada cadena de caracteres
***********************************************************************************************************************************************/

DECLARE  @NombreArchivo    VARCHAR(8000),
         @CantidadDeLineas INT,
         @CMD              VARCHAR(8000)
DECLARE  @tmpTABLA TABLE (Lineas VARCHAR(1000))
 
SET @NombreArchivo = 'c:\ver.txt'
SET @CMD           = 'find /V /C "nadaContieneEsteString" ' + @NombreArchivo
  
INSERT INTO @tmpTABLA 
       EXEC master..xp_cmdshell @CMD

DELETE Tmp
  FROM @tmpTABLA Tmp 
 WHERE Tmp.Lineas IS NULL
 
SELECT @CantidadDeLineas =  SUBSTRING (Lineas, 12 + len(@NombreArchivo) + 2, 1000) 
  FROM @tmpTABLA

SELECT Lineas 
  FROM @tmpTABLA

SELECT @CantidadDeLineas

/*FIN*/