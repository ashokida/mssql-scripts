
### 📂 Índice de Scripts del Repositorio

#### 🔍 1. Búsqueda y Auditoría de Objetos
Ruta: `./busqueda-objetos-bd/`  
*Incluye herramientas de localización de objetos y tareas de mantenimiento del servidor.*

| Archivo | Función Principal |
| :--- | :--- |
| [ScriptBuscaCampoEnTodasTablas.sql](./busqueda-objetos-bd/ScriptBuscaCampoEnTodasTablas.sql) | Busca campo específico en todas las tablas de la BD. |
| [ScriptBuscaTextoEnTablas.sql](./busqueda-objetos-bd/ScriptBuscaTextoEnTablas.sql) | Busca un texto específico en todas las tablas. |
| [ScriptBuscaTextoSP_I.sql](./busqueda-objetos-bd/ScriptBuscaTextoSP_I.sql) | Búsqueda de texto en Stored Procedures (V1). |
| [ScriptBuscaTextoSP_II.sql](./busqueda-objetos-bd/ScriptBuscaTextoSP_II.sql) | Búsqueda de texto en Stored Procedures (V2). |
| [ScriptBuscaTextoSP_III.sql](./busqueda-objetos-bd/ScriptBuscaTextoSP_III.sql) | Búsqueda de texto en Stored Procedures (V3). |
| [ScriptBuscaTextoSP_IV.sql](./busqueda-objetos-bd/ScriptBuscaTextoSP_IV.sql) | Búsqueda de texto en Stored Procedures (V4). |
| [ScriptDependencias.sql](./busqueda-objetos-bd/ScriptDependencias.sql) | Obtención de Foreign Keys (FKs). |
| [ScriptDependenciasTablas.sql](./busqueda-objetos-bd/ScriptDependenciasTablas.sql) | Obtención de dependencias jerárquicas de tablas. |


#### 🔍 2. Administracion y Mantenimiento
Ruta: `./administracion-mantenimiento/`  
*Incluye herramientas de consulta y mantenimiento del servidor.*

| Archivo | Función Principal |
| :--- | :--- |
| [ScriptReduceLogTransacciones.sql](./administracion-mantenimiento/ScriptReduceLogTransacciones.sql) | Limpieza y reducción del log de transacciones. |
| [ScriptListaIndices.sql](./administracion-mantenimiento/ScriptListaIndices.sql) | Lista todos los índices de todas las tablas. |
| [ScriptListaDTS.sql](./administracion-mantenimiento/ScriptListaDTS.sql) | Lista de los paquetes DTS del servidor. |
| [ScriptQueNoEjecuteSegunServidor.sql](./administracion-mantenimiento/ScriptQueNoEjecuteSegunServidor.sql) | Validación de ambiente para evitar ejecuciones incorrectas. |
| [ScriptReportingServicesEstadistica.sql](./administracion-mantenimiento/ScriptReportingServicesEstadistica.sql) | Estadísticas de uso de Reporting Services. |

#### 🛡️ 3. Seguridad, Roles y Permisos
Ruta: `./seguridad-roles-permisos/`

| Archivo | Función Principal |
| :--- | :--- |
| [P_ROLES_PERMISOS.sql](./seguridad-roles-permisos/P_ROLES_PERMISOS.sql) | Obtiene roles y permisos de usuarios. |
| [P_S_ROLES.sql](./seguridad-roles-permisos/P_S_ROLES.sql) | Obtiene roles definidos en la base de datos. |
| [ScriptCreaRoles.sql](./seguridad-roles-permisos/ScriptCreaRoles.sql) | Creación de Roles y asignación a usuarios MSSQL. |
| [ScriptListaRolesUsuarios.sql](./seguridad-roles-permisos/ScriptListaRolesUsuarios.sql) | Lista los roles de todos los usuarios actuales. |
| [ScriptPermisosSP.sql](./seguridad-roles-permisos/ScriptPermisosSP.sql) | Despliega GRANTS de objetos específicos (Stored Procedures). |
| [02_GeneradorScript-Framework_Perfiles.sql](./seguridad-roles-permisos/02_GeneradorScript-Framework_Perfiles.sql) | Genera inserts para perfiles de usuarios en Framework PHP. |

#### 🏗️ 4. Desarrollo y Plantillas (Templates)
Ruta: `./desarrollo-plantillas/`

| Archivo | Función Principal |
| :--- | :--- |
| [SP_LOG.sql](./desarrollo-plantillas/SP_LOG.sql) | Plantilla de Stored Procedure con manejo de logs. |
| [ScriptManejoError.sql](./desarrollo-plantillas/ScriptManejoError.sql) | Plantilla estándar para el manejo de errores (TRY/CATCH). |
| [ScriptDevolverMensaje.sql](./desarrollo-plantillas/ScriptDevolverMensaje.sql) | Tratamiento de mensajes de SP con parámetros OUTPUT. |
| [ScriptCursores.sql](./desarrollo-plantillas/ScriptCursores.sql) | Estructura correcta para la generación de cursores. |
| [ScriptPlantillaEjecucionProduccion.sql](./desarrollo-plantillas/ScriptPlantillaEjecucionProduccion.sql) | Protocolo para ejecución manual de tickets urgentes. |
| [ScriptFuncionesUtiles.sql](./desarrollo-plantillas/ScriptFuncionesUtiles.sql) | Librería de funciones auxiliares para scripts. |
| [ListaMailsEnviados.sql](./desarrollo-plantillas/ListaMailsEnviados.sql) | Lista mails que fueron enviados desde servidor BD. |

#### 📊 5. Manipulación de Datos e Integración
Ruta: `./manipulaciondatos-integracion/`

| Archivo | Función Principal |
| :--- | :--- |
| [ScriptCargaArchivoEnTabla.sql](./manipulaciondatos-integracion/ScriptCargaArchivoEnTabla.sql) | Ingesta de datos desde archivos planos a tablas SQL. |
| [ScriptGeneraTXT.sql](./manipulaciondatos-integracion/ScriptGeneraTXT.sql) | Generación y compresión de archivos de texto (.tar.gz). |
| [ScriptUsoArchivoFormato.sql](./manipulaciondatos-integracion/ScriptUsoArchivoFormato.sql) | Uso de archivos de formato .fmt y .dat. |
| [ScriptObtieneCantRegistrosArchivo.sql](./manipulaciondatos-integracion/ScriptObtieneCantRegistrosArchivo.sql) | Validación de cantidad de registros en archivos externos. |
| [ScriptPIVOT.sql](./manipulaciondatos-integracion/ScriptPIVOT.sql) | Ejemplo de rotación de filas a columnas (PIVOT). |
| [ScriptMultipleUpdOneRow.sql](./manipulaciondatos-integracion/ScriptMultipleUpdOneRow.sql) | Optimización de inserts en una sola línea. |
| [2330013_ECOM_GeneraScriptInsertCAN.sql](./manipulaciondatos-integracion/2330013_ECOM_GeneraScriptInsertCAN.sql) | Generación de scripts a partir de volcados de datos. |

#### 📋 6. Diccionario de Datos y Listado
Ruta: `./diccionariodatos-listado/`

| Archivo | Función Principal |
| :--- | :--- |
| [ScriptListaDeTablasYCampos.sql](./diccionariodatos-listado/ScriptListaDeTablasYCampos.sql) | Diccionario completo: tablas y sus campos. |
| [ScriptListaDeTablas.sql](./diccionariodatos-listado/ScriptListaDeTablas.sql) | Inventario de tablas de la base de datos. |
| [ScriptListaClavesYsusCampos.sql](./diccionariodatos-listado/ScriptListaClavesYsusCampos.sql) | Inventario de Claves Primarias (PKs) y sus columnas. |
| [ScriptListaStores.sql](./diccionariodatos-listado/ScriptListaStores.sql) | Listado de todos los Stored Procedures. |
| [ScriptListaFuncionesDeUsuario.sql](./diccionariodatos-listado/ScriptListaFuncionesDeUsuario.sql) | Listado de funciones definidas por el usuario (UDF). |
| [ScriptListaTriggers.sql](./diccionariodatos-listado/ScriptListaTriggers.sql) | Inventario de Triggers activos. |
| [ScriptObtengoMenuesFW.sql](./diccionariodatos-listado/ScriptObtengoMenuesFW.sql) | Consulta de menús en Framework PHP. |
| [01_GeneradorScript-Framework_Menues.sql](./diccionariodatos-listado/01_GeneradorScript-Framework_Menues.sql) | Generador de inserts para menús y controladores. |
