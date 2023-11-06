rman target sys/produbankbu01@bankbu @'/home/oracle/rman_scripts/wholedb_diario.cmd' catalog rman/welcome1@rcat
--
rman @'/home/oracle/rman_scripts/wholedb_diario.cmd' catalog rman/welcome1@rcat
--
ORACLE_SID=bankbu; export ORACLE_SID
DATE_SUFFIX=`date +"%d""%m""%y""%H""%M"`; export DATE_SUFFIX
LOGFILE=/fs/vol8/backup/logs/backupRman_Mensual_Bankbu__$DATE_SUFFIX.log; export LOGFILE

rman target sys/produbankbu01@bankbu @'/home/oracle/rman_scripts/wholedb_mensual.cmd' catalog rman/welcome1@rcat msglog $LOGFILE 
--
rman @'/home/oracle/rman_scripts/wholedb_mensual.cmd' catalog rman/welcome1@rcat msglog $LOGFILE 
--
rman @'/home/oracle/rman_scripts/wholedb_mensual.cmd' catalog rman/welcome1@rcat
--
ORACLE_SID=bankbu; export ORACLE_SID
DATE_SUFFIX=`date +"%d""%m""%y""%H""%M"`; export DATE_SUFFIX
LOGFILE=/fs/vol8/backup/logs/backupRman_Mensual_Bankbu__$DATE_SUFFIX.log; export LOGFILE

rman target sys/produbankbu01@bankbu @'/home/oracle/rman_scripts/wholedb_mensual_prueba.cmd' catalog rman/welcome1@rcat msglog $LOGFILE
--
RUN
{
	allocate channel t1 type 'sbt_tape' parms 'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
	backup spfile;
	sql "alter database backup controlfile to trace";
	backup (database include current controlfile KEEP UNTIL TIME 'SYSDATE + 30') ;
	sql 'alter system switch logfile';
	sql 'alter system archive log current';
	backup (archivelog all delete input);
	release channel t1;
}
EXIT;
--
RUN
{
	allocate channel t1 type 'sbt_tape' parms'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
	backup database plus archivelog delete input; 
	release channel t1;
}
EXIT;
--
RUN
{
	allocate channel t1 type 'sbt_tape' parms'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
	backup database plus archivelog delete input; 
	release channel t1;
}
EXIT;
--
RUN
{
	allocate channel t1 type 'sbt_tape' parms'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
	backup spfile TAG 'BACKUP_ANUAL';
	sql "alter database backup controlfile to trace";
	backup database tag 'BACKUP_ANUAL' KEEP UNTIL TIME 'SYSDATE + 3650' logs ;
	sql 'alter system switch logfile';
	sql 'alter system archive log current';
	backup (archivelog all tag 'BACKUP_ANUAL' delete input);
	release channel t1;
}
EXIT;
--
RUN
{
	allocate channel t1 type 'sbt_tape' parms'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
	backup spfile TAG 'BACKUP_ANUAL';
	sql "alter database backup controlfile to trace";
	backup (database tag 'BACKUP_ANUAL' KEEP UNTIL TIME 'SYSDATE + 3650') logs ;
	sql 'alter system switch logfile';
	sql 'alter system archive log current';
	backup (archivelog all tag 'BACKUP_ANUAL' delete input);
	release channel t1;
}
EXIT;
--
RUN
{
	allocate channel t1 type 'sbt_tape' parms'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
	backup spfile TAG 'BACKUP_ANUAL';
	sql 'alter database backup controlfile to trace';
	backup database tag 'BACKUP_ANUAL' KEEP UNTIL TIME 'SYSDATE + 3650' logs ;
	sql 'alter system switch logfile';
	sql 'alter system archive log current';
	backup (archivelog all tag 'BACKUP_ANUAL' delete input);
	release channel t1;
}
EXIT;
--
RUN
{
	set duplex=2;
	allocate channel t1 type 'sbt_tape' parms'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
	backup database plus archivelog delete input; 
	release channel t1;
}
EXIT;
--
RUN
{
	allocate channel t1 type 'sbt_tape' parms 'ENV=(TDPO_OPTFILE=/usr/tivoli/tsm/client/oracle/bin64/tdpo.opt)';
	sql "alter database backup controlfile to trace";
	backup spfile TAG 'BACKUP_ANUAL';
	backup database tag 'BACKUP_ANUAL' KEEP UNTIL TIME 'SYSDATE + 365' logs ;
	sql 'alter system switch logfile';
	sql 'alter system archive log current';
	backup (archivelog all tag 'BACKUP_ANUAL' delete input);
	release channel t1;
}
EXIT;
--
export ORACLE_SID=SIF
#export PWD_RMAN=`cat $SCRIPT_HOME/.rman`
#export PWD_CAT=`cat $SCRIPT_HOME/.catalog`
$ORACLE_HOME/bin/rman target rmansifrac/rmansifrac catalog rmansifrac/rmansifrac@oemrep cmdfile $SCRIPT_HOME/bkbd_disk_sif.sql msglog $SCRIPT_HOME/logs/bkbd_disk_sif_$FECYHOR.log

run {
	allocate channel  c1 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c2 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c3 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c4 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c5 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c6 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c7 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c8 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c9 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c10 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c11 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c12 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c13 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c14 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c15 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	allocate channel  c16 type disk format = '/database/rman/RMSIF/%U.bak' parms 'BLKSIZE=8388608';
	crosscheck archivelog all;
	backup database plus archivelog;
}
--
run {
	allocate channel c1 type 'sbt_tape';
	allocate channel c2 type 'sbt_tape';
	allocate channel c3 type 'sbt_tape';
	allocate channel c4 type 'sbt_tape';
	allocate channel c5 type 'sbt_tape';
	allocate channel c6 type 'sbt_tape';
	allocate channel c7 type 'sbt_tape';
	allocate channel c8 type 'sbt_tape';
	sql 'alter system archive log current';
	backup format 'segu_arc_%c_%s_%p.bak' archivelog all delete input;
}
--
run {
	allocate channel c1 type 'sbt_tape' parms 'ENV=(TDPO_OPTFILE=C:\Program Files\Tivoli\TSM\AgentOBA\tdpo.opt)' CONNECT='rman/rman@tt';
	allocate channel c2 type 'sbt_tape' parms 'ENV=(TDPO_OPTFILE=C:\Program Files\Tivoli\TSM\AgentOBA\tdpo.opt)' CONNECT='rman/rman@tt';
	allocate channel c3 type 'sbt_tape' parms 'ENV=(TDPO_OPTFILE=C:\Program Files\Tivoli\TSM\AgentOBA\tdpo.opt)' CONNECT='rman/rman@tt';
	allocate channel c4 type 'sbt_tape' parms 'ENV=(TDPO_OPTFILE=C:\Program Files\Tivoli\TSM\AgentOBA\tdpo.opt)' CONNECT='rman/rman@tt';
	sql 'alter system archive log current';
	backup format 'tt_arc_%c_%s_%p_%U.bak' archivelog all delete input ;
}
--
run {
	allocate channel c1 type 'sbt_tape';
	allocate channel c2 type 'sbt_tape';
	allocate channel c3 type 'sbt_tape';
	allocate channel c4 type 'sbt_tape';
	allocate channel c5 type 'sbt_tape';
	allocate channel c6 type 'sbt_tape';
	allocate channel c7 type 'sbt_tape';
	allocate channel c8 type 'sbt_tape';
	sql 'alter system archive log current';
	backup (database include current controlfile);
}
--
run {
	allocate channel c1 type 'sbt_tape' parms 'ENV=(TDPO_OPTFILE=C:\Program Files\Tivoli\TSM\AgentOBA\tdpo.opt)' CONNECT='rman/rman@tt';
	allocate channel c2 type 'sbt_tape' parms 'ENV=(TDPO_OPTFILE=C:\Program Files\Tivoli\TSM\AgentOBA\tdpo.opt)' CONNECT='rman/rman@tt';
	allocate channel c3 type 'sbt_tape' parms 'ENV=(TDPO_OPTFILE=C:\Program Files\Tivoli\TSM\AgentOBA\tdpo.opt)' CONNECT='rman/rman@tt';
	allocate channel c4 type 'sbt_tape' parms 'ENV=(TDPO_OPTFILE=C:\Program Files\Tivoli\TSM\AgentOBA\tdpo.opt)' CONNECT='rman/rman@tt';
	sql 'alter system archive log current';
	backup (database include current controlfile);
}
--
shutdown immediate;
startup mount;
backup spfile;
backup database;
alter database open;
DELETE NOPROMPT OBSOLETE;
quit;