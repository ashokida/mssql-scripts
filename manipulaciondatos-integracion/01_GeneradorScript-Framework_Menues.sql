DECLARE @TMP_NUEVAS_SECCIONES   TABLE (SECCION_NOMBRE VARCHAR(255), VAR_SECCION VARCHAR(300))
DECLARE @TMP_NUEVOS_MENUES      TABLE (ID_MENU INT, MENU_ACCION VARCHAR(100), VAR_SECCION VARCHAR(300), VAR_MENU VARCHAR(100))
DECLARE @TMP_NUEVOS_MENUES_CONT TABLE (CONTROLADOR_NOMBRE VARCHAR(50), ACCION_NOMBRE VARCHAR(255), VAR_MENU VARCHAR(100))

DECLARE @SERVER                VARCHAR(30),
        @BASE                  VARCHAR (50),
        @DIROUT                VARCHAR(100),
        @INICIATIVA            VARCHAR(10), 
        @FILENAME              VARCHAR(500), 
        @COMMAND               VARCHAR(4000), 
        @RESULT                INT,
        @MENSAJE               VARCHAR(500),
        @ACTUALIZO_NBRE_MNU    CHAR(1)

    --SETEO TODOS LOS PARAMETROS 
    SET @SERVER              = @@SERVERNAME
	SET @BASE                = 'STP'
	SET @DIROUT              = '\\' + @@SERVERNAME + '\STP_CABAL\OUT\'
	SET @INICIATIVA          = '2430003'
	SET @FILENAME            = @INICIATIVA + '_' + @BASE + '_FWK-DatosMenues.sql'
	SET @ACTUALIZO_NBRE_MNU  = 'N' --Si es 'S' actualizo los nombres de menues sin acento (Es que al levantarlos se rompe el string si tiene acento)
	

BEGIN TRY
	SET NOCOUNT ON    

	--INSERTO EN TABLAS TEMPORALES:
	
	--LAS NUEVAS SECCIONES A CREAR O EXISTENTES
	INSERT INTO @TMP_NUEVAS_SECCIONES (SECCION_NOMBRE, VAR_SECCION) 
	     SELECT NOMBRE,
	            '@ID_SECCION_' + UPPER(REPLACE(dbo.Fx_FC_RemoverTildes(NOMBRE),' ','_')) 
	       FROM FW_SECCIONES 
	      --WHERE NOMBRE IN ('Envíos', 'Reportes') 
	
	--LOS NUEVOS MENUES A CREAR O EXISTENTES, INDICANDO LA SECCION (NUEVA O EXISTENTE)
	INSERT INTO @TMP_NUEVOS_MENUES (ID_MENU, MENU_ACCION, VAR_SECCION, VAR_MENU) 
	     SELECT FM.ID_MENU,
	            FM.ACCION,
	            '@ID_SECCION_' + UPPER(REPLACE(FS.NOMBRE,' ','_')) VAR_SECCION,
	            '@ID_MENU_' + UPPER(REPLACE(FM.CONTROLADOR,' ','_')) + UPPER(REPLACE(FM.ACCION,' ','_'))  VAR_MENU
	       FROM FW_MENU FM INNER JOIN FW_SECCIONES FS ON FM.SECCION = FS.SECCION_ID
	      --WHERE FM.NOMBRE IN ('ABM Maquina de estados','Asignación Mail','Asignación Parametro','Clientes','Estados','Imposicion piezas RHE','Mail','Motivos','Novedades Facturación','Operaciones por CT','Parametros Sistema','Producto por Cliente','Productos','Rubros','Sucursal por Cliente','Transacciones') 	    
    
    --LAS NUEVAS ACCIONES DE LOS CONTROLADORES (PARA LOS NUEVOS MENUES CREADOS) O EXISTENTES
    INSERT INTO @TMP_NUEVOS_MENUES_CONT (CONTROLADOR_NOMBRE, ACCION_NOMBRE, VAR_MENU)
         SELECT FC.CONTROLADOR,
                FC.ACCION,
                TN.VAR_MENU
          FROM FW_MENU_CONTROLADOR FC INNER JOIN FW_MENU FM INNER JOIN @TMP_NUEVOS_MENUES TN ON FM.ACCION = TN.MENU_ACCION
                                                                                            AND FM.ID_MENU = TN.ID_MENU
                                      ON FC.MENU_ID = FM.ID_MENU 


    --CREO E INSERTO EN LA TABLA TEMPORAL LAS LINEAS QUE VA A CONTENER EL SCRIPT 
	IF OBJECT_ID('tempdb..##TMP') IS NOT NULL  DROP TABLE ##TMP
	CREATE TABLE ##TMP
	(
	ORDEN INT,
	DATOS VARCHAR(MAX)
	)
    
    --DECLARACIONES DE VARIABLES (Para declarar, declaro todos los IDS, porque puede haber secciones, menues o controladores que ya existen y no incluyo en las temporales)
	INSERT INTO ##TMP (ORDEN, DATOS) SELECT 1, 'SET NOCOUNT ON;' 
    INSERT INTO ##TMP (ORDEN, DATOS) SELECT 2, 'DECLARE @vMensaje VARCHAR(200)'  
    INSERT INTO ##TMP (ORDEN, DATOS) SELECT 3, '       ,@ID_SECCION_' + UPPER(REPLACE(dbo.Fx_FC_RemoverTildes(FS.NOMBRE),' ','_')) + ' INT' FROM dbo.FW_SECCIONES FS
    INSERT INTO ##TMP (ORDEN, DATOS) SELECT 4, '       ,@ID_MENU_'    + UPPER(REPLACE(FM.CONTROLADOR,' ','_')) + UPPER(REPLACE(FM.ACCION,' ','_')) + ' INT' FROM dbo.FW_MENU FM 
    INSERT INTO ##TMP (ORDEN, DATOS) SELECT 5, '       ,@ID_PERFIL_'  + UPPER(REPLACE(FF.NOMBRE,' ','_')) + ' INT' FROM dbo.FW_PERFILES FF 
    INSERT INTO ##TMP (ORDEN, DATOS) SELECT 6, '   '   
    
    
    --LINEA EN BLANCO E INSTRUCCION DE COMIENZO DE TRANSACCION
  	INSERT INTO ##TMP (ORDEN, DATOS) SELECT 7,
  	                          '   '   + CHAR(13) + CHAR(10) + 
                              'BEGIN TRY'    + CHAR(13) + CHAR(10) + 
                              '  BEGIN TRAN' + CHAR(13) + CHAR(10) + 
                              '   PRINT ' + '''' + '--->>>  Actualizacion de datos Iniciada  <<<---' + ''''

	--UPDATE DE NOMBRE DE MENUES-----------------------------------------------------------------------------------------------------------------------
    IF @ACTUALIZO_NBRE_MNU = 'S'
      BEGIN
        INSERT INTO ##TMP (ORDEN, DATOS)
	    SELECT 8,
	           '   -----------------------------------------------------------------------------------------------------------------' + CHAR(13) + CHAR(10) + 
               '   --TABLA:   FW_MENU'  + CHAR(13) + CHAR(10) + 
               '   --ACCION:  ACTUALIZACION DE REGISTROS' + CHAR(13) + CHAR(10) + 
               '   --COMMENT: SE ACTUALIZAN LOS NOMBRES DE LOS MENUES. SE TOMAN DE DESARROLLO'

        --LINEA EN BLANCO
  	    INSERT INTO ##TMP (ORDEN, DATOS) SELECT 9, '   '
  	    
        INSERT INTO ##TMP (ORDEN, DATOS)
        SELECT 10,
               '   SET @vMENSAJE = ' + '''' + 'No se pudo actualizar dato en la tabla [dbo].[FW_MENU] (' + FM.NOMBRE + ')' + '''' + CHAR(13) + CHAR(10) + 
               '   UPDATE FW_MENU ' + CHAR(13) + CHAR(10) + 
               '      SET NOMBRE      = ' + '''' + dbo.Fx_FC_RemoverTildes(FM.NOMBRE) + ''''   + CHAR(13) + CHAR(10) +
               '         ,DESCRIPCION = ' + '''' + dbo.Fx_FC_RemoverTildes(FM.DESCRIPCION) + ''''   + CHAR(13) + CHAR(10) + 
               '    WHERE CONTROLADOR = ' + '''' + FM.CONTROLADOR + '''' + ' AND ACCION = '  + '''' + FM.ACCION + ''''  + CHAR(13) + CHAR(10) +   
               '   PRINT '+ '''' + 'FW_MENU..........................OK [' + UPPER(FM.NOMBRE) + '] - (Update Nombre/Descripcion)' + '''' + CHAR(13) + CHAR(10)   
          FROM dbo.FW_MENU FM INNER JOIN @TMP_NUEVOS_MENUES TM ON FM.ACCION = TM.MENU_ACCION
	  END
	 
	--INSERT DE SECCIONES------------------------------------------------------------------------------------------------------------------------------
	INSERT INTO ##TMP (ORDEN, DATOS)
	SELECT 11,  -----> ORDEN EN QUE DEBE QUEDAR EL SCRIPT (FW_SECCIONES se inserta 1ero)
	       '   -----------------------------------------------------------------------------------------------------------------' + CHAR(13) + CHAR(10) + 
           '   --TABLA:   FW_SECCIONES'  + CHAR(13) + CHAR(10) + 
           '   --ACCION:  INSERCION DE REGISTROS' + CHAR(13) + CHAR(10) + 
           '   --COMMENT: SE AGREGA NUEVA SECCION DE ' + UPPER(FS.NOMBRE) + CHAR(13) + CHAR(10) + 
           + CHAR(13) + CHAR(10) + 
           '   SET @vMENSAJE = ' + '''' + 'No se pudieron insertar datos en la tabla [dbo].[FW_SECCIONES] (' + FS.NOMBRE + ')' + '''' + CHAR(13) + CHAR(10) + 
           + CHAR(13) + CHAR(10) + 
           '   IF NOT EXISTS (SELECT TOP 1 * FROM dbo.FW_SECCIONES WHERE NOMBRE = ' + '''' + FS.NOMBRE + '''' + ')' + CHAR(13) + CHAR(10) + 
           '     BEGIN' + CHAR(13) + CHAR(10) + 
           '       INSERT INTO dbo.FW_SECCIONES (NOMBRE, ORDEN) VALUES (' + '''' + FS.NOMBRE + ''''+ ',' + LTRIM(FS.ORDEN) + ') ' + CHAR(13) + CHAR(10) + 
           '       SET @ID_SECCION_' + UPPER(REPLACE(dbo.Fx_FC_RemoverTildes(FS.NOMBRE),' ','_')) + ' = SCOPE_IDENTITY()' + CHAR(13) + CHAR(10) + 
           '     END' + CHAR(13) + CHAR(10) + 
           '   ELSE' + CHAR(13) + CHAR(10) + 
           '     BEGIN' + CHAR(13) + CHAR(10) + 
           '       SET @ID_SECCION_' + UPPER(REPLACE(dbo.Fx_FC_RemoverTildes(FS.NOMBRE),' ','_')) + ' = (SELECT SECCION_ID FROM dbo.FW_SECCIONES WHERE NOMBRE = ' + '''' + FS.NOMBRE + '''' + ')' + CHAR(13) + CHAR(10) + 
           '     END   ' + CHAR(13) + CHAR(10) + 
           '   PRINT '+ '''' + 'FW_SECCIONES.....................OK [' + UPPER(REPLACE(dbo.Fx_FC_RemoverTildes(FS.NOMBRE),' ','_')) + ']' + '''' + CHAR(13) + CHAR(10)   
      FROM dbo.FW_SECCIONES FS INNER JOIN @TMP_NUEVAS_SECCIONES TN ON FS.NOMBRE = TN.SECCION_NOMBRE

    --LINEA EN BLANCO
  	INSERT INTO ##TMP (ORDEN, DATOS) SELECT 12, '   '

    --INSERT DE MENUES------------------------------------------------------------------------------------------------------------------------------
	INSERT INTO ##TMP (ORDEN, DATOS)
	SELECT 13, -----> ORDEN EN QUE DEBE QUEDAR EL SCRIPT (Insert de FW_MENU viene desdpues de FW_SECCIONES)
	       '   -----------------------------------------------------------------------------------------------------------------' + CHAR(13) + CHAR(10) + 
           '   --TABLA:   FW_MENU'  + CHAR(13) + CHAR(10) + 
           '   --ACCION:  INSERCION DE REGISTROS' + CHAR(13) + CHAR(10) + 
           '   --COMMENT: SE AGREGA NUEVO MENU DE ' + UPPER(FM.NOMBRE) + CHAR(13) + CHAR(10) + 
           CHAR(13) + CHAR(10) + 
           '   SET @vMENSAJE = ' + '''' + 'No se pudieron insertar datos en la tabla [dbo].[FW_MENU]' + '''' + CHAR(13) + CHAR(10) + 
           CHAR(13) + CHAR(10) + 
           '   IF NOT EXISTS (SELECT TOP 1 * FROM dbo.FW_MENU WHERE CONTROLADOR = ' + '''' + FM.CONTROLADOR + '''' + ' AND ACCION = ' + '''' + FM.ACCION + '''' + ')' + CHAR(13) + CHAR(10) + 
           '     BEGIN' + CHAR(13) + CHAR(10) + 
           '       INSERT INTO dbo.FW_MENU (SECCION, NOMBRE, DESCRIPCION, CONTROLADOR, ACCION, ORDEN, PARAMETROS)' + CHAR(13) + CHAR(10) +  
           '            VALUES (' + TM.VAR_SECCION + ',' +  '''' + FM.NOMBRE + ''''+ ',' + '''' + FM.DESCRIPCION + ''''+ ',' + '''' + FM.CONTROLADOR + ''''+ ',' + '''' + FM.ACCION + '''' + ',' + LTRIM(FM.ORDEN) + ',' + '''' + FM.PARAMETROS + ''''+  + ') ' + CHAR(13) + CHAR(10) + 
           '       SET @ID_MENU_' +  UPPER(REPLACE(FM.CONTROLADOR,' ','_')) + UPPER(REPLACE(FM.ACCION,' ','_')) + ' = SCOPE_IDENTITY()' + CHAR(13) + CHAR(10) + 
           '     END' + CHAR(13) + CHAR(10) + 
           '   ELSE' + CHAR(13) + CHAR(10) + 
           '     BEGIN' + CHAR(13) + CHAR(10) + 
           '       SET @ID_MENU_' +  UPPER(REPLACE(FM.CONTROLADOR,' ','_')) + UPPER(REPLACE(FM.ACCION,' ','_')) + ' = (SELECT ID_MENU FROM dbo.FW_MENU WHERE CONTROLADOR = ' + '''' + FM.CONTROLADOR + '''' + ' AND ACCION = ' + '''' + FM.ACCION + '''' + ')' + CHAR(13) + CHAR(10) + 
           '     END   '  + CHAR(13) + CHAR(10) + 
           '   PRINT '+ '''' + 'FW_MENU..........................OK [' + UPPER(FM.NOMBRE) + ']' + '''' + CHAR(13) + CHAR(10)     
      FROM dbo.FW_MENU FM INNER JOIN @TMP_NUEVOS_MENUES TM ON FM.ID_MENU = TM.ID_MENU

    --LINEA EN BLANCO
  	INSERT INTO ##TMP (ORDEN,DATOS) SELECT 14, '   '

    --INSERT DE MENU_CONTROLADORES-------------------------------------------------------------------------------------------------------------------
	INSERT INTO ##TMP (ORDEN, DATOS)
	SELECT 15, -----> ORDEN EN QUE DEBE QUEDAR EL SCRIPT (Insert de FW_MENU_CONTROLADOR viene despues de FW_MENU)
	       '   -----------------------------------------------------------------------------------------------------------------' + CHAR(13) + CHAR(10) + 
           '   --TABLA:   FW_MENU_CONTROLADOR'  + CHAR(13) + CHAR(10) + 
           '   --ACCION:  INSERCION DE REGISTROS' + CHAR(13) + CHAR(10) + 
           '   --COMMENT: SE AGREGA NUEVA ACCION DEL CONTROLADOR ' + '"' + TC.CONTROLADOR_NOMBRE + '"' + CHAR(13) + CHAR(10) + 
           CHAR(13) + CHAR(10) + 
           '   SET @vMENSAJE = ' + '''' + 'No se pudieron insertar datos en la tabla [dbo].[FW_MENU_CONTROLADOR] (' + TC.ACCION_NOMBRE + ')' + '''' + CHAR(13) + CHAR(10) + 
           CHAR(13) + CHAR(10) + 
           '   IF NOT EXISTS (SELECT TOP 1 * FROM dbo.FW_MENU_CONTROLADOR WHERE MENU_ID = ' + TC.VAR_MENU + ' AND CONTROLADOR = ' + '''' + TC.CONTROLADOR_NOMBRE + '''' + ' AND ACCION = ' + '''' + TC.ACCION_NOMBRE + '''' +  ')' + CHAR(13) + CHAR(10) + 
           '   INSERT INTO dbo.FW_MENU_CONTROLADOR (MENU_ID,CONTROLADOR,ACCION)' + CHAR(13) + CHAR(10) +  
           '        VALUES (' + TC.VAR_MENU + ',' + '''' + TC.CONTROLADOR_NOMBRE + '''' + ',' + '''' + TC.ACCION_NOMBRE + '''' + ')' + CHAR(13) + CHAR(10) +
           '   PRINT '+ '''' + 'FW_MENU_CONTROLADOR..............OK [' + UPPER(TC.ACCION_NOMBRE) + ']' + '''' + CHAR(13) + CHAR(10)   
      FROM @TMP_NUEVOS_MENUES_CONT TC
    

    --LINEA EN BLANCO E INSTRUCCION DE FIN DE TRANSACCION CON CATCH
  	INSERT INTO ##TMP (ORDEN, DATOS) 
  	SELECT 16,
  	       '   '   + CHAR(13) + CHAR(10) + 
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
	SET @COMMAND = 'BCP "SELECT DATOS FROM ' + @BASE + '.dbo.##TMP ORDER BY ORDEN" QUERYOUT "'
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

