/**********************************************************************************************************************************************
*    Descripcion: Script que lista todos los indices de todas las tablas
* Fecha creacion: 30/09/2013
*          Autor: AShokida
***********************************************************************************************************************************************/

SELECT '[' + Sch.name + ']' AS ESQUEMA,
       '[' + Tab.[name] + ']' AS TABLA,
       Ind.[name] AS INDICE,
       SUBSTRING((    SELECT ', ' + AC.name FROM sys.[tables] AS T INNER JOIN sys.[indexes] I ON T.[object_id] = I.[object_id]
                                                                INNER JOIN sys.[index_columns] IC ON I.[object_id] = IC.[object_id] AND I.[index_id] = IC.[index_id]
                                                                INNER JOIN sys.[all_columns] AC ON T.[object_id] = AC.[object_id] AND IC.[column_id] = AC.[column_id]
                      WHERE Ind.[object_id] = I.[object_id]
                        AND Ind.index_id = I.index_id
                        AND IC.is_included_column = 0
                   ORDER BY IC.key_ordinal
                   FOR XML PATH('') 
                 ), 2, 8000
                ) AS COLUMNAS_CLAVE,
       SUBSTRING((    SELECT ', ' + AC.name FROM sys.[tables] AS T INNER JOIN sys.[indexes] I ON T.[object_id] = I.[object_id]
                                                                   INNER JOIN sys.[index_columns] IC ON I.[object_id] = IC.[object_id] AND I.[index_id] = IC.[index_id]
                                                                   INNER JOIN sys.[all_columns] AC ON T.[object_id] = AC.[object_id] AND IC.[column_id] = AC.[column_id]
                       WHERE Ind.[object_id] = I.[object_id]
                         AND Ind.index_id = I.index_id
                         AND IC.is_included_column = 1
                    ORDER BY IC.key_ordinal
                    FOR XML PATH('') 
                 ), 2, 8000
                ) AS INCLUDE_COLS
  FROM sys.[indexes] Ind INNER JOIN sys.[tables] AS Tab ON Tab.[object_id] = Ind.[object_id]
                         INNER JOIN sys.[schemas] AS Sch ON Sch.[schema_id] = Tab.[schema_id]
 WHERE Ind.[name] is not null --AND Tab.name = '' 
ORDER BY ESQUEMA,TABLA

/*FIN*/