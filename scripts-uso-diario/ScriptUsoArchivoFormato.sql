/*
Ejemplo para crear arhivo de formato,
             crear archivo .dat
             insertat mediante SQL los datos de un archivo .dat en una tabla utlizando un archivo de formato  

1- Crear el archivo de formato usando instruccion BCP
   bcp CENCON.dbo.ZZ_SUCURSAL_PRUEBA format nul -S B1842ZACS0076 -T -n -f \\B1842zacs0076\SISENT_INFORMES\prueba\ZZ_SUCURSAL_PRUEBA.fmt

2- Crear archivo .dat con el contenido de toda la tabla
   BCP "SELECT * FROM CENCON.DBO.ZZ_SUCURSAL_PRUEBA " QueryOut \\B1842zacs0076\SISENT_INFORMES\prueba\ZZ_SUCURSAL_PRUEBA.dat -n -S B1842ZACS0076 -T -k

3- Insertar datos en tabla a partir de archivos .dat y .fmt
*/
   BULK INSERT ZZ_SUCURSAL_PRUEBA 
   FROM '\\B1842zacs0076\SISENT_INFORMES\prueba\ZZ_SUCURSAL_PRUEBA.dat' 
   WITH (FORMATFILE = '\\B1842ZACS0076\SISENT_INFORMES\prueba\ZZ_SUCURSAL_PRUEBA.fmt')

