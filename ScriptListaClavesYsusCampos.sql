/**********************************************************************************************************************************************
*    Descripcion: Script que lista las claves primarias y sus respectivos campos
* Fecha creacion: 18/07/2014
*          Autor: AShokida
***********************************************************************************************************************************************/

SELECT IND.NAME                            AS CLAVE,
       OBJECT_NAME(IC.OBJECT_ID)           AS TABLA,
       COL_NAME(IC.OBJECT_ID,IC.COLUMN_ID) AS CAMPO
  FROM SYS.INDEXES IND INNER JOIN SYS.INDEX_COLUMNS IC ON IND.OBJECT_ID = IC.OBJECT_ID
                                                      AND IND.INDEX_ID = IC.INDEX_ID
 WHERE IND.IS_PRIMARY_KEY = 1
 AND OBJECT_NAME(IC.OBJECT_ID)  = '' ---> Aca especifico el nombre de la tabla en particular que quiero
 
 /*FIN*/

