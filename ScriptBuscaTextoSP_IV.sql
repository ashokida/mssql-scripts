/**********************************************************************************************************************************************
*    Descripcion: Script que busca un string en stored procedures
* Fecha creacion: 05/12/2011
***********************************************************************************************************************************************/

-- Declara variables
declare @BD varchar(50)
declare @part_name_sp varchar(50)
declare @part_name_find varchar(50)
 
--Seteo de variables--
set @part_name_sp = ''				-- Nombre o parte del nombre de los sp a filtar en la busqueda. '' para no filtrar 
set @part_name_find = 'cobgl'	    -- Nombre o parte del texto a buscar. 
set @BD = DB_NAME()					-- Nombre completo de la base de datos donde se realiza la búsqueda

-- Ejecuta la búsqueda
exec('use ' + @BD )
SELECT 'sp_helptext ' +  '''' + s.name  +  '.'  +   o.name  +  '''' as Store, COUNT(*) as CantOcurrencias 
  FROM sysobjects o inner join  syscomments c on o.id = c.id
                    inner join sys.schemas  s on s.schema_id = o.uid 
WHERE o.name like '%' + ltrim(rtrim(@part_name_sp)) + '%'
  AND type='p'
  AND text like '%' + ltrim(rtrim(@part_name_find)) + '%'
 
GROUP BY o.name , s.name
ORDER BY 2 DESC

/*FIN*/

