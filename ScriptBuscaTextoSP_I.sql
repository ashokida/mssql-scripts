/**********************************************************************************************************************************************
*    Descripcion: Script que busca un string en stored procedures, vistas, etc
* Fecha creacion: 08/01/2013
*          Autor: AShokida
***********************************************************************************************************************************************/

Declare @vTexto VarChar (8000)

Set @vTexto = '' -----> Especificar el string a buscar

Select Convert (VarChar (50), SO.Name) AS OBJETO,
       AO.Type_Desc                    AS TIPO_DE_OBJETO,
       Replace (SubString (SC.Text, CharIndex(@vTexto, SC.Text) - 30, 60 + Len (@vTexto)), Char(13) + Char(10), ' <Enter> ') AS CADENA
  From Sys.SysObjects SO Inner Join Sys.All_Objects AO On AO.Object_Id = SO.Id
                         Inner Join Sys.SysComments SC ON SC.Id        = SO.Id
 Where SC.Text  Like '%' + @vTexto + '%'
   And AO.Type_Desc In ('SQL_STORED_PROCEDURE', 'VIEW')
  

 Order By AO.Type_Desc, SO.Name, SC.ColID


/*FIN*/