/**********************************************************************************************************************************************
*    Descripcion: Script que busca un string en stored procedures, vistas, etc
* Fecha creacion: 11/07/2008
*          Autor: AShokida
***********************************************************************************************************************************************/

Declare @vTexto VarChar (8000)

Set @vTexto = 'PAR_ID' -----> Especificar el string a buscar

Select distinct(Convert (VarChar (50), SO.Name)) as OBJETO,
       (Replace (SubString (SC.Text, CharIndex(@vTexto, SC.Text) - 30, 60 + Len (@vTexto)), Char(13) + Char(10), ' <Enter> ')) as CADENA
  From Sys.SysObjects SO Inner Join Sys.All_Objects AO On AO.Object_Id = SO.Id
                         Inner Join Sys.SysComments SC ON SC.Id        = SO.Id
 Where SC.Text  Like '%' + @vTexto + '%'
   And AO.Type_Desc = 'SQL_STORED_PROCEDURE'
 Order By OBJETO

/*FIN*/