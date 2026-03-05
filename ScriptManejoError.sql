BEGIN TRY
  BEGIN TRAN
  COMMIT TRAN
END TRY   

/*******************************************************************************************************************************/
BEGIN CATCH
  IF @@TRANCOUNT > 0
 	 ROLLBACK TRAN PRUEBA
       
  SELECT 'NRO_ERROR: ' + LTRIM(ERROR_NUMBER()) + ' - DESCRIPCION_ERROR: ' +  LTRIM(ERROR_MESSAGE()) AS MENSAJE_ERROR
 
END CATCH 
/********************************************************************************************************************************/
