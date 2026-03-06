/**********************************************************************************************************************************************
*    Descripcion: Lista de funciones utiles para utilizar cuando sea necesario
* Fecha creacion: 24/10/2013
*          Autor: AShokida
***********************************************************************************************************************************************/

/*Completar con ceros a la izquierda*/
SELECT REPLICATE('0', (10 - LEN(uni_codigo_nis))) + uni_codigo_nis from sucursal


/*Si existe una FK de una columna determinada*/
  IF EXISTS (SELECT TOP 1 * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KCU ON KCU.CONSTRAINT_CATALOG = RC.CONSTRAINT_CATALOG  AND KCU.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA AND KCU.CONSTRAINT_NAME = RC.CONSTRAINT_NAME 
              WHERE KCU.TABLE_NAME = 'MAQUINA_ESTADO' AND KCU.COLUMN_NAME = 'TRN_CODIGO')

/************************************************************************************************************************************
* Descripcion: Script para comprobar el valor de identidad actual de una tabla y definir u nuevo valor
*************************************************************************************************************************************

EJ:
   DBCC CHECKIDENT ('Traza.PROVEEDOR')                        : Comprueba el valor del ID
   DBCC CHECKIDENT (<TABLA>, Reseed, <ULTIMO ID DE LA TABLA>) : Sin esquema, solo especificar nombre de tabla
   DBCC CHECKIDENT ('Traza.PROVEEDOR', Reseed, 44)            : Si hace falta especificar el esquema, el nombre debe estar entre comillas       

*/


              