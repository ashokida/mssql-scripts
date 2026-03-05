### 📂 Índice de Scripts del Repositorio
Scripts Transact-SQL personalizados para la gestión diaria de bases de datos operativas

| Archivo | Función Principal |
| :--- | :--- |
| [01_GeneradorScript-Framework_Menues.sql](./sql/01_GeneradorScript-Framework_Menues.sql)| Genera script de inserts para tablas utilizadas por web PHP (Seccion/Menu/Controlador) . |
| `02_GeneradorScript-Framework_Perfiles.sql` | Genera script de inserts para los perfiles de usuarios. |
| `2330013_ECOM_GeneraScriptInsertCAN.sql` | Genera archivo a partir de volcado de datos. |
| `P_ROLES_PERMISOS.sql` | Obtiene roles y permisos de usuarios de base de datos. |
| `P_S_ROLES.sql` | Obtiene roles de base de datos. |
| `SP_LOG.sql` | Plantilla para Stored Procedure con manejo de logs y errores. |
| `ScriptBuscaCampoEnTodasTablas.sql` | Busca campo especifico en todas las tablas de la base de datos actual. |
| `ScriptBuscaTextoEnTablas.sql` | Busca un texto especifico en todas las tablas de la base de datos actual. |
| `ScriptBuscaTextoSP_I.sql` | Version 1 para buscar un texto especifico en todos los Stored Proecedures. |
| `ScriptBuscaTextoSP_II.sql` | Version 2 para buscar un texto especifico en todos los Stored Proecedures. |
| `ScriptBuscaTextoSP_III.sql` | Version 3 para buscar un texto especifico en todos los Stored Proecedures. |
| `ScriptBuscaTextoSP_IV.sql` | Version 4 para buscar un texto especifico en todos los Stored Proecedures. |
| `ScriptCargaArchivoEnTabla.sql` | A partir de un archivo de texto plano se obtienen los datos para insertar en una tabla. |
| `ScriptCreaRoles.sql` | Creacion de Roles y asignacion de rol a usuario MSSQL. |
| `ScriptCursores.sql` | Script para generacion correcta de cursores. |
| `ScriptDependencias.sql` | Obtencion de FKs. |
| `ScriptDependenciasTablas.sql` | Obtencion de dependencias de tablas. |
| `ScriptDevolverMensaje.sql` | Tratamiento de mensaje de SP con parametro output. |
| `ScriptFuncionesUtiles.sql` | Funciones utiles a incorporar en scripts . |
| `ScriptGeneraTXT.sql` | Generacion y compresion de archivo de texto plano con herramienta .tar.gz. |
| `ScriptListaClavesYsusCampos.sql` | Lista las claves primarias y sus respectivos campos. |
| `ScriptListaDTS.sql` | Lista de los DTS del servidor. |
| `ScriptListaDeTablas.sql` | Lista todas las tablas de la base de datos actual. |
| `ScriptListaDeTablasYCampos.sql` | Lista todas las tablas y todos los campos existentes en la base de datos. |
| `ScriptListaFKs.sql` | Lista de FKs de todas las tablas. |
| `ScriptListaFuncionesDeUsuario.sql` |  Script que lista las funciones definidas por el usuario. |
| `ScriptListaIndices.sql` | Script que lista todos los indices de todas las tablas. |
| `ScriptListaRolesUsuarios.sql` | Lista los roles de todos los usuarios de la base de datos. |
| `ScriptListaStores.sql` | Script que lista todas las stored procedures. |
| `ScriptListaTriggers.sql` |  Lista de Triggers creados en la base de datos. |
| `ScriptManejoError.sql` | Plantilla de script para el manejo de errores. |
| `ScriptMultipleUpdOneRow.sql` | Plantilla de insert en una sola linea. |
| `ScriptObtengoMenuesFW.sql` | Obtencion de menu fwk php. |
| `ScriptObtieneCantRegistrosArchivo.sql` | Script de ejemplo que permite obtener la cantidad de registros de un archivo	. |
| `ScriptPIVOT.sql` | Script ejemplo para pivotear una tabla. |
| `ScriptPermisosSP.sql` | Script que despliega los permisos (GRANTS) de los objetos que especifico ('P' = Stored Procedure). |
| `ScriptPlantillaEjecucionProduccion.sql` | Plantilla para realizar ejecucion en produccion por Ticket urgente. |
| `ScriptQueNoEjecuteSegunServidor.sql` | Script para evitar ejecucion en ambiente incorrecto. |
| `ScriptReduceLogTransacciones.sql` | Script que limpia el log de transacciones de una base de datps. |
| `ScriptReportingServicesEstadistica.sql` | Reporte de estadisticas de Reporting Services. |
| `ScriptSplitDoble.sql` | Script para utilizar funcion de split. |
| `ScriptUsoArchivoFormato.sql` | Plantilla para crear archivo de formato .fmt y .dat. |
