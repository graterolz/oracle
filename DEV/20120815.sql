BEGIN
	pm_eg.INSERTA_EQ_CLPF05_FAM;
	pm_eg.INSERTA_EQ_CLPF07;
	--
	EXECUTE IMMEDIATE 'TRUNCATE TABLE EQ_COLECPER1';
	--
	INSERT INTO EQ_COLECPER1 (RAMO, POLIZA, NUMCER, COFAAM, CODPLA, CODCOB, MONCOB, PRICAP)
	SELECT 	aa.ramo, aa.poliza, aa.numcer, aa.cofaam, aa.codpla,
			CASE aa.ramo WHEN 02 THEN '02' || TO_CHAR (fune.cod1) END codcob,
			bb.moncob, CAST (aa.pricap AS NUMERIC (13, 2)) pricap
	FROM clpf05 aa, clpf02 bb,(
		SELECT SUBSTR (acargu, 14, 2) cod1, SUBSTR (acfunc, 1, 30) des1
		FROM ctraltab
		WHERE actiar = 4015
	) fune
	WHERE bb.ramo = aa.ramo
	AND bb.poliza = aa.poliza
	AND bb.codpla = aa.codpla
	AND cobcol = CASE aa.ramo WHEN 02 THEN TO_NUMBER (fune.cod1) END
	AND aa.ramo = 02
	AND cobcol = CASE bb.ramo WHEN 02 THEN TO_NUMBER (fune.cod1) END
	AND bb.ramo = 02
	AND cobcol = CASE aa.ramo WHEN aa.ramo THEN TO_NUMBER (fune.cod1) END
	AND cobcol = CASE 02 WHEN 02 THEN TO_NUMBER (fune.cod1) END
	AND (aa.ramo = bb.ramo AND cobcol = TO_NUMBER (fune.cod1) OR aa.ramo <> bb.ramo AND cobcol = NULL);
	--
	INSERT INTO EQ_COLECPER1 (RAMO, POLIZA, NUMCER, COFAAM, CODPLA, CODCOB, MONCOB, PRICAP)
	SELECT 	aa.ramo, aa.poliza, aa.numcer, aa.cofaam, aa.codpla,
			CASE aa.ramo WHEN 22 THEN '22' || TO_CHAR (vida.cod1) END codcob,
			bb.moncob, CAST (aa.pricap AS NUMERIC (13, 2)) pricap
	FROM clpf05 aa, clpf02 bb,(
		SELECT SUBSTR (acargu, 14, 2) cod1, SUBSTR (acfunc, 1, 40) des1 
		FROM ctraltab
		WHERE actiar = 60
	) vida
	WHERE bb.ramo = aa.ramo
	AND bb.poliza = aa.poliza
	AND bb.codpla = aa.codpla
	AND cobcol = CASE aa.ramo WHEN 22 THEN TO_NUMBER (vida.cod1) END
	AND aa.ramo = 22
	AND cobcol = CASE bb.ramo WHEN 22 THEN TO_NUMBER (vida.cod1) END
	AND bb.ramo = NVL (22, UID)
	AND cobcol = CASE aa.ramo WHEN aa.ramo THEN TO_NUMBER (vida.cod1) END
	AND cobcol = CASE 22 WHEN 22 THEN TO_NUMBER (vida.cod1) END
	AND cobcol = CASE aa.ramo WHEN bb.ramo THEN TO_NUMBER (vida.cod1) END;
	COMMIT;
	--
	INSERT INTO EQ_COLECPER1 (RAMO, POLIZA, NUMCER, COFAAM, CODPLA, CODCOB, MONCOB, PRICAP)
	SELECT 	aa.ramo, aa.poliza, aa.numcer, aa.cofaam, aa.codpla,
			CASE aa.ramo WHEN 27 THEN '27' || TO_CHAR (apc.cod1) END codcob, bb.moncob,
			CAST (aa.pricap AS NUMERIC (13, 2)) pricap
	FROM clpf05 aa, clpf02 bb,(
		SELECT SUBSTR (acargu, 14, 2) cod1, SUBSTR (acfunc, 1, 25) des1
		FROM ctraltab
		WHERE actiar = 15
	) apc
	WHERE aa.ramo = bb.ramo
	AND aa.poliza = bb.poliza
	AND aa.codpla = bb.codpla
	AND (aa.ramo = 27 AND cobcol = TO_NUMBER (apc.cod1) OR aa.ramo <> 27 AND cobcol = NULL)
	AND aa.ramo = 27;
	--
	INSERT INTO EQ_COLECPER1 (RAMO, POLIZA, NUMCER, COFAAM, CODPLA, CODCOB, MONCOB,PRICAP)
	SELECT 	aa.ramo, aa.poliza, aa.numcer, aa.cofaam, aa.codpla,
			CASE aa.ramo WHEN 15 THEN '15' || TO_CHAR (odont.cod1) END codcob,
			bb.moncob, CAST (aa.pricap AS NUMERIC (13, 2)) pricap
	FROM clpf05 aa, clpf02 bb, (
		SELECT SUBSTR (acargu, 14, 2) cod1, SUBSTR (acfunc, 1, 30) des1
		FROM ctraltab
		WHERE actiar = NVL (246, UID)
	) odont
	WHERE aa.ramo = bb.ramo
	AND aa.poliza = bb.poliza
	AND aa.codpla = bb.codpla
	AND (aa.ramo = 15 AND cobcol = TO_NUMBER (odont.cod1) OR aa.ramo <> 15 AND cobcol = NULL)
	AND aa.ramo = 15;
	COMMIT;
	--
	INSERT INTO EQ_COLECPER1 (RAMO, POLIZA,NUMCER, COFAAM, CODPLA, CODCOB, MONCOB, PRICAP)
	SELECT 	aa.ramo, aa.poliza, aa.numcer, aa.cofaam, aa.codpla,
			CASE aa.ramo WHEN 24 THEN '24' || TO_CHAR (hcm.cod1) END codcob,
			bb.moncob, CAST (aa.pricap AS NUMERIC (13, 2)) pricap
	FROM clpf05 aa, clpf02 bb,(
		SELECT SUBSTR (acargu, 14, 2) cod1, SUBSTR (acfunc, 1, 38) des1
		FROM ctraltab
		WHERE actiar = 53
	) hcm
	WHERE bb.ramo = aa.ramo
	AND bb.poliza = aa.poliza
	AND bb.codpla = aa.codpla
	AND cobcol = CASE aa.ramo WHEN 24 THEN TO_NUMBER (hcm.cod1) END
	AND aa.ramo = 24
	AND cobcol = CASE bb.ramo WHEN 24 THEN TO_NUMBER (hcm.cod1) END
	AND bb.ramo = 24
	AND (aa.ramo = aa.ramo AND cobcol = TO_NUMBER (hcm.cod1) OR aa.ramo <> aa.ramo AND cobcol = NULL)
	AND cobcol = CASE 24 WHEN 24 THEN TO_NUMBER (hcm.cod1) END
	AND cobcol = CASE aa.ramo WHEN bb.ramo THEN TO_NUMBER (hcm.cod1) END;
	COMMIT;
	--
	EXECUTE IMMEDIATE 'TRUNCATE TABLE EQ_COBER_COLEC';
	--
	INSERT INTO EQ_COBER_COLEC (RAMO, POLIZA, NUMCER, COFAAM, CODPLA, CODCOB, MONCOB, PRICAP)
	SELECT RAMO, POLIZA, NUMCER, COFAAM, CODPLA, CODCOB, MAX (MONCOB), MAX (PRICAP)
	FROM EQ_COLECPER1
	GROUP BY RAMO, POLIZA, NUMCER, COFAAM, CODPLA, CODCOB;
	--
	DBMS_OUTPUT.put_line ('Inicio Cob. Ind: ' || SYSTIMESTAMP);
	PM_GF02.MIGRAR_COBERTURAS_INDIVIDUALES;
	DBMS_OUTPUT.put_line ('Fin Cob. Ind:' || SYSTIMESTAMP);
	--
	DBMS_OUTPUT.put_line ('Inicio Cob. Col: ' || SYSTIMESTAMP);
	PM_GF02.MIGRAR_COBERTURAS_COLECTIVAS;
	DBMS_OUTPUT.put_line ('Fin Cob. Ind:' || SYSTIMESTAMP);
	--
	DBMS_OUTPUT.put_line ('Inicio Ins. eq_coberturas_ind: ' || SYSTIMESTAMP);
	PM_GF02.INSERTAR_DAT_EQ_COBERTURAS_IND;
	DBMS_OUTPUT.put_line ('Fin Ins. eq_coberturas_ind:' || SYSTIMESTAMP);
END;