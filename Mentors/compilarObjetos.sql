-- Compilar objetos inválidos 

SELECT 'Alter '||decode(object_type,'PACKAGE BODY','PACKAGE',object_type)||' '||owner||'.'||object_name||'  compile;'
	FROM dba_objects 
	WHERE status ='INVALID'
	AND owner = 'OPENCARD';

-- Compilar Schema completo

EXEC UTL_RECOMP.RECOMP_SERIAL (schema => 'OPENCARD'); 

EXEC SYS.DBMS_UTILITY.COMPILE_SCHEMA(schema => 'OPENCARD');
 
Exec dbms_ddl.alter_compile ( 'PACKAGE' , 'OPENCARD', 'CO_KM_AUTHORIZATIONS');
Exec dbms_ddl.alter_compile ( 'PACKAGE BODY' , 'OPENCARD', 'CO_KM_AUTHORIZATIONS');
 
Exec dbms_ddl.alter_compile ( 'PACKAGE' , 'OPENCARD', 'CO_KM_AUTHORIZER');
Exec dbms_ddl.alter_compile ( 'PACKAGE BODY' , 'OPENCARD', 'CO_KM_AUTHORIZER');