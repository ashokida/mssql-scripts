/**********************************************************************************************************************************************
*    Descripcion: Script que lista todas las stored procedures (En caso de ser necesario le agrego la columna de create para los permisos)
* Fecha creacion: 19/12/2012
*          Autor: AShokida
***********************************************************************************************************************************************/

  SELECT SO.name AS NOMBRE_SP, 
         SC.name AS ESQUEMA,
         SO.create_date AS FECHA_CREACION,
         SO.modify_date AS FECHA_MODIFICACION
         --'CREATE PROCEDURE ' + '[' + SC.name + '].' + '[' + SO.name + ']' AS CREACION,
         --'GRANT EXECUTE ON ' + '[' + SC.name + '].' + '[' + SO.name + ']' + ' TO [APPFW_WEB]' AS GRANTS 
    FROM SYS.objects SO INNER JOIN SYS.SCHEMAS SC ON SO.SCHEMA_ID = SC.SCHEMA_ID   
   WHERE TYPE='P'
  ORDER BY  SO.modify_date desc

/*FIN*/
