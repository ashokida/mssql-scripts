/**********************************************************************************************************************************************
*    Descripcion: Script que lista todas las tablas 
* Fecha creacion: 15/01/2013
*          Autor: AShokida
***********************************************************************************************************************************************/

   SELECT SO.NAME TABLA, 
          SO.modify_date,
		  SO.create_date 
     FROM sys.objects SO 
WHERE SO.TYPE = 'U'
--AND SO.name like '%norma%'  
ORDER BY SO.NAME

/*FIN*/

--select * from TEST_AES