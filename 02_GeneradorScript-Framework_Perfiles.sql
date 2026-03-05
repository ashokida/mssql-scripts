DECLARE @TMP_NUEVOS_MENUES      TABLE (ID_MENU INT, MENU_ACCION VARCHAR(100), VAR_SECCION VARCHAR(300), VAR_MENU VARCHAR(100))
DECLARE @TMP_NUEVOS_PERFILES    TABLE (ID_PERFIL INT, NOMBRE VARCHAR(100), VAR_PERFIL VARCHAR(100))
DECLARE @TMP_NUEVOS_MENUES_PERF TABLE (ID_PERFIL INT, ID_MENU INT, VAR_PERFIL VARCHAR(100) ,VAR_MENU VARCHAR(100), NOMBRE_PERFIL VARCHAR(100), NOMBRE_MENU VARCHAR(100), ACCION VARCHAR(100))

DECLARE @SERVER                VARCHAR(30),
        @BASE                  VARCHAR (50),
        @DIROUT                VARCHAR(100),
        @INICIATIVA            VARCHAR(10), 
        @FILENAME              VARCHAR(500), 
        @COMMAND               VARCHAR(4000), 
        @RESULT                INT,
        @MENSAJE               VARCHAR(500),
        @PERFIL_AMBIENTE       VARCHAR(20)

    --SETEO TODOS LOS PARAMETROS 
    SET @SERVER          = @@SERVERNAME
	SET @BASE            = 'STP'
	SET @DIROUT          = '\\' + @@SERVERNAME + '\STP_CABAL\OUT\'
	SET @INICIATIVA      = '2430003'
	SET @FILENAME        = @INICIATIVA + '_' + @BASE + '_FWK-Datos_Perfiles.sql'
	SET @PERFIL_AMBIENTE = 'DESA'     --> DESA/TEST/PROD (Para especificar los nombres de los perfiles en los distintos ambientes)

BEGIN TRY
	SET NOCOUNT ON    

	--INSERTO EN TABLAS TEMPORALES:
	
	--LOS NUEVOS MENUES A CREAR O EXISTENTES, INDICANDO LA SECCION (NUEVA O EXISTENTE)
	INSERT INTO @TMP_NUEVOS_MENUES (ID_MENU, MENU_ACCION, VAR_SECCION, VAR_MENU) 
	     SELECT FM.ID_MENU,
	            FM.ACCION,
	            '@ID_SECCION_' + UPPER(REPLACE(FS.NOMBRE,' ','_')) VAR_SECCION,
	            '@ID_MENU_' + UPPER(REPLACE(FM.CONTROLADOR,' ','_')) + UPPER(REPLACE(FM.ACCION,' ','_'))  VAR_MENU
	       FROM FW_MENU FM INNER JOIN FW_SECCIONES FS ON FM.SECCION = FS.SECCION_ID
	      --WHERE FM.NOMBRE IN ('ABM Maquina de estados','Asignación Mail','Asignación Parametro','Clientes','Estados','Imposicion piezas RHE','Mail','Motivos','Novedades Facturación','Operaciones por CT','Parametros Sistema','Producto por Cliente','Productos','Rubros','Sucursal por Cliente','Transacciones') 	    
    
    --LOS NUEVOS PERFILES A CREAR
    INSERT INTO @TMP_NUEVOS_PERFILES (ID_PERFIL, NOMBRE, VAR_PERFIL)
         SELECT FP.ID_PERFIL,
                CASE WHEN @PERFIL_AMBIENTE = 'DESA'THEN FP.NOMBRE
                     WHEN @PERFIL_AMBIENTE = 'TEST'THEN FP.NOMBRE
                     WHEN @PERFIL_AMBIENTE = 'TEST'THEN FP.NOMBRE
                END,     
               '@ID_PERFIL_' + UPPER(REPLACE(dbo.Fx_FC_RemoverTildes(FP.NOMBRE),' ','_')) 
           FROM FW_PERFILES FP
          --WHERE FP.ID_PERFIL IN ('')  
    
        
    --LOS NUEVOS MENU_PERFILES A CREAR O EXISTENTES
    INSERT INTO @TMP_NUEVOS_MENUES_PERF (ID_PERFIL, ID_MENU, VAR_PERFIL, VAR_MENU, NOMBRE_PERFIL, NOMBRE_MENU, ACCION)
         SELECT FP.ID_PERFIL,
                FP.ID_MENU,
                '@ID_PERFIL_' + UPPER(REPLACE(FF.NOMBRE,' ','_')) ,
                TN.VAR_MENU,
                FF.NOMBRE,
                FM.NOMBRE,
                FM.ACCION
           FROM FW_MENU_PERFILES FP INNER JOIN FW_MENU FM INNER JOIN @TMP_NUEVOS_MENUES TN ON FM.ID_MENU = TN.ID_MENU   
                                    ON FP.ID_MENU = FM.ID_MENU
                                    INNER JOIN FW_PERFILES FF ON FP.ID_PERFIL = FF.ID_PERFIL
--            AND FF.NOMBRE IN ('')--------> ACA AGREGAR LOS PERFILES QUE VAN A ACCEDER A LOS MENUES, SI SE PONE VACIO NO AGREGA NADA EN FW_MENU_PERFIL

    --CREO E INSERTO EN LA TABLA TEMPORAL LAS LINEAS QUE VA A CONTENER EL SCRIPT 
	IF OBJECT_ID('tempdb..##TMP') IS NOT NULL  DROP TABLE ##TMP
	CREATE TABLE ##TMP
	(
	DATOS VARCHAR(MAX),
	ORDEN INT
	)
    
    --DECLARACIONES DE VARIABLES (Para declarar, declaro todos los IDS, porque puede haber secciones, menues o controladores que ya existen y no incluyo en las temporales)
	INSERT INTO ##TMP (DATOS) SELECT 'SET NOCOUNT ON;'  
    INSERT INTO ##TMP (DATOS) SELECT 'DECLARE @vMensaje VARCHAR(200)'  
    INSERT INTO ##TMP (DATOS) SELECT '       ,@ID_MENU_'    + UPPER(REPLACE(FM.CONTROLADOR,' ','_')) + UPPER(REPLACE(FM.ACCION,' ','_')) + ' INT' FROM dbo.FW_MENU FM 
    INSERT INTO ##TMP (DATOS) SELECT '       ,@ID_PERFIL_'  + UPPER(REPLACE(FF.NOMBRE,' ','_')) + ' INT' FROM dbo.FW_PERFILES FF 
    INSERT INTO ##TMP (DATOS) SELECT '   '   
    
    
    --LINEA EN BLANCO E INSTRUCCION DE COMIENZO DE TRANSACCION
  	INSERT INTO ##TMP (DATOS) SELECT '   '   + CHAR(13) + CHAR(10) + 
                              'BEGIN TRY'    + CHAR(13) + CHAR(10) + 
                              '  BEGIN TRAN' + CHAR(13) + CHAR(10) + 
                              '   PRINT ' + '''' + '--->>>  Actualizacion de datos Iniciada  <<<---' + ''''
    --LINEA EN BLANCO
  	INSERT INTO ##TMP (DATOS) SELECT '   '

 	--INSERT DE PERFILES------------------------------------------------------------------------------------------------------------------------------
	INSERT INTO ##TMP (DATOS)
	SELECT '   -----------------------------------------------------------------------------------------------------------------' + CHAR(13) + CHAR(10) + 
           '   --TABLA:   FW_PERFILES'  + CHAR(13) + CHAR(10) + 
           '   --ACCION:  INSERCION DE REGISTROS' + CHAR(13) + CHAR(10) + 
           '   --COMMENT: SE AGREGA NUEVO PERFIL DE ' + UPPER(FP.NOMBRE) + CHAR(13) + CHAR(10) + 
           + CHAR(13) + CHAR(10) + 
           '   SET @vMENSAJE = ' + '''' + 'No se pudieron insertar datos en la tabla [dbo].[FW_PERFILES]' + '''' + CHAR(13) + CHAR(10) + 
           + CHAR(13) + CHAR(10) + 
           '   IF NOT EXISTS (SELECT TOP 1 * FROM dbo.FW_PERFILES WHERE NOMBRE = ' + '''' + FP.NOMBRE + '''' + ')' + CHAR(13) + CHAR(10) + 
           '     BEGIN' + CHAR(13) + CHAR(10) + 
           '       INSERT INTO dbo.FW_PERFILES (NOMBRE) VALUES (' + '''' + FP.NOMBRE + ''''+ ') ' + CHAR(13) + CHAR(10) + 
           '       SET ' + FP.VAR_PERFIL + ' = SCOPE_IDENTITY()' + CHAR(13) + CHAR(10) + 
           '     END' + CHAR(13) + CHAR(10) + 
           '   ELSE' + CHAR(13) + CHAR(10) + 
           '     BEGIN' + CHAR(13) + CHAR(10) + 
           '       SET ' + FP.VAR_PERFIL + ' = (SELECT ID_PERFIL FROM dbo.FW_PERFILES WHERE NOMBRE = ' + '''' + FP.NOMBRE + '''' + ')' + CHAR(13) + CHAR(10) + 
           '     END   ' + CHAR(13) + CHAR(10) + 
           '   PRINT '+ '''' + 'FW_PERFILES......................OK [' + UPPER(REPLACE(dbo.Fx_FC_RemoverTildes(FP.NOMBRE),' ','_')) + ']' + '''' + CHAR(13) + CHAR(10)   
      FROM @TMP_NUEVOS_PERFILES FP


    --LINEA EN BLANCO 
  	INSERT INTO ##TMP (DATOS) SELECT '   '

    --INSERT DE MENU_PERFILES-------------------------------------------------------------------------------------------------------------------
	INSERT INTO ##TMP (DATOS)
	SELECT '   -----------------------------------------------------------------------------------------------------------------' + CHAR(13) + CHAR(10) + 
           '   --TABLA:   FW_MENU_PERFILES'  + CHAR(13) + CHAR(10) + 
           '   --ACCION:  INSERCION DE REGISTROS' + CHAR(13) + CHAR(10) + 
           '   --COMMENT: SE AGREGA NUEVA RELACION DE MENU Y PERFIL ' + '"' + TP.NOMBRE_MENU + '/' + TP.NOMBRE_PERFIL + '"' + CHAR(13) + CHAR(10) + 
           CHAR(13) + CHAR(10) + 
           '   SET @vMENSAJE = ' + '''' + 'No se pudieron insertar datos en la tabla [dbo].[FW_MENU_PERFIL] (' + TP.NOMBRE_MENU + '/' + TP.NOMBRE_PERFIL + ')' + '''' + CHAR(13) + CHAR(10) + 
           CHAR(13) + CHAR(10) + 
           '   IF NOT EXISTS (SELECT TOP 1 * ' + CHAR(13) + CHAR(10) + 
           '                    FROM dbo.FW_MENU_PERFILES FP INNER JOIN dbo.FW_MENU FM ON FP.ID_MENU = FM.ID_MENU' + CHAR(13) + CHAR(10) + 
           '                                                 INNER JOIN dbo.FW_PERFILES FF ON FP.ID_PERFIL = FF.ID_PERFIL ' + CHAR(13) + CHAR(10) + 
           '                   WHERE FF.NOMBRE = ' + '''' + TP.NOMBRE_PERFIL + '''' + CHAR(13) + CHAR(10) +  
           '                     AND FM.ACCION = ' + '''' + TP.ACCION  + '''' + ')' +  CHAR(13) + CHAR(10) +  
           '   INSERT INTO dbo.FW_MENU_PERFILES (ID_PERFIL, ID_MENU) VALUES (' + TP.VAR_PERFIL + ', ' + TP.VAR_MENU + ')' + CHAR(13) + CHAR(10) +
           '   PRINT '+ '''' + 'FW_MENU_PERFIL...................OK [' + UPPER(TP.NOMBRE_MENU) + '/' + UPPER(TP.NOMBRE_PERFIL) + ']' + '''' + CHAR(13) + CHAR(10)   
      FROM @TMP_NUEVOS_MENUES_PERF TP



    --LINEA EN BLANCO E INSTRUCCION DE FIN DE TRANSACCION CON CATCH
  	INSERT INTO ##TMP (DATOS) 
  	SELECT '   '   + CHAR(13) + CHAR(10) + 
           '   -----------------------------------------------------------------------------------------------------------------' + CHAR(13) + CHAR(10) + 
           '   PRINT ' + '''' + '--->>>  Actualizacion de datos Finalizada  <<<---' + '''' + CHAR(13) + CHAR(10) + 
           CHAR(13) + CHAR(10) +
           '  COMMIT'    + CHAR(13) + CHAR(10) +
           'END TRY' + CHAR(13) + CHAR(10) +
           CHAR(13) + CHAR(10) + 
           CHAR(13) + CHAR(10) +  
           '/*****************************************************************************************************************************************/' + CHAR(13) + CHAR(10) + 
           'BEGIN CATCH' + CHAR(13) + CHAR(10) + 
           '  IF @@TRANCOUNT > 0 ROLLBACK TRAN' + CHAR(13) + CHAR(10) + 
           '  DECLARE @MENSAJE_ERROR NVARCHAR(1000)' + CHAR(13) + CHAR(10) + 
           '  SET @MENSAJE_ERROR = (SELECT ' + '''' + '[-ERROR: ' + '''' + ' + ERROR_MESSAGE() + ' + '''' + '|' + '''' + '+' + CHAR(13) + CHAR(10) + 
           '                               ' + '''' +  '-NRO: '   + '''' + ' + LTRIM(ERROR_NUMBER()) + ' + '''' +  '|' + '''' + ' + ' + CHAR(13) + CHAR(10) +  
           '                               ' + '''' +  '-LINEA: ' + '''' + ' + LTRIM(ERROR_LINE()) + ' + '''' + ']' + '''' + CHAR(13) + CHAR(10) + 
           '                       )' + CHAR(13) + CHAR(10) + 
           '  PRINT @MENSAJE_ERROR ' + CHAR(13) + CHAR(10) + 
           '  PRINT ' + '''' + '--->>> Actualizacion Terminada¡Rollback! <<<---' + '''' + CHAR(13) + CHAR(10) + 
           'END CATCH' + CHAR(13) + CHAR(10) + 
           '/****************************************************************************************************************************************/'
     
	--GENERAMOS EL ARCHIVO
	SET @COMMAND = 'BCP "SELECT DATOS FROM ' + @BASE + '.dbo.##TMP" QUERYOUT "'
	SET @COMMAND = @COMMAND + @DIROUT + @FILENAME + '" -T  -S ' + @SERVER + ' -c -t ' 

	EXECUTE @RESULT = MASTER..XP_CMDSHELL @COMMAND

	IF @RESULT = 0  
	  BEGIN   
		 PRINT 'OK. Se genero el archivo correctamente'
		 DROP TABLE ##TMP
	  END	 
	ELSE
	  BEGIN
		 --SI NO SE PUDO GENERAR EL ARCHIVO TXT
		 SET @MENSAJE = 'No se ha podido generar el archivo TXT'
		 RAISERROR ('', 16, 1)
	  END    
END TRY
 
/*****************************************************************************************************************************************/
BEGIN CATCH
  IF @@TRANCOUNT > 0 ROLLBACK TRAN
  
  DECLARE @MENSAJE_ERROR NVARCHAR(1000)
  
  SET @MENSAJE_ERROR = (SELECT '-ERROR: ' + @MENSAJE + ' [' + ERROR_MESSAGE() + '|' +
                               '-NRO: '  + LTRIM(ERROR_NUMBER()) + '|' +
                               '-LINEA:' + LTRIM(ERROR_LINE()) + ']'
                       )
  
  PRINT @MENSAJE_ERROR 
END CATCH
/****************************************************************************************************************************************/

/*FIN*/

