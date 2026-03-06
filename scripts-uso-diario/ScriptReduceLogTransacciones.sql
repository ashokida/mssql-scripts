/**********************************************************************************************************************************************
*    Descripcion: Script que limpia el log de transacciones de una base de datps
* Fecha creacion: 15/10/2014
*          Autor: AShokida
*           Nota: Especificar la BD en el parametro @BASE y ejecutar el resultado del query dinamico
***********************************************************************************************************************************************/

DECLARE @BASE VARCHAR(20),
        @STR  VARCHAR(1000)

SET @BASE  = 'CENCON'

SET @STR = 'USE ' + @BASE
SET @STR = @STR + ' ALTER DATABASE ' + @BASE
SET @STR = @STR + ' SET RECOVERY SIMPLE '
SET @STR = @STR + ' DBCC SHRINKFILE (' + @BASE + '_Log)'
SET @STR = @STR + ' ALTER DATABASE ' + @BASE
SET @STR = @STR + ' SET RECOVERY FULL '

SELECT @STR

/*FIN*/