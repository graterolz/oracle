SELECT
	username
FROM dba_users
WHERE account_status ='LOCKED';
--
SELECT
	owner,
	trigger_name
FROM dba_triggers
WHERE status ='DISABLED';
--
SELECT
	owner,
	table_name,
	constraint_name
FROM dba_constraints
WHERE status ='DISABLED';
--
ALTER TABLE OPENCARD.KE_USERS_ACTIONS ENABLE NOVALIDATE CONSTRAINT USE_ACC_USER_FK;
ALTER TABLE OPENCARD.KE_HISTORIC_CLIENTS_CONSULT enable NOVALIDATE constraint KE_HISTORIC_CLIENTS_CONSU_FK1;