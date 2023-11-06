-- Crear una secuencia
CREATE SEQUENCE OPENCARD.IN_S_DAF_TEST_FILE_SEQ START WITH 2;

-- Chequear numero de secuencias.
SELECT last_number FROM all_sequences WHERE equence_name = 'IN_S_OUTCLEAR_SEQ';

-- Incrementar una secuencia a un nro deseado
ALTER SEQUENCE OPENCARD.KE_S_HISTORICAL_BLOCKADES INCREMENT BY 9;
SELECT OPENCARD.KE_S_HISTORICAL_BLOCKADES.NEXTVAL FROM dual;
ALTER SEQUENCE OPENCARD.KE_S_HISTORICAL_BLOCKADES  INCREMENT BY 1;

-- Procedimiento para cambiarlas
CREATE OR REPLACE PROCEDURE SYS.SEQUENCE_NEWVALUE( seqowner VARCHAR2, seqname ARCHAR2, newvalue NUMBER) AS ln NUMBER; ib NUMBER;
BEGIN
	SELECT last_number, increment_by
	INTO ln, ib FROM dba_sequences
	WHERE sequence_owner = upper(seqowner) AND sequence_name = upper(seqname);
	EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || seqowner || '.' || seqname ||
	' INCREMENT BY ' || (newvalue - ln);
	EXECUTE IMMEDIATE 'SELECT ' || seqowner || '.' || seqname ||
	'.NEXTVAL FROM DUAL' INTO ln;
	EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || seqowner || '.' || seqname 
	|| ' INCREMENT BY ' || ib;
END;
 
GRANT EXECUTE ON sequence_newvalue TO gokhan;
 
EXEC sequence_newvalue( 'GOKHAN', 'SAMPLE_SEQ', 10000 );