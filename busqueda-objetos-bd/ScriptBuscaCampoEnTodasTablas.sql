/**********************************************************************************************************************************************
*    Descripcion: Script que busca el nombre de un campo en todas las tablas de la base de datos
* Fecha creacion: 30/07/2010
*          Autor: AShokida
***********************************************************************************************************************************************/

  SELECT sysobjects.NAME   AS TABLA, 
         syscolumns.NAME   AS CAMPO, 
         systypes.NAME     AS TIPO, 
         syscolumns.LENGTH AS LONGITUD
    FROM sysobjects INNER JOIN syscolumns ON sysobjects.id = syscolumns.id 
                    INNER JOIN systypes ON syscolumns.xtype = systypes.xtype
   WHERE (sysobjects.xtype = 'U')
     and (UPPER(syscolumns.NAME) like upper('par_id')) ------> Especificar aca el nombre del campo
ORDER BY sysobjects.NAME, syscolumns.colid

/*FIN*/