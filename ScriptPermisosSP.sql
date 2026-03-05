/**********************************************************************************************************************************************
*    Descripcion: Script que despliega los permisos (GRANTS) de los objetos que especifico ('P' = Stored Procedure)
* Fecha creacion: 05/08/2014
*          Autor: AShokida
***********************************************************************************************************************************************/

  SELECT SO.name          AS NOMBRE_SP, 
         SC.name          AS ESQUEMA,
         SO.create_date   AS FECHA_CREACION,
         SO.modify_date   AS FECHA_MODIFICACION,
         SO.TYPE
         --'CREATE PROCEDURE ' + '[' + SC.name + '].' + '[' + SO.name + ']' AS CREACION,
         --'GRANT EXECUTE ON ' + '[' + SC.name + '].' + '[' + SO.name + ']' + ' TO [APPFW_WEB]' AS GRANTS 
         ,aux.*
    FROM SYS.objects SO INNER JOIN SYS.SCHEMAS SC ON SO.SCHEMA_ID = SC.SCHEMA_ID   
                        LEFT  JOIN (SELECT class_desc 
                                          ,CASE WHEN class = 0 THEN DB_NAME()
                                                WHEN class = 1 THEN OBJECT_NAME(major_id)
                                                WHEN class = 3 THEN SCHEMA_NAME(major_id) 
         
                                           END [Securable]
                                          ,USER_NAME(grantee_principal_id) [User]
                                          ,permission_name
                                          ,state_desc
                                     FROM sys.database_permissions
                                    WHERE TYPE = 'EX'
                                      AND class_desc NOT IN ('database')
                                      AND (OBJECT_NAME(major_id) NOT IN ('sp_alterdiagram',
                                                                         'sp_alterdiagram',
                                                                         'sp_creatediagram',
                                                                         'sp_creatediagram',
                                                                         'sp_dropdiagram',
                                                                         'sp_dropdiagram',
                                                                         'sp_helpdiagramdefinition',
                                                                         'sp_helpdiagramdefinition',
                                                                         'sp_helpdiagrams',
                                                                         'sp_helpdiagrams',
                                                                         'sp_renamediagram',
                                                                         'sp_renamediagram'
                                                                        ) and class = 1
                                          )
                                    --AND USER_NAME(grantee_principal_id)  = 'Appfw_web') aux on aux.Securable = SO.name
                                   ) aux on aux.Securable = SO.name
   WHERE so.type='p'
   --AND class_desc is null  
 ORDER BY NOMBRE_SP
 
 /*FIN*/