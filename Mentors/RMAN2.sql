-- Consultar las base de datos registrada en el catálogo.
list db_unique_name all;

-- Registrar una base de datos  de RMAN
register database;

-- Quitar una base de dato de RMAN
unregister database;
unregis

-- Ver el DBID de una base de dato
SQL> select dbid from v$database;

-- Variables que usa rman para el formato de tiempo.
export NLS_LANG=american
export NLS_DATE_FORMAT='Mon DD YYYY HH24:MI:SS'

-- Validar si está activado el modo AchiveLog
archive log list;

select name, log_mode from v$database;

-- Para borra los Archivelog obsoletos
$> rman target / catalog RMAN/RespaldoRMAN01@RCATBOD
RMAN> delete obsolete;
RMAN> DELETE NOPROMPT FORCE ARCHIVELOG UNTIL TIME 'SYSDATE-1'
RMAN> delete force archivelog until time ‘sysdate-2′;

-- Ver y cambiar el directorio destino de recovery
show parameter db_recovery_file_dest
alter system set db_recovery_file_dest='+DATA' scope=spfile;

-- Nota:  El alter se debe realizar nomount

--
--
--

rman target lzambrano/Pegaso26@bankbu catalog rman/RespaldoRMAN01@rcatbod

rman target lzambrano/Pegaso26@BankbuBi catalog rman/RespaldoRMAN01@rcatbod

rman target sys/produics01@ICS catalog rman/RespaldoRMAN01@rcatbod