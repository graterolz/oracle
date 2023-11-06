-- Recuperacion de GAPs en Standby cuando el archive existe en disco o en Cinta

Se prepara el ambiente.

set lines 900;
set pages 400;
set pagesize 400;
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';

1) Se Verifica con el siguiente query el estado de los procesos de archiving

select process,status,client_process,sequence#,block#,active_agents,known_agents 
from v$managed_standby;

2) Mediante una inspeccion visual del resultado de este proximo query se identifican los rangos de GAP

select process,status,client_process,sequence#,block#,active_agents,known_agents from v$managed_standby;

3) Con este query se identifica si el archive todavia existe en disco

select sequence#, name, archived, applied from  v$archived_log where sequence# like '%15551%';

3.1) De ser encontrado con el query anterior, se ejecuta un apply manual luego de cancelar el apply 

alter database recover managed standby database cancel; -- se cancela el apply auto

ALTER DATABASE REGISTER OR REPLACE PHYSICAL LOGFILE '<path to archive>/arch_1_53713_645984751'; -- se aplica el o los archive necesarios para cerrar el GAP.

4) De no encontrarse el archive en disco, se intenta restaurar los archives faltantes desde cinta a una ubicacion de disco (esto puede realizarse con el proceso 
de apply activo, y como se realiza desde rman, tan pronto el archive se consigue se auto aplica y continua el proceso.

rman target / catalog RMAN/RespaldoRMAN01@RCATBOD

run {
allocate channel 'dev_0' type 'sbt_tape'
parms 'SBT_LIBRARY=/opt/omni/lib/libob2oracle8_64bit.so,ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=BIST=BD-BANK-SCAN_Bankbu_BD_FULL_ORA)';
allocate channel 'dev_1' type 'sbt_tape'
parms 'SBT_LIBRARY=/opt/omni/lib/libob2oracle8_64bit.so,ENV=(OB2BARTYPE=Oracle8,OB2APPNAMARLIST=BD-BANK-SCAN_Bankbu_BD_FULL_ORA)';
allocate channel 'dev_2' type 'sbt_tape'
parms 'SBT_LIBRARY=/opt/omni/lib/libob2oracle8_64bit.so,ENV=(OB2BARTYPE=Oracle8,OB2APPNAMARLIST=BD-BANK-SCAN_Bankbu_BD_FULL_ORA)';

send device type 'sbt_tape' 'OB2BARHOSTNAME=bd-bank-scan.com';
set archivelog destination to '/Test/arch';

restore archivelog from logseq = 15550 until logseq = 15738; -- Se cambian los numeros de seq por los necesarios para cerrar el GAP 
-- se pueden agregar lineas adicionales con otros rangos para utilizar el mismo proceso para varios gaps.

release channel 'dev_0';
release channel 'dev_1';
release channel 'dev_2';
}