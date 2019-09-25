DECLARE
	CED_MED1	EQ_HJPF71.NUMID%TYPE;
	CED_MED2	EQ_HJPF71.NUMID%TYPE;
	BANDERA		NUMBER (1) := 0;
	V_DVID		NUMBER (3) := 0;
	N_CED		NUMBER (14);

	CURSOR CUR_HJPF71
	IS
	SELECT * FROM HJPF71;

	CURSOR CUR_MENORES
	IS
	SELECT TIPOID, NUMID, DVID, COFAAM
	FROM EQ_MENORES
	ORDER BY TIPOID, NUMID, DVID, COFAAM;
BEGIN
	EXECUTE IMMEDIATE 'TRUNCATE TABLE EQ_HJPF71';

	FOR I IN CUR_HJPF71
	LOOP
		INSERT INTO EQ_HJPF71 (
			RAMO, POLIZA, STSREC, NUMREC, COFAAM,NOMBEN, CEDBEN, EDAD,
			DIANAC, MESNAC, ANONAC, DIAING, MESING, ANOING, DIARET, MESRET,
			ANORET, CODPAR, MONMAX, PRMEXB, PRMBSB, PRMGAB, PRMOTB, PRMEXE,
			PRMBSE, PRMGAE, PRMOTE, STSPRE, STSPLA, TASA
		)
		VALUES (
			I.RAMO, I.POLIZA, I.STSREC, I.NUMREC, I.COFAAM, I.NOMBEN, I.CEDBEN, I.EDAD,
			I.DIANAC, I.MESNAC, I.ANONAC, I.DIAING, I.MESING, I.ANOING, I.DIARET, I.MESRET,
			I.ANORET, I.CODPAR, I.MONMAX, I.PRMEXB, I.PRMBSB, I.PRMGAB, I.PRMOTB, I.PRMEXE,
			I.PRMBSE, I.PRMGAE, I.PRMOTE, I.STSPRE, I.STSPLA, I.TASA
		);
		COMMIT;
	END LOOP;
	--
	UPDATE EQ_HJPF71
	SET NTIPO = 1
	WHERE ANONAC > 0 
	AND COFAAM <> 9
	AND COFAAM > 0
	AND EDAD < 8;
	COMMIT;
	--
	UPDATE EQ_HJPF71
	SET NTIPO = 2
	WHERE NTIPO IS NULL
	AND ANONAC > 0
	AND COFAAM <> 99
	AND COFAAM > 0
	AND CEDBEN < 100;
	COMMIT;
	--
	UPDATE EQ_HJPF71
	SET NTIPO = 2
	WHERE NTIPO IS NULL
	AND ANONAC > 0
	AND COFAAM <> 99
	AND COFAAM > 0
	AND CEDBEN > 99999999;
	COMMIT;
	--
	UPDATE EQ_HJPF71
	SET TIPOID = 'V'
	WHERE ANONAC > 0
	AND COFAAM <> 99
	AND COFAAM > 0
	AND CEDBEN > 99
	AND CEDBEN < 80000000
	AND NTIPO IS NULL;
	COMMIT;
	--
	UPDATE EQ_HJPF71
	SET TIPOID = 'E'
	WHERE ANONAC > 0
	AND COFAAM <> 99
	AND COFAAM > 0
	AND CEDBEN >= 80000000
	AND CEDBEN < 100000000
	AND NTIPO IS NULL;
	COMMIT;
	--
	UPDATE EQ_HJPF71 AA
	SET TIPOID = 'M',
		NUMID = (
			SELECT MAX (BB.CCLI2) FROM HJPF01 BB
			WHERE AA.RAMO = BB.RAMO
			AND AA.POLIZA = BB.POLIZA
			AND AA.NTIPO = 1
			GROUP BY RAMO, POLIZA
		)
	WHERE EXISTS (
		SELECT 1 FROM HJPF01 BB
		WHERE AA.RAMO = BB.RAMO
		AND AA.POLIZA = BB.POLIZA
		AND AA.NTIPO = 1
		GROUP BY RAMO, POLIZA
	)
	AND RAMO = 26;
	COMMIT;
	--
	UPDATE EQ_HJPF71 AA
	SET DIRCB1 = (
		SELECT BB.DIRCB1 FROM HJPF01 BB
		WHERE AA.ANONAC > 0
		AND AA.COFAAM <> 99
		AND AA.COFAAM > 0
		AND BB.RAMO = AA.RAMO
		AND BB.POLIZA = AA.POLIZA
	),
	ZONCOB = (
		SELECT BB.ZONCOB FROM HJPF01 BB
		WHERE AA.ANONAC > 0
		AND AA.COFAAM <> 99
		AND AA.COFAAM > 0
		AND BB.RAMO = AA.RAMO
		AND BB.POLIZA = AA.POLIZA
	),
	TELEF = (
		SELECT BB.TELEF FROM HJPF01 BB
		WHERE AA.ANONAC > 0
		AND AA.COFAAM <> 99
		AND AA.COFAAM > 0
		AND BB.RAMO = AA.RAMO
		AND BB.POLIZA = AA.POLIZA
	),
	DIRRG1 = (
		SELECT BB.DIRRG1 FROM HJPF01 BB
		WHERE AA.ANONAC > 0
		AND AA.COFAAM <> 99
		AND AA.COFAAM > 0
		AND BB.RAMO = AA.RAMO
		AND BB.POLIZA = AA.POLIZA
	)
	WHERE EXISTS ( 
		SELECT 1 FROM HJPF01 BB
		WHERE AA.ANONAC > 0
		AND AA.COFAAM <> 99
		AND AA.COFAAM > 0
		AND BB.RAMO = AA.RAMO
		AND BB.POLIZA = AA.POLIZA
	);
	COMMIT;
	--
	EXECUTE IMMEDIATE 'TRUNCATE TABLE EQ_MENORES';

	INSERT INTO EQ_MENORES (TIPOID, NUMID, DVID, COFAAM)
	SELECT TIPOID, NUMID, '0' DVID, COFAAM FROM EQ_HJPF71
	WHERE ANONAC > 0
	AND COFAAM <> 99
	AND COFAAM > 0
	AND NTIPO = 1
	AND RAMO = 26
	GROUP BY TIPOID, NUMID, 0, COFAAM;
	COMMIT;
	--
	FOR X IN CUR_MENORES
	LOOP
		IF BANDERA = 0 THEN
			CED_MED2 := X.NUMID;
		END IF;

		CED_MED1 := X.NUMID;

		IF CED_MED1 <> CED_MED2 OR BANDERA = 0 THEN
			V_DVID := 1;
			BANDERA := 1;
			CED_MED2 := X.NUMID;
		ELSE IF V_DVID >= 9 THEN
			V_DVID := 9;
		ELSE
			V_DVID := V_DVID + 1;
		END IF;

		UPDATE EQ_MENORES EQM
		SET DVID = V_DVID
		WHERE EQM.TIPOID = X.TIPOID
		AND EQM.NUMID = X.NUMID
		AND EQM.COFAAM = X.COFAAM;
		COMMIT;
	END LOOP;
	--
	FOR X IN CUR_MENORES
	LOOP
		UPDATE EQ_HJPF71 EQH
		SET DVID = X.DVID,
			TIPOID = 'M'
		WHERE EQH.TIPOID = X.TIPOID
		AND EQH.NUMID = X.NUMID
		AND EQH.COFAAM = X.COFAAM
		AND EQH.NTIPO = 1
		AND EQH.ANONAC > 0
		AND EQH.COFAAM <> 99
		AND EQH.COFAAM > 0;
		COMMIT;
	END LOOP;
	--
	UPDATE EQ_HJPF71
	SET NUMID = CEDBEN
	WHERE ANONAC > 0
	AND COFAAM <> 99
	AND COFAAM > 0
	AND NTIPO = 0;
	COMMIT;
	--
	UPDATE EQ_HJPF71
	SET DVID = (
		CASE WHEN TIPOID IN ('J', 'G') THEN
			ACSEL.PR_TERCERO.GENERA_DVID@CERT (TIPOID, NUMID)
		ELSE
			'0'
		END)
	WHERE TRIM (TIPOID) IS NOT NULL
	AND TRIM (NUMID) IS NOT NULL;
	COMMIT;
	--
	UPDATE EQ_HJPF71
	SET CODCLI = PM.GENERA_CODCLI (TIPOID, NUMID, DVID),
		INDNACIONAL = PM.BUSQUEDA_INDNACIONAL (TIPOID)
	WHERE ANONAC > 0
	AND COFAAM <> 99
	AND COFAAM > 0
	AND TRIM (TIPOID) IS NOT NULL
	AND TRIM (NUMID) IS NOT NULL
	AND TRIM (DVID) IS NOT NULL;
	COMMIT;
END;
--
DECLARE
	v_TIPOID 		ACSMIGRA.TERCERO_MIG.TIPOID@DESA%TYPE;
	v_NUMID 		ACSMIGRA.TERCERO_MIG.NUMID@DESA%TYPE;
	v_DVID 			ACSMIGRA.TERCERO_MIG.DVID@DESA%TYPE;
	v_NOMTER 		ACSMIGRA.TERCERO_MIG.NOMTER@DESA%TYPE;
	v_APETER 		ACSMIGRA.TERCERO_MIG.APETER@DESA%TYPE;
	v_CODPAIS		ACSMIGRA.TERCERO_MIG.CODPAIS@DESA%TYPE;
	v_CODESTADO 	ACSMIGRA.TERCERO_MIG.CODESTADO@DESA%TYPE;
	v_CODCIUDAD 	ACSMIGRA.TERCERO_MIG.CODCIUDAD@DESA%TYPE;
	v_CODMUNICIPIO 	ACSMIGRA.TERCERO_MIG.CODMUNICIPIO@DESA%TYPE;
	v_DIREC 		ACSMIGRA.TERCERO_MIG.DIREC@DESA%TYPE;
	v_TELEF1 		ACSMIGRA.TERCERO_MIG.TELEF1@DESA%TYPE;
	v_TELEF2 		ACSMIGRA.TERCERO_MIG.TELEF2@DESA%TYPE;
	v_TELEF3 		ACSMIGRA.TERCERO_MIG.TELEF3@DESA%TYPE;
	v_FAX 			ACSMIGRA.TERCERO_MIG.FAX@DESA%TYPE;
	v_TELEX 		ACSMIGRA.TERCERO_MIG.TELEX@DESA%TYPE;
	v_ZIP 			ACSMIGRA.TERCERO_MIG.ZIP@DESA%TYPE;
	v_INDNACIONAL 	ACSMIGRA.TERCERO_MIG.INDNACIONAL@DESA%TYPE;
	v_STSTER 		ACSMIGRA.TERCERO_MIG.STSTER@DESA%TYPE;
	v_FECSTS 		ACSMIGRA.TERCERO_MIG.FECSTS@DESA%TYPE;
	v_NUMCTAAUXI 	ACSMIGRA.TERCERO_MIG.NUMCTAAUXI@DESA%TYPE;
	v_EMAIL 		ACSMIGRA.TERCERO_MIG.EMAIL@DESA%TYPE;
	v_TIPOTER		ACSMIGRA.TERCERO_MIG.TIPOTER@DESA%TYPE;
	v_RIF			ACSMIGRA.TERCERO_MIG.RIF@DESA%TYPE;
	v_NIT 			ACSMIGRA.TERCERO_MIG.NIT@DESA%TYPE;
	v_CODPARROQUIA	ACSMIGRA.TERCERO_MIG.CODPARROQUIA@DESA%TYPE;
	v_CODSECTOR		ACSMIGRA.TERCERO_MIG.CODSECTOR@DESA%TYPE;
	v_WEBSITE		ACSMIGRA.TERCERO_MIG.WEBSITE@DESA%TYPE;
	v_RAZONSOCIAL	ACSMIGRA.TERCERO_MIG.RAZONSOCIAL@DESA%TYPE;
	v_INDMIGRA		ACSMIGRA.TERCERO_MIG.INDMIGRA@DESA%TYPE;
	v_MIGRA 		ACSMIGRA.TERCERO_MIG.MIGRA@DESA%TYPE;
	--
	v_CODCLI 			ACSMIGRA.CLIENTE_MIG.CODCLI@DESA%TYPE;
	v_CLASECLI			ACSMIGRA.CLIENTE_MIG.CLASECLI@DESA%TYPE;
	v_TIPOCLI			ACSMIGRA.CLIENTE_MIG.TIPOCLI@DESA%TYPE;
	v_SEXO				ACSMIGRA.CLIENTE_MIG.SEXO@DESA%TYPE;
	v_FECNAC			ACSMIGRA.CLIENTE_MIG.FECNAC@DESA%TYPE;
	v_EDOCIVIL			ACSMIGRA.CLIENTE_MIG.EDOCIVIL@DESA%TYPE;
	v_CODACT			ACSMIGRA.CLIENTE_MIG.CODACT@DESA%TYPE;
	v_CODFUERZA			ACSMIGRA.CLIENTE_MIG.CODFUERZA@DESA%TYPE;
	v_CODGRADO			ACSMIGRA.CLIENTE_MIG.CODGRADO@DESA%TYPE;
	v_FECVINC			ACSMIGRA.CLIENTE_MIG.FECVINC@DESA%TYPE;
	v_FECLISTANEGRA		ACSMIGRA.CLIENTE_MIG.FECLISTANEGRA@DESA%TYPE;
	v_CODLISTANEGRA		ACSMIGRA.CLIENTE_MIG.CODLISTANEGRA@DESA%TYPE;
	v_MTOINGANUAL		ACSMIGRA.CLIENTE_MIG.MTOINGANUAL@DESA%TYPE;
	v_FECINGANUAL		ACSMIGRA.CLIENTE_MIG.FECINGANUAL@DESA%TYPE;
	v_TIPOCONYUGE		ACSMIGRA.CLIENTE_MIG.TIPOCONYUGE@DESA%TYPE;
	v_NUMIDCONYUGE		ACSMIGRA.CLIENTE_MIG.NUMIDCONYUGE@DESA%TYPE;
	v_NOMCONYUGE 		ACSMIGRA.CLIENTE_MIG.NOMCONYUGE@DESA%TYPE;
	v_APECONYUGE		ACSMIGRA.CLIENTE_MIG.APECONYUGE@DESA%TYPE;
	v_INDCONTRAGARANTE	ACSMIGRA.CLIENTE_MIG.INDCONTRAGARANTE@DESA%TYPE;
	v_CODINGANUAL		ACSMIGRA.CLIENTE_MIG.CODINGANUAL@DESA%TYPE;
	v_NUMEXP			ACSMIGRA.CLIENTE_MIG.NUMEXP@DESA%TYPE;
	--
	CURSOR CUR_GENERAL_MENORES
	IS
	SELECT
		TIPOID,NUMID,DVID,MAX(NOMTER) NOMTER,MAX(APETER) APETER,MAX(CODPAIS) CODPAIS,MAX(CODESTADO) CODESTADO,
		MAX(CODCIUDAD) CODCIUDAD,MAX(CODMUNICIPIO) CODMUNICIPIO,MAX(DIREC) DIREC,MAX(TELEF1) TELEF1,MAX(TELEF2) TELEF2,
		MAX(TELEF3) TELEF3,MAX(FAX) FAX,MAX(TELEX) TELEX,MAX(ZIP) ZIP,MAX(INDNACIONAL) INDNACIONAL,MAX(STSTER) STSTER,
		MAX(FECSTS) FECSTS,MAX(NUMCTAAUXI) NUMCTAAUXI,MAX(EMAIL) EMAIL,MAX(TIPOTER) TIPOTER,MAX(RIF) RIF,MAX(NIT) NIT,
		MAX(CODPARROQUIA) CODPARROQUIA,MAX(CODSECTOR) CODSECTOR,MAX(WEBSITE) WEBSITE,MAX(RAZONSOCIAL) RAZONSOCIAL,
		MAX(INDMIGRA) INDMIGRA,MAX(MIGRA) MIGRA,CODCLI CODCLI,MAX(CLASECLI) CLASECLI,MAX(TIPOCLI) TIPOCLI,MAX(SEXO) SEXO,
		MAX(FECNAC) FECNAC,MAX(EDOCIVIL) EDOCIVIL,MAX(CODACT) CODACT,MAX(CODFUERZA) CODFUERZA,MAX(CODGRADO) CODGRADO,
		MAX(FECVINC) FECVINC,MAX(FECLISTANEGRA) FECLISTANEGRA,MAX(CODLISTANEGRA) CODLISTANEGRA,MAX(MTOINGANUAL) MTOINGANUAL,
		MAX(FECINGANUAL) FECINGANUAL,MAX(TIPOCONYUGE) TIPOCONYUGE,MAX(NUMIDCONYUGE) NUMIDCONYUGE,MAX(NOMCONYUGE) NOMCONYUGE,
		MAX(APECONYUGE) APECONYUGE,MAX(INDCONTRAGARANTE) INDCONTRAGARANTE,MAX(CODINGANUAL) CODINGANUAL,MAX(NUMEXP) NUMEXP,
		MAX(NOMBRETABLA) NOMBRETABLA,MAX(ANONAC) ANONAC,MAX(COFAAM) COFAAM
	FROM (
		SELECT
			TIPOID TIPOID,NUMID NUMID,DVID DVID,NOMBEN NOMTER,NULL APETER,NULL CODPAIS,ZONCOB CODESTADO,NULL CODCIUDAD,
			NULL CODMUNICIPIO,DIRRG1 DIREC,TO_CHAR (TELEF) TELEF1,NULL TELEF2,NULL TELEF3,NULL FAX,NULL TELEX,NULL ZIP,
			INDNACIONAL INDNACIONAL,NULL STSTER,NULL FECSTS,NULL NUMCTAAUXI,NULL EMAIL,NULL TIPOTER,NULL RIF,NULL NIT,
			NULL CODPARROQUIA,NULL CODSECTOR,NULL WEBSITE,NULL RAZONSOCIAL,NULL INDMIGRA,NULL MIGRA,CODCLI CODCLI,NULL CLASECLI,
			NULL TIPOCLI,PM.BUSCA_SEXO_PARENTESCO (CODPAR, 'I') SEXO,PM.VALIDA_CONVIERTE_FECHA (DIANAC, MESNAC, ANONAC) FECNAC,
			NULL EDOCIVIL,NULL CODACT,NULL CODFUERZA,NULL CODGRADO,NULL FECVINC,NULL FECLISTANEGRA,NULL CODLISTANEGRA,NULL MTOINGANUAL,
			NULL FECINGANUAL,NULL TIPOCONYUGE,NULL NUMIDCONYUGE,NULL NOMCONYUGE,NULL APECONYUGE,NULL INDCONTRAGARANTE,NULL CODINGANUAL,
			NULL NUMEXP,'EQ_HJPF71' NOMBRETABLA,ANONAC,COFAAM
		FROM EQ_HJPF71
		UNION ALL
		SELECT 
			TIPOID TIPOID,NUMID NUMID,DVID DVID,COLASE NOMTER,NULL APETER,NULL CODPAIS,NULL CODESTADO,NULL CODCIUDAD,
			NULL CODMUNICIPIO,B.DIRRG1 DIREC,TO_CHAR (B.TELEF) TELEF1,NULL TELEF2,NULL TELEF3,NULL FAX,NULL TELEX,NULL ZIP,
			INDNACIONAL INDNACIONAL,NULL STSTER,NULL FECSTS,NULL NUMCTAAUXI,NULL EMAIL,NULL TIPOTER,NULL RIF,NULL NIT,
			NULL CODPARROQUIA,NULL CODSECTOR,NULL WEBSITE,NULL RAZONSOCIAL,NULL INDMIGRA,NULL MIGRA,CODCLI CODCLI,NULL CLASECLI,
			NULL TIPOCLI,(
				CASE SEXBEN
					WHEN 'M' THEN 'M'
					WHEN 'F' THEN 'F'
					ELSE 'M'
				END) SEXO,
			PM.VALIDA_CONVIERTE_FECHA (A.DIANAC, A.MESNAC, A.ANONAC) FECNAC,NULL EDOCIVIL,NULL CODACT,NULL CODFUERZA,NULL CODGRADO,
			NULL FECVINC,NULL FECLISTANEGRA,NULL CODLISTANEGRA,NULL MTOINGANUAL,NULL FECINGANUAL,NULL TIPOCONYUGE,NULL NUMIDCONYUGE,
			NULL NOMCONYUGE,NULL APECONYUGE,NULL INDCONTRAGARANTE,NULL CODINGANUAL,NULL NUMEXP,'EQ_CLPF05_FAM' NOMBRETABLA,0,0
		FROM EQ_CLPF05_FAM A, HJPF01 B
		WHERE A.RAMO = B.RAMO AND A.POLIZA = B.POLIZA
	)
	GROUP BY TIPOID,NUMID,DVID,CODCLI;
	--
	CURSOR CUR_TERCERO_MIG (
		P_TIPOID	ACSMIGRA.TERCERO_MIG.TIPOID@DESA%TYPE,
		P_NUMID		ACSMIGRA.TERCERO_MIG.NUMID@DESA%TYPE,
		P_DVID		ACSMIGRA.TERCERO_MIG.DVID@DESA%TYPE
	) IS
	SELECT * FROM TERCERO_MIG_PRUEBA
	WHERE TIPOID = P_TIPOID
	AND NUMID = P_NUMID
	AND DVID = P_DVID;
	--
	CURSOR CUR_CLIENTE_MIG (
		P_TIPOID	ACSMIGRA.CLIENTE_MIG.TIPOID@DESA%TYPE,
		P_NUMID		ACSMIGRA.CLIENTE_MIG.NUMID@DESA%TYPE,
		P_DVID		ACSMIGRA.CLIENTE_MIG.DVID@DESA%TYPE,
		P_CODCLI	ACSMIGRA.CLIENTE_MIG.CODCLI@DESA%TYPE
	) IS
	SELECT * FROM CLIENTE_MIG_PRUEBA
	WHERE TIPOID = P_TIPOID
	AND NUMID = P_NUMID
	AND DVID = P_DVID
	AND CODCLI = P_CODCLI;
	--
	CURSOR CUR_TERCERO_ROL_MIG (
		P_TIPOID	ACSMIGRA.TERCERO_ROL_MIG.TIPOID@DESA%TYPE,
		P_NUMID		ACSMIGRA.TERCERO_ROL_MIG.NUMID@DESA%TYPE,
		P_DVID		ACSMIGRA.TERCERO_ROL_MIG.DVID@DESA%TYPE,
		P_TIPOTER	ACSMIGRA.TERCERO_ROL_MIG.TIPOTER@DESA%TYPE
	) IS
	SELECT * FROM TERCERO_ROL_MIG_PRUEBA
	WHERE TIPOID = P_TIPOID
	AND NUMID = P_NUMID
	AND DVID = P_DVID
	AND TIPOTER = P_TIPOTER;
	--
	RT_CUR_TERCERO_MIG 	CUR_TERCERO_MIG%ROWTYPE;	
	RT_CUR_CLIENTE_MIG	CUR_CLIENTE_MIG%ROWTYPE;
	RT_CUR_TERCERO_ROL_MIG	CUR_TERCERO_ROL_MIG%ROWTYPE;
	--
	iTipoError 		ERR_MIG_CLIENTE.TIPOERROR%TYPE;
	iCodError 		ERR_MIG_CLIENTE.CODERROR%TYPE;
	iNomProceso 	ERR_MIG_CLIENTE.NOMPROCESO%TYPE;
	iNomTabla 		ERR_MIG_CLIENTE.NOMTABLA%TYPE;
	iError 			ERR_MIG_CLIENTE.ORAERROR%TYPE;
	IDISPONIBLE		BOOLEAN;
BEGIN
	FOR I IN CUR_GENERAL_MENORES
	LOOP
		v_TIPOID := NULL;
		v_NUMID := NULL;
		v_DVID := NULL;
		v_NOMTER := NULL;
		v_APETER := NULL;
		v_CODPAIS := NULL;
		v_CODESTADO := NULL;
		v_CODCIUDAD := NULL;
		v_CODMUNICIPIO := NULL;
		v_DIREC := NULL;
		v_TELEF1 := NULL;
		v_TELEF2 := NULL;
		v_TELEF3 := NULL;
		v_FAX := NULL;
		v_TELEX := NULL;
		v_ZIP := NULL;
		v_INDNACIONAL := NULL;
		v_STSTER := NULL;
		v_FECSTS := NULL;
		v_NUMCTAAUXI := NULL;
		v_EMAIL := NULL;
		v_TIPOTER := NULL;
		v_RIF := NULL;
		v_NIT := NULL;
		v_CODPARROQUIA := NULL;
		v_CODSECTOR := NULL;
		v_WEBSITE := NULL;
		v_RAZONSOCIAL := NULL;
		v_INDMIGRA := NULL;
		v_MIGRA := NULL;
		v_CODCLI := NULL;
		v_CLASECLI := NULL;
		v_TIPOCLI := NULL;
		v_SEXO := NULL;
		v_FECNAC := NULL;
		v_EDOCIVIL := NULL;
		v_CODACT := NULL;
		v_CODFUERZA := NULL;
		v_CODGRADO := NULL;
		v_FECVINC := NULL;
		v_FECLISTANEGRA := NULL;
		v_CODLISTANEGRA := NULL;
		v_MTOINGANUAL := NULL;
		v_FECINGANUAL := NULL;
		v_TIPOCONYUGE := NULL;
		v_NUMIDCONYUGE := NULL;
		v_NOMCONYUGE := NULL;
		v_APECONYUGE := NULL;
		v_INDCONTRAGARANTE := NULL;
		v_CODINGANUAL := NULL;
		v_NUMEXP := NULL;
		--
		iNomTabla := I.NOMBRETABLA;

		IF iNomTabla = 'EQ_HJPF71' THEN
			v_CODESTADO := PM.BUSQUEDA_localidad (I.CODESTADO, 'E');
			v_CODCIUDAD := PM.BUSQUEDA_localidad (I.CODESTADO, 'C');
			v_CODMUNICIPIO := PM.BUSQUEDA_localidad (I.CODESTADO, 'M');
			v_CODPARROQUIA := PM.BUSQUEDA_LOCALIDAD (I.CODESTADO, 'A');
			v_CODSECTOR := PM.BUSQUEDA_LOCALIDAD (I.CODESTADO, 'S');
		ELSE
			v_CODESTADO := '999';
			v_CODCIUDAD := '999';
			v_CODMUNICIPIO := '999';
			v_CODPARROQUIA := '999';
			v_CODSECTOR := '999';
		END IF;
		--
		v_TIPOID := I.TIPOID;
		v_NUMID := I.NUMID;
		v_DVID := I.DVID;
		v_NOMTER := I.NOMTER;
		v_APETER := I.APETER;
		v_CODPAIS := '001';
		v_DIREC := I.DIREC;
		v_TELEF1 := I.TELEF1;
		v_TELEF2 := I.TELEF2;
		v_TELEF3 := I.TELEF3;
		v_FAX := I.FAX;
		v_TELEX := I.TELEX;
		v_ZIP := I.ZIP;
		v_INDNACIONAL := I.INDNACIONAL;
		v_STSTER := 'INA';
		v_FECSTS := '01/01/2000';
		v_NUMCTAAUXI := I.NUMCTAAUXI;
		v_EMAIL := I.EMAIL;
		v_TIPOTER := 'CI';
		v_RIF := I.RIF;
		v_NIT := I.NIT;
		v_WEBSITE := I.WEBSITE;
		v_RAZONSOCIAL := (CASE WHEN v_TIPOID = 'J' THEN TRIM (v_NOMTER) ELSE NULL END);
		v_INDMIGRA := I.INDMIGRA;
		v_MIGRA := I.MIGRA;
		v_CODCLI := I.CODCLI;
		v_CLASECLI := '006';
		v_TIPOCLI :=
			(CASE v_TIPOID
				WHEN 'J' THEN 'E'
				WHEN 'G' THEN 'G'
				WHEN 'V' THEN 'P'
				WHEN 'E' THEN 'P'
				ELSE NULL
			END);
		v_SEXO := I.SEXO;
		v_FECNAC := I.FECNAC;
		v_EDOCIVIL := '9';
		v_CODACT := '9999';
		v_CODFUERZA := I.CODFUERZA;
		v_CODGRADO := I.CODGRADO;
		v_FECVINC := '01/01/2000';
		v_FECLISTANEGRA := I.FECLISTANEGRA;
		v_CODLISTANEGRA := I.CODLISTANEGRA;
		v_MTOINGANUAL := I.MTOINGANUAL;
		v_FECINGANUAL := '01/01/2000';
		v_TIPOCONYUGE := I.TIPOCONYUGE;
		v_NUMIDCONYUGE := I.NUMIDCONYUGE;
		v_NOMCONYUGE := I.NOMCONYUGE;
		v_APECONYUGE := I.APECONYUGE;
		v_INDCONTRAGARANTE := I.INDCONTRAGARANTE;
		v_CODINGANUAL := I.CODINGANUAL;
		v_NUMEXP := I.NUMEXP;
		---
		IF v_TIPOID IN ('J', 'G')THEN
			v_SEXO := 'N';
		END IF;

		v_NOMTER := TRIM (PM.ELIMINA_ESPACIOS (UPPER (v_NOMTER)));

		v_DIREC := PM.ELIMINA_ESPACIOS (UPPER (
			(CASE
				WHEN TRIM (v_DIREC) IS NULL THEN 'SIN DIRECCION'
				ELSE v_DIREC
			END)
		));

		v_RAZONSOCIAL := PM.ELIMINA_ESPACIOS (UPPER ( (CASE WHEN v_TIPOID = 'J' THEN v_NOMTER END)));
		IDISPONIBLE := TRUE;
		iTipoError := 'ERR-TERCEROS';
		iNomProceso := 'PROCESO GENERAL DE TERCEROS MENORES';
		--
		IF v_NOMTER IS NULL THEN
			IDISPONIBLE := FALSE;
			iCodError := '001';

			SELECT DESCRIPCION INTO iError
			FROM ERRORES
			WHERE TIPOERROR = iTipoError
			AND CODERROR = iCodError;

			PM.GENERA_ERROR_CLIENTE (
				NTIPOERROR	=> iTipoError,
				NCODERROR	=> iCodError,
				NNOMPROCESO	=> iNomProceso,
				NNOMTABLA	=> iNomTabla,
				NTIPOID		=> v_TIPOID,
				NNUMID		=> v_NUMID,
				NDVID		=> v_DVID,
				NCODCLI		=> v_CODCLI,
				ERROR		=> iError
			);
		END IF;
		--
		IF TRIM (v_TIPOID) IS NULL THEN
			IDISPONIBLE := FALSE;
			iCodError := '003';

			SELECT DESCRIPCION INTO iError
			FROM ERRORES
			WHERE TIPOERROR = iTipoError
			AND CODERROR = iCodError;

			PM.GENERA_ERROR_CLIENTE (
				NTIPOERROR	=> iTipoError,
				NCODERROR	=> iCodError,
				NNOMPROCESO	=> iNomProceso,
				NNOMTABLA	=> iNomTabla,
				NTIPOID		=> v_TIPOID,
				NNUMID		=> v_NUMID,
				NDVID		=> v_DVID,
				NCODCLI		=> v_CODCLI,
				NERROR 		=> iError
			);
		END IF;
		--
		IF iNomTabla = 'EQ_HJPF71' AND I.ANONAC < 0 AND I.COFAAM < 0 AND (I.COFAAM > 99 OR I.COFAAM < 99) THEN
			IDISPONIBLE := FALSE;
			iCodError := '004';

			SELECT DESCRIPCION INTO iError
			FROM ERRORES
			WHERE TIPOERROR = iTipoError
			AND CODERROR = iCodError;

			PM.GENERA_ERROR_CLIENTE (
				NTIPOERROR	=> iTipoError,
				NCODERROR	=> iCodError,
				NNOMPROCESO	=> iNomProceso,
				NNOMTABLA	=> iNomTabla,
				NTIPOID		=> v_TIPOID,
				NNUMID		=> v_NUMID,
				NDVID		=> v_DVID,
				NCODCLI		=> v_CODCLI,
				NERROR 		=> iError
			);
		END IF;
		--
		IF IDISPONIBLE = TRUE THEN
			OPEN CUR_TERCERO_MIG (v_TIPOID,v_NUMID,v_DVID);
			FETCH CUR_TERCERO_MIG INTO RT_CUR_TERCERO_MIG;

			IF CUR_TERCERO_MIG%NOTFOUND THEN
			BEGIN
				INSERT INTO TERCERO_MIG_PRUEBA (
					TIPOID,NUMID,DVID,NOMTER,APETER,CODPAIS,CODESTADO,CODCIUDAD,CODMUNICIPIO,DIREC,TELEF1,TELEF2,TELEF3,FAX,
					TELEX,ZIP,INDNACIONAL,STSTER,FECSTS,NUMCTAAUXI,EMAIL,TIPOTER,RIF,NIT,CODPARROQUIA,CODSECTOR,WEBSITE,RAZONSOCIAL,
					INDMIGRA,MIGRA
				)
				VALUES (
					v_TIPOID,v_NUMID,v_DVID,v_NOMTER,v_APETER,v_CODPAIS,v_CODESTADO,v_CODCIUDAD,v_CODMUNICIPIO,v_DIREC,v_TELEF1,v_TELEF2,
					v_TELEF3,v_FAX,v_TELEX,v_ZIP,v_INDNACIONAL,v_STSTER,v_FECSTS,v_NUMCTAAUXI,v_EMAIL,v_TIPOTER,v_RIF,v_NIT,v_CODPARROQUIA,
					v_CODSECTOR,v_WEBSITE,v_RAZONSOCIAL,v_INDMIGRA,v_MIGRA
				);
			EXCEPTION WHEN OTHERS THEN
				iCodError := '002';
				iError := SQLERRM;
				PM.GENERA_ERROR_CLIENTE (
					NTIPOERROR	=> iTipoError,
					NCODERROR	=> iCodError,
					NNOMPROCESO	=> iNomProceso,
					NNOMTABLA	=> iNomTabla,
					NTIPOID		=> v_TIPOID,
					NNUMID		=> v_NUMID,
					NDVID		=> v_DVID,
					NCODCLI		=> v_CODCLI,
					NERROR 		=> iError
				);
			END;
			END IF;
			CLOSE CUR_TERCERO_MIG;
			--			
			OPEN CUR_CLIENTE_MIG (v_TIPOID,v_NUMID,v_DVID,v_CODCLI);
			FETCH CUR_CLIENTE_MIG INTO RT_CUR_CLIENTE_MIG;

			IF CUR_CLIENTE_MIG%NOTFOUND THEN
			BEGIN
				INSERT INTO CLIENTE_MIG_PRUEBA (
					TIPOID,NUMID,DVID,CODCLI,CLASECLI,TIPOCLI,SEXO,FECNAC,EDOCIVIL,CODACT,CODFUERZA,CODGRADO,FECVINC,
					FECLISTANEGRA,CODLISTANEGRA,MTOINGANUAL,FECINGANUAL,NUMCTAAUXI,TIPOCONYUGE,NUMIDCONYUGE,NOMCONYUGE,
					APECONYUGE,INDCONTRAGARANTE,CODINGANUAL,NUMEXP,INDMIGRA
				)
				VALUES (
					v_TIPOID,v_NUMID,v_DVID,v_CODCLI,v_CLASECLI,v_TIPOCLI,v_SEXO,v_FECNAC,v_EDOCIVIL,v_CODACT,v_CODFUERZA,
					v_CODGRADO,v_FECVINC,v_FECLISTANEGRA,v_CODLISTANEGRA,v_MTOINGANUAL,v_FECINGANUAL,v_NUMCTAAUXI,v_TIPOCONYUGE,
					v_NUMIDCONYUGE,v_NOMCONYUGE,v_APECONYUGE,v_INDCONTRAGARANTE,v_CODINGANUAL,v_NUMEXP,v_INDMIGRA
				);
				COMMIT;
			EXCEPTION WHEN OTHERS THEN
				iCodError := '002';
				iError := SQLERRM;
				PM.GENERA_ERROR_CLIENTE (
					NTIPOERROR	=> iTipoError,
					NCODERROR	=> iCodError,
					NNOMPROCESO	=> iNomProceso,
					NNOMTABLA	=> iNomTabla,
					NTIPOID		=> v_TIPOID,
					NNUMID		=> v_NUMID,
					NDVID		=> v_DVID,
					NCODCLI		=> v_CODCLI,
					NERROR 		=> iError
				);
			END;

			OPEN CUR_TERCERO_ROL_MIG (v_TIPOID,v_NUMID,v_DVID,v_TIPOTER);
			FETCH CUR_TERCERO_ROL_MIG INTO RT_CUR_TERCERO_ROL_MIG;

			IF CUR_TERCERO_ROL_MIG%NOTFOUND THEN
			BEGIN
				INSERT INTO TERCERO_ROL_MIG_PRUEBA (
					TIPOID,NUMID,DVID,TIPOTER,STSROL,FECSTS
				)
				VALUES (
					v_TIPOID,v_NUMID,v_DVID,v_TIPOTER,v_STSTER,v_FECSTS
				);
				COMMIT;
			EXCEPTION WHEN OTHERS THEN
				iCodError := '002';
				iError := SQLERRM;
				PM.GENERA_ERROR_CLIENTE (
					NTIPOERROR	=> iTipoError,
					NCODERROR	=> iCodError,
					NNOMPROCESO	=> iNomProceso,
					NNOMTABLA	=> iNomTabla,
					NTIPOID		=> v_TIPOID,
					NNUMID		=> v_NUMID,
					NDVID		=> v_DVID,
					NCODCLI		=> v_CODCLI,
					NERROR 		=> iError
				);
			END;
			END IF;
			CLOSE CUR_TERCERO_ROL_MIG;
		END IF;
		ROLLBACK;

		CLOSE CUR_CLIENTE_MIG;
		END IF;
	END LOOP;
END;