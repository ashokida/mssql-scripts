/*********************************************************************************************************************************************
* Descripcion: 
*   
*      Ticket:         
*       Fecha: //
*       Autor: AShokida 
**********************************************************************************************************************************************/

DECLARE @vMensaje varchar(100)

BEGIN TRY 
  BEGIN TRAN 
    SET @vMensaje = 'Aca escribir mensaje de error'
      
  COMMIT
END TRY

/*******************************************************************************************************************************/
BEGIN CATCH
  IF @@TRANCOUNT > 0
    BEGIN
 	 ROLLBACK TRAN  
      /*
     --Opcion 1--------------------------------------------------------------- 
     SELECT 'NRO_ERROR: ' + LTRIM(ERROR_NUMBER()) + ' - DESCRIPCION_ERROR: ' +  LTRIM(ERROR_MESSAGE()) AS MENSAJE_ERROR
     
     --Opcion 2---------------------------------------------------------------
     Declare @ErrorMessage NVARCHAR(1000), 
          @ErrorSeverity INT, 
          @ErrorState INT
     
     
      SELECT @ErrorMessage = @vMensaje + char(13) + ERROR_MESSAGE(),
             @ErrorSeverity = ERROR_SEVERITY(),
             @ErrorState = ERROR_STATE()
                    
      RAISERROR(@ErrorMessage , @ErrorSeverity, @ErrorState);
     */
     --Opcion 3---------------------------------------------------------------
     SELECT LTRIM(ERROR_NUMBER())  AS NRO_ERROR,
            LTRIM(ERROR_MESSAGE()) AS SQL_ERROR,
            @vMensaje AS DESCRIPCION_ERROR
    END  
 
END CATCH 
/********************************************************************************************************************************/

/*FIN*/
GO
 
