-- Mata sesiones inactivas
DECLARE
	CURSOR curSession
	IS
	SELECT
		osuser, 
		username,
		machine,
		program,
		SID,
		SERIAL# Serial,
		STATUS  
	FROM v$session 
	WHERE PROGRAM='JDBC Thin Client'
	AND username='BD_DEMO'
	AND status = 'INACTIVE'
	ORDER BY osuser;

	SQLD VARCHAR2(100);
BEGIN
	FOR I IN curSession
	LOOP
		SQLD := 'ALTER SYSTEM KILL SESSION '||''''||I.SID||','||I.SERIAL||'''';
		EXECUTE IMMEDIATE SQLD;
		--DBMS_OUTPUT.PUT_LINE(SQLD);
	END LOOP;
END;