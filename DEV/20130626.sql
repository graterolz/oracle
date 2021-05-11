BEGIN
	UPDATE CERT_VEH SET CodPlanExceso = '000';
END;
--
DECLARE
	CURSOR EXCESO
	IS
	SELECT CER_VEH_MIG.*,(
		SELECT EXCESO FROM EQ_EXCESO@LINKMIGRA EQ
		WHERE TO_NUMBER (EQ.TipoVehAs) = TO_NUMBER (CER_VEH_MIG.ClaRcv)
		AND TO_NUMBER (EQ.SumAse) = TO_NUMBER (CER_VEH_MIG.SumExce)
	) EXCE
	FROM (
		WITH VEH AS (
			SELECT IdePol, NumCert FROM CERT_VEH
			WHERE EXISTS(
				SELECT 1 FROM POLIZA
				WHERE IndMigra IS NOT NULL)
			),
		EQ AS (
			SELECT 	EQ_COB.IdePol, Ramo, Poliza, NumCert, IndTipo,
					DECODE (CodCob, 3357, 'EXCE', 8649, 'EXCE') TipoPlan,
					DECODE (IndTipo, 1, MAX (SumAse), 2, MAX (MonCob)) SumExce
			FROM EQ_COBERTURAS_IND@LINKMIGRA EQ_COB, VEH
			WHERE EQ_COB.IdePol = VEH.IdePol
			AND EQ_COB.NumCer = VEH.NumCert
			AND CodCob IN (3357, 8649)
			GROUP BY EQ_COB.IdePol, Ramo, Poliza, NumCert, IndTipo, CodCob
		),
		CER_COL AS (
			SELECT DISTINCT EQ.IdePol, EQ.Ramo, EQ.Poliza, EQ.NumCert, ClaRcv, EQ.SumExce
			FROM EQ_CLPF07@LINKMIGRA CER, EQ
			WHERE IndTipo = 2
			AND CER.Ramo = EQ.Ramo
			AND CER.Poliza = EQ.Poliza
			AND CerVeh = NumCert
		),
		CER_IND AS (
			SELECT DISTINCT EQ.IdePol, EQ.Ramo, EQ.Poliza, EQ.NumCert, ClaRcv, EQ.SumExce
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
	FOR C IN EXCESO
	LOOP
		BEGIN
			UPDATE CERT_VEH
			SET CodPlanExceso = C.Exce
			WHERE IdePol = C.IdePol AND NumCert = C.NumCert;
		EXCEPTION WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE (
				'Error cambiando el Plan APOV: ' ||  C.IdePol || ' ' || C.NumCert || ' ' || SQLERRM
			);
		END;
	END LOOP;
END;