UPDATE OP_PROCESSES
SET STATUS = 'NE'
WHERE GROUP_CODE = 54
AND PROCESS_CODE = 5;
COMMIT;
--
SELECT
	STATUS,
	GROUP_CODE,
	PROCESS_CODE
FROM OP_PROCESSES
WHERE GROUP_CODE = 54
AND PROCESS_CODE = 5;
--
SELECT
	STATUS,
	GROUP_CODE,
	PROCESS_CODE
FROM OP_PROCESSES
WHERE GROUP_CODE = 54
AND PROCESS_CODE = 5;
--
ALTER SESSION SET nls_date_format = 'dd-mm-yy hh24:mi:ss';
SELECT to_char(sysdate) FROM dual;

INSERT INTO gestorv2.mnt_crec_gestor
SELECT
	trunc(sysdate),
	table_name,num_rows 
FROM dba_tables
WHERE owner='GESTORV2'
ORDER BY table_name;
COMMIT;
--
SELECT to_char(sysdate) FROM dual;
--
SELECT count(*) FROM ichub.oai_hub_queue;
SELECT count(*) FROM ichub.componentinfo;
SELECT count(*) FROM ichub.componentinfovalue;
SELECT count(*) FROM ichub.messagestatustable;
--
TRUNCATE table ichub.oai_hub_queue;
TRUNCATE table ichub.componentinfo;
TRUNCATE table ichub.componentinfovalue;
TRUNCATE table ichub.messagestatustable;
--
DELETE FROM oaihub902.MSG_CORRELATION
WHERE creation_date < sysdate - 5/(24*60);
COMMIT;
--
SELECT to_char(sysdate,'dd-mon-yy hh24:mi:ss') from dual;
--
ALTER TABLE GESTORV2.AUD_REGISTRO_DETALLE disable CONSTRAINT FK_AUD_REG_DETA_A_CABEZA;
TRUNCATE TABLE GESTORV2.AUD_REGISTRO_DETALLE;
TRUNCATE TABLE GESTORV2.AUD_REGISTRO;
ALTER TABLE GESTORV2.AUD_REGISTRO_DETALLE enable CONSTRAINT FK_AUD_REG_DETA_A_CABEZA;
--
DECLARE 
	NOMBRE_COLA VARCHAR2(200);
	MENSAJE VARCHAR2(3000);
	V_ERROR_CODE NUMBER;
	V_ERROR_MESSAGE VARCHAR2(200);
BEGIN 
	NOMBRE_COLA := 'COLA_GESGS_OUT';
	MENSAJE := NULL;
	V_ERROR_CODE := NULL;
	V_ERROR_MESSAGE := NULL;
	FOR I IN 1 .. 2 LOOP
		GESGSAQ_ADM.AQ_UTILITIES.DESENCOLAR_MSG (NOMBRE_COLA, MENSAJE, V_ERROR_CODE, V_ERROR_MESSAGE );
		COMMIT; 
		dbms_output.put_line('errmsg:'||substr(V_ERROR_MESSAGE,1,100));
	END LOOP;
END; 
--
SELECT
	a.id_modulo,
	a.name_modulo,
	(case
		when (SELECT modulo_access ma from en_user_access where id_user=7) like '%'+str(a.id_modulo,case when a.id_modulo < 10 then 1 else 2 end)+'%' then 'true'
		else 'false'
	end) chk
FROM
	en_modulo a,
	(SELECT COUNT(*) t FROM en_modulo) b
--
TRUNCATE TABLE monitor_tablas;
GRANT SELECT ON sys.dba_tables to system;
GRANT SELECT ANY TABLE to system;
SELECT COUNT(*) from monitor_tablas;
--
CREATE TABLE monitor_tablas (
	fecha date,
	tabla varchar2(40),
	total number
) tablespace &1;

CREATE INDEX idx_monitor_tablas on monitor_tablas(fecha,tabla) tablespace &2;
--
--
--
DROP INDEX SYSRECTOR.CAPS_IDX2;
CREATE UNIQUE INDEX INPRONTUP.CAPS_IDX2 ON INPRONTUP.CARM_PROVEEDORES_SERVICIOS(
	CAPS_CD_PROVEEDOR_ORIGEN
)
	TABLESPACE USERS
	LOGGING
	PCTFREE 10
	INITRANS 2
	MAXTRANS 255
	STORAGE(BUFFER_POOL DEFAULT)
	NOPARALLEL
	NOCOMPRESS
--
DROP INDEX SYSRECTOR.CAPS_INDEX1;
CREATE INDEX INPRONTUP.CAPS_INDEX1 ON INPRONTUP.CARM_PROVEEDORES_SERVICIOS(
	CAPS_CACN_CD_NACIONALIDAD,
	CAPS_CACN_NU_CEDULA_RIF
)
	TABLESPACE USERS
	LOGGING
	PCTFREE 10
	INITRANS 2
	MAXTRANS 255
	STORAGE(BUFFER_POOL DEFAULT)
	NOPARALLEL
	NOCOMPRESS
--
EXEC DBMS_STATS.GATHER_index_STATS (ownname => 'INPRONTUP', indname => 'CAPS_IDX2', estimate_percent => 30 );
COMMIT;
EXEC DBMS_STATS.GATHER_index_STATS (ownname => 'INPRONTUP', indname => 'CAPS_INDEX1', estimate_percent => 30 );
COMMIT;
--
exec DBMS_STATS.GATHER_SCHEMA_STATS (ownname => 'INPRONTUP', estimate_percent => 30, degree=> 4, cascade => TRUE);
commit;
--
DROP USER oaihub902 CASCADE;
--
grant select on messagestatustable to estadisticas;
grant select on APPIDTABLE to estadisticas;
grant select on MESSAGEINFOIDTABLE to estadisticas;
--
GRANT CONNECT,RESOURCE TO oaihub902;
GRANT ALTER SESSION TO oaihub902;
GRANT ALTER DATABASE TO oaihub902;
GRANT CREATE ANY INDEX TO oaihub902;
GRANT CREATE ANY SNAPSHOT TO oaihub902;
GRANT CREATE DATABASE LINK TO oaihub902;
GRANT CREATE SESSION TO oaihub902;
GRANT CREATE SYNONYM TO oaihub902;
GRANT CREATE VIEW TO oaihub902;
GRANT EXECUTE ANY PROCEDURE TO oaihub902;
GRANT IMP_FULL_DATABASE TO oaihub902;
--
CREATE USER oaihub902 IDENTIFIED BY &1 DEFAULT TABLESPACE USERS PROFILE DEFAULT ACCOUNT UNLOCK;
ALTER USER oaihub902 DEFAULT ROLE ALL;
ALTER USER oaihub902 QUOTA UNLIMITED ON USERS;
--
GRANT EXECUTE ON DBMS_AQADM TO oaihub902;
GRANT AQ_ADMINISTRATOR_ROLE TO oaihub902;
--
CREATE VIEW lcoview as
SELECT
	lco.*,
	lcogroup.name groupname
FROM lco, lcogroup
WHERE lco.groupid = lcogroup.id;
--
CREATE VIEW eventview as
SELECT
	event.*,
	eventgroup.name eventgroupname
FROM event, eventgroup
WHERE event.eventgroupid=eventgroup.id;
--
CREATE VIEW eventlcoview as
SELECT
	groupname,
	lcoview.name lconame,
	lcoview.version lcoversion,eventlco.*
FROM eventlco, lcoview
WHERE eventlco.lcoid=lcoview.id;
--
CREATE VIEW emdview as
SELECT
	at.name atname,
	eventgroup.name eventgroupname,
	event.name eventname,
	event.version eventversion,
	role,
	emd.version,
	emd.id,
	emd.visible,
	emd.type,
	emd.owner
FROM emd, event, eventgroup, at
WHERE atid=at.id
AND eventid=event.id
AND event.eventgroupid=eventgroup.id;
--
CREATE VIEW dsoview as
SELECT dso.*, at.name groupname
FROM dso, at
WHERE dso.groupid=at.id;
--
truncate table oaihub902.MESSAGESTATUSTABLE;
create synonym messagestatustable for oaihub902.messagestatustable;
create synonym APPIDTABLE for oaihub902.APPIDTABLE;
create synonym MESSAGEINFOIDTABLE for oaihub902.MESSAGEINFOIDTABLE;
--
CREATE TABLE SEQUENCE_VALUES(
	NAME VARCHAR2(30),
	VALUE NUMBER
);
--
INSERT INTO SEQUENCE_VALUES VALUES ('ATIDSEQ', ATIDSEQ.NEXTVAL);
INSERT INTO SEQUENCE_VALUES VALUES ('LCOGROUPIDSEQ', LCOGROUPIDSEQ.NEXTVAL);
INSERT INTO SEQUENCE_VALUES VALUES ('LCOIDSEQ', LCOIDSEQ.NEXTVAL);
INSERT INTO SEQUENCE_VALUES VALUES ('EVENTGROUPIDSEQ', EVENTGROUPIDSEQ.NEXTVAL);
--
INSERT INTO SEQUENCE_VALUES VALUES ('EVENTIDSEQ', EVENTIDSEQ.NEXTVAL);
INSERT INTO SEQUENCE_VALUES VALUES ('EMDIDSEQ', EMDIDSEQ.NEXTVAL);
INSERT INTO SEQUENCE_VALUES VALUES ('DSOIDSEQ', DSOIDSEQ.NEXTVAL);
INSERT INTO SEQUENCE_VALUES VALUES ('BFIDSEQ', BFIDSEQ.NEXTVAL);
INSERT INTO SEQUENCE_VALUES VALUES ('BPIDSEQ', BPIDSEQ.NEXTVAL);

INSERT INTO SEQUENCE_VALUES VALUES ('LOOKUPSEQ', 1);
INSERT INTO SEQUENCE_VALUES VALUES ('COMPONENTINFOESEQ', 1);
INSERT INTO SEQUENCE_VALUES VALUES ('APPIDSEQ', 1);
INSERT INTO SEQUENCE_VALUES VALUES ('REPOIDSEQ', 1);
INSERT INTO SEQUENCE_VALUES VALUES ('MESSAGEINFOIDSEQ', 1);
INSERT INTO SEQUENCE_VALUES VALUES ('ERRORIDS', 1);
--
DROP TABLE SEQUENCE_VALUES;
--
create synonym messagestatustable for ichub.messagestatustable;
create synonym APPIDTABLE for ichub.APPIDTABLE;
create synonym MESSAGEINFOIDTABLE for ichub.MESSAGEINFOIDTABLE;
--
CREATE TABLE lookupid (
	id NUMBER(10) NOT NULL CONSTRAINT pk_lookup_id PRIMARY KEY,
	NAME VARCHAR2(256) NOT NULL CONSTRAINT uni_lookup_name UNIQUE
);
--
CREATE TABLE lookup (
	tableid NUMBER(10) NOT NULL CONSTRAINT fk_lookup_tableid REFERENCES
	lookupid(id)
	ON DELETE CASCADE,
	KEY VARCHAR2(256) NOT NULL,
	value VARCHAR2(256),
	CONSTRAINT pk_lookup PRIMARY KEY (tableid, KEY)
);
--
CREATE TABLE componentinfo (
	NAME VARCHAR2(256) NOT NULL,
	type VARCHAR2(256) NOT NULL,
	host VARCHAR2(256) NOT NULL,
	KEY VARCHAR2(256) NOT NULL,
	seqnum NUMBER CONSTRAINT pk_componentinfo PRIMARY KEY
);
--
CREATE TABLE componentinfovalue (
	seqnum NUMBER CONSTRAINT fk_seqnum REFERENCES componentinfo(seqnum) ON
	DELETE CASCADE,
	value VARCHAR2(512)
);
--
CREATE TABLE appidtable (
	appid NUMBER CONSTRAINT pk_appidtable PRIMARY KEY,
	appname VARCHAR2(256) NOT NULL,
	partition VARCHAR2(256),
	instancenum VARCHAR2(4),
	hostname VARCHAR2(256) NOT NULL
);
--
CREATE TABLE repoidtable (
	repoid NUMBER CONSTRAINT pk_repoidtable PRIMARY KEY,
	reponame VARCHAR2(256) NOT NULL,
	hostname VARCHAR2(256) NOT NULL
);
--
CREATE TABLE messageinfoidtable (
	messageinfoid NUMBER CONSTRAINT pk_messageinfoidtable PRIMARY KEY,
	appname VARCHAR2(256) NOT NULL,
	bo VARCHAR2(256) NOT NULL,
	eventname VARCHAR2(256) NOT NULL,
	eventversion VARCHAR2(16) NOT NULL,
	msgversion VARCHAR2(16) NOT NULL,
	role VARCHAR2(16) NOT NULL
);
--
CREATE TABLE msg_correlation (
	messageinfoid NUMBER,
	correlation_fields VARCHAR2(4000),
	tracking_id VARCHAR2(4000),
	saved_info LONG RAW,
	creation_date DATE DEFAULT sysdate
);
--
CREATE TABLE messagestatustable (
	senderapp NUMBER,
	recipientapp NUMBER,
	processingapp NUMBER,
	messageinfoid NUMBER,
	trackingid VARCHAR2(100),
	msgstatus NUMBER,
	timestamp DATE DEFAULT sysdate,
	result VARCHAR2(1000)
);
--
CREATE TABLE oai_agent_error (
	errorid NUMBER CONSTRAINT pk_oai_agent_error PRIMARY KEY,
	isoutbound NUMBER,
	senderappid NUMBER NOT NULL,
	recipientappid NUMBER,
	messageinfoid NUMBER NOT NULL,
	logcomponentid VARCHAR2(64) NOT NULL,
	timestamp DATE NOT NULL,
	application VARCHAR2(64) NOT NULL,
	host VARCHAR2(64) NOT NULL,
	severity NUMBER NOT NULL,
	internalid VARCHAR2(128) NOT NULL,
	description VARCHAR2(4000),
	srcmessage BLOB,
	dstmessage BLOB,
	stacktrace BLOB
);
--
CREATE SEQUENCE atIDSeq;
CREATE SEQUENCE lcogroupIDSeq;
CREATE SEQUENCE lcoIDSeq;
CREATE SEQUENCE eventgroupIDSeq;
CREATE SEQUENCE eventIDSeq;
CREATE SEQUENCE emdidseq;
CREATE SEQUENCE dsoIDSeq;
CREATE SEQUENCE bfIdSeq;
CREATE SEQUENCE bpIdSeq;
CREATE SEQUENCE lookupSeq;
CREATE SEQUENCE ComponentInfoEseq;
CREATE SEQUENCE AppIDSeq;
CREATE SEQUENCE RepoIDSeq;
CREATE SEQUENCE MessageInfoIDSeq;
CREATE SEQUENCE ErrorIDs;
--
CREATE TABLE at (
	id NUMBER(10) CONSTRAINT pk_at_id PRIMARY KEY CONSTRAINT nn_at_id NOT NULL,
	name VARCHAR2(256) CONSTRAINT uni_at_name UNIQUE CONSTRAINT nn_at_name NOT NULL,
	type NUMBER(10) CONSTRAINT nn_at_type NOT NULL
);
--
CREATE TABLE lcogroup (
	id NUMBER(10) CONSTRAINT pk_lcogroup_id PRIMARY KEY CONSTRAINT nn_lcogroup_id NOT NULL,
	name VARCHAR2(256) CONSTRAINT uni_lcogroup_name UNIQUE CONSTRAINT nn_lcogroup_name NOT NULL
);
--
CREATE TABLE lco (
	id NUMBER(10) CONSTRAINT pk_lco_id PRIMARY KEY CONSTRAINT nn_lco_id NOT NULL,
	groupid NUMBER(10) CONSTRAINT fk_lco_group REFERENCES lcogroup(id) ON DELETE CASCADE CONSTRAINT nn_lco_group NOT NULL,
	name VARCHAR2(600) CONSTRAINT nn_lco_name NOT NULL,
	version VARCHAR2(40) CONSTRAINT nn_lco_version NOT NULL,
	usecount NUMBER(10) CONSTRAINT nn_lco_uc NOT NULL,
	owner VARCHAR2(40) CONSTRAINT nn_lco_owner NOT NULL,
	CONSTRAINT uni_lco UNIQUE(groupid,name,version)
);
--
SELECT
	mif.eventname,
	aso.appname origen,
	asd.appname destino,
	MIN ((fin.TIMESTAMP - ini.TIMESTAMP) * 86400) duracion_min,
	MAX ((fin.TIMESTAMP - ini.TIMESTAMP) * 86400) duracion_max,
	ROUND (AVG ((fin.TIMESTAMP - ini.TIMESTAMP) * 86400), 2) duracion_prom,
	COUNT (*) mensajes_procesados
FROM
	messagestatustable ini,
	messagestatustable fin,
	messageinfoidtable mif,
	appidtable aso,
	appidtable apo,
	appidtable asd,
	appidtable apd
WHERE aso.appname = 'GESTORAQ'
AND apo.appname = 'GESTORAQ'
AND asd.appname = 'AS400GN'
AND apd.appname = 'GESTORAQ'
AND ini.msgstatus = 1
AND mif.messageinfoid = ini.messageinfoid
AND ini.trackingid = fin.trackingid
AND fin.msgstatus = 8
AND ini.TIMESTAMP >= TO_DATE ('28052007 00:00:00', 'ddmmyyyy hh24:mi:ss')
AND ini.TIMESTAMP <= TO_DATE ('28052007 23:59:59', 'ddmmyyyy hh24:mi:ss')
AND ini.senderapp = aso.appid
AND ini.processingapp = apo.appid
AND fin.senderapp = asd.appid
AND fin.processingapp = apd.appid
GROUP BY mif.eventname, aso.appname, asd.appname
--
SELECT
	mif.eventname, aso.appname origen, asd.appname destino,
	ini.trackingid, ini.processingapp, ini.TIMESTAMP inicio,
	fin.TIMESTAMP fin,
	(EXTRACT (DAY FROM (fin.TIMESTAMP - ini.TIMESTAMP))
		* 24 * 60 * 60
	)
	+
	(EXTRACT (HOUR FROM (fin.TIMESTAMP - ini.TIMESTAMP))
		* 60 * 60
	)
	+
	(EXTRACT (MINUTE FROM (fin.TIMESTAMP - ini.TIMESTAMP))
		* 60
	)
	+ EXTRACT (SECOND FROM (fin.TIMESTAMP - ini.TIMESTAMP))
	duracion_seg
FROM
	messagestatustable ini,
	messagestatustable fin,
	messageinfoidtable mif,
	appidtable aso,
	appidtable apo,
	appidtable asd,
	appidtable apd
WHERE aso.appname = 'AS400GN'
AND apo.appname = 'AS400GN'
AND asd.appname = 'GESTORAQ'
AND apd.appname = 'AS400GN'
AND ini.msgstatus = 1
AND mif.messageinfoid = ini.messageinfoid
AND ini.trackingid = fin.trackingid
AND fin.msgstatus = 8
AND ini.TIMESTAMP >= TO_DATE ('08062007 00:00:00', 'ddmmyyyy hh24:mi:ss')
AND ini.TIMESTAMP <= TO_DATE ('08062007 23:59:59', 'ddmmyyyy hh24:mi:ss')
AND ini.senderapp = aso.appid
AND ini.processingapp = apo.appid
AND fin.senderapp = asd.appid
AND fin.processingapp = apd.appid
ORDER BY ini.TIMESTAMP
--
SELECT
	mif.eventname, aso.appname origen, asd.appname destino,
	ini.trackingid, ini.processingapp, ini.TIMESTAMP inicio,
	fin.TIMESTAMP fin,
	(fin.TIMESTAMP - ini.TIMESTAMP) * 86400 duracion_seg
FROM
	messagestatustable ini,
	messagestatustable fin,
	messageinfoidtable mif,
	appidtable aso,
	appidtable apo,
	appidtable asd,
	appidtable apd
WHERE aso.appname = 'AS400GN'
AND apo.appname = 'AS400GN'
AND asd.appname = 'GESTORAQ'
AND apd.appname = 'AS400GN'
AND ini.msgstatus = 1
AND mif.messageinfoid = ini.messageinfoid
AND ini.trackingid = fin.trackingid
AND fin.msgstatus = 8
AND ini.TIMESTAMP >= TO_DATE ('30042007 00:00:00', 'ddmmyyyy hh24:mi:ss')
AND ini.TIMESTAMP <= TO_DATE ('30042007 23:59:59', 'ddmmyyyy hh24:mi:ss')
AND ini.senderapp = aso.appid
AND ini.processingapp = apo.appid
AND fin.senderapp = asd.appid
AND fin.processingapp = apd.appid
ORDER BY ini.TIMESTAMP
--