BEGIN
	UPDATE CERT_VEH
	SET CodPlanApov = '000';
END;
--
DECLARE
	CURSOR APOV
	IS
	SELECT CER_VEH_MIG.*, NVL ((
		SELECT APOV FROM EQ_APOV@LINKMIGRA EQ
		WHERE TO_NUMBER (EQ.TipoVehAs) = TO_NUMBER (CER_VEH_MIG.ClaRcv)
		AND TO_NUMBER (EQ.SumAse) = TO_NUMBER (CER_VEH_MIG.SumApov)
	),'000') APOV
	FROM (
		WITH 
		VEH AS (
			SELECT IdePol, NumCert FROM CERT_VEH
			WHERE EXISTS (
				SELECT 1 FROM POLIZA
				WHERE IndMigra IS NOT NULL
			)
		),
		EQ AS (
			SELECT EQ_COB.IdePol, Ramo, Poliza, NumCert, IndTipo,
					DECODE (CodCob, 3561, 'APOV', 8860, 'APOV') TipoPlan,
					DECODE (IndTipo, 1, MAX (SumAse), 2, MAX (MonCob)) SumApov
			FROM EQ_COBERTURAS_IND@LINKMIGRA EQ_COB, VEH
			WHERE EQ_COB.IdePol = VEH.IdePol
			AND EQ_COB.NumCer = VEH.NumCert
			AND CodCob IN (3561, 8860)
			GROUP BY EQ_COB.IdePol, Ramo, Poliza, NumCert, IndTipo, CodCob
		),
		CER_COL AS (
			SELECT DISTINCT EQ.IdePol, EQ.Ramo, EQ.Poliza, EQ.NumCert,ClaRcv, EQ.SumApov 
			FROM EQ_CLPF07@LINKMIGRA CER, EQ
			WHERE IndTipo = 2
			AND CER.Ramo = EQ.Ramo
			AND CER.Poliza = EQ.Poliza
			AND CerVeh = NumCert
		),
		CER_IND AS (
			SELECT DISTINCT EQ.IdePol, EQ.Ramo, EQ.Poliza, EQ.NumCert, ClaRcv, EQ.SumApov
			FROM HJPF03@LINKMIGRA CER, EQ
			WHERE IndTipo = 1
			AND CER.Ramo = EQ.Ramo
			AND CER.Poliza = EQ.Poliza
		)
		SELECT * FROM CER_COL
		UNION ALL
		SELECT * FROM CER_IND
	) CER_VEH_MIG
	ORDER BY Ramo, Poliza, NumCert;	
BEGIN
	FOR C IN APOV
	LOOP
		BEGIN
			UPDATE CERT_VEH
			SET CodPlanApov = C.APOV
			WHERE IdePol = C.IdePol AND NumCert = C.NumCert;
		EXCEPTION WHEN OTHERS THEN
			DBMS_OUTPUT. PUT_LINE (
				'Error cambiando el Plan APOV: ' ||
				C.IdePol ||
				' ' ||
				C.NumCert ||
				' ' ||
				SQLERRM
			);
		END;
	END LOOP;
END;