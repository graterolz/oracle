-- Visualizar los procesos activo de Backup en RMAN
SELECT SID,SERIAL#,USERNAME,TO_CHAR(START_TIME, 'DD/MM/YY hh24:mi:ss') START_TIME,
CONTEXT,SOFAR,TOTALWORK,ROUND(SOFAR / TOTALWORK * 100, 2) "%_COMPLETE",
TO_CHAR(sysdate + TIME_REMAINING / 3600 / 24, 'DD/MM/YY hh24:mi:ss') Estimated_End_Time
FROM V$SESSION_LONGOPS
WHERE OPNAME LIKE 'RMAN%' AND OPNAME NOT LIKE '%aggregate%' AND TOTALWORK != 0 AND SOFAR <> TOTALWORK;


-- Ver los backupSet realizado.
select RECID, STAMP, SET_STAMP, SET_COUNT, BACKUP_TYPE, CONTROLFILE_INCLUDED, INCREMENTAL_LEVEL, PIECES, 
TO_CHAR(START_TIME, 'DD/MM/YY hh24:mi:ss') START_TIME, TO_CHAR(COMPLETION_TIME, 'DD/MM/YY hh24:mi:ss') COMPLETION_TIME 
from V$BACKUP_SET where START_TIME >= TO_DATE('15/12/15','DD/MM/YY hh24:mi:ss');

SELECT * from v$rman_status

SELECT * from v$rman_backup_job

-- Consultas de Base de datos sobre el schema rman
select * from RMAN.RC_DATABASE;
select DB_ID, BACKUP_TYPE, START_TIME, STATUS from RMAN.RC_BACKUP_SET WHERE DB_ID=3079508743;

--
--
--
--
--
-- Backup antes del cierre
-- Desde PRODUCCIÓN:
-- Para detener el transporte de redo logs…  
-- Aplicar en la primaria, via databroker

> dgmgrl
> connect /

> show database verbose BANKBU;
> edit database BANKBU set state='LOG-TRANSPORT-OFF';

-- Desde contingencia Detener Aplicación
> dgmgrl
> connect /

edit database 'bankbu_stby' set state='APPLY-OFF'; 

-- Backup contingencia
>rman target /

show parameter recovery
alter system set db_recovery_file_dest='+DATA' scope=both sid='*';

run {
	allocate channel "ch1" device type disk format
	"+DATA/Bankbu_stby/backupset/";
	Backup database;
}

alter system set db_recovery_file_dest='+FRA' scope=both sid='*';

-- Reactivar el dataguard 
-- Activar nuevamente el transporte de log entre la primaria y la standby

-- Aplicar en la primaria PRODUCCION

> dgmgrl
> connect /
> show database verbose BANKBU;
> edit database BANKBU set state='ONLINE'; 

-- En contingencia  la BD debe estar en modo mount

> dgmgrl
> connect /

edit database 'bankbu_stby' set state='APPLY-ON';