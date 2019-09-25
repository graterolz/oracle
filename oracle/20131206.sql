DECLARE
	v_cnt INTEGER;
	v_sql VARCHAR2 (2000);
BEGIN
	FOR v_i IN (SELECT DISTINCT table_name FROM user_tab_columns WHERE column_name = 'NUMPOL')
	LOOP
		BEGIN
			v_sql := 'SELECT COUNT(*) FROM ' || v_i.table_name || ' WHERE NUMPOL = 10257361';
			EXECUTE IMMEDIATE v_sql INTO v_cnt;

			IF v_cnt > 0 THEN
				DBMS_OUTPUT.put_line (v_i.table_name || ': ' || v_cnt);
			END IF;
		EXCEPTION WHEN OTHERS THEN
			NULL;
		END;
	END LOOP;
END;
--
SELECT * FROM HJPF08_GC WHERE POLIZA = 10257361;