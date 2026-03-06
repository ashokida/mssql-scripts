/**********************************************************************************************************************************************
*    Descripcion: Script que lista las funciones definidas por el usuario
* Fecha creacion: 04/07/2014
*          Autor: AShokida
***********************************************************************************************************************************************/

  SELECT SO.name        AS NOMBRE_FUNCION, 
         SC.name        AS ESQUEMA,
         SO.create_date AS FECHA_CREACION,
         SO.modify_date AS FECHA_MODIFICACION
    FROM SYS.objects SO INNER JOIN SYS.SCHEMAS SC ON SO.SCHEMA_ID = SC.SCHEMA_ID   
   WHERE TYPE='FN' 
ORDER BY  SC.NAME, SO.name


/*FIN*/
