/**********************************************************************************************************************************************
*    Descripcion: Script de ejemplo para generacion correcta de cursores
* Fecha creacion: 28/07/2014
*          Autor: AShokida
***********************************************************************************************************************************************/


/************************************************************************************************************************************
* Creo la SP que va a devolver las tablas como cursores a recorrer
************************************************************************************************************************************/

CREATE PROCEDURE dbo.ZZZ_PRUEBA @CursorDeSalida_PARAMETROS CURSOR VARYING OUTPUT,
                                @CursorDeSalida_REGION     CURSOR VARYING OUTPUT

AS

--Cursor para la tabla dbo.PARAMETROS_FACT
SET @CursorDeSalida_PARAMETROS = CURSOR FORWARD_ONLY STATIC FOR
                                 SELECT PAR_ID,
                                        PAR_DESCRIPCION,
                                        PAR_VALOR   
                                   FROM dbo.PARAMETROS_FACT;
                                   OPEN @CursorDeSalida_PARAMETROS;

--Cursor para la tabla dbo.REGION
SET @CursorDeSalida_REGION = CURSOR FORWARD_ONLY STATIC FOR
                             SELECT REG_CODIGO,
                                    REG_NOMBRE   
                               FROM dbo.REGION;
                               OPEN @CursorDeSalida_REGION;
GO   
 



/************************************************************************************************************************************
* Con el script siguiente recorreria los cursores para mostrar el contenido de las tablas
************************************************************************************************************************************/

--Declaro todas las variables, cursores y tablas temporales
DECLARE @MiCursor1 CURSOR,
        @MiCursor2 CURSOR,

        @PAR_ID VARCHAR(50), 
        @PAR_DESCRIPCION VARCHAR(255), 
        @PAR_VALOR VARCHAR(255),

        @REG_CODIGO INT,
        @REG_NOMBRE VARCHAR(30)

DECLARE @tmp_PAR table (PAR_ID VARCHAR(50), PAR_DESCRIPCION VARCHAR(255), PAR_VALOR VARCHAR(255))
DECLARE @tmp_REG table (REG_CODIGO INT, REG_NOMBRE VARCHAR(30))


--Ejecuto SP que devuelve los cursores de las tablas
EXEC dbo.ZZZ_PRUEBA @CursorDeSalida_PARAMETROS = @MiCursor1 OUTPUT,
                    @CursorDeSalida_REGION     = @MiCursor2 OUTPUT


--Recorro Primer Cursor----------------------------------------------------------------------------
  /*Inserto en tabla temporal mientras recorro cursor, para asi efectuar el select despues*/
FETCH NEXT FROM @MiCursor1 INTO @PAR_ID, @PAR_DESCRIPCION, @PAR_VALOR;

WHILE (@@FETCH_STATUS = 0)
 BEGIN;
     INSERT INTO @tmp_PAR
          SELECT @PAR_ID,
                 @PAR_DESCRIPCION,
                 @PAR_VALOR
    
     FETCH NEXT FROM @MiCursor1 INTO @PAR_ID, @PAR_DESCRIPCION, @PAR_VALOR;
     

     
 END;
CLOSE @MiCursor1;
DEALLOCATE @MiCursor1;


--Recorro Segundo Cursor---------------------------------------------------------------------------
  /*Inserto en tabla temporal mientras recorro cursor, para asi efectuar el select despues*/
FETCH NEXT FROM @MiCursor2 INTO @REG_CODIGO, @REG_NOMBRE

WHILE (@@FETCH_STATUS = 0)
 BEGIN;
     INSERT INTO @tmp_REG
          SELECT @REG_CODIGO,
                 @REG_NOMBRE
    
     FETCH NEXT FROM @MiCursor2 INTO @REG_CODIGO, @REG_NOMBRE
     

     
 END;
CLOSE @MiCursor2;
DEALLOCATE @MiCursor2;



SELECT * FROM  @tmp_PAR 
SELECT * FROM  @tmp_REG 

DROP PROCEDURE dbo.ZZZ_PRUEBA