/**********************************************************************************************************************************************
*    Descripcion: Script que busca un string en stored procedures
* Fecha creacion: 11/07/2008
*          Autor: AShokida
***********************************************************************************************************************************************/

DECLARE
@strFind varchar (100)  ,
@varDBName varchar (100),
@varQuery varchar (1000) 

SET @strFind = 'BCP'      ----> Especificar string a buscar
SET @varDBName = 'CENCON' ----> Especificar Base de Datos donde se quiere buscar el string

select @varQuery = 'SELECT distinct ' + 'name SP_Name, ''sp_helptext '''''' + name + ''''''''SP_HT ' +
                     'FROM [' + @varDBName + '].[dbo].[sysobjects] inner join [' + @varDBName + '].[dbo].[syscomments] ' +
                       'on [' + @varDBName + '].[dbo].[sysobjects].id = [' + @varDBName + '].[dbo].[syscomments].id ' +
                    'WHERE xtype = ''P'' ' + 
                      'and text like ''%' + @strFind + '%'' ' + 
                 'order by name '

exec (@varQuery)

/*FIN*/

 


