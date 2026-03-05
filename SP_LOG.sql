
CREATE PROCEDURE [dbo].[TU_NOMBRE_SP] @pPARAMETROS VARCHAR(MAX)
                
AS        

/***************************************************************************************************************************************************        
** Descripcion: 
** Fecha:     
** Autor:       
** Versión:  
** Notas:    
**        
** Modificaciones.        
**                                                                    
** Ejemplos. 
** 
** Permisos.
****************************************************************************************************************************************************/        

 SET NOCOUNT ON;    
 
--DECLARE VARIABLES

--SETEO VARIABLES

BEGIN TRY
  BEGIN TRAN 
  
    --TODO EL CONTENIDO   


  COMMIT

END TRY

/*********************************************************************************************************************************************************/
BEGIN CATCH
  DECLARE @NOMBRE_SP         NVARCHAR(256),
          @MENSAJE_ADICIONAL NVARCHAR(500)  
  
  IF @@TRANCOUNT > 0 ROLLBACK TRAN  
 	 
  SET @NOMBRE_SP = OBJECT_NAME(@@PROCID)
  SET @MENSAJE_ADICIONAL = 'Hubo un error en la SP'
 	 
  EXEC dbo.BD_SP_LOG_ERROR  @NOMBRE_SP, @MENSAJE_ADICIONAL 
	 
END CATCH 
/********************************************************************************************************************************************************/

/*FIN*/             
GO

CREATE PROCEDURE [dbo].[BD_SP_LOG_ERROR] @pNOMBRE_SP         nVarChar (256),
                                         @pMENSAJE_ADICIONAL nVarChar (500) = Null
                                                  

AS

/********************************************************************************************************************
** Desc:           Graba un error atrapado en una SP en la tabla LOG
** Fecha:          01/03/2016
** Autor Original: GaFernandez (Para SACCT)
** Modificado por: AShokida    (Adaptado para ECOM)
** Versión:        1.0.0
** Notas:          Esto es lo que corresponde poner en donde se llame a esta SP
**                 <Luego del try incorporar la siguiente sintaxis >
**				    BEGIN CATCH
**				      -- Incorporar Rollback si es necesario.
**				      A) Ejemplo agregando mensaje de error personalizado
**			             -- Procesa el error
**			             Declare @pNOMBRE_SP         nVarChar(256)
**                               @pMENSAJE_ADICIONAL nVarChar (500)
**
**                           Set @pNOMBRE_SP         = 'OT_SP_ORDEN_TRABAJO_EMISION'
**			                 Set @pMENSAJE_ADICIONAL = 'Se detecto un error durante el proceso'
**
**	  		                Exec [dbo].[BD_SP_LOG_ERROR] @pNOMBRE_SP, @pMENSAJE_ADICIONAL
**
**			          B) Ejemplo sin mensaje de error personalizado
**				         -- Procesa el error
**				         Exec [dbo].[FC_BD_SP_LOG_ERROR] 'OT_SP_ORDEN_TRABAJO_EMISION'
**				    END CATCH
**		
**
** Modificaciones.
** DD/MM/AAAA (Autor - X.X.X) : Descripcion de la modificación
**
** Ejemplo.
** EXEC BD_SP_LOG_ERROR 'Aca va mensaje de error adicional'
**
** Permisos.
** No requiere permisos por ejecutarse desde otra SP
********************************************************************************************************************/
 
 SET NOCOUNT ON;   

DECLARE @ERROR_MESSAGE  NVARCHAR(4000)


IF @pMENSAJE_ADICIONAL IS NULL
  SET @ERROR_MESSAGE = (SELECT ISNULL(ERROR_MESSAGE(),'') )
ELSE
  BEGIN
    IF ERROR_MESSAGE() IS NULL OR ERROR_MESSAGE() = ''
      SET @ERROR_MESSAGE = @pMENSAJE_ADICIONAL
    ELSE  
      SET @ERROR_MESSAGE = (SELECT @pMENSAJE_ADICIONAL + ' - (' + ISNULL(ERROR_MESSAGE(),'') + ')')
  END 

IF ERROR_PROCEDURE() IS NOT NULL
  SET @pNOMBRE_SP = ERROR_PROCEDURE()
                              
                                  
-- GENERA EL LOG EN LA TABLA DE LOG_SP DE LA BASE DE DATOS ECOM
INSERT INTO dbo.LOG_SP (LOG_FECHA,LOG_USUARIO,LOG_MENSAJE,LOG_NUMERO,LOG_LINEA,LOG_PROCEDIMIENTO)
     SELECT GETDATE (),
            SUSER_SNAME(),
            @ERROR_MESSAGE,
            ERROR_NUMBER(),
            ERROR_LINE(),
            @pNOMBRE_SP


/* FIN */



