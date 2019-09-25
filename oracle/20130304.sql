DECLARE
	CURSOR CUR_AUTO
	IS
	SELECT DISTINCT POLIZA, NUMREC
	FROM SINIESTROS_MIGRA_REN
	WHERE APTO = 'S'
	AND SUBSTR (PM.BUSCA_PRODUCTO_PLAN (RAMO, POLIZA, NUMCERT),1,4) = 'AUTI';
BEGIN
	DELETE FROM SINIESTROS_RECIBO_MULTIRAMO;
	COMMIT;

	FOR I IN CUR_AUTO
	LOOP
		FOR J IN (
			SELECT * FROM (
				SELECT 32 RAMO FROM DUAL UNION
				SELECT 33 RAMO FROM DUAL UNION
				SELECT 34 RAMO FROM DUAL UNION
				SELECT 35 RAMO FROM DUAL
			)
		)
		LOOP
			INSERT INTO SINIESTROS_RECIBO_MULTIRAMO VALUES (J.RAMO, I.POLIZA, I.NUMREC);
		END LOOP;
		COMMIT;
	END LOOP;
END;