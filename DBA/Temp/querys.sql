-- Verificar ultimo analyze realizado
select * from all_tables order by last_analyzed desc;
 
-- Verificar tablas fragmentadas
SELECT
	owner,
	table_name,
	round((blocks * 8), 2) || 'kb' "Tamanio fragmentado",
	round((num_rows * avg_row_len / 1024), 2) || 'kb' "Tamanio Actual",
	round((blocks * 8), 2) - round((num_rows * avg_row_len / 1024), 2) || 'kb',
	((round((blocks * 8), 2) - round((num_rows * avg_row_len / 1024), 2)) /
	round((blocks * 8), 2)) * 100 - 10 "espacio reclamable %"
FROM dba_tables
WHERE table_name in ('ACCOUNT_ASSIGNATION','WORKLIST','PEOPLE','ACCOUNT','WORKLIST_DEFINITION','WORKLIST_ASSIGNMENT','WORKLIST_QUERY')
AND OWNER = 'COBRA';

SELECT
	open_mode,
	database_role,
	resetlogs_change#,
	prior_resetlogs_change#
FROM v$database;

-- Espacio en disco
select name,total_mb,free_mb from v$asm_diskgroup;

--SQL Conversion BANKBU
select thread#,max(sequence#) from v$archived_log group by thread#;

-- KILL Session --
SELECT
	'ALTER SYSTEM KILL SESSION '||chr(39)||sid||','||serial#||chr(39)||';'
FROM v$session
WHERE username in ('PNV7');

-- Identifica Bloqueos
SELECT
	s.username,
	s.sid,
	s.serial#,
	s.osuser,
	k.ctime,
	o.object_name object,
	k.kaddr,
	DECODE(l.locked_mode,
		1, 'No Lock',
		2, 'Row Share',
		3, 'Row Exclusive',
		4, 'Shared Table',
		5, 'Shared Row Exclusive',
		6, 'Exclusive'
	) locked_mode,
	DECODE(k.type,
		'BL','Buffer Cache Management (PCM lock)',
		'CF','Controlfile Transaction',
		'CI','Cross Instance Call',
		'CU','Bind Enqueue',
		'DF','Data File',
		'DL','Direct Loader',
		'DM','Database Mount',
		'DR','Distributed Recovery',
		'DX','Distributed Transaction',
		'FS','File Set',
		'IN','Instance Number',
		'IR','Instance Recovery',
		'IS','Instance State',
		'IV','Library Cache Invalidation',
		'JQ','Job Queue',
		'KK','Redo Log Kick',
		'LA','Library Cache Lock',
		'LB','Library Cache Lock',
		'LC','Library Cache Lock',
		'LD','Library Cache Lock',
		'LE','Library Cache Lock',
		'LF','Library Cache Lock',
		'LG','Library Cache Lock',
		'LH','Library Cache Lock',
		'LI','Library Cache Lock',
		'LJ','Library Cache Lock',
		'LK','Library Cache Lock',
		'LL','Library Cache Lock',
		'LM','Library Cache Lock',
		'LN','Library Cache Lock',
		'LO','Library Cache Lock',
		'LP','Library Cache Lock',
		'MM','Mount Definition',
		'MR','Media Recovery',
		'NA','Library Cache Pin',
		'NB','Library Cache Pin',
		'NC','Library Cache Pin',
		'ND','Library Cache Pin',
		'NE','Library Cache Pin',
		'NF','Library Cache Pin',
		'NG','Library Cache Pin',
		'NH','Library Cache Pin',
		'NI','Library Cache Pin',
		'NJ','Library Cache Pin',
		'NK','Library Cache Pin',
		'NL','Library Cache Pin',
		'NM','Library Cache Pin',
		'NN','Library Cache Pin',
		'NO','Library Cache Pin',
		'NP','Library Cache Pin',
		'NQ','Library Cache Pin',
		'NR','Library Cache Pin',
		'NS','Library Cache Pin',
		'NT','Library Cache Pin',
		'NU','Library Cache Pin',
		'NV','Library Cache Pin',
		'NW','Library Cache Pin',
		'NX','Library Cache Pin',
		'NY','Library Cache Pin',
		'NZ','Library Cache Pin',
		'PF','Password File',
		'PI','Parallel Slaves',
		'PR','Process Startup',
		'PS','Parallel Slave Synchronization',
		'QA','Row Cache Lock',
		'QB','Row Cache Lock',
		'QC','Row Cache Lock',
		'QD','Row Cache Lock',
		'QE','Row Cache Lock',
		'QF','Row Cache Lock',
		'QG','Row Cache Lock',
		'QH','Row Cache Lock',
		'QI','Row Cache Lock',
		'QJ','Row Cache Lock',
		'QK','Row Cache Lock',
		'QL','Row Cache Lock',
		'QM','Row Cache Lock',
		'QN','Row Cache Lock',
		'QO','Row Cache Lock',
		'QP','Row Cache Lock',
		'QQ','Row Cache Lock',
		'QR','Row Cache Lock',
		'QS','Row Cache Lock',
		'QT','Row Cache Lock',
		'QU','Row Cache Lock',
		'QV','Row Cache Lock',
		'QW','Row Cache Lock',
		'QX','Row Cache Lock',
		'QY','Row Cache Lock',
		'QZ','Row Cache Lock',
		'RT','Redo Thread',
		'SC','System Commit number',
		'SM','SMON synchronization',
		'SN','Sequence Number',
		'SQ','Sequence Enqueue',
		'SR','Synchronous Replication',
		'SS','Sort Segment',
		'ST','Space Management Transaction',
		'SV','Sequence Number Value',
		'TA','Transaction Recovery',
		'TM','DML Enqueue',
		'TS','Table Space (or Temporary Segment)',
		'TT','Temporary Table',
		'TX','Transaction',
		'UL','User-defined Locks',
		'UN','User Name',
		'US','Undo segment Serialization',
		'WL','Writing redo Log',
		'XA','Instance Attribute Lock',
		'XI','Instance Registration Lock'
	) type
FROM
	gv$session s,
	sys.gv$lock c,
	sys.gv$locked_object l,
	dba_objects o,
	sys.gv$lock k,
	gv$lock v
WHERE o.object_id = l.object_id
AND l.session_id = s.sid
AND k.sid = s.sid
--AND s.saddr = c.saddr
AND k.kaddr = c.kaddr
AND k.kaddr = v.kaddr
--AND v.saddr = s.saddr
AND k.lmode = l.locked_mode
AND k.lmode = c.lmode
AND k.request = c.request
ORDER BY object;
--
-- Bloqueos
--
SELECT
	s.sid, s.serial#,
	decode(s.process, NULL,
		decode(substr(p.username,1,1),'?', upper(s.osuser), p.username),
		decode(p.username, 'ORACUSR ', upper(s.osuser), s.process)
	) process,
	nvl(s.username, 'SYS ('||substr(p.username,1,4)||')') username,
	decode(s.terminal, NULL, rtrim(p.terminal, chr(0)), upper(s.terminal)) terminal,
	decode(l.type,
	-- Long locks
		'TM', 'DML/DATA ENQ', 'TX', 'TRANSAC ENQ',
		'UL', 'PLS USR LOCK',
	-- Short locks
		'BL', 'BUF HASH TBL','CF', 'CONTROL FILE',
		'CI', 'CROSS INST F','DF', 'DATA FILE',
		'CU', 'CURSOR BIND ',
		'DL', 'DIRECT LOAD ','DM', 'MOUNT/STRTUP',
		'DR', 'RECO LOCK','DX', 'DISTRIB TRAN',
		'FS', 'FILE SET','IN', 'INSTANCE NUM',
		'FI', 'SGA OPN FILE',
		'IR', 'INSTCE RECVR','IS', 'GET STATE',
		'IV', 'LIBCACHE INV','KK', 'LOG SW KICK ',
		'LS', 'LOG SWITCH',
		'MM', 'MOUNT DEF','MR', 'MEDIA RECVRY',
		'PF', 'PWFILE ENQ','PR', 'PROCESS STRT',
		'RT', 'REDO THREAD ','SC', 'SCN ENQ',
		'RW', 'ROW WAIT',
		'SM', 'SMON LOCK','SN', 'SEQNO INSTCE',
		'SQ', 'SEQNO ENQ','ST', 'SPACE TRANSC',
		'SV', 'SEQNO VALUE ','TA', 'GENERIC ENQ ',
		'TD', 'DLL ENQ','TE', 'EXTEND SEG',
		'TS', 'TEMP SEGMENT','TT', 'TEMP TABLE',
		'UN', 'USER NAME','WL', 'WRITE REDO',
		'TYPE='||l.type
	) type,
	decode(l.lmode, 0,
		'NONE', 1,
		'NULL', 2,
		'RS', 3,
		'RX', 4,
		'S', 5,
		'RSX', 6,
		'X', to_char(l.lmode)
	) lmode,
	decode(l.request, 0,
		'NONE', 1,
		'NULL', 2,
		'RS', 3,
		'RX', 4,
		'S', 5,
		'RSX', 6,
		'X', to_char(l.request)
	) lrequest,
	decode(l.type, 'MR',
		decode(u.name, NULL, 'DICTIONARY OBJECT', u.name||'.'||o.name),
			'TD', u.name||'.'||o.name,
			'TM', u.name||'.'||o.name,
			'RW', 'FILE#='||substr(l.id1,1,3)||
			' BLOCK#='||substr(l.id1,4,5)||' ROW='||l.id2,
			'TX', 'RS+SLOT#'||l.id1||' WRP#'||l.id2,
			'WL', 'REDO LOG FILE#='||l.id1,
			'RT', 'THREAD='||l.id1,
			'TS', decode(l.id2, 0, 'ENQUEUE', 'NEW BLOCK ALLOCATION'),
			'ID1='||l.id1||' ID2='||l.id2) object
FROM sys.v_$lock l, sys.v_$session s, sys.obj$ o, sys.user$ u, sys.v_$process p
WHERE s.paddr = p.addr(+)
AND l.sid = s.sid
AND l.id1 = o.obj#(+)
AND o.owner# = u.user#(+)
AND l.type <> 'MR'
AND s.serial#<>1
AND s.username NOT IN (
	'SYS','SYSTEM','OUTLN','PERFSTAT','DBSNMP'
)
UNION ALL
SELECT
	s.sid,
	s.serial#,
	s.process,
	s.username,
	s.terminal,
	'LATCH', 'X', 'NONE', h.name||' ADDR='||rawtohex(laddr)
FROM sys.v_$process p, sys.v_$session s, sys.v_$latchholder h
WHERE h.pid = p.pid
AND p.addr = s.paddr
AND s.username NOT IN (
	'SYS','SYSTEM','OUTLN','PERFSTAT','DBSNMP'
)
UNION ALL
SELECT
	s.sid,
	s.serial#,
	s.process,
	s.username,
	s.terminal,
	'LATCH', 'NONE', 'X', name||' LATCH='||p.latchwait
FROM sys.v_$session s, sys.v_$process p, sys.v_$latch l
WHERE latchwait IS NOT NULL
AND p.addr = s.paddr
AND p.latchwait = l.addr
AND s.serial#<>1
AND s.username NOT IN ('SYS','SYSTEM','OUTLN','PERFSTAT','DBSNMP')
--
--
--
SELECT
	'alter '||object_type||' '||owner|| '.'||object_name||' compile;'||chr(10)||'show errors' 
FROM DBA_objects
WHERE object_type in ('FUNCTION','PROCEDURE','PACKAGE','TRIGGER','VIEW', 'PACKAGE BODY')
AND status = 'INVALID'
AND owner = 'PNV7'
ORDER BY object_type;
--
SELECT
	'alter package '||object_name||' compile body;'||chr(10)||'show errors'
FROM dba_objects
WHERE object_type = 'PACKAGE BODY'
AND status = 'INVALID'
AND owner= 'PNV7';
--
SELECT
	a.tablespace_name TABLESPACE_NAME,
	nvl(sum(b.bytes)/1048576, 0.00) MB_OCUPADOS
FROM dba_tablespaces a, dba_segments b
WHERE a.tablespace_name = b.tablespace_name (+)
AND a.tablespace_name = 'IVRPSPTS9D'
AND b.segment_type != 'TEMPORARY'
GROUP BY a.tablespace_name
ORDER BY 1
--
SELECT
	tablespace_name TABLESPACE_NAME,
	nvl(sum(bytes)/1048576, 0.00) MB_DEFINIDOS
FROM dba_data_files
WHERE tablespace_name = '&1'
GROUP BY tablespace_name
ORDER BY 1;
--
select
	tablespace_name TABLESPACE_NAME,
	nvl(sum(bytes)/1048576, 0.00) MB_LIBRES
FROM dba_free_space
WHERE tablespace_name = '&1'
GROUP BY tablespace_name
ORDER BY 1;
--
SELECT
	a.tablespace_name TABLESPACE_NAME,
	nvl(sum(a.bytes)/1048576, 0.00) MB_OCUPADOS
FROM dba_segments a
WHERE a.tablespace_name = '&1'
AND a.segment_type != 'TEMPORARY'
GROUP BY a.tablespace_name
ORDER BY 1;
--
SELECT
	'_DEFINIDO_' || tablespace_name TABLESPACE_NAME,
	nvl(sum(bytes)/1048576, 0.00) MB_DEFINIDOS
FROM dba_data_files
WHERE tablespace_name = '&1'
GROUP BY tablespace_name
ORDER BY 1;
--
SELECT
	'_OCUPADO_' || a.tablespace_name TABLESPACE_NAME,
	nvl(sum(a.bytes)/1048576, 0.00) MB_OCUPADOS
FROM dba_segments a
WHERE a.tablespace_name = '&1'
AND a.segment_type != 'TEMPORARY'
GROUP BY a.tablespace_name
ORDER BY 1;

SELECT
	'_LIBRE_' || tablespace_name TABLESPACE_NAME,
	nvl(sum(bytes)/1048576, 0.00) MB_LIBRES
FROM dba_free_space
WHERE tablespace_name = '&1'
GROUP BY tablespace_name
ORDER BY 1;
--
SELECT DISTINCT a.tablespace_name TABLESPACE_NAME FROM dba_data_files a;
--
--
--
--
--
SELECT 
	sid,
	logon_time,
	username,
	disk_reads,
	buffer_gets,
	status,
	rows_processed,
	UPPER(
		DECODE(command_type,
			1,'Create Table',2,'Insert',3,'Select',
			4,'Create Cluster',5,'Alter Cluster',6,'Update',
			7,'Delete', 8,'Drop Cluster', 9,'Create Index',
			10,'Drop INdex', 11,'ALter Index', 12,'Drop Table',
			13,'Create Sequence', 14,'ALter Sequence', 15,'ALter Table',
			16,'Drop Sequence', 17,'Grant', 18,'Revoke',
			19,'Create Synonym', 20,'Drop Synonym', 21,'Create View',
			22,'Drop View', 23,'Validate Index', 24,'Create Procedure',
			25,'Alter Procedure', 26,'Lock Table', 27,'No Operation',
			28,'Rename', 29,'Comment', 30,'Audit',
			31,'NoAudit', 32,'Create Database Link', 33,'Drop Database Link',
			34,'Create Database', 35,'Alter Database', 36,'Create Rollback Segment',
			37,'Alter Rollback Segment', 38,'Drop Rollback Segment', 39,'Create Tablespace',
			40,'ALter Tablespace', 41,'Drop Tablespace', 42,'ALter Sessions',
			43,'ALter User', 44,'Commit', 45,'Rollback',
			46,'Savepoint', 47,'PL/SQL Execute', 48,'Set Transaction',
			49,'ALter System Swith Log', 50,'Explain Plan', 51,'Create User',
			52,'Create Role', 53,'Drop User', 54,'Drop Role',
			55,'Set Role', 56,'Create Schema', 57,'Creat Control File',
			58,'ALter Tracing', 59,'Create Trigger', 60,'Alter Trigger',
			61,'Drop Trigger', 62,'Analyze Table', 63,'Analyze Index',
			64,'Analyze Cluster', 65,'Create Profile', 66,'Drop Profile',
			67,'Alter Profile', 68,'Drop Procedure', 69,'Drop Procedure',
			70,'Alter Resource Cost', 71,'Create Snapshot Log', 72,'ALter Snapshot LOg',
			73,'Drop Snapshot Log', 74,'Create Snapshot', 75,'Alter Snapshot',
			76,'Drop Snapshot', 79,'ALter Role', 85,'Truncate Table',
			86,'Truncate Cluster', 88,'Alter View', 91,'Create Function',
			92,'ALter Function', 93,'Drop FUnction', 94,'Create Package',
			95,'ALter Package', 96,'Drop Package', 97,'Create Package Body',
			98,'ALter Package Body', 99,'Drop Package Body'
		)
	) command_executed,
	sql_text
FROM v$sqlarea, v$session
WHERE address = sql_address
AND hash_value = sql_hash_value
AND username != 'SYSTEM'
AND username = 'COBRA1'
ORDER BY status DESC;
--
--
--
alter system switch logfile;
alter system switch logfile;
alter system switch logfile;
--
alter database create standby controlfile as 'v:\oracle\standby\config9i\STANDBY_CONTROL.CTL';
alter database backup controlfile to 'v:\oracle\standby\config9i\control01.ctl';
alter database backup controlfile to trace;

alter tablespace statspack_data begin backup;
host copy V:\DATABASE\CONFIG9I\statspack_data01.DBF L:\config9i\ >> v:\oracle\standby\config9i\hotbackup.log
alter tablespace statspack_data end backup;

alter tablespace AUDITORIA begin backup;
host copy W:\DATABASE\CONFIG9I\AUDITORIA1.DBF M:\config9i\ >> v:\oracle\standby\config9i\hotbackup.log
alter tablespace AUDITORIA end backup;

alter tablespace SYSTEM begin backup;
host copy W:\DATABASE\CONFIG9I\SYSTEM01.DBF M:\config9i\ >> v:\oracle\standby\config9i\hotbackup.log
alter tablespace SYSTEM end backup;

alter tablespace USER_DATA begin backup;
host copy X:\DATABASE\CONFIG9I\USERS01.DBF N:\config9i\ >> v:\oracle\standby\config9i\hotbackup.log
alter tablespace USER_DATA end backup;

alter tablespace UNDOTBS1 begin backup;
host copy z:\DATABASE\CONFIG9I\UNDOTBS01.DBF P:\config9i\ >> v:\oracle\standby\config9i\hotbackup.log
alter tablespace UNDOTBS1 end backup;

alter tablespace USER_INDEX begin backup;
host copy Z:\DATABASE\CONFIG9I\USER_INDEX.DBF P:\config9i\ >> v:\oracle\standby\config9i\hotbackup.log
alter tablespace USER_INDEX end backup;

SELECT
	file#,
	status,
	to_char(time,'DD-MM-YYYY HH24:Mi') TIME
FROM v$backup;
--
-- Para obtener todas las sesiones de un usuario
SELECT
	s.sid,
	s.serial#,
	p.spid,
	s.username,
	s.osuser,
	to_char(s.logon_time,'dd-mm-yy hh24:mi:ss') login,
	s.status,
	s.program
FROM v$session s, v$process p
WHERE UPPER(s.username) LIKE UPPER('PNV7')
AND s.paddr = p.addr
ORDER BY 6;
--
--
--
--
--
SELECT
	d.tablespace_name, 
	decode(d.status,'ONLINE','ON',DECODE(d.status,'OFFLINE','OFF','RO')) STA,
	d.next_extent/1024 Tam_Ext_kb,
	trunc(((a.bytes / 1024 / 1024) - (a.bytes - decode(f.bytes, NULL,0, f.bytes)) / 1024 / 1024) / (d.next_extent/1024/1024)) Ext_libres,
	ROUND((a.bytes / 1024 / 1024), 2) Definido, 
	ROUND(((a.bytes - decode(f.bytes, NULL, 0, f.bytes)) / 1024 / 1024), 2) Usado, 
	ROUND(((a.bytes / 1024 / 1024) - (a.bytes - decode(f.bytes, NULL,0, f.bytes)) / 1024 / 1024), 2) Libre, 
	ROUND((((a.bytes / 1024 / 1024) - (a.bytes - decode(f.bytes, NULL,0, f.bytes)) / 1024 / 1024) / (a.bytes / 1024 / 1024)) * 100.0, 2) "% Libre"
FROM sys.dba_tablespaces d, sys.sm$ts_avail a, sys.sm$ts_free f
WHERE d.tablespace_name = a.tablespace_name 
AND f.tablespace_name(+) = d.tablespace_name 
UNION ALL 
SELECT
	d.tablespace_name, 
	decode(d.status,'ONLINE','ON',DECODE(d.status,'OFFLINE','OFF','RO')),
	d.next_extent/1024,
	trunc((a.bytes / 1024 / 1024) - (NVL(t.bytes, 0) / 1024 / 1024) / (d.next_extent/1024/1024)),
	ROUND((a.bytes / 1024 / 1024), 2), 
	ROUND(NVL(t.bytes,0) / 1024 / 1024, 2), 
	ROUND((a.bytes / 1024 / 1024) - (NVL(t.bytes, 0) / 1024 / 1024),2), 
	ROUND(100 - (NVL(t.bytes / a.bytes * 100, 0)), 2)
FROM sys.dba_tablespaces d,
(
	SELECT
		tablespace_name,
		SUM(bytes) bytes
	FROM dba_temp_files 
	GROUP BY tablespace_name
) a,
(
	SELECT
		tablespace_name,
		SUM(bytes_cached) bytes
	FROM sys.v_$temp_extent_pool 
	GROUP BY tablespace_name
) t 
WHERE d.tablespace_name = a.tablespace_name (+) 
AND d.tablespace_name = t.tablespace_name (+) 
AND d.extent_management LIKE 'LOCAL' 
AND d.contents LIKE 'TEMPORARY'
ORDER BY 8;
--
SELECT
	'ALTER USER "'||username||'" identified by values '''||extract(xmltype(dbms_metadata.get_xml('USER',username)),'//USER_T/PASSWORD/text()').getStringVal()||''';' old_password 
FROM dba_users
WHERE username in (
	'ANONYMOUS',
	'APEX_PUBLIC_USER',
	'CTXSYS',
	'DIP',
	'EXFSYS',
	'FLOWS_FILES',
	'FLOWS_030000',
	'MDDATA',
	'MDSYS',
	'OLAPSYS',
	'ORDPLUGINS',
	'ORDSYS',
	'OWBSYS',
	'SCOTT',
	'SI_INFORMTN_SCHEMA',
	'SPATIAL_CSW_ADMIN_USR',
	'SPATIAL_WFS_ADMIN_USR',
	'TSMSYS',
	'WKPROXY',
	'WKSYS',
	'WK_TEST',
	'WMSYS',
	'XDB',
	'XS$NULL'
);
--
SELECT
	(SELECT sum(bytes/1048576) FROM dba_data_files) "Data Mb", 
	(SELECT NVL(sum(bytes/1048576),0) FROM dba_temp_files) "Temp Mb",
	(SELECT sum(bytes/1048576)*max(members) FROM v$log) "Redo Mb",
	(SELECT sum(bytes/1048576) FROM dba_data_files) +
	(SELECT NVL(sum(bytes/1048576),0) FROM dba_temp_files) +
	(SELECT sum(bytes/1048576)*max(members) FROM v$log) "Total Mb"
FROM dual;
--
SELECT
	username,
	granted_role,
	account_status,
	admin_option
FROM dba_role_privs, dba_users 
WHERE username = grantee 
AND granted_role = 'DBA'
ORDER BY 1;
--
SELECT
	username,
	granted_role,
	account_status
FROM dba_users
LEFT JOIN dba_role_privs ON dba_users.username = dba_role_privs.grantee
GROUP BY username, account_status, granted_role
--
SELECT
	s1.username || '@' || s1.machine || ' ( SID=' || s1.sid ||
	' ) esta Bloqueando -> ' || s2.username || '@' || s2.machine || 
	' ( SID=' || s2.sid || ' ) ' AS blocking_status
FROM v$lock l1, v$session s1, v$lock l2, v$session s2
WHERE s1.sid = l1.sid
AND s2.sid = l2.sid
AND l1.BLOCK = 1
AND l2.request > 0
AND l1.id1 = l2.id1
AND l2.id2 = l2.id2;
--
SELECT
	(ROUND((((a.bytes / 1024 / 1024) - (a.bytes - decode(f.bytes, NULL,0, f.bytes)) / 1024 / 1024) / (a.bytes / 1024 / 1024)) * 100.0, 2)) 
FROM sys.dba_tablespaces d, sys.sm$ts_avail a, sys.sm$ts_free f
WHERE d.tablespace_name = a.tablespace_name
AND f.tablespace_name(+) = d.tablespace_name
AND d.tablespace_name = ts;
--
ALTER SESION SET nls_date_format = 'dd-mm-yy hh24:mi:ss';
SELECT SYSDATE "Fecha y hora Actual" FROM dual;
SELECT host_name || '.' || instance_name "Servidor.Instancia" FROM v$instance;
--
EXEC DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'GESTRAQ', estimate_percent => 30, cascade => TRUE);
commit;
EXEC DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'GESTRAQ_ADM', estimate_percent => 30, cascade => TRUE);
commit;

EXEC DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'GESGSAQ', estimate_percent => 30, cascade => TRUE);
commit;
EXEC DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'GESGSAQ_ADM', estimate_percent => 30, cascade => TRUE);
commit;

EXEC DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'GESTTAQ', estimate_percent => 30, cascade => TRUE);
commit;
EXEC DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'GESTTAQ_ADM', estimate_percent => 30, cascade => TRUE);
commit;

EXEC DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'RECTORAQ', estimate_percent => 30, cascade => TRUE);
commit;
EXEC DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'RECTORAQ_ADM', estimate_percent => 30, cascade => TRUE);
commit;

EXEC DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'OAIHUB902', estimate_percent => 30, cascade => TRUE);
commit;
--
SELECT 'exec dbms_stats.gather_index_stats('||owner||','||index_name||',estimate_percent=> 100);'
FROM dba_indexes
WHERE owner = '&1'
AND partitioned='NO';
--
SELECT 'exec dbms_stats.gather_table_stats('||owner||','||table_name||', estimate_percent=> 5);'
FROM dba_tables
WHERE owner = '&1'
AND table_name not in (select table_name from dba_external_tables where owner='&1')
AND partitioned='NO';
--
SELECT 'exec dbms_stats.gather_index_stats('||owner||','||index_name||','||partition_name||', estimate_percent=> 100);'
FROM dba_ind_partitions
WHERE index_owner = '&1';
--
SELECT 'exec dbms_stats.gather_table_stats('||owner||','||table_name||','||partition_name||', estimate_percent=> 5);'
FROM dba_tab_partitions
WHERE table_owner = '&1';
--
EXEC dbms_aqadm.stop_queue('COLA_GESTR_IN',TRUE,TRUE);
COMMIT;
EXEC dbms_aqadm.DROP_queue('COLA_GESTR_IN');
COMMIT;
EXEC dbms_aqadm.DROP_queue_TABLE('TABLA_COLA_GESTR_IN');
COMMIT;
--
EXEC dbms_aqadm.stop_queue('COLA_GESTR_OUT',TRUE,TRUE);
COMMIT;
EXEC dbms_aqadm.DROP_queue('COLA_GESTR_OUT');
COMMIT;
EXEC dbms_aqadm.DROP_queue_TABLE('TABLA_COLA_GESTR_OUT');
COMMIT;
EXEC dbms_aqadm.stop_queue('COLA_CANAL_IN',TRUE,TRUE);
COMMIT;
EXEC dbms_aqadm.DROP_queue('COLA_CANAL_IN');
COMMIT;

EXEC dbms_aqadm.DROP_queue_TABLE('TABLA_COLA_CANAL_IN');
COMMIT;
--
EXEC dbms_aqadm.stop_queue('COLA_CANAL_OUT',TRUE,TRUE);
COMMIT;
EXEC dbms_aqadm.DROP_queue('COLA_CANAL_OUT');
COMMIT;
--
EXEC dbms_aqadm.DROP_queue_TABLE('TABLA_COLA_CANAL_OUT');
COMMIT;
--
EXEC corr_aq_901.drop_corrupted_qt901(qt_schema=>'GESGSAQ_ADM',QT_NAME=>'TABLA_COLA_CANAL_IN');
COMMIT;
EXEC corr_aq_901.drop_corrupted_qt901(qt_schema=>'GESGSAQ_ADM',QT_NAME=>'TABLA_COLA_CANAL_OUT');
COMMIT;
EXEC corr_aq_901.drop_corrupted_qt901(qt_schema=>'GESGSAQ_ADM',QT_NAME=>'TABLA_COLA_GESTR_IN');
COMMIT;
EXEC corr_aq_901.drop_corrupted_qt901(qt_schema=>'GESGSAQ_ADM',QT_NAME=>'TABLA_COLA_GESTR_OUT');
COMMIT;
--
SELECT
	to_char(ssn.sid, '9999') sid, ssn.username usuario, to_char(prc.spid, '999999999') "PID/THREAD", to_char(logon_time,'dd-mon-yy hh24:mi:ss'),
	to_char((se1.value/1024)/1024, '999G999G990D00') || ' MB' " CURRENT SIZE",
	to_char((se2.value/1024)/1024, '999G999G990D00') || ' MB' " MAXIMUM SIZE",
	dj.what
FROM
	v$sesstat se1,
	v$sesstat se2,
	v$session ssn,
	v$bgprocess bgp,
	v$process prc,
	v$instance ins,
	dba_jobs_running djr,
	dba_jobs dj
WHERE se1.statistic# = 20
AND se2.statistic# = 21
AND se1.sid = ssn.sid
AND se2.sid = ssn.sid
AND ssn.paddr = bgp.paddr (+)
AND ssn.paddr = prc.addr (+)
AND ssn.SID = djr.sid
and djr.job = dj.job
--
SELECT
	to_char(ssn.sid, '9999') sid, ssn.username usuario, to_char(prc.spid, '999999999') "PID/THREAD", to_char(logon_time,'dd-mon-yy hh24:mi:ss'),
	to_char((se1.value/1024)/1024, '999G999G990D00') || ' MB' " CURRENT SIZE",
	to_char((se2.value/1024)/1024, '999G999G990D00') || ' MB' " MAXIMUM SIZE"
FROM
	v$sesstat se1,
	v$sesstat se2,
	v$session ssn,
	v$bgprocess bgp,
	v$process prc,
	v$instance ins
WHERE se1.statistic# = 20
AND se2.statistic# = 21
AND se1.sid = ssn.sid
AND se2.sid = ssn.sid
AND ssn.paddr = bgp.paddr (+)
AND ssn.paddr = prc.addr (+)
--
SELECT * FROM v$datafile_header
WHERE status ='OFFLINE' 
OR ERROR IS NOT NULL;
--
SELECT * FROM v$managed_standby 
WHERE process like 'MRP%';
--
SELECT * FROM v$dataguard_status
WHERE severity IN ('Error','Fatal')
AND timestamp > (sysdate -1);
--
SELECT
	DISTINCT DECODE(:B9 , 'ASC', T.FECHA_VALOR - :B8 , 'DES', :B8 - T.FECHA_VALOR) ORDENAMIENTO,
	T.FECHA_VALOR FECHA,
	T.SEC_TRANSACCION,
	TRA_K_GENERAL.F_OBTENER_NOM_TIPO_TRANSAC(T.COD_EMPRESA, T.COD_TRANSACCION) DESCRIPCION,
	T.VALOR_MONTO_AFECTA_FLUJO MONTO,
	DECODE(T.TIPO_MOVIMIENTO, 'ING', 'CRE', 'EGR', 'DEB') NATURALEZA
FROM TRA_TRANSACCION T
WHERE (T.COD_EMPRESA, T.COD_FIDUCIA, T.SEC_TRANSACCION) IN (
	SELECT A.COD_EMPRESA, A.COD_FIDUCIA, A.SEC_TRANSACCION
	FROM TRA_TRANSACCION_DET_ACUM A
	WHERE A.COD_EMPRESA = :B7 AND A.COD_FIDUCIA = :B6 AND A.COD_ACUMULADOR = :B10
)
AND T.COD_EMPRESA = :B7
AND T.COD_FIDUCIA = :B6
AND T.FECHA_VALOR BETWEEN :B5 AND :B4
AND (T.FECHA_VALOR >= :B3 OR :B3 IS NULL)
AND T.COD_PARTICIPE = :B2
AND T.NUM_CUENTA = :B1
AND T.TIPO_MOVIMIENTO IN ('ING', 'EGR')
AND T.ESTADO = 'APL'
ORDER BY ORDENAMIENTO ASC, T.SEC_TRANSACCION;
--
SELECT
	tsname,
	round(tablespace_size*t2.block_size/1024/1024,2) TSize,
	round(tablespace_usedsize*t2.block_size/1024/1024,2) TUsed,
	round((tablespace_size-tablespace_usedsize)*t2.block_size/1024/1024,2) TFree,
	round(val1*t2.block_size/1024/1024,2) "Dif_1h",round(val2*t2.block_size/1024/1024,2) "Dif_1d",
	round(val3*t2.block_size/1024/1024,2) "Dif_1s",round(val4*t2.block_size/1024/1024,2) "Dif_1m",
	round((tablespace_usedsize/tablespace_size)*100)||'%' "%Used",
	round(((tablespace_usedsize+val3)/tablespace_size)*100)||'%' "%Proy_1s",
	round(((tablespace_usedsize+val4)/tablespace_size)*100)||'%' "%Proy_1m",
	(case
		when ((((tablespace_usedsize+val3)/tablespace_size)*100 < 80) and (((tablespace_usedsize+val4)/tablespace_size)*100 < 80)) then 'NORMAL'
		when ((((tablespace_usedsize+val3)/tablespace_size)*100 between 80 and 90) OR (((tablespace_usedsize+val4)/tablespace_size)*100 between 80 and 90)) then 'WARNING'else 'CRITICAL'
	end) STATUS
FROM (
	SELECT DISTINCT
		tsname,
		rtime,
		tablespace_size,
		tablespace_usedsize,
		tablespace_usedsize-first_value(tablespace_usedsize) over (partition by tablespace_id order by rtime rows 1 preceding) val1,
		tablespace_usedsize-first_value(tablespace_usedsize) over (partition by tablespace_id order by rtime rows 24 preceding) val2,
		tablespace_usedsize-first_value(tablespace_usedsize) over (partition by tablespace_id order by rtime rows 168 preceding) val3,
		tablespace_usedsize-first_value(tablespace_usedsize) over (partition by tablespace_id order by rtime rows 720 preceding) val4
	FROM (
		SELECT
			t1.tablespace_size,
			t1.snap_id,
			t1.rtime,
			t1.tablespace_id,
			t1.tablespace_usedsize-nvl(t3.space,0) tablespace_usedsize
		FROM
			dba_hist_tbspc_space_usage t1,
			dba_hist_tablespace_stat t2,
			(
				SELECT ts_name,sum(space) space
				FROM recyclebin GROUP BY ts_name
			) t3
		WHERE t1.tablespace_id = t2.ts#
		AND t1.snap_id = t2.snap_id
		AND t2.tsname = t3.ts_name (+)
	) t1,
	dba_hist_tablespace_stat t2
WHERE t1.tablespace_id = t2.ts#
AND t1.snap_id = t2.snap_id
) t1, dba_tablespaces t2 
WHERE t1.tsname = t2.tablespace_name
AND rtime = (
	SELECT max(rtime)
	FROM dba_hist_tbspc_space_usage
)
AND t2.contents = 'PERMANENT'
ORDER BY "Dif_1h" desc, "Dif_1d" desc, "Dif_1s" desc, "Dif_1m" desc
--
SELECT
	max(al.sequence#) "Last Seq Recieved",
	max(lh.sequence#) "Last Seq Applied"
FROM v$archived_log al, v$log_history lh;
--
SELECT TO_CHAR(SYSDATE,'DD-MON-YY HH24:MI:SS') FROM DUAL;
--
SELECT
	to_char(sysdate,'dd-MON-yy hh:mi:ss') TIMESTAMP,
	b.THREAD# node,
	b.SEQUENCE# LOG_CUR,
	max(a.sequence#) LOG_REC,
	b.BLOCK#,
	b.BLOCKS
FROM
	v$managed_standby b,
	v$log_history a
WHERE b.process = 'RFS'
AND b.status='WRITING'
AND b.THREAD#=a.thread#
GROUP BY to_char(sysdate,'dd-MON-yy hh:mi:ss'), b.THREAD#, b.SEQUENCE#, b.BLOCK#, b.BLOCKS
ORDER BY 2;
--
SELECT * FROM V$ARCHIVE_GAP;
--
EXEC dbms_aqadm.stop_queue('COLA_GESTR_IN',TRUE,TRUE);
COMMIT;
exec dbms_aqadm.DROP_queue('COLA_GESTR_IN');
COMMIT;
EXEC dbms_aqadm.DROP_queue_TABLE('TABLA_COLA_GESTR_IN');
COMMIT;
EXEC dbms_aqadm.stop_queue('COLA_GESTR_OUT',TRUE,TRUE);
COMMIT;
EXEC dbms_aqadm.DROP_queue('COLA_GESTR_OUT');
COMMIT;
EXEC dbms_aqadm.DROP_queue_TABLE('TABLA_COLA_GESTR_OUT');
COMMIT;
EXEC dbms_aqadm.stop_queue('COLA_CANAL_IN',TRUE,TRUE);
COMMIT;
EXEC dbms_aqadm.DROP_queue('COLA_CANAL_IN');
COMMIT;
EXEC dbms_aqadm.DROP_queue_TABLE('TABLA_COLA_CANAL_IN');
COMMIT;
EXEC dbms_aqadm.stop_queue('COLA_CANAL_OUT',TRUE,TRUE);
COMMIT;
EXEC dbms_aqadm.DROP_queue('COLA_CANAL_OUT');
COMMIT;
EXEC dbms_aqadm.DROP_queue_TABLE('TABLA_COLA_CANAL_OUT',true);
COMMIT;
--
BEGIN 
	sys.dbms_aqadm.create_queue_table ( 
		queue_table => 'GESTRAQ_ADM.TABLA_COLA_CANAL_IN',
		queue_payload_type => 'RAW',
		sort_list => 'ENQ_TIME',
		comment => '',
		multiple_consumers => FALSE,
		message_grouping => DBMS_AQADM.NONE,
		storage_clause => 'TABLESPACE TSD_GESTRAQ_DF LOGGING',
		compatible => '8.1',
		primary_instance => '0',
		secondary_instance => '0'
	);
	COMMIT;
END;
--
BEGIN 
	sys.dbms_aqadm.create_queue(
		queue_name => 'GESTRAQ_ADM.COLA_CANAL_IN',
		queue_table => 'GESTRAQ_ADM.TABLA_COLA_CANAL_IN',
		queue_type => sys.dbms_aqadm.NORMAL_QUEUE,
		max_retries => '5',
		retry_delay => '0',
		retention_time => '0',
		comment => ''
	);
END;
--
BEGIN 
	sys.dbms_aqadm.start_queue(
		queue_name => 'GESTRAQ_ADM.COLA_CANAL_IN',
		enqueue => TRUE,
		dequeue => TRUE
	);
END;
--
BEGIN 
	sys.dbms_aqadm.create_queue_table (
		queue_table => 'GESTRAQ_ADM.TABLA_COLA_CANAL_OUT',
		queue_payload_type => 'RAW',
		sort_list => 'ENQ_TIME',
		comment => '',
		multiple_consumers => FALSE,
		message_grouping => DBMS_AQADM.NONE,
		storage_clause => 'TABLESPACE TSD_GESTRAQ_DF LOGGING',
		compatible => '8.1',
		primary_instance => '0',
		secondary_instance => '0'
	); 
	COMMIT;
END;
--
BEGIN 
	sys.dbms_aqadm.create_queue(
		queue_name => 'GESTRAQ_ADM.COLA_CANAL_OUT',
		queue_table => 'GESTRAQ_ADM.TABLA_COLA_CANAL_OUT',
		queue_type => sys.dbms_aqadm.NORMAL_QUEUE,
		max_retries => '5',
		retry_delay => '0',
		retention_time => '0',
		comment => ''
	);
END;
--
BEGIN 
	sys.dbms_aqadm.start_queue(
		queue_name => 'GESTRAQ_ADM.COLA_CANAL_OUT',
		enqueue => TRUE,
		dequeue => TRUE
	);
END;
--
BEGIN 
	sys.dbms_aqadm.create_queue_table ( 
		queue_table => 'GESTRAQ_ADM.TABLA_COLA_GESTR_IN',
		queue_payload_type => 'RAW',
		sort_list => 'ENQ_TIME',
		comment => '',
		multiple_consumers => FALSE,
		message_grouping => DBMS_AQADM.NONE,
		storage_clause => 'TABLESPACE TSD_GESTRAQ_DF LOGGING',
		compatible => '8.1',
		primary_instance => '0',
		secondary_instance => '0'
	); 
COMMIT;
END;
--
BEGIN 
	sys.dbms_aqadm.create_queue(
		queue_name => 'GESTRAQ_ADM.COLA_GESTR_IN',
		queue_table => 'GESTRAQ_ADM.TABLA_COLA_GESTR_IN',
		queue_type => sys.dbms_aqadm.NORMAL_QUEUE,
		max_retries => '5',
		retry_delay => '0',
		retention_time => '0',
		comment => ''
	);
END;
--
BEGIN 
	sys.dbms_aqadm.start_queue(
		queue_name => 'GESTRAQ_ADM.COLA_GESTR_IN',
		enqueue => TRUE,
		dequeue => TRUE
	);
END;
--
BEGIN 
	sys.dbms_aqadm.create_queue_table (
		queue_table => 'GESTRAQ_ADM.TABLA_COLA_GESTR_OUT',
		queue_payload_type => 'RAW',
		sort_list => 'ENQ_TIME',
		comment => '',
		multiple_consumers => FALSE,
		message_grouping => DBMS_AQADM.NONE,
		storage_clause => 'TABLESPACE TSD_GESTRAQ_DF LOGGING',
		compatible => '8.1',
		primary_instance => '0',
		secondary_instance => '0'
	);
	COMMIT;
END;
--
BEGIN 
	sys.dbms_aqadm.create_queue(
		queue_name => 'GESTRAQ_ADM.COLA_GESTR_OUT',
		queue_table => 'GESTRAQ_ADM.TABLA_COLA_GESTR_OUT',
		queue_type => sys.dbms_aqadm.NORMAL_QUEUE,
		max_retries => '5',
		retry_delay => '0',
		retention_time => '0',
		comment => ''
	);
END;
--
BEGIN
	sys.dbms_aqadm.start_queue(
		queue_name => 'GESTRAQ_ADM.COLA_GESTR_OUT',
		enqueue => TRUE,
		dequeue => TRUE
	);
END;
--
SELECT
	c.name,
	a.addr,
	a.gets,
	a.misses,
	a.sleeps,
	a.immediate_gets,
	a.immediate_misses,b.pid 
FROM
	v$latch a,
	v$latchholder b,
	v$latchname c 
WHERE a.addr = b.laddr(+) 
AND a.latch# = c.latch# 
ORDER BY a.latch#;
--
SELECT
	substr(sql_text,1,40) "Stmt", count(*),
	sum(sharable_mem) "Mem",
	sum(users_opening) "Open",
	sum(executions) "Exec"
FROM v$sql
GROUP BY substr(sql_text,1,40)
HAVING sum(sharable_mem) > 40;
--
SELECT
	name,
	(1-(physical_reads / (consistent_gets + db_block_gets )))*100 "HIT_RATIO"
FROM V$BUFFER_POOL_STATISTICS
WHERE (consistent_gets + db_block_gets) !=0;
--
SELECT
	substr(sql_text,1,40) "SQL",
	count(*), 
	sum(executions) "TotExecs"
FROM v$sqlarea
WHERE executions < 5
GROUP BY substr(sql_text,1,40)
HAVING count(*) > 30
ORDER BY 2;
--
SELECT
	SUM(PINS) "EXECUTIONS",
	SUM(RELOADS) "CACHE MISSES WHILE EXECUTING"
FROM V$LIBRARYCACHE;
--
SELECT
	hash_value,
	count(*)
FROM v$sqlarea 
GROUP BY hash_value 
HAVING count(*) > 5;
--
SELECT
	address,
	hash_value,
	version_count,
	users_opening,
	users_executing,
	substr(sql_text,1,40) "SQL"
FROM v$sqlarea
WHERE version_count > 10;
--
EXEC dbms_aqadm.stop_queue('COLA_GESTT_IN',TRUE,TRUE);
COMMIT;
EXEC dbms_aqadm.DROP_queue('COLA_GESTT_IN');
COMMIT;
EXEC dbms_aqadm.DROP_queue_TABLE('TABLA_COLA_GESTT_IN');
COMMIT;
EXEC dbms_aqadm.stop_queue('COLA_GESTT_OUT',TRUE,TRUE);
COMMIT;
EXEC dbms_aqadm.DROP_queue('COLA_GESTT_OUT');
COMMIT;
EXEC dbms_aqadm.DROP_queue_TABLE('TABLA_COLA_GESTT_OUT');
COMMIT;
EXEC dbms_aqadm.stop_queue('COLA_CANALTT_IN',TRUE,TRUE);
COMMIT;
EXEC dbms_aqadm.DROP_queue('COLA_CANALTT_IN');
COMMIT;
EXEC dbms_aqadm.DROP_queue_TABLE('TABLA_COLA_CANALTT_IN');
COMMIT;
EXEC dbms_aqadm.stop_queue('COLA_CANALTT_OUT',TRUE,TRUE);
COMMIT;
EXEC dbms_aqadm.DROP_queue('COLA_CANALTT_OUT');
COMMIT;
EXEC dbms_aqadm.DROP_queue_TABLE('TABLA_COLA_CANALTT_OUT');
COMMIT;
--
BEGIN 
	sys.dbms_aqadm.create_queue_table (
		queue_table => 'GESTTAQ_ADM.TABLA_COLA_CANALTT_IN',
		queue_payload_type => 'RAW',
		sort_list => 'ENQ_TIME',
		comment=> '',
		multiple_consumers => FALSE,
		message_grouping=> DBMS_AQADM.NONE,
		storage_clause => 'TABLESPACE TSD_GESTRAQ_DF LOGGING',
		compatible => '8.1',
		primary_instance=> '0',
		secondary_instance => '0'
	); 
	COMMIT;
END;
--
BEGIN 
	sys.dbms_aqadm.create_queue(
		queue_name => 'GESTTAQ_ADM.COLA_CANALTT_IN',
		queue_table => 'GESTTAQ_ADM.TABLA_COLA_CANALTT_IN',
		queue_type => sys.dbms_aqadm.NORMAL_QUEUE,
		max_retries => '5',
		retry_delay => '0',
		retention_time => '0',
		comment => ''
	);
END;
--
BEGIN 
	sys.dbms_aqadm.start_queue(
		queue_name => 'GESTTAQ_ADM.COLA_CANALTT_IN',
		enqueue => TRUE,
		dequeue => TRUE
	);
END;
--
BEGIN 
	sys.dbms_aqadm.create_queue_table (
		queue_table => 'GESTTAQ_ADM.TABLA_COLA_CANALTT_OUT',
		queue_payload_type => 'RAW',
		sort_list => 'ENQ_TIME',
		comment => '',
		multiple_consumers => FALSE,
		message_grouping => DBMS_AQADM.NONE,
		storage_clause => 'TABLESPACE TSD_GESTRAQ_DF LOGGING',
		compatible => '8.1',
		primary_instance => '0',
		secondary_instance => '0'
	);
	COMMIT;
END;
--
BEGIN 
	sys.dbms_aqadm.create_queue(
		queue_name => 'GESTTAQ_ADM.COLA_CANALTT_OUT',
		queue_table => 'GESTTAQ_ADM.TABLA_COLA_CANALTT_OUT',
		queue_type => sys.dbms_aqadm.NORMAL_QUEUE,
		max_retries => '5',
		retry_delay => '0',
		retention_time => '0',
		comment => ''
	);
END;
--
BEGIN 
	sys.dbms_aqadm.start_queue(
		queue_name => 'GESTTAQ_ADM.COLA_CANALTT_OUT',
		enqueue => TRUE,
		dequeue => TRUE
	);
END;
--
BEGIN 
	sys.dbms_aqadm.create_queue_table (
		queue_table => 'GESTTAQ_ADM.TABLA_COLA_GESTT_IN',
		queue_payload_type => 'RAW',
		sort_list => 'ENQ_TIME',
		comment => '',
		multiple_consumers => FALSE,
		message_grouping => DBMS_AQADM.NONE,
		storage_clause => 'TABLESPACE TSD_GESTRAQ_DF LOGGING',
		compatible => '8.1',
		primary_instance => '0',
		secondary_instance => '0'
	);
	COMMIT;
END;
--
-- Para tomar la traza a un proceso Oracle
SELECT
	p.pid,
	p.spid,
	p.username,
	s.username,
	s.machine,
	s.logon_time
FROM v$process p, v$session s
WHERE p.addr = s.paddr
AND s.sid = 101
ORDER BY s.machine
--
ALTER SESION SET max_dump_file_size=unlimited;
--
SET nls_date_format='DD-MM-YYYY HH24:MI:SS';
--
SELECT
	instance_name,
	host_name
FROM v$instance;
--
SELECT
	dbid,
	created,
	log_mode,
	force_logging
FROM v$database;
--
SELECT
	name,
	value
FROM v$parameter
ORDER BY name;
--
SELECT
	file_id,
	file_name,
	tablespace_name,
	bytes/1024 tam_kb 
FROM dba_data_files
ORDER BY 2;
--
SELECT
	file_id,
	file_name,
	tablespace_name,
	bytes/1024 tam_kb 
FROM dba_temp_files
ORDER BY 2;
--
SELECT name
FROM v$controlfile;
--
SELECT
	lf.group#,
	lf.member,
	l.bytes/1024 tam_kb
FROM v$logfile lf, v$log l
WHERE lf.group# = l.group#;
--
SELECT
	owner,
	table_name,
	tablespace_name,
	cluster_name,
	pct_free,
	pct_used,
	ini_trans,
	pct_increase,
	freelists,
	freelist_groups,
	logging,
	degree,
	cache,
	partitioned,
	temporary,
	buffer_pool
FROM dba_tables
ORDER BY 1,2;
--
SELECT
	owner,
	index_name,
	index_type,
	table_owner,
	table_name,
	table_type,
	uniqueness,
	tablespace_name,
	ini_trans,
	pct_increase,
	logging,
	degree,
	partitioned
FROM dba_indexes
ORDER BY 1,2;
--
SELECT * FROM dba_ind_columns
ORDER BY 1,2,6;
--
SELECT
	table_owner,
	table_name,
	partition_name,
	subpartition_count,
	high_value,
	high_value_length,
	partition_position
FROM all_tab_partitions
ORDER BY 1,2,3;
--
SELECT
	to_char(max(lh.first_time),'dd-mm-yyyy hh24:mi:ss') Fecha,
	max(lh.sequence#) Seq
FROM v$log_history lh;
--
SELECT
	to_char(max(al.first_time),'dd-mm-yyyy hh24:mi:ss') Fecha,
	max(al.sequence#) Seq
FROM v$archived_log al;
--
SELECT
	to_char(fecha,'dd-mon-yy hh24:mi:ss') fecha,ts_temp,notificado 
FROM monitor.cambios_temp_gestraq
WHERE trunc(fecha)=trunc(sysdate)
ORDER BY fecha;
--
SELECT
	jobid,
	decode(estatus,1,'ACTIVO','INACTIVO'),
	to_char(fecha_ini,'dd-mon-yy hh24:mi:ss'),
	to_char(fecha_fin,'dd-mon-yy hh24:mi:ss')
FROM gestraq_adm.control_desenc_suicidas
WHERE trunc(fecha_ini)=trunc(sysdate)
ORDER BY fecha_ini;
--
SELECT
	jobid,
	to_char(fecha_ini,'dd-mon-yy hh24:mi:ss'),
	to_char(fecha_fin,'dd-mon-yy hh24:mi:ss')
FROM gestraq_adm.bitacora_desenc_suicidas
WHERE trunc(fecha_ini)=trunc(sysdate)
ORDER BY fecha_ini;
--
SELECT
	job,
	last_date,
	last_sec,
	next_date,next_sec,
	failures,broken,what
FROM user_jobs
WHERE what like '%chq_temp_gestraq%'
OR what like '%monitor_canal%';
--
SELECT
	d.tablespace_name,
	decode(d.status,'ONLINE','ON',DECODE(d.status,'OFFLINE','OFF','RO')) STA,
	d.next_extent/1024 Tam_Ext_kb,
	trunc(((a.bytes / 1024 / 1024) - (a.bytes - decode(f.bytes, NULL,0, f.bytes)) / 1024 / 1024) / (d.next_extent/1024/1024)) Ext_libres,
	ROUND((a.bytes / 1024 / 1024), 2) Definido, 
	ROUND(((a.bytes - decode(f.bytes, NULL, 0, f.bytes)) / 1024 / 1024), 2) Usado, 
	ROUND(((a.bytes / 1024 / 1024) - (a.bytes - decode(f.bytes, NULL,0, f.bytes)) / 1024 / 1024), 2) Libre, 
	ROUND((((a.bytes / 1024 / 1024) - (a.bytes - decode(f.bytes, NULL,0, f.bytes)) / 1024 / 1024) / (a.bytes / 1024 / 1024)) * 100.0, 2) "% Libre"
FROM sys.dba_tablespaces d, sys.sm$ts_avail a, sys.sm$ts_free f
WHERE d.tablespace_name = a.tablespace_name 
AND f.tablespace_name(+) = d.tablespace_name 
AND (ROUND((((a.bytes / 1024 / 1024) - (a.bytes - decode(f.bytes, NULL,0, f.bytes)) / 1024 / 1024) / (a.bytes / 1024 / 1024)) * 100.0, 2)) <= 30
UNION ALL 
SELECT
	d.tablespace_name,
	decode(d.status,'ONLINE','ON',DECODE(d.status,'OFFLINE','OFF','RO')),
	d.next_extent/1024,
	trunc((a.bytes / 1024 / 1024) - (NVL(t.bytes, 0) / 1024 / 1024) / (d.next_extent/1024/1024)),
	ROUND((a.bytes / 1024 / 1024), 2),
	ROUND(NVL(t.bytes,0) / 1024 / 1024, 2),
	ROUND((a.bytes / 1024 / 1024) - (NVL(t.bytes, 0) / 1024 / 1024),2),
	ROUND(100 - (NVL(t.bytes / a.bytes * 100, 0)), 2)
FROM sys.dba_tablespaces d, (
	SELECT
		tablespace_name,
		SUM(bytes) bytes
	FROM dba_temp_files 
	GROUP BY tablespace_name
	) a,
	(
	SELECT
		tablespace_name,
		SUM(bytes_cached) bytes
	FROM sys.v_$temp_extent_pool 
	GROUP BY tablespace_name
	) t 
WHERE d.tablespace_name = a.tablespace_name(+) 
AND d.tablespace_name = t.tablespace_name(+) 
AND d.extent_management LIKE 'LOCAL' 
AND d.contents LIKE 'TEMPORARY'
and ROUND(100 - (NVL(t.bytes / a.bytes * 100, 0)), 2) <= 20
order by 8;
--
select
	to_char(max(al.first_time),'dd-mm-yyyy hh24:mi:ss') Fecha_ult_Archive_Produccion,
	max(al.sequence#) Seq
from v$archived_log al;
--
alter session set nls_date_format='dd-mm-yy hh24:mi:ss';
--
select THREAD#,max(first_time),max(SEQUENCE#) 
from v$archived_log 
group by THREAD#;
--
select to_char(max(al.first_time),'dd-mm-yyyy hh24:mi:ss') Fecha_ult_Archive_DataGuard, max(al.sequence#) Seq
from v$archived_log al;
--
select * from v$archive_gap;
--
select job,schema_user,log_user,next_date,next_sec,failures,broken,what,instance
from dba_jobs
where broken='Y' or failures>0;
--
select owner,object_name,object_type
from dba_objects
where status='INVALID';
--
SELECT
	d.tablespace_name, 
	decode(d.status,'ONLINE','ON',DECODE(d.status,'OFFLINE','OFF','RO')) STA,
	d.next_extent/1024 Tam_Ext_kb,
	trunc(((a.bytes / 1024 / 1024) - (a.bytes - decode(f.bytes, NULL,0, f.bytes)) / 1024 / 1024) / (d.next_extent/1024/1024)) Ext_libres,
	ROUND((a.bytes / 1024 / 1024), 2) Definido, 
	ROUND(((a.bytes - decode(f.bytes, NULL, 0, f.bytes)) / 1024 / 1024), 2) Usado, 
	ROUND(((a.bytes / 1024 / 1024) - (a.bytes - decode(f.bytes, NULL,0, f.bytes)) / 1024 / 1024), 2) Libre, 
	ROUND((((a.bytes / 1024 / 1024) - (a.bytes - decode(f.bytes, NULL,0, f.bytes)) / 1024 / 1024) / (a.bytes / 1024 / 1024)) * 100.0, 2) "% Libre"
FROM sys.dba_tablespaces d, sys.sm$ts_avail a, sys.sm$ts_free f
WHERE d.tablespace_name = a.tablespace_name 
AND f.tablespace_name(+) = d.tablespace_name 
and d.tablespace_name in (
	select distinct
		tablespace_name
	from dba_segments
	where segment_name in (
		select
			table_name 
		from dba_tables 
		where owner='EBA'
		and partitioned='YES'
		union 
		select
			index_name
		from dba_indexes 
		where owner='EBA'
		and partitioned='YES'
	)
);
--
SELECT TO_CHAR(SYSDATE,'DD-MON-YY HH24:MI:SS') FROM DUAL;
exec DBMS_STATS.GATHER_SCHEMA_STATS(OWNNAME=>'GESTORTT', CASCADE=>TRUE, ESTIMATE_PERCENT=>20);
SELECT TO_CHAR(SYSDATE,'DD-MON-YY HH24:MI:SS') FROM DUAL;
--
select
	to_char(s.startup_time,' dd Mon "at" HH24:mi:ss') instart_fmt,
	di.instance_name inst_name,
	di.db_name db_name,
	s.snap_id snap_id,
	to_char(s.snap_time,'dd Mon YYYY HH24:mi') snapdat, 
	s.snap_level lvl,
	substr(s.ucomment, 1,60) commnt
from
	stats$snapshot s,
	stats$database_instance di
where s.dbid = 203306654
and di.dbid = 203306654
and s.instance_number = 1
and di.instance_number = 1
and di.dbid = s.dbid
and di.instance_number = s.instance_number
and di.startup_time = s.startup_time
and s.snap_id < 100
order by db_name, instance_name, snap_id;
--
CREATE USER REPORT IDENTIFIED BY entrada987
	DEFAULT TABLESPACE USERS
	TEMPORARY TABLESPACE TEMPORAL
	QUOTA UNLIMITED ON USERS
	PROFILE DEFAULT
	ACCOUNT UNLOCK
--
GRANT AQ_ADMINISTRATOR_ROLE TO REPORT
GRANT AQ_USER_ROLE TO REPORT
ALTER USER REPORT DEFAULT ROLE AQ_ADMINISTRATOR_ROLE, AQ_USER_ROLE
GRANT CREATE PROCEDURE TO REPORT
GRANT CREATE PUBLIC SYNONYM TO REPORT
GRANT CREATE SESSION TO REPORT
GRANT CREATE TABLE TO REPORT
GRANT CREATE VIEW TO REPORT
GRANT UNLIMITED TABLESPACE TO REPORT
--
SELECT
	avg(db_time) "Avg Bd",
	avg(SECURITY_TIME) "Avg Atalla",
	avg(TRAN_PROC_TIME) "Avg Aplic",
	max(db_time) "Max Bd",
	max(SECURITY_TIME) "Max Atalla",
	max(TRAN_PROC_TIME) "Max Aplic"
from EBA.EFT_STATS
where tran_time >= trunc(sysdate)
and tran_time <= trunc(sysdate)+(8/24)
--
exec DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'ESTADISTICAS', estimate_percent => 30, cascade => TRUE);
exec DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'GESTRAQ', estimate_percent => 30, cascade => TRUE);
exec DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'GESTRAQ_ADM', estimate_percent => 30, cascade => TRUE);
exec DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'GESGSAQ', estimate_percent => 30, cascade => TRUE);
exec DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'GESGSAQ_ADM', estimate_percent => 30, cascade => TRUE);
exec DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'GESTTAQ', estimate_percent => 30, cascade => TRUE);
exec DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'GESTTAQ_ADM', estimate_percent => 30, cascade => TRUE);
exec DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'RECTORAQ', estimate_percent => 30, cascade => TRUE);
exec DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'RECTORAQ_ADM', estimate_percent => 30, cascade => TRUE);
COMMIT;
--
select event, total_waits, time_waited, average_wait
from v$system_event
where event like 'log file switch%';
--
select event, total_waits, time_waited, average_wait
from v$system_event
where event like 'log file switch (arc%';
--
select (req.value*5000)/entries.value "Ratio" 
from v$sysstat req, v$sysstat entries 
where req.name = 'redo log space requests' 
and entries.name = 'redo entries' ;
--
select 
	decode(px.qcinst_id,NULL,username, ' - '||lower(substr(s.program,length(s.program)-4,4) ) ) "Username", 
	decode(px.qcinst_id,NULL, 'QC', '(Slave)') "QC/Slave" , 
	to_char( px.server_set) "Slave Set", 
	to_char(s.sid) "SID", 
	decode(px.qcinst_id, NULL ,to_char(s.sid) ,px.qcsid) "QC SID", 
	px.req_degree "Requested DOP", 
	px.degree "Actual DOP" 
from 
	v$px_session px, 
	v$session s 
where px.sid=s.sid (+) 
and px.serial#=s.serial# 
order by 5 , 1 desc
--
select
	table_name,
	partition_name,
	decode(to_number(substr(partition_name,4,2)),
		1,'Ene',
		2,'Feb',
		3,'Mar',
		4,'Abr',
		5,'May',
		6,'Jun',
		7,'Jul',
		8,'Ago',
		9,'Sep',
		10,'Oct',
		11,'Nov',
		12,'Dic')||'-'||substr(partition_name,6,2) Mes_Anno
from all_tab_partitions
where table_owner='&1'
order by 1,substr(partition_name,6,2)||substr(partition_name,4,2)||substr(partition_name,2,2);
--
select
	table_name,
	partition_name
from all_tab_partitions
where table_owner='&1'
and partition_name not like 'SYS%'
order by table_name,partition_position;
--
ALTER TABLE EBA.EB_TRAN_LOG DROP PARTITION P231206;
ALTER TABLE EBA.EB_TRAN_LOG DROP PARTITION P241206;
ALTER TABLE EBA.EB_TRAN_LOG DROP PARTITION P251206;
--
INSERT INTO AU_ACCT_XREF
SELECT
	TMP_AU_ACCT_XREF.issuer,
	TMP_AU_ACCT_XREF.ext_card_nbr,
	TMP_AU_ACCT_XREF.acct_type,
	TMP_AU_ACCT_XREF.pri_acct_ind,
	TMP_AU_ACCT_XREF.card_type,
	AU_CARD.card_nbr,
	AU_ACCOUNT.acct_nbr,
	TMP_AU_ACCT_XREF.mbr_nbr 
FROM AU_CARD, TMP_AU_ACCT_XREF, AU_ACCOUNT
WHERE TMP_AU_ACCT_XREF.ext_card_nbr=AU_CARD.ext_card_nbr
AND TMP_AU_ACCT_XREF.ext_acct_nbr=AU_ACCOUNT.ext_acct_nbr
--
SELECT
	segment_name,
	segment_type,
	sum(extents)
FROM dba_segments
WHERE owner='NOTES'
GROUP BY segment_name,segment_type
HAVING SUM(extents) > 10
ORDER BY 3 DESC;
--
SELECT
	p.spid "OS Thread",
	b.name "Name-User",
	s.osuser,
	s.program,
	s.status
FROM
	v$process p,
	v$session s,
	v$bgprocess b
WHERE p.addr = s.paddr
AND p.addr = b.paddr
AND s.status='KILLED'
UNION ALL
SELECT
	p.spid "OS Thread",
	s.username "Name-User",
	s.osuser,
	s.program,
	s.status
FROM
	v$process p,
	v$session s
WHERE p.addr = s.paddr
AND s.username is not null
AND s.status='KILLED';
--
EXEC dbms_aqadm.start_queue('gestraq_adm.AQ$_TABLA_COLA_CANAL_IN_E', false, true);
COMMIT;
EXEC API_MANIPULACION_COLAS_GEN.ELIMINA_MENSAJES_E(5,'AQ$_TABLA_COLA_CANAL_IN_E');
EXEC dbms_aqadm.stop_queue('gestraq_adm.AQ$_TABLA_COLA_CANAL_IN_E', true, true);
COMMIT;
--
DROP USER USER_ELIM_SESION cascade;
CREATE USER USER_ELIM_SESION IDENTIFIED BY VALUES '2CED9989CC0EECC0';
CREATE USER prueba2 IDENTIFIED BY pepe DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;
GRANT CREATE SESSION TO prueba2;
GRANT ALTER SYSTEM TO USER_ELIM_SESION;
GRANT CREATE PROCEDURE TO USER_ELIM_SESION;
GRANT SELECT ON SYS.V_$PROCESS TO USER_ELIM_SESION;
GRANT SELECT ON SYS.V_$SESSION TO USER_ELIM_SESION;
--
CREATE OR REPLACE PROCEDURE USER_ELIM_SESION.Eliminar_sesion( vsid in number, vser in number ) IS
	vStrSql varchar2(200);
BEGIN
	vStrSql := 'alter system disconnect session ' || chr(39)|| vsid || ',' || vser || chr(39)||' immediate';
	EXECUTE IMMEDIATE vStrSql;
END;
--
SELECT parametro,valor_num,valor_char 
FROM gestraq_adm.config_desenc_suicidas;
--
SELECT * FROM gestraq_adm.control_desenc_suicidas WHERE trunc(fecha_ini)=trunc(sysdate);
SELECT * FROM gestraq_adm.bitacora_desenc_suicidas WHERE trunc(fecha_ini)=trunc(sysdate);
--
SELECT
	job,
	broken,
	failures,
	next_date,
	next_sec,
	last_date,
	last_sec,what
FROM dba_jobs 
WHERE what like '%monitor_canal%';
--
SELECT
	to_char(sysdate,'dd-mon-yyyy hh24:mi:ss'),
	to_char(sysdate+15/(24*60*60),'dd-mon-yyyy hh24:mi:ss')
FROM dual;
--
SELECT
	substr(to_char(sysdate,'dd-mm-yy hh24:mi:ss'),1,20) fecha_sistema,
	COUNT(*) CANAL_IN 
FROM GESTRAQ_ADM.TABLA_COLA_canal_in;
--
SELECT
	substr(to_char(sysdate,'dd-mm-yy hh24:mi:ss'),1,20) fecha_sistema,
	COUNT(*) CANAL_OUT
FROM GESTRAQ_ADM.TABLA_COLA_canal_out;
--
SELECT
	substr(to_char(sysdate,'dd-mm-yy hh24:mi:ss'),1,20) fecha_sistema,
	COUNT(*) GESTR_IN
FROM GESTRAQ_ADM.TABLA_COLA_GESTR_in;
--
SELECT
	substr(to_char(sysdate,'dd-mm-yy hh24:mi:ss'),1,20) fecha_sistema,
	COUNT(*) GESTR_OUT
FROM GESTRAQ_ADM.TABLA_COLA_GESTR_out;
--
SELECT
	substr(to_char(sysdate,'dd-mm-yy hh24:mi:ss'),1,20) fecha_sistema,
	count(*) RECTOR_IN
FROM rectoraq_adm.TABLA_COLA_RECTOR_IN;
--
SELECT
	substr(to_char(sysdate,'dd-mm-yy hh24:mi:ss'),1,20) fecha_sistema,
	count(*) RECTOR_OUT
FROM rectoraq_adm.TABLA_COLA_RECTOR_out;
--
SELECT
	count(s.username) "Procesos GESTORAQ_ADM"
FROM
	v$session s,
	v$sqlarea a
WHERE s.username = 'GESTRAQ_ADM'
AND substr(s.status, 1, 1) = 'A'
AND s.audsid != userenv('SESSIONID')
AND s.type = 'USER'
AND s.sql_address = a.address
AND s.sql_hash_value = a.hash_value;
--
SELECT
	count(s.username) "Procesos RECTORAQ_ADM"
FROM
	v$session s,
	v$sqlarea a
WHERE s.username = 'RECTORAQ_ADM'
AND substr(s.status, 1, 1) = 'A'
AND s.audsid != userenv('SESSIONID')
AND s.type = 'USER'
AND s.sql_address = a.address
AND s.sql_hash_value = a.hash_value;
--
SELECT
	owner,
	object_type,
	object_name
FROM dba_objects
WHERE object_name LIKE '%_I'
AND owner='PSP';
--
SELECT 'alter table PSP.'||object_name||' coalesce;'
FROM dba_objects
WHERE object_name LIKE 'AQ%_I'
AND owner='PSP'
AND object_type='TABLE';
--
SELECT 'alter table PSP.'||object_name||' coalesce;'
FROM dba_objects
WHERE object_name LIKE 'AQ%_T'
AND owner='PSP'
AND object_type='TABLE';
--
SELECT 'alter table PSP.'||object_name||' coalesce;'
FROM dba_objects
WHERE object_name LIKE 'AQ%_H'
AND owner='PSP'
AND object_type='TABLE';
--
SELECT 'alter index PSP.'||object_name||' coalesce;'
FROM dba_objects
WHERE object_name LIKE 'AQ%_I'
AND owner='PSP'
AND object_type='INDEX';
--
SELECT 'alter index PSP.'||object_name||' coalesce;'
FROM dba_objects
WHERE object_name like 'AQ%_T'
AND owner='PSP'
AND object_type='INDEX';
--
CREATE USER RMAN IDENTIFIED BY rman987
	DEFAULT TABLESPACE USERS
	TEMPORARY TABLESPACE TEMP
	PROFILE DEFAULT
	ACCOUNT LOCK
--
GRANT CREATE SESSION TO RMAN;
GRANT EXP_FULL_DATABASE TO RMAN WITH ADMIN OPTION
GRANT IMP_FULL_DATABASE TO RMAN WITH ADMIN OPTION
GRANT SELECT_CATALOG_ROLE TO RMAN WITH ADMIN OPTION
GRANT EXECUTE_CATALOG_ROLE TO RMAN WITH ADMIN OPTION
GRANT RECOVERY_CATALOG_OWNER TO RMAN WITH ADMIN OPTION
--
ALTER USER RMAN DEFAULT ROLE
	DBA,
	EXP_FULL_DATABASE,
	IMP_FULL_DATABASE,
	SELECT_CATALOG_ROLE,
	EXECUTE_CATALOG_ROLE,
	RECOVERY_CATALOG_OWNER
--
GRANT SYSDBA TO RMAN;