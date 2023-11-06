Sobre el Standby Servers
tail -f /u01/app/oracle/diag/rdbms/bankbu_stby/BANKBU_STBY/trace/alert_BANKBU_STBY.log

Entrar SQL  *Plus : sqlplus / as sysdba

shutdown immediate;
startup mount;
alter database convert to physical standby;
shutdown immediate;
startup nomount;
alter database mount standby database;
alter database recover managed standby database  through all switchover disconnect  using current logfile;
select open_mode,database_role,resetlogs_change#,prior_resetlogs_change# from v$database;
select thread#,max(sequence#) from v$archived_log group by thread#;

Sobre el PRIMARY Servers
tail -f /u01/app/oracle/diag/rdbms/bankbu/BANKBU1/trace/alert_BANKBU1.log

Entrar SQL  *Plus : sqlplus / as sysdba

select thread#,max(sequence#) from v$archived_log group by thread#;

// moviendo de memoria a archile log
alter system checkpoint;
alter system switch logfile;
alter system checkpoint;
alter system switch logfile;

Sobre el Standby Servers

//valida physical
select db_unique_name,database_role,open_mode,flashback_on from v$database;
select thread#,max(sequence#) from v$archived_log group by thread#;

set lines 900;
set pages 400;
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';

//consulta la aplicación archive log

NODO 1
select thread#, sequence#, first_time, next_time, archived, applied from v$archived_log where thread#=1 order by thread#, sequence#;

NODO 2
select thread#, sequence#, first_time, next_time, archived, applied from v$archived_log where thread#=2 order by thread#, sequence#;

select process,status,client_process,sequence#,block#,active_agents,known_agents from v$managed_standby;

ENVIAR EVIDENCIA CONSULTA
select db_unique_name,database_role,open_mode,flashback_on from v$database;
select thread#,max(sequence#) from v$archived_log group by thread#;