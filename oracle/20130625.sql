DECLARE
	CURSOR TIPOVEH
	IS
	SELECT DISTINCT IdePol, NumCert, ClaRcv,
		(SELECT TipoVeh FROM EQ_AUTO@LINKMIGRA EQ 
			WHERE TO_NUMBER (EQ.TipoVehAs) = TO_NUMBER (CER_VEH_MIG.ClaRcv)) TipoVeh,
		(SELECT ClaseVeh FROM EQ_AUTO@LINKMIGRA EQ 
			WHERE TO_NUMBER (EQ.TipoVehAs) = TO_NUMBER (CER_VEH_MIG.ClaRcv)) ClaseVeh
	FROM (
		WITH VEH AS (
			SELECT IdePol, NumCert FROM CERT_VEH
			WHERE EXISTS(
				SELECT 1 FROM POLIZA WHERE IndMigra IS NOT NULL
			)
		),
		EQ AS (
			SELECT DISTINCT EQ_COB.IdePol, Ramo, Poliza, NumCert, IndTipo
			FROM EQ_COBERTURAS_IND@LINKMIGRA EQ_COB, VEH
			WHERE EQ_COB.IdePol = VEH.IdePol
			AND EQ_COB.NumCer = VEH.NumCert
		),
		CER_COL AS (
			SELECT EQ.IdePol, EQ.NumCert, CER.ClaRcv
			FROM EQ_CLPF07@LINKMIGRA CER, EQ
			WHERE IndTipo = 2
			AND CER.Ramo = EQ.Ramo
			AND CER.Poliza = EQ.Poliza
			AND CerVeh = NumCert
		),
		CER_IND AS (
			SELECT EQ.IdePol, EQ.NumCert, CER.ClaRcv
			FROM HJPF03@LINKMIGRA CER, EQ
			WHERE IndTipo = 1
			AND CER.Ramo = EQ.Ramo
			AND CER.Poliza = EQ.Poliza
		)
		SELECT * FROM CER_COL
		UNION ALL
		SELECT * FROM CER_IND
	) CER_VEH_MIG
	ORDER BY IdePol, NumCert;
BEGIN
	FOR C IN TIPOVEH
	LOOP
		BEGIN
			UPDATE CERT_VEH
			SET TipoVeh = C.TipoVeh, ClaseVeh = C.ClaseVeh
			WHERE IdePol = C.IdePol 
			AND NumCert = C.NumCert;
		EXCEPTION WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE ('Error Actualizando: ' || C.IdePol || ' ' || C.NumCert);
		END;
	END LOOP;
END;