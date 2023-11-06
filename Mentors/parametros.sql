-- INFORMACIÓN INSTANCIA
-- Información del estado de una instancia de base de datos: estado, versión, nombre, cuando se levantó, el nombre de la máquina, …
SELECT *   FROM v$instance;
select status from v$instance

-- NOMBRE DE LA BASE DE DATOS
-- A veces no sabemos dónde estamos conectados, una forma es localizar el nombre de la base de datos
SELECT value   FROM v$system_parameter  WHERE name = 'db_name';

select db_unique_name,database_role,open_mode from v$database;

-- Lista los data file que se encuentra en control file
SELECT NAME FROM V$DATAFILE;

-- PARÁMETROS DE LA BASE DE DATOS
-- Vista que muestra los parámetros generales de Oracle:
SELECT *   FROM v$system_parameter;
-- o también
SHOW PARAMETERS valor_a_buscar

-- PRODUCTOS ORACLE INSTALADOS Y LA VERSIÓN
SELECT *   FROM product_component_version;

-- OBTENER LA IP DEL SERVIDOR DE LA BASE DE DATOS ORACLE DATABASE
SELECT utl_inaddr.get_host_address IP  FROM DUAL;

-- Configuración de Procesos, sesiones y transacciones
processes=x
sessions=x*1.1+5
transactions=sessions*1.1 
alter system set processes=400 scope=spfile 
alter system set sessions=XXXX scope=spfile 
alter system set transactions=XXXX scope=spfile 