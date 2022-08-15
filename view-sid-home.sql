SET serveroutput ON;
DECLARE
	OHM varchar2(100);
	OHS varchar2(100);
BEGIN
	DBMS_system.get_env('ORACLE_HOME', OHM);
	DBMS_system.get_env('ORACLE_SID', OHS);
	DBMS_OUTPUT.PUT_LINE(OHM);
	DBMS_OUTPUT.PUT_LINE(OHS);
END;