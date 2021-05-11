-- Compila objectos BD
DECLARE
	CURSOR curObjects
	IS
	SELECT
		owner,
		object_name,
		object_type 
	FROM dba_objects
	WHERE status ='INVALID'
	AND owner = 'BD_DEMO';
	
	SQLD VARCHAR2(1000);
BEGIN
	FOR I IN curObjects
	LOOP
		BEGIN
			IF(I.object_type = 'PACKAGE') THEN
				SQLD:= 'ALTER '||I.object_type||' "'||I.owner||'"."'||I.object_name||'" COMPILE';
			ELSIF (I.object_type = 'PACKAGE BODY') THEN
				SQLD:= 'ALTER PACKAGE'||' "'||I.owner||'"."'||I.object_name||'" COMPILE BODY';
			ELSIF (I.object_type = 'JAVA SOURCE') THEN
				SQLD:= 'ALTER '||I.object_type||' "'||I.owner||'"."'||I.object_name||'" COMPILE';
			ELSIF (I.object_type = 'JAVA CLASS') THEN
				SQLD:= 'ALTER '||I.object_type||' "'||I.owner||'"."'||TO_CHAR(I.object_name)||'" RESOLVE';
			ELSE
				SQLD:= I.object_type;
			END IF;
			
			EXECUTE IMMEDIATE SQLD;
		EXCEPTION
			WHEN OTHERS THEN 
				NULL;
				DBMS_OUTPUT.PUT_LINE(SQLD);
		END;
	END LOOP;
END;