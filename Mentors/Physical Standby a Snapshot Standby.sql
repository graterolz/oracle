Sobre el Standby Servers
select db_unique_name,database_role,open_mode,flashback_on from v$database;
select thread#,max(sequence#) from v$archived_log group by thread#;

Sobre el PRIMARY Servers
tail -f /u01/app/oracle/diag/rdbms/bankbu/BANKBU1/trace/alert_BANKBU1.log


SQL PLUS

alter system checkpoint;
alter system switch logfile;
alter system checkpoint;
alter system switch logfile;

Sobre el Standby Servers
select db_unique_name,database_role,open_mode from v$database;
select thread#,max(sequence#) from v$archived_log group by thread#;

tail -f /u01/app/oracle/diag/rdbms/bankbu_stby/BANKBU_STBY/trace/alert_BANKBU_STBY.log

set lines 900;
set pages 400;
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';

NODO 1
select thread#,sequence#,first_time,next_time,archived,applied from v$archived_log  where thread#=1 order by thread#, sequence#;

NODO 2
select thread#,sequence#,first_time,next_time,archived,applied from v$archived_log  where thread#=2 order by thread#, sequence#;

alter database recover managed standby database cancel;
shutdown immediate;
startup mount;
alter database convert to snapshot standby;
alter database open;
select open_mode,database_role,resetlogs_change#,prior_resetlogs_change# from v$database;

alter system set encryption wallet open identified by "produBankbuAS01";

@/Test/Bloquear_Usuarios_Contingencia.sql;