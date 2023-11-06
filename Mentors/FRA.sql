-- Configurar el FRA
-- Para configurar el Fra la base de dato debe estar en modo ArchiveLog y configurar los parámetros de db_recovery.
	- Para habilitar el modo archivelog:
	SQL>SHUTDOWN IMMEDIATE;
	SQL>STARTUP MOUNT;
	SQL>ALTER DATABASE ARCHIVELOG;
	SQL>ALTER DATABASE OPEN;
	
	- Configuración de los parámetros:
	SQL> alter system set db_recovery_file_dest_size=300g scope=both;
	SQL> alter system set db_recovery_file_dest='+FRA01' scope=both;



-- Ver espacio disponible en el FRA
select name,floor(space_limit / 1024 / 1024 / 1024) "Size GB",ceil(space_used / 1024 / 1024 / 1024) "Used GB", 
floor(space_used/space_limit*100) "% Used", ceil(SPACE_RECLAIMABLE / 1024 / 1024 / 1024) "RECLAIMABLE GB", NUMBER_OF_FILES
from v$recovery_file_dest
order by name;
