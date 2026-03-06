/**********************************************************************************************************************************************
*    Descripcion: Script que lista todas las tablas y sus campos con sus especificaciones (tipo, largo y de que esquema son)
* Fecha creacion: 15/01/2013
*          Autor: AShokida
***********************************************************************************************************************************************/

   SELECT SO.NAME TABLA, 
          SC.NAME CAMPO, 
          SH.name ESQUEMA,
          ST.name AS TIPO,
          SC.MAX_LENGTH AS LARGO
     FROM sys.objects SO INNER JOIN sys.columns SC ON SO.OBJECT_ID = SC.OBJECT_ID
                         INNER JOIN sys.types ST ON SC.system_type_id = ST.system_type_id
                         INNER JOIN sys.schemas SH ON SH.schema_id = SO.schema_id
WHERE SO.TYPE = 'U'
/*and SO.NAME  not like '_eventslog'
and SO.NAME  not like '_______HERMANADO_SUCURSAL'
and SO.NAME  not like 'LISTA_TT'
and SO.NAME  not like 'zz_TEMPO_PI'
and SO.NAME  not like 'zz_TEMPO_PI2'
and SO.NAME  not like '%nw%'
and SO.NAME  not like 'SUCURSAL_OLD'
and SO.NAME  not like 'tarjeta_prepaga_TT'
and SO.NAME  not like 'tarjeta_prepagaTT'
and SO.NAME  not like 'sysdiagrams'
and SO.NAME  not like 'CUENTAS_PAGO_DETALLE2'
and SO.NAME  not like 'CUENTAS_PAGO_LOTE2'
and SO.NAME  not like 'PERSONA_AUX'
and SO.NAME  not like 'PERSONA_AUX2'
and SO.NAME  not like 'PersonaHoy'
and SO.NAME  not like 'TEST_AES'
and SO.NAME  not like 'CONTROL'
*/
ORDER BY SO.NAME, 
         SC.NAME,
         SH.NAME

/*FIN*/

--select * from TEST_AES