DELETE eq_siniestro;
COMMIT;
--
DELETE log_siniestro_mig;
COMMIT;
--
DELETE ERR_MIG_SINIESTRO WHERE TIPOERROR = 'ERR-SIN-CARGA-BASE';
COMMIT;
--
DROP TABLE MIGRA.ERR_MIG_SINIESTRO CASCADE CONSTRAINTS;
CREATE TABLE MIGRA.ERR_MIG_SINIESTRO (
   IDEERROR       NUMBER (14),
   TIPOERROR      VARCHAR2 (20 BYTE),
   CODERROR       VARCHAR2 (3 BYTE),
   NOMPROCESO     VARCHAR2 (100 BYTE),
   NOMTABLA       VARCHAR2 (60 BYTE),
   FECOCURRENCIA  DATE,
   RAMO           NUMBER (2),
   POLIZA         NUMBER (8),
   SERIE          NUMBER (4),
   RECLAC         CHAR (1 BYTE),
   RECLAM         CHAR (6 BYTE),
   OBSERVACIONES  VARCHAR2 (500 BYTE),
   DIASIN         NUMBER (2),
   MESSIN         NUMBER (2),
   A�OSIN         NUMBER (4),
   DIANOT         NUMBER (2),
   MESNOT         NUMBER (2),
   A�ONOT         NUMBER (4),
   DIACON         NUMBER (2),
   MESCON         NUMBER (2),
   A�OCON         NUMBER (4),
   ZONA           NUMBER (4),
   CERTIF         VARCHAR2 (10),
   CCLI1          VARCHAR2 (1),
   CCLI2          NUMBER (10),
   CODAJU         NUMBER (5),
   TIPMON         VARCHAR2 (2)
);
--
DROP SEQUENCE MIGRA.SQ_ERR_MIG_SINIESTRO;
CREATE SEQUENCE MIGRA.SQ_ERR_MIG_SINIESTRO
   START WITH 1
   MAXVALUE 9999999
   MINVALUE 0
   NOCYCLE
   CACHE 20
   NOORDER;
--
SELECT 'EQ_HJPF01', COUNT (*) FROM EQ_HJPF01
WHERE TRIM (TIPOID) IS NULL
OR TRIM (NUMID) IS NULL
OR TRIM (DVID) IS NULL
OR TRIM (CODCLI) IS NULL
OR TRIM (INDNACIONAL) IS NULL
UNION ALL
SELECT 'EQ_HJPF205', COUNT (*) FROM EQ_HJPF205
WHERE TRIM (TIPOID) IS NULL
OR TRIM (NUMID) IS NULL
OR TRIM (DVID) IS NULL
OR TRIM (CODCLI) IS NULL
OR TRIM (INDNACIONAL) IS NULL
UNION ALL
SELECT 'EQ_FNPF01', COUNT (*) FROM EQ_FNPF01
WHERE TRIM (TIPOID) IS NULL
OR TRIM (NUMID) IS NULL
OR TRIM (DVID) IS NULL
OR TRIM (CODCLI) IS NULL
OR TRIM (INDNACIONAL) IS NULL
UNION ALL
SELECT 'EQ_ORDENE', COUNT (*) FROM EQ_ORDENE
WHERE TRIM (TIPOID) IS NULL
OR TRIM (NUMID) IS NULL
OR TRIM (DVID) IS NULL
OR TRIM (CODCLI) IS NULL
OR TRIM (INDNACIONAL) IS NULL
UNION ALL
SELECT 'EQ_ORPF06', COUNT (*) FROM EQ_ORPF06
WHERE TRIM (TIPOID) IS NULL
OR TRIM (NUMID) IS NULL
OR TRIM (DVID) IS NULL
OR TRIM (CODCLI) IS NULL
OR TRIM (INDNACIONAL) IS NULL
UNION ALL
SELECT 'EQ_CLPF07', COUNT (*) FROM EQ_CLPF07
WHERE TRIM (TIPOID) IS NULL
OR TRIM (NUMID) IS NULL
OR TRIM (DVID) IS NULL
OR TRIM (CODCLI) IS NULL
OR TRIM (INDNACIONAL) IS NULL
UNION ALL
SELECT 'EQ_HJPF06', COUNT (*) FROM EQ_HJPF06
WHERE TRIM (TIPOID) IS NULL
OR TRIM (NUMID) IS NULL
OR TRIM (DVID) IS NULL
OR TRIM (CODCLI) IS NULL
OR TRIM (INDNACIONAL) IS NULL
UNION ALL
SELECT 'EQ_HJPF71', COUNT (*) FROM EQ_HJPF71
WHERE TRIM (TIPOID) IS NULL
OR TRIM (NUMID) IS NULL
OR TRIM (DVID) IS NULL
OR TRIM (CODCLI) IS NULL
OR TRIM (INDNACIONAL) IS NULL
UNION ALL
SELECT 'EQ_CLPF05_FAM', COUNT (*) FROM EQ_CLPF05_FAM
WHERE TRIM (TIPOID) IS NULL
OR TRIM (NUMID) IS NULL
OR TRIM (DVID) IS NULL
OR TRIM (CODCLI) IS NULL
OR TRIM (INDNACIONAL) IS NULL
--
DECLARE
	CURSOR CUR_EQ_CLIENTE (
		P_TIPOID    acsel.EQ_CLIENTE.TIPOID@cert%TYPE,
		P_NUMID     acsel.EQ_CLIENTE.NUMID@cert%TYPE,
		P_DVID      acsel.EQ_CLIENTE.DVID@cert%TYPE
	)
	IS
	SELECT * FROM acsel.EQ_CLIENTE@cert
	WHERE TIPOIDas = P_TIPOID
	AND NUMIDas = P_NUMID
	AND DVIDas = P_DVID;

	CURSOR CUR_EQ_HJPF71
	IS
	SELECT * FROM EQ_HJPF71;

	CURSOR CUR_EQ_CLPF05_FAM
	IS
	SELECT * FROM EQ_HJPF71;
BEGIN
	FOR I IN CUR_EQ_HJPF71
	LOOP
		OPEN CUR_EQ_CLIENTE (I.TIPOID, I.NUMID, I.DVID);
		FETCH CUR_EQ_CLIENTE INTO RT_CUR_EQ_CLIENTE;
		CLOSE CUR_EQ_CLIENTE;
	END LOOP;

	FOR I IN CUR_EQ_CLPF05_FAM
	LOOP
		OPEN CUR_EQ_CLIENTE (I.TIPOID, I.NUMID, I.DVID);
		FETCH CUR_EQ_CLIENTE INTO RT_CUR_EQ_CLIENTE;
		CLOSE CUR_EQ_CLIENTE;
	END LOOP;
END;
--
DECLARE
	CURSOR CUR_CLPF05_NUMID
	IS
	SELECT TIPOID, NUMID, COFAAM FROM EQ_CLPF05_FAM
	WHERE RAMO IN (24, 02)
	AND TIPOID = 'M'
	GROUP BY TIPOID, NUMID, COFAAM
	ORDER BY TIPOID, NUMID;
	--
	CURSOR CUR_CLPF05
	IS
	SELECT
		TIPOPR, RAMO, POLIZA, NUMCER, COFAAM, COLASE, NACION, CEDCOL, DIANAC,
		MESNAC, ANONAC, EDAACT, EDOCOL, DIAING, MESING, ANOING, CODPLA, SUELDO,
		TELASE, CLACOL, PRICAP, PRIPRO, DIARET, MESRET, ANORET, ACTRET, CLASCO,
		CODCOM, SEXBEN, ZURDO, PROF, FECMOD, FECSOL, ZONEFT, TIPRIE, MATERN,
		FTORCG, CORRE, STSPRE, STSPLA, CODPAR, INDEXC
	FROM CLPF05
	GROUP BY
		TIPOPR, RAMO, POLIZA, NUMCER, COFAAM, COLASE, NACION, CEDCOL, DIANAC,
		MESNAC, ANONAC, EDAACT, EDOCOL, DIAING, MESING, ANOING, CODPLA, SUELDO,
		TELASE, CLACOL, PRICAP, PRIPRO, DIARET, MESRET, ANORET, ACTRET, CLASCO,
		CODCOM, SEXBEN, ZURDO, PROF, FECMOD, FECSOL, ZONEFT, TIPRIE, MATERN, FTORCG,
		CORRE, STSPRE, STSPLA, CODPAR, INDEXC;
	--
	CURSOR CUR_MENORES_1
	IS
	SELECT RAMO, POLIZA, NUMCER, COFAAM FROM EQ_CLPF05_FAM
	WHERE CEDCOL < 999
	AND NUMID IS NULL
	GROUP BY RAMO, POLIZA, NUMCER, COFAAM
	ORDER BY RAMO, POLIZA, NUMCER, COFAAM;
	--
	CURSOR CUR_MENORES_2
	IS
	SELECT ROWID, CEDCOL FROM EQ_CLPF05_FAM
	WHERE CEDCOL >= 100000000
	AND NUMID IS NULL;
	--
	CURSOR CUR_MENORES_3
	IS
	SELECT ROWID, CEDCOL FROM EQ_CLPF05_FAM
	WHERE CEDCOL >= 999
	AND CEDCOL < 80000000
	AND TRIM (NACION) IS NULL
	AND NUMID IS NULL;
	--
	CURSOR CUR_MENORES_4
	IS
	SELECT ROWID, CEDCOL FROM EQ_CLPF05_FAM
	WHERE CEDCOL >= 80000000
	AND TRIM (NACION) IS NULL
	AND NUMID IS NULL;
	--
	P_NUMERO	NUMBER := 1;
	P_NUMID_AN	EQ_CLPF05_FAM.NUMID%TYPE := 0;
	P_NUMID_AC	EQ_CLPF05_FAM.NUMID%TYPE;
	P_DVID		EQ_CLPF05_FAM.DVID%TYPE;
BEGIN
	EXECUTE IMMEDIATE 'TRUNCATE TABLE EQ_CLPF05_FAM';

	FOR I IN CUR_CLPF05
	LOOP
		INSERT INTO EQ_CLPF05_FAM (
			TIPOPR, RAMO, POLIZA, NUMCER, COFAAM, COLASE, NACION, CEDCOL, DIANAC,
			MESNAC, ANONAC, EDAACT, EDOCOL, DIAING, MESING, ANOING, CODPLA, SUELDO,
			TELASE, CLACOL, PRICAP, PRIPRO, DIARET, MESRET, ANORET, ACTRET, CLASCO,
			CODCOM, SEXBEN, ZURDO, PROF,FECMOD, FECSOL, ZONEFT, TIPRIE, MATERN, FTORCG,
			CORRE, STSPRE, STSPLA, CODPAR, INDEXC
		)
		VALUES (
			I.TIPOPR, I.RAMO, I.POLIZA,I.NUMCER, I.COFAAM,  I.COLASE, I.NACION, I.CEDCOL, I.DIANAC,
			I.MESNAC, I.ANONAC, I.EDAACT, I.EDOCOL, I.DIAING, I.MESING, I.ANOING, I.CODPLA, I.SUELDO,
			I.TELASE, I.CLACOL, I.PRICAP, I.PRIPRO, I.DIARET, I.MESRET, I.ANORET, I.ACTRET, I.CLASCO,
			I.CODCOM, I.SEXBEN, I.ZURDO, I.PROF, I.FECMOD, I.FECSOL, I.ZONEFT, I.TIPRIE, I.MATERN, I.FTORCG,
			I.CORRE, I.STSPRE, I.STSPLA, I.CODPAR, I.INDEXC
		);
		COMMIT;
	END LOOP;

	DELETE FROM EQ_CLPF05_FAM WHERE COFAAM <> 0 AND RAMO = 27;
	COMMIT;
	--
	UPDATE EQ_CLPF05_FAM
	SET TIPOID = 'M',
		NUMID = NUMCER
	WHERE EDAACT < 8
	AND RAMO = 26;
	COMMIT;
	--
	UPDATE EQ_CLPF05_FAM
	SET TIPOID = PM.BUSQUEDA_NACION (NACION),
		NUMID = CEDCOL
	WHERE RAMO <> 27
	AND COFAAM = 0
	AND NUMID IS NULL;
	COMMIT;
	--
	UPDATE EQ_CLPF05_FAM
	SET TIPOID = PM.BUSQUEDA_NACION (NACION),
		NUMID = CEDCOL
	WHERE RAMO = 27
	AND COFAAM = 0
	AND CEDCOL < 100000000
	AND NUMID IS NULL;
	COMMIT;
	--
	FOR I IN CUR_MENORES_1
	LOOP
		UPDATE EQ_CLPF05_FAM
		SET TIPOID = 'N',
			NUMID = (
				SELECT COUNT (*) + P_NUMERO FROM acsel.tercero@cert
				WHERE tipoid = 'N'
			),
			DVID = '7'
		WHERE RAMO = I.RAMO
		AND POLIZA = I.POLIZA
		AND NUMCER = I.NUMCER
		AND COFAAM = I.COFAAM;
		COMMIT;

		P_NUMERO := P_NUMERO + 1;
	END LOOP;
	--
	FOR I IN CUR_MENORES_2
	LOOP
		UPDATE EQ_CLPF05_FAM
		SET TIPOID = 'N', 
			NUMID = I.CEDCOL
		WHERE ROWID = I.ROWID;
		COMMIT;
	END LOOP;
	--
	FOR I IN CUR_MENORES_3
	LOOP
		UPDATE EQ_CLPF05_FAM
		SET TIPOID = 'V',
			NUMID = I.CEDCOL
		WHERE ROWID = I.ROWID;
		COMMIT;
	END LOOP;
	--
	FOR I IN CUR_MENORES_4
	LOOP
		UPDATE EQ_CLPF05_FAM
		SET TIPOID = 'E',
			NUMID = I.CEDCOL
		WHERE ROWID = I.ROWID;
		COMMIT;
	END LOOP;
	--
	UPDATE EQ_CLPF05_FAM AA
	SET AA.DIAORI = (
		SELECT MAX (BB.DIAORI) FROM CLPF25 BB
		WHERE AA.RAMO = BB.RAMO
		AND AA.POLIZA = BB.POLIZA
		AND AA.NUMCER = BB.NUMCER
		AND AA.COFAAM = BB.COFAAM
		AND AA.CORRE = BB.CORRE
		GROUP BY AA.RAMO,AA.POLIZA,AA.NUMCER,AA.COFAAM,AA.CORRE
	),
	AA.MESORI = (
		SELECT MAX (BB.MESORI) FROM CLPF25 BB
		WHERE AA.RAMO = BB.RAMO
		AND AA.POLIZA = BB.POLIZA
		AND AA.NUMCER = BB.NUMCER
		AND AA.COFAAM = BB.COFAAM
		AND AA.CORRE = BB.CORRE
		GROUP BY AA.RAMO, AA.POLIZA, AA.NUMCER, AA.COFAAM, AA.CORRE
	),
	AA.ANOORI = (
		SELECT MAX (BB.ANOORI) FROM CLPF25 BB
		WHERE AA.RAMO = BB.RAMO
		AND AA.POLIZA = BB.POLIZA
		AND AA.NUMCER = BB.NUMCER
		AND AA.COFAAM = BB.COFAAM
		AND AA.CORRE = BB.CORRE
		GROUP BY AA.RAMO, AA.POLIZA, AA.NUMCER, AA.COFAAM, AA.CORRE
	)
	WHERE EXISTS (
		SELECT 1 FROM CLPF25 BB
		WHERE AA.RAMO = BB.RAMO
		AND AA.POLIZA = BB.POLIZA
		AND AA.NUMCER = BB.NUMCER
		AND AA.COFAAM = BB.COFAAM
		AND AA.CORRE = BB.CORRE
	);
	COMMIT;
	--
	UPDATE EQ_CLPF05_FAM
	SET DVID = (
		CASE WHEN TIPOID IN ('J', 'G') THEN
			ACSEL.PR_TERCERO.GENERA_DVID@CERT (TIPOID, NUMID)
		ELSE
			'0'
		END
	)
	WHERE TRIM (TIPOID) IS NOT NULL
	AND TRIM (NUMID) IS NOT NULL;
	COMMIT;

	P_NUMID_AN := 0;
	P_DVID := 0;

	FOR X IN CUR_CLPF05_NUMID
	LOOP
		P_NUMID_AC := X.NUMID;

		IF P_NUMID_AC = P_NUMID_AN THEN
			P_DVID := P_DVID + 1;

			UPDATE EQ_CLPF05_FAM
			SET DVID = P_DVID
			WHERE TIPOID = X.TIPOID
			AND NUMID = X.NUMID
			AND COFAAM = X.COFAAM;
			COMMIT;

			P_NUMID_AN := X.NUMID;
		ELSE
			P_DVID := 1;

			UPDATE EQ_CLPF05_FAM
			SET DVID = P_DVID
			WHERE TIPOID = X.TIPOID
			AND NUMID = X.NUMID
			AND COFAAM = X.COFAAM;
			COMMIT;

			P_NUMID_AN := X.NUMID;
		END IF;
	END LOOP;
	--
	UPDATE EQ_CLPF05_FAM
	SET CODCLI = PM.GENERA_CODCLI (TIPOID, NUMID, DVID),
		INDNACIONAL = PM.BUSQUEDA_INDNACIONAL (TIPOID)
	WHERE TRIM (TIPOID) IS NOT NULL
	AND TRIM (NUMID) IS NOT NULL
	AND TRIM (DVID) IS NOT NULL;
	COMMIT;
END;