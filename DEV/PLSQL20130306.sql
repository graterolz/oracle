DECLARE
	CURSOR SINI_MIG
	IS
	SELECT
		RAMO,POLIZA,SERIE,RECLAM,ZONA,CERTIF,DIASIN,MESSIN,ANOSIN,DIANOT,MESNOT,ANONOT,DIACON,
		MESCON,ANOCON,SALDRE,SLDRAJ,NUMREC,CCLI1,CCLI2,CODAJU,TIPMON,TIPCAM,SLREFO,SLAJFO
	FROM SIPF01
	WHERE STATU IN (0,3)
	AND RAMO NOT IN (23,24,26)
	UNION ALL
	SELECT
		RAMO,POLIZA,SERIE,RECLAM,ZONA,CERTIF,DIASIN,MESSIN,ANOSIN,DIANOT,MESNOT,ANONOT,DIACON,
		MESCON,ANOCON,SALDRE,SLDRAJ,NUMREC,CCLI1,CCLI2,CODAJU,TIPMON,TIPCAM,SLREFO,SLAJFO
	FROM SIPF01
	WHERE STATU = 1
	AND SALDRE > 0
	AND RAMO NOT IN (23,24,26);
	--
	CURSOR DESCRIP10 (
		pRamo 		SIPF01.RAMO%TYPE,
		pPoliza 	SIPF01.POLIZA%TYPE,
		pSerie 		SIPF01.SERIE%TYPE,
		pReclam 	SIPF01.RECLAM%TYPE
	)
	IS
	SELECT RAMO,POLIZA,SERIE,RECLAM,CORRE,OBSER
	FROM SIPF10
	WHERE RAMO = pRamo
	AND POLIZA = pPoliza
	AND SERIE = pSerie
	AND RECLAM = pReclam
	ORDER BY RAMO,POLIZA,SERIE,RECLAM,CORRE;
	--
	CURSOR CUR_LOG_SINIESTRO_MIG (
		pRamo 		SIPF01.RAMO%TYPE,
		pPoliza 	SIPF01.POLIZA%TYPE,
		pSerie 		SIPF01.SERIE%TYPE,
		pReclam 	SIPF01.RECLAM%TYPE
	)
	IS
	SELECT * FROM LOG_SINIESTRO_MIG
	WHERE RAMOAS = pRamo
	AND POLIZAAS = pPoliza
	AND SERIE = pSerie
	AND RECLAMAS = pReclam;
	--
	RT_CUR_LOG_SINIESTRO_MIG	CUR_LOG_SINIESTRO_MIG%ROWTYPE;
	--
	CURSOR CUR_BUSCA_ZONA (pZona SIPF01.ZONA%TYPE)
	IS
	SELECT * FROM ACSEL.EQ_OFICINAS@CERT
	WHERE ZONCOB = pZona
	AND ROWNUM = 1;
	--
	RT_CUR_BUSCA_ZONA	CUR_BUSCA_ZONA%ROWTYPE;
	--
	CURSOR CUR_EQ_LOCALIDADES (pZona SIPF01.ZONA%TYPE)
	IS
	SELECT * FROM acsel.eq_localidades@cert
	WHERE ZONA_COBRO = pZona;
	--
	RT_CUR_EQ_LOCALIDADES	CUR_EQ_LOCALIDADES%ROWTYPE;
	--
	CURSOR CUR_LVAL (pCodLval ACSEL.LVAL.CODLVAL@CERT%TYPE)
	IS
	SELECT * FROM ACSEL.LVAL@CERT
	WHERE TIPOLVAL = 'TIPOID'
	AND CODLVAL = pCodLval;
	--
	RT_CUR_LVAL	CUR_LVAL%ROWTYPE;
	--
	CURSOR CUR_SIPF07 (
		pRamo 		SIPF07.RAMO%TYPE,
		pPoliza 	SIPF07.POLIZA%TYPE,
		pSerie 		SIPF07.SERIE%TYPE,
		pReclam 	SIPF07.RECLAM%TYPE
	)
	IS
	SELECT * FROM SIPF07
	WHERE RAMO = pRAmo
	AND POLIZA = pPoliza
	AND SERIE = pSerie
	AND RECLAM = pReclam
	AND codbe = 0
	AND ROWNUM = 1
	ORDER BY RAMO,POLIZA,SERIE,RECLAM,CODBE;
	--
	RT_CUR_SIPF07	CUR_SIPF07%ROWTYPE;
	--
	CURSOR CUR_SIPF90 (
		pRamo 		SIPF90.RAMO%TYPE,
		pPoliza 	SIPF90.POLIZA%TYPE,
		pSerie 		SIPF90.SERIE%TYPE,
		pReclam		SIPF90.RECLAM%TYPE
	)
	IS
	SELECT * FROM SIPF90
	WHERE RAMO = pRamo
	AND POLIZA = pPoliza
	AND SERIE = pSerie
	AND RECLAM = pReclam
	AND ROWNUM = 1
	ORDER BY RAMO,POLIZA,SERIE,RECLAM;
	--
	RT_CUR_SIPF90 	CUR_SIPF90%ROWTYPE;
	--
	CURSOR CUR_AMPF02 (
		pRamo 		SIPF90.RAMO%TYPE,
		pPoliza 	SIPF90.POLIZA%TYPE,
		pSerie 		SIPF90.SERIE%TYPE,
		pReclam 	SIPF90.RECLAM%TYPE
	)
	IS
	SELECT COUNT (*) AS CANTIDAD FROM AMPF02
	WHERE RAMO = pRamo
	AND POLIZA = pPoliza
	AND SERIE = pSerie
	AND RECLAM = pReclam;
	--
	RT_CUR_AMPF02	CUR_AMPF02%ROWTYPE;
	--
	CURSOR CUR_EQ_CAUSASIN (pRamo SIPF90.RAMO%TYPE)
	IS
	SELECT * FROM EQ_CAUSASIN
	WHERE RAMO = pRamo;
	--
	RT_CUR_EQ_CAUSASIN	CUR_EQ_CAUSASIN%ROWTYPE;
	--
	v_RAMO 		SIPF01.RAMO%TYPE;
	v_POLIZA 	SIPF01.POLIZA%TYPE;
	v_SERIE		SIPF01.SERIE%TYPE;
	v_RECLAM 	SIPF01.RECLAM%TYPE;
	v_ZONA		SIPF01.ZONA%TYPE;
	v_CERTIF	SIPF01.CERTIF%TYPE;
	v_DIASIN	SIPF01.DIASIN%TYPE;
	v_MESSIN	SIPF01.MESSIN%TYPE;
	v_ANOSIN 	SIPF01.ANOSIN%TYPE;
	v_DIANOT	SIPF01.DIANOT%TYPE;
	v_MESNOT	SIPF01.MESNOT%TYPE;
	v_ANONOT	SIPF01.ANONOT%TYPE;
	v_DIACON	SIPF01.DIACON%TYPE;
	v_MESCON	SIPF01.MESCON%TYPE;
	v_ANOCON	SIPF01.ANOCON%TYPE;
	v_SALDRE	SIPF01.SALDRE%TYPE;
	v_SLDRAJ	SIPF01.SLDRAJ%TYPE;
	v_NUMREC	SIPF01.NUMREC%TYPE;
	v_CCLI1		SIPF01.CCLI1%TYPE;
	v_CCLI2		SIPF01.CCLI2%TYPE;
	v_CODAJU	SIPF01.CODAJU%TYPE;
	v_TIPMON	SIPF01.TIPMON%TYPE;
	v_TIPCAM	SIPF01.TIPCAM%TYPE;
	v_SLREFO	SIPF01.SLREFO%TYPE;
	v_SLAJFO	SIPF01.SLAJFO%TYPE;
	--
	v_RAMOAS		EQ_SINIESTRO.RAMOAS%TYPE;
	v_POLIZAAS		EQ_SINIESTRO.POLIZAAS%TYPE;
	v_NUMCERTAS		EQ_SINIESTRO.NUMCERTAS%TYPE;
	v_NUMRECAS		EQ_SINIESTRO.NUMRECAS%TYPE;
	v_CODCOBAS		EQ_SINIESTRO.CODCOBAS%TYPE;
	v_RECLAMAS		EQ_SINIESTRO.RECLAMAS%TYPE;
	v_IDESIN		EQ_SINIESTRO.IDESIN%TYPE;
	v_IDEPOL		EQ_SINIESTRO.IDEPOL%TYPE;
	v_NUMCERT 		EQ_SINIESTRO.NUMCERT%TYPE;
	v_NUMSIN		EQ_SINIESTRO.NUMSIN%TYPE;
	vv_SERIE		EQ_SINIESTRO.SERIE%TYPE;
	v_CODCLI		EQ_SINIESTRO.CODCLI%TYPE;
	v_STSSIN		EQ_SINIESTRO.STSSIN%TYPE;
	v_FECSTS		EQ_SINIESTRO.FECSTS%TYPE;
	v_CODSIN		EQ_SINIESTRO.CODSIN%TYPE;
	v_FECOCURR		EQ_SINIESTRO.FECOCURR%TYPE;
	v_HORAOCURR		EQ_SINIESTRO.HORAOCURR%TYPE;
	v_FECNOTIF		EQ_SINIESTRO.FECNOTIF%TYPE;
	v_HORANOTIF		EQ_SINIESTRO.HORANOTIF%TYPE;
	v_FECONST		EQ_SINIESTRO.FECONST%TYPE;
	v_FECREGIST		EQ_SINIESTRO.FECREGIST%TYPE;
	v_HORAREGIST	EQ_SINIESTRO.HORAREGIST%TYPE;
	v_CODOFIRECEP	EQ_SINIESTRO.CODOFIRECEP%TYPE;
	v_CODOFIEMI		EQ_SINIESTRO.CODOFIEMI%TYPE;
	v_TIPOIDA		EQ_SINIESTRO.TIPOIDA%TYPE;
	v_NUMIDA		EQ_SINIESTRO.NUMIDA%TYPE;
	v_DVIDA			EQ_SINIESTRO.DVIDA%TYPE;
	v_NUMPLACA		EQ_SINIESTRO.NUMPLACA%TYPE;
	v_CODPAIS		EQ_SINIESTRO.CODPAIS%TYPE;
	v_CODESTADO		EQ_SINIESTRO.CODESTADO%TYPE;
	v_CODCIUDAD		EQ_SINIESTRO.CODCIUDAD%TYPE;
	v_CODMUNICIPIO	EQ_SINIESTRO.CODMUNICIPIO%TYPE;
	v_DIREC 		EQ_SINIESTRO.DIREC%TYPE;
	v_TEXTSIN		EQ_SINIESTRO.TEXTSIN%TYPE;
	v_SUCANOSIN		EQ_SINIESTRO.SUCANOSIN%TYPE;
	v_CODRAMOCERT	EQ_SINIESTRO.CODRAMOCERT%TYPE;
	v_CODAJUSTADOR	EQ_SINIESTRO.CODAJUSTADOR%TYPE;
	v_CAUSASIN		EQ_SINIESTRO.CAUSASIN%TYPE;
	v_CODANALISTA	EQ_SINIESTRO.CODANALISTA%TYPE;
	v_IDEBIEN		EQ_SINIESTRO.IDEBIEN%TYPE;
	v_IDEASEG		EQ_SINIESTRO.IDEASEG%TYPE;
	v_IDECOBERT		EQ_SINIESTRO.IDECOBERT%TYPE;
	v_IDERES		EQ_SINIESTRO.IDERES%TYPE;
	v_CODCOBERT		EQ_SINIESTRO.CODCOBERT%TYPE;
	v_FECRES		EQ_SINIESTRO.FECRES%TYPE;
	v_IDEREC		EQ_SINIESTRO.IDEREC%TYPE;
	v_CODMONEDA 	EQ_SINIESTRO.CODMONEDA%TYPE;
	v_PORCREEM		EQ_SINIESTRO.PORCREEM%TYPE;
	v_NUMMODRES		EQ_SINIESTRO.NUMMODRES%TYPE;
	v_FECMODRES		EQ_SINIESTRO.FECMODRES%TYPE;
	v_ORIGMODRES	EQ_SINIESTRO.ORIGMODRES%TYPE;
	v_CODCPTORES	EQ_SINIESTRO.CODCPTORES%TYPE;
	v_MTORES		EQ_SINIESTRO.MTORES%TYPE;
	v_MTORESMONEDA	EQ_SINIESTRO.MTORESMONEDA%TYPE;
	v_MTOFACTDO		EQ_SINIESTRO.MTOFACTDO%TYPE;
	v_MTOFACTDOMON	EQ_SINIESTRO.MTOFACTDOMONEDA%TYPE;
	v_MTODEDUC		EQ_SINIESTRO.MTODEDUC%TYPE;
	v_MTODEDUCMON	EQ_SINIESTRO.MTODEDUCMONEDA%TYPE;
	v_MIGRA			EQ_SINIESTRO.MIGRA%TYPE;
	v_ERROR			EQ_SINIESTRO.ERROR%TYPE;
	--
	lv_RAMOAS		LOG_SINIESTRO_MIG.RAMOAS%TYPE;
	lv_POLIZAAS		LOG_SINIESTRO_MIG.POLIZAAS%TYPE;
	lv_SERIE		LOG_SINIESTRO_MIG.SERIE%TYPE;
	lv_RECLAMAS		LOG_SINIESTRO_MIG.RECLAMAS%TYPE;
	lv_MIGRA		LOG_SINIESTRO_MIG.MIGRA%TYPE;
	lv_C_ERROR		LOG_SINIESTRO_MIG.C_ERROR%TYPE;
	lv_IDESIN		LOG_SINIESTRO_MIG.IDESIN%TYPE;
	lv_ESTATUS 		LOG_SINIESTRO_MIG.ESTATUS%TYPE;
	lv_FECESTATUS	LOG_SINIESTRO_MIG.FECESTATUS%TYPE;
	--
	SUBTYPE CampoNull IS VARCHAR2 (1);
	SUBTYPE CampoBool IS BOOLEAN;
	--
	iErrorGrave		CampoBool;
	iErrorGastos	CampoBool;
	iErrorWarning	CampoBool;
	iActualiza		CampoBool;
	ValidaNumero	CampoNull;
	iSldrajValido	CampoBool;
	iSlrefoValido	CampoBool;
	iSlajfoValido	CampoBool;
	--
	vTipoError		ERR_MIG_SINIESTRO.TIPOERROR%TYPE;
	vCodError		ERR_MIG_SINIESTRO.CODERROR%TYPE;
	vNomProceso		ERR_MIG_SINIESTRO.NOMPROCESO%TYPE;
	vNomTabla		ERR_MIG_SINIESTRO.NOMTABLA%TYPE;
	vObservaciones	ERR_MIG_SINIESTRO.OBSERVACIONES%TYPE;
	--
	v_CERTIFAS		SIPF01.CERTIF%TYPE;
	NUMID_AF		VARCHAR2 (10);
BEGIN
	FOR I IN SINI_MIG
	LOOP
		iErrorGrave := FALSE;
		iErrorGastos := FALSE;
		iErrorWarning := FALSE;
		vTipoError := 'ERR-SIN-CARGA-BASE';
		vNomProceso := 'CARGA_BASICA_SINIESTROS';
		vNomTabla := 'SIPF1';
		--
		v_RAMO := I.RAMO;
		v_POLIZA := I.POLIZA;
		v_SERIE := I.SERIE;
		v_RECLAM := I.RECLAM;
		v_ZONA := I.ZONA;
		v_CERTIF := I.CERTIF;
		v_DIASIN := I.DIASIN;
		v_MESSIN := I.MESSIN;
		v_ANOSIN := I.ANOSIN;
		v_DIANOT := I.DIANOT;
		v_MESNOT := I.MESNOT;
		v_ANONOT := I.ANONOT;
		v_DIACON := I.DIACON;
		v_MESCON := I.MESCON;
		v_ANOCON := I.ANOCON;
		v_SALDRE := I.SALDRE;
		v_SLDRAJ := I.SLDRAJ;
		v_NUMREC := I.NUMREC;
		v_CCLI1 := I.CCLI1;
		v_CCLI2 := I.CCLI2;
		v_CODAJU := I.CODAJU;
		v_TIPMON := I.TIPMON;
		v_TIPCAM := I.TIPCAM;
		v_SLREFO := I.SLREFO;
		v_SLAJFO := I.SLAJFO;
		--
		v_RAMOAS := 0;
		v_POLIZAAS := 0;
		v_NUMCERTAS := NULL;
		v_NUMRECAS := NULL;
		v_CODCOBAS := NULL;
		v_RECLAMAS := 0;
		v_IDESIN := NULL;
		v_IDEPOL := NULL;
		v_NUMCERT := NULL;
		v_NUMSIN := NULL;
		vv_SERIE := 0;
		v_CODCLI := NULL;
		v_STSSIN := NULL;
		v_FECSTS := NULL;
		v_CODSIN := NULL;
		v_FECOCURR := NULL;
		v_HORAOCURR := NULL;
		v_FECNOTIF := NULL;
		v_HORANOTIF := NULL;
		v_FECONST := NULL;
		v_FECREGIST := NULL;
		v_HORAREGIST := NULL;
		v_CODOFIRECEP := NULL;
		v_CODOFIEMI := NULL;
		v_TIPOIDA := NULL;
		v_NUMIDA := NULL;
		v_DVIDA := NULL;
		v_NUMPLACA := NULL;
		v_CODPAIS := NULL;
		v_CODESTADO := NULL;
		v_CODCIUDAD := NULL;
		v_CODMUNICIPIO := NULL;
		v_DIREC := NULL;
		v_TEXTSIN := NULL;
		v_SUCANOSIN := NULL;
		v_CODRAMOCERT := NULL;
		v_CODAJUSTADOR := NULL;
		v_CAUSASIN := NULL;
		v_CODANALISTA := NULL;
		v_IDEBIEN := NULL;
		v_IDEASEG := NULL;
		v_IDECOBERT := NULL;
		v_IDERES := NULL;
		v_CODCOBERT := NULL;
		v_FECRES := NULL;
		v_IDEREC := NULL;
		v_CODMONEDA := NULL;
		v_PORCREEM := NULL;
		v_NUMMODRES := NULL;
		v_FECMODRES := NULL;
		v_ORIGMODRES := NULL;
		v_CODCPTORES := NULL;
		v_MTORES := NULL;
		v_MTORESMONEDA := NULL;
		v_MTOFACTDO := NULL;
		v_MTOFACTDOMON := NULL;
		v_MTODEDUC := NULL;
		v_MTODEDUCMON := NULL;
		v_MIGRA := NULL;
		v_ERROR := NULL;
		--
		BEGIN
			SELECT 'x' INTO ValidaNumero
			FROM DUAL
			WHERE TRANSLATE (v_RAMO,'T_0123456789 +-.,;:*!¡=/\()%^[]','T') IS NOT NULL
			OR TRIM (v_RAMO) IS NULL;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			ValidaNumero := NULL;
		END;
		--
		IF (ValidaNumero IS NOT NULL) THEN
			vCodError := '001';
			iActualiza := FALSE;
			vObservaciones := 'Ramo No numerico';
			--
			MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
				nTipoError => vTipoError,
				nCodError => vCodError,
				nNomProceso => vNomProceso,
				nNomTabla => vNomTabla,
				nRamo => v_RAMO,
				nPoliza => v_POLIZA,
				nSerie => v_SERIE,
				nReclam => v_RECLAM,
				cObservaciones => vObservaciones
			);
			iErrorGrave := TRUE;
		ELSE
			v_RAMOAS := v_RAMO;
		END IF;
		--
		BEGIN
			SELECT 'x' INTO ValidaNumero
			FROM DUAL
			WHERE TRANSLATE (v_POLIZA,'T_0123456789 +-.,;:*!¡=/\()%^[]','T') IS NOT NULL
			OR TRIM (v_POLIZA) IS NULL;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			ValidaNumero := NULL;
		END;
		--
		IF (ValidaNumero IS NOT NULL) THEN
			vCodError := '001';
			iActualiza := FALSE;
			vObservaciones := 'Poliza No numerica';
			--
			MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
				nTipoError => vTipoError,
				nCodError => vCodError,
				nNomProceso => vNomProceso,
				nNomTabla => vNomTabla,
				nRamo => v_RAMO,
				nPoliza => v_POLIZA,
				nSerie => v_SERIE,
				nReclam => v_RECLAM,
				cObservaciones => vObservaciones
			);
			iErrorGrave := TRUE;
		ELSE
			v_POLIZAAS := v_POLIZA;
		END IF;
		--
		BEGIN
			SELECT 'x' INTO ValidaNumero
			FROM DUAL
			WHERE TRANSLATE (v_SERIE,'T_0123456789 +-.,;:*!¡=/\()%^[]','T') IS NOT NULL
			OR TRIM (v_SERIE) IS NULL;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			ValidaNumero := NULL;
		END;
		--
		IF (ValidaNumero IS NOT NULL) THEN
			vCodError := '001';
			iActualiza := FALSE;
			vObservaciones := 'Serie No numerica';
			--
			MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
				nTipoError => vTipoError,
				nCodError => vCodError,
				nNomProceso => vNomProceso,
				nNomTabla => vNomTabla,
				nRamo => v_RAMO,
				nPoliza => v_POLIZA,
				nSerie => v_SERIE,
				nReclam => v_RECLAM,
				cObservaciones => vObservaciones
			);
			iErrorGrave := TRUE;
		ELSE
			vv_SERIE := v_SERIE;
		END IF;
		--
		BEGIN
			SELECT 'x' INTO ValidaNumero
			FROM DUAL
			WHERE TRANSLATE (v_SERIE,'T_0123456789 +-.,;:*!¡=/\()%^[]','T') IS NOT NULL
			OR TRIM (v_SERIE) IS NULL;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			ValidaNumero := NULL;
		END;
		--
		IF (ValidaNumero IS NOT NULL) THEN
			vCodError := '001';
			iActualiza := FALSE;
			vObservaciones := 'Reclam (Numero de Siniestro) No numerico';
			--
			MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
				nTipoError => vTipoError,
				nCodError => vCodError,
				nNomProceso => vNomProceso,
				nNomTabla => vNomTabla,
				nRamo => v_RAMO,
				nPoliza => v_POLIZA,
				nSerie => v_SERIE,
				nReclam => v_RECLAM,
				cObservaciones => vObservaciones
			);
			iErrorGrave := TRUE;
		ELSE
			v_RECLAMAS := v_RECLAM;			
		END IF;
		--
		OPEN CUR_LOG_SINIESTRO_MIG (v_RAMO,v_POLIZA,v_SERIE,v_RECLAM);
		FETCH CUR_LOG_SINIESTRO_MIG INTO RT_CUR_LOG_SINIESTRO_MIG;

		IF CUR_LOG_SINIESTRO_MIG%FOUND THEN
			IF RT_CUR_LOG_SINIESTRO_MIG.ESTATUS = 'ENP' THEN
				vCodError := '002';
				iActualiza := FALSE;
				vObservaciones :=  'Siniestro en Proceso,no puede cargarse en EQ_SINIESTROS';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorGrave := TRUE;
			ELSIF RT_CUR_LOG_SINIESTRO_MIG.ESTATUS = 'MIG' THEN
				vCodError := '002';
				iActualiza := FALSE;
				vObservaciones := 'Siniestro esta en MIGRADO';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorGrave := TRUE;
			END IF;
		END IF;
		CLOSE CUR_LOG_SINIESTRO_MIG;
		--
		BEGIN
			SELECT 'x' INTO ValidaNumero
			FROM DUAL
			WHERE TRANSLATE (v_ZONA,'T_0123456789 +-.,;:*!¡=/\()%^[]','T') IS NOT NULL
			OR TRIM (v_ZONA) IS NULL;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			ValidaNumero := NULL;
		END;
		--
		IF (ValidaNumero IS NOT NULL) THEN
			vCodError := '001';
			iActualiza := FALSE;
			vObservaciones := 'Campo ZONA no es numerico se colocara 999999 a CODIOFIRECEP';
			--
			MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
				nTipoError => vTipoError,
				nCodError => vCodError,
				nNomProceso => vNomProceso,
				nNomTabla => vNomTabla,
				nRamo => v_RAMO,
				nPoliza => v_POLIZA,
				nSerie => v_SERIE,
				nReclam => v_RECLAM,
				cObservaciones => vObservaciones
			);
			iErrorWarning := TRUE;
			v_CODOFIRECEP := '999999';
		ELSE
			OPEN CUR_BUSCA_ZONA (v_ZONA);
			FETCH CUR_BUSCA_ZONA INTO RT_CUR_BUSCA_ZONA;

			IF CUR_BUSCA_ZONA%FOUND THEN
				v_CODOFIRECEP := RT_CUR_BUSCA_ZONA.CODOFI;
			ELSE
				v_CODOFIRECEP := '999999';
				vCodError := '006';
				iActualiza := FALSE;
				vObservaciones :=  'Zona sin equivalencia en ACSEL.EQ_OFICINAS@CERT';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorWarning := TRUE;
			END IF;
			CLOSE CUR_BUSCA_ZONA;
			--
			OPEN CUR_EQ_LOCALIDADES (v_ZONA);
			FETCH CUR_EQ_LOCALIDADES INTO RT_CUR_EQ_LOCALIDADES;

			IF CUR_EQ_LOCALIDADES%FOUND THEN
				v_CODPAIS := RT_CUR_EQ_LOCALIDADES.CODPAIS;
				v_CODESTADO := RT_CUR_EQ_LOCALIDADES.CODESTADO;
				v_CODCIUDAD := RT_CUR_EQ_LOCALIDADES.CODCIUDAD;
				v_CODMUNICIPIO := RT_CUR_EQ_LOCALIDADES.CODMUNICIPIO;
			ELSE
				v_CODPAIS := '001';
				v_CODESTADO := '999';
				v_CODCIUDAD := '999';
				v_CODMUNICIPIO := '999';
				vCodError := '006';
				iActualiza := FALSE;
				vObservaciones :=  'Zona sin equivalencia en ACSEL.EQ_OFICINAS@CERT';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorWarning := TRUE;
			END IF;
			CLOSE CUR_EQ_LOCALIDADES;
		END IF;
		--
		BEGIN
			SELECT 'x' INTO ValidaNumero
			FROM DUAL
			WHERE TRANSLATE (v_CERTIF,'T_0123456789 +-.,;:*!¡=/\()%^[]','T') IS NOT NULL
			OR TRIM (v_CERTIF) IS NULL;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			ValidaNumero := NULL;
		END;
		--
		IF (ValidaNumero IS NOT NULL) THEN
			vCodError := '001';
			iActualiza := TRUE;
			vObservaciones := 'Certificado AS No Numerico';
			--
			MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
				nTipoError => vTipoError,
				nCodError => vCodError,
				nNomProceso => vNomProceso,
				nNomTabla => vNomTabla,
				nRamo => v_RAMO,
				nPoliza => v_POLIZA,
				nSerie => v_SERIE,
				nReclam => v_RECLAM,
				cObservaciones => vObservaciones
			);
			iErrorWarning := TRUE;
		ELSE
			v_CERTIFAS := v_CERTIF;
		END IF;
		--
		BEGIN
			SELECT TO_DATE (TO_CHAR (v_DIASIN || '/' || v_MESSIN || '/' || v_ANOSIN),'DD/MM/YYYY')
			INTO v_FECOCURR
			FROM DUAL;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			v_FECOCURR := NULL;
		END;
		--
		IF (v_FECOCURR IS NULL) THEN
			vCodError := '003';
			iActualiza := FALSE;
			vObservaciones := 'Campos DIASIN,MESSIN,ANOSIN no forman una fecha logica,no se puede obtener la fecha de Ocurrencia';
			--
			MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
				nTipoError => vTipoError,
				nCodError => vCodError,
				nNomProceso => vNomProceso,
				nNomTabla => vNomTabla,
				nRamo => v_RAMO,
				nPoliza => v_POLIZA,
				nSerie => v_SERIE,
				nReclam => v_RECLAM,
				cObservaciones => vObservaciones
			);
			iErrorWarning := TRUE;
		END IF;
		--
		BEGIN
			SELECT TO_DATE (TO_CHAR (v_DIANOT || '/' || v_MESNOT || '/' || v_ANONOT),'DD/MM/YYYY')
			INTO v_FECNOTIF
			FROM DUAL;
			--
			v_FECREGIST := v_FECNOTIF;
			--
			IF (v_FECNOTIF < v_FECOCURR) THEN
				vCodError := '003';
				iActualiza := TRUE;
				vObservaciones :=  'Fecha de Ocurrencia menor a la Fecha de notificacion';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorWarning := TRUE;
				v_FECNOTIF := TO_DATE (v_FECOCURR,'DD/MM/YYYY') + 4;
			END IF;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			v_FECNOTIF := NULL;
			v_FECREGIST := NULL;
		END;
		--
		IF (v_FECNOTIF IS NULL) THEN
			vCodError := '003';
			iActualiza := TRUE;
			vObservaciones :='Campos DIANOT,MESNOT,ANONOT no forman una fecha logica.';
			--
			MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
				nTipoError => vTipoError,
				nCodError => vCodError,
				nNomProceso => vNomProceso,
				nNomTabla => vNomTabla,
				nRamo => v_RAMO,
				nPoliza => v_POLIZA,
				nSerie => v_SERIE,
				nReclam => v_RECLAM,
				cObservaciones => vObservaciones
			);
			iErrorWarning := TRUE;
		END IF;
		--
		BEGIN
			SELECT TO_DATE (TO_CHAR (v_DIACON || '/' || v_MESCON || '/' || v_ANOCON),'DD/MM/YYYY')
			INTO v_FECONST
			FROM DUAL;
			--
			IF (v_FECONST < v_FECNOTIF) THEN
				v_FECONST := v_FECNOTIF;
			END IF;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				v_FECONST := NULL;
			END;
			--
			IF (v_FECONST IS NULL) THEN
				vCodError := '003';
				iActualiza := TRUE;
				vObservaciones := 'Campos DIACON,MESCON,ANOCON no forman una fecha logica.';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorWarning := TRUE;
				v_FECONST := v_FECNOTIF;
			END IF;
			--
			BEGIN
				SELECT 'x' INTO ValidaNumero
				FROM DUAL
				WHERE TRANSLATE (v_SALDRE,'T_0123456789 +-.,;:*!¡=/\()%^[]','T') IS NOT NULL
				OR TRIM (v_SALDRE) IS NULL;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				ValidaNumero := NULL;
			END;
			--
			IF (ValidaNumero IS NOT NULL) THEN
				vCodError := '001';
				iActualiza := FALSE;
				vObservaciones := 'Siniestro SALDRE no numerico';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorGrave := TRUE;
			ELSE
				IF v_SALDRE < 0 THEN
					vCodError := '004';
					iActualiza := FALSE;
					vObservaciones := 'Siniestro con reserva total (SALDRE) negativa';
					--
					MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
						nTipoError => vTipoError,
						nCodError => vCodError,
						nNomProceso => vNomProceso,
						nNomTabla => vNomTabla,
						nRamo => v_RAMO,
						nPoliza => v_POLIZA,
						nSerie => v_SERIE,
						nReclam => v_RECLAM,
						cObservaciones => vObservaciones
					);
					iErrorGrave := TRUE;
				END IF;
			END IF;
			--
			BEGIN
				SELECT 'x' INTO ValidaNumero
				FROM DUAL
				WHERE TRANSLATE (v_SALDRE,'T_0123456789 +-.,;:*!¡=/\()%^[]','T') IS NOT NULL
				OR TRIM (v_SALDRE) IS NULL;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				ValidaNumero := NULL;
			END;
			--
			iSldrajValido := TRUE;
			--
			IF (ValidaNumero IS NOT NULL) THEN
				iSldrajValido := FALSE;
				vCodError := '001';
				iActualiza := FALSE;
				vObservaciones := 'Saldo de reserva para ajustador SLDRAJ no es numerico';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorGrave := TRUE;
			ELSE
				IF (v_SLDRAJ < 0) THEN
					iSldrajValido := FALSE;
					vCodError := '005';
					iActualiza := FALSE;
					vObservaciones :=  'Siniestro con reserva de ajuste (SLDRAJ) negativo';
					--
					MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
						nTipoError => vTipoError,
						nCodError => vCodError,
						nNomProceso => vNomProceso,
						nNomTabla => vNomTabla,
						nRamo => v_RAMO,
						nPoliza => v_POLIZA,
						nSerie => v_SERIE,
						nReclam => v_RECLAM,
						cObservaciones => vObservaciones
					);
					iErrorGrave := TRUE;
				END IF;
			END IF;
			--
			BEGIN
				SELECT 'x' INTO ValidaNumero
				FROM DUAL
				WHERE TRANSLATE (v_NUMREC,'T_0123456789 +-.,;:*!¡=/\()%^[]','T') IS NOT NULL
				OR TRIM (v_NUMREC) IS NULL;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				ValidaNumero := NULL;
			END;
			--
			IF (ValidaNumero IS NOT NULL) THEN
				vCodError := '001';
				iActualiza := FALSE;
				vObservaciones := 'Numero de recibo no es numerico y sin este dato no es posible ubicar IDEREC';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorGrave := TRUE;
			ELSE
				v_NUMRECAS := v_NUMREC;
			END IF;
			--
			OPEN CUR_LVAL (v_CCLI1);
			FETCH CUR_LVAL INTO RT_CUR_LVAL;

			IF CUR_LVAL%FOUND THEN
				v_TIPOIDA := v_CCLI1;
			ELSE
				vCodError := '006';
				iActualiza := TRUE;
				vObservaciones := 'CCLI1 no existe en el lval TIPOID';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorWarning := TRUE;
			END IF;
			CLOSE CUR_LVAL;
			--
			BEGIN
				SELECT 'x' INTO ValidaNumero
				FROM DUAL
				WHERE TRANSLATE (v_CCLI2,'T_0123456789 +-.,;:*!¡=/\()%^[]','T') IS NOT NULL
				OR TRIM (v_CCLI2) IS NULL;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				ValidaNumero := NULL;
			END;
			--
			IF (ValidaNumero IS NOT NULL) THEN
				vCodError := '001';
				iActualiza := TRUE;
				vObservaciones := 'CCLI2 no es numerico,se utilizara el CODCLI de la poliza afectada para determinar el cliente.';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones	=> vObservaciones
				);
				iErrorWarning := TRUE;
			ELSE
				v_NUMIDA := v_CCLI2;
			END IF;
			--
			BEGIN
				SELECT 'x' INTO ValidaNumero
				FROM DUAL
				WHERE TRANSLATE (v_CODAJU,'T_0123456789 +-.,;:*!¡=/\()%^[]','T') IS NOT NULL
				OR TRIM (v_CODAJU) IS NULL;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				ValidaNumero := NULL;
			END;
			--
			IF (ValidaNumero IS NOT NULL) THEN
				vCodError := '001';
				iActualiza := TRUE;
				vObservaciones := 'Codigo de ajustador no numerico,se movera cero para procesar';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorWarning := TRUE;
			ELSE IF (v_CODAJU = 0) THEN
				v_CODAJUSTADOR := v_CODAJU;
			END IF;
			--
			IF (TRIM (v_TIPMON) IN (NULL,'BS')) THEN
				v_CODMONEDA := 'BS';
			ELSIF (v_TIPMON = 'DO') THEN
				v_CODMONEDA := 'DL';
			ELSE
				vCodError := '007';
				iActualiza := TRUE;
				vObservaciones := 'Moneda del siniestro desconocida,se tomara la de la poliza afectada';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorWarning := TRUE;
			END IF;
			--
			iSlrefoValido := TRUE;
			--
			BEGIN
				SELECT 'x' INTO ValidaNumero
				FROM DUAL
				WHERE TRANSLATE (v_SLREFO,'T_0123456789 +-.,;:*!¡=/\()%^[]','T') IS NOT NULL
				OR TRIM (v_SLREFO) IS NULL;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				ValidaNumero := NULL;
			END;
			--
			IF (ValidaNumero IS NOT NULL) THEN
				vCodError := '005';
				iActualiza := FALSE;
				vObservaciones := 'Siniestro con reserva de asegurado en moneda foranea (SLAJFO) no numerica';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones	=> vObservaciones
				);
				iErrorGrave := TRUE;
				iSlrefoValido := FALSE;
			ELSE
				IF (v_SLREFO >= 0) THEN
					v_MTORESMONEDA := v_SLREFO;
					v_MTOFACTDOMON := v_SLREFO;
				ELSE
					vCodError := '005';
					iActualiza := FALSE;
					vObservaciones := 'Siniestro con reserva de asegurado en moneda foranea (SLAJFO) negativa';
					--
					MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
						nTipoError => vTipoError,
						nCodError => vCodError,
						nNomProceso => vNomProceso,
						nNomTabla => vNomTabla,
						nRamo => v_RAMO,
						nPoliza => v_POLIZA,
						nSerie => v_SERIE,
						nReclam => v_RECLAM,
						cObservaciones => vObservaciones
					);
					iErrorGrave := TRUE;
					iSlrefoValido := FALSE;
				END IF;
			END IF;
			--
			iSlajfoValido := TRUE;
			--
			BEGIN
				SELECT 'x' INTO ValidaNumero
				FROM DUAL
				WHERE TRANSLATE (v_SLAJFO,'T_0123456789 +-.,;:*!¡=/\()%^[]','T') IS NOT NULL
				OR TRIM (v_SLAJFO) IS NULL;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				ValidaNumero := NULL;
			END;
			--
			IF (ValidaNumero IS NOT NULL) THEN
				vCodError := '001';
				iActualiza := FALSE;
				vObservaciones := 'Saldo de reserva para ajustador SLAJFO no es numerico';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorGrave := TRUE;
				iSlajfoValido := FALSE;
			ELSE
				IF (v_SLAJFO < 0) THEN
					vCodError := '005';
					iActualiza := FALSE;
					vObservaciones :=  'Siniestro con reserva de ajustador en moneda extranjera (SLAJFO) negativo';
					--
					MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
						nTipoError => vTipoError,
						nCodError => vCodError,
						nNomProceso => vNomProceso,
						nNomTabla => vNomTabla,
						nRamo => v_RAMO,
						nPoliza => v_POLIZA,
						nSerie => v_SERIE,
						nReclam => v_RECLAM,
						cObservaciones => vObservaciones
					);
					iSlajfoValido := FALSE;
				END IF;
			END IF;
			--
			v_STSSIN := 'ACT';
			v_FECSTS := SYSDATE;
			v_FECONST := SYSDATE;
			v_FECRES := SYSDATE;
			v_FECMODRES := SYSDATE;
			v_HORAOCURR := TO_DATE (SYSDATE || ' 12:00','DD/MM/YYYY HH:MI');
			v_HORANOTIF := TO_DATE (SYSDATE || ' 12:00','DD/MM/YYYY HH:MI');
			v_HORAREGIST := TO_DATE (SYSDATE || ' 12:00','DD/MM/YYYY HH:MI');
			v_CODANALISTA := 'MIGRA';
			v_PORCREEM := 100;
			v_MTODEDUC := 0;
			v_MTODEDUCMON := 0;
			--
			OPEN CUR_SIPF07 (v_RAMOAS,v_POLIZAAS,vv_SERIE,v_RECLAMAS);
			FETCH CUR_SIPF07 INTO RT_CUR_SIPF07;

			IF CUR_SIPF07%FOUND THEN
				v_CODCOBAS := TO_CHAR (RT_CUR_SIPF07.CODCOB);
			ELSE
				vCodError := '008';
				iActualiza := FALSE;
				vObservaciones := 'Siniestro (ramo,poliza,serie,reclam) no tiene coberturas afectadas en SIPF07';
				--
				MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
					nTipoError => vTipoError,
					nCodError => vCodError,
					nNomProceso => vNomProceso,
					nNomTabla => vNomTabla,
					nRamo => v_RAMO,
					nPoliza => v_POLIZA,
					nSerie => v_SERIE,
					nReclam => v_RECLAM,
					cObservaciones => vObservaciones
				);
				iErrorGrave := TRUE;
			END IF;
			CLOSE CUR_SIPF07;
			--
			IF (v_RAMOAS IN (31,32,33,34,35)) THEN
				OPEN CUR_SIPF90 (v_RAMOAS,v_POLIZAAS,vv_SERIE,v_RECLAMAS);
				FETCH CUR_SIPF90 INTO RT_CUR_SIPF90;

				IF CUR_SIPF90%FOUND THEN
					v_DIREC := RT_CUR_SIPF90.LUGOCU;
					IF (LENGTH (
						TRIM (
							RT_CUR_SIPF90.DESAC1||' '||
							RT_CUR_SIPF90.DESAC5||' '||
							RT_CUR_SIPF90.DANAC1||' '||
							RT_CUR_SIPF90.DANAC5
						)) <= 4000) THEN
						v_TEXTSIN := TRIM (
							RT_CUR_SIPF90.DESAC1||' '||
							RT_CUR_SIPF90.DESAC5||' '||
							RT_CUR_SIPF90.DANAC1||' '||
							RT_CUR_SIPF90.DANAC5
						);
					END IF;
				ELSE
					vCodError := '009';
					iActualiza := TRUE;
					vObservaciones :=  'Siniestro sin registro en la SIPF90,por lo tanto no tiene ni descripcion ni lugar de ocurrencia';
					--
					MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
						nTipoError => vTipoError,
						nCodError => vCodError,
						nNomProceso => vNomProceso,
						nNomTabla => vNomTabla,
						nRamo => v_RAMO,
						nPoliza => v_POLIZA,
						nSerie => v_SERIE,
						nReclam => v_RECLAM,
						cObservaciones => vObservaciones
					);
					iErrorGrave := TRUE;
					v_TEXTSIN := 'Sin descripcion';
					v_DIREC := 'Sin direccion';
				END IF;
				CLOSE CUR_SIPF90;
			ELSE
				v_DIREC := 'Sin direccion';
				--
				FOR X IN DESCRIP10 (v_RAMOAS,v_POLIZAAS,v_RECLAMAS,vv_SERIE)
				LOOP
					v_TEXTSIN := v_TEXTSIN || ' ' || X.OBSER;
				END LOOP;
				--
				IF (TRIM (v_TEXTSIN) IS NULL) THEN
					v_TEXTSIN := 'Sin descripcion';
					vCodError := '010';
					iActualiza := TRUE;
					vObservaciones := 'Siniestro sin descripcion en la SIPF10';
					--
					MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
						nTipoError => vTipoError,
						nCodError => vCodError,
						nNomProceso => vNomProceso,
						nNomTabla => vNomTabla,
						nRamo => v_RAMO,
						nPoliza => v_POLIZA,
						nSerie => v_SERIE,
						nReclam => v_RECLAM,
						cObservaciones => vObservaciones
					);
					iErrorWarning := TRUE;
				END IF;
			END IF;
			--
			IF (v_RAMO IN (2,3,10,21,27)) THEN
				OPEN CUR_AMPF02 (v_RAMOAS,v_POLIZAAS,vv_SERIE,v_RECLAMAS);
				FETCH CUR_AMPF02 INTO RT_CUR_AMPF02;

				IF CUR_AMPF02%FOUND THEN
					IF RT_CUR_AMPF02.CANTIDAD = 1 THEN
						SELECT CEDPAC INTO NUMID_AF
						FROM AMPF02
						WHERE RAMO = v_RAMOAS
						AND POLIZA = v_POLIZAAS
						AND SERIE = vv_SERIE
						AND RECLAM = v_RECLAMAS;
					ELSE
						vCodError := '013';
						iActualiza := FALSE;
						vObservaciones := 'Siniestro es del ramo de personas y existe mas de un registro en AMPF02 para el mismo siniestro';
						--
						MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
							nTipoError => vTipoError,
							nCodError => vCodError,
							nNomProceso => vNomProceso,
							nNomTabla => vNomTabla,
							nRamo => v_RAMO,
							nPoliza => v_POLIZA,
							nSerie => v_SERIE,
							nReclam => v_RECLAM,
							cObservaciones	=> vObservaciones
						); 
						iErrorGrave := TRUE;
					END IF;
				ELSE
					vCodError := '013';
					iActualiza := FALSE;
					vObservaciones :=  'Siniestro es del ramo de personas y no tiene registros en AMPF02,revisar';
					--
					MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
						nTipoError => vTipoError,
						nCodError => vCodError,
						nNomProceso => vNomProceso,
						nNomTabla => vNomTabla,
						nRamo => v_RAMO,
						nPoliza => v_POLIZA,
						nSerie => v_SERIE,
						nReclam => v_RECLAM,
						cObservaciones => vObservaciones
					);
					iErrorGrave := TRUE;
				END IF;
				CLOSE CUR_AMPF02;
			END IF;
			--
			IF (iSldrajValido = TRUE AND iSlajfoValido = TRUE) THEN
				IF (v_SLDRAJ = 0 AND v_SLAJFO <> 0) OR (v_SLDRAJ <> 0 AND v_SLAJFO = 0) THEN
					vCodError := '011';
					iActualiza := FALSE;
					vObservaciones := 'Campo SLDRAJ y SLAJFO son inconsistentes entre si,uno es cero y el otro mayor a cero';
					--
					MIG_SINIESTRO.GENERA_ERROR_CARTERA_SIN (
						nTipoError => vTipoError,
						nCodError => vCodError,
						nNomProceso => vNomProceso,
						nNomTabla => vNomTabla,
						nRamo => v_RAMO,
						nPoliza => v_POLIZA,
						nSerie => v_SERIE,
						nReclam => v_RECLAM,
						cObservaciones => vObservaciones
					);
					iErrorGrave := TRUE;
				END IF;
			END IF;
			--
			IF (iErrorGrave = FALSE) THEN
				v_NUMMODRES := 0;
				--
				BEGIN
					INSERT INTO EQ_SINIESTRO (
						RAMOAS,POLIZAAS,NUMCERTAS,NUMRECAS,CODCOBAS,RECLAMAS,IDESIN,IDEPOL,NUMCERT,NUMSIN,SERIE,CODCLI,
						STSSIN,FECSTS,CODSIN,FECOCURR,HORAOCURR,FECNOTIF,HORANOTIF,FECONST,FECREGIST,HORAREGIST,CODOFIRECEP,
						CODOFIEMI,TIPOIDA,NUMIDA,DVIDA,NUMPLACA,CODPAIS,CODESTADO,CODCIUDAD,CODMUNICIPIO,DIREC,TEXTSIN,
						SUCANOSIN,CODRAMOCERT,CODAJUSTADOR,CAUSASIN,CODANALISTA,IDEBIEN,IDEASEG,IDECOBERT,IDERES,CODCOBERT,
						FECRES,IDEREC,CODMONEDA,PORCREEM,NUMMODRES,FECMODRES,ORIGMODRES,CODCPTORES,MTORES,MTORESMONEDA,
						MTOFACTDO,MTOFACTDOMONEDA,MTODEDUC,MTODEDUCMONEDA,MIGRA,ERROR
					)
					VALUES (
						v_RAMOAS,v_POLIZAAS,v_NUMCERTAS,v_NUMRECAS,v_CODCOBAS,v_RECLAMAS,v_IDESIN,v_IDEPOL,v_NUMCERT,v_NUMSIN,vv_SERIE,
						v_CODCLI,v_STSSIN,v_FECSTS,v_CODSIN,v_FECOCURR,v_HORAOCURR,v_FECNOTIF,v_HORANOTIF,v_FECONST,v_FECREGIST,v_HORAREGIST,
						v_CODOFIRECEP,v_CODOFIEMI,v_TIPOIDA,v_NUMIDA,v_DVIDA,v_NUMPLACA,v_CODPAIS,v_CODESTADO,v_CODCIUDAD,v_CODMUNICIPIO,
						v_DIREC,v_TEXTSIN,v_SUCANOSIN,v_CODRAMOCERT,v_CODAJUSTADOR,v_CAUSASIN,v_CODANALISTA,v_IDEBIEN,v_IDEASEG,v_IDECOBERT,
						v_IDERES,v_CODCOBERT,v_FECRES,v_IDEREC,v_CODMONEDA,v_PORCREEM,v_NUMMODRES,v_FECMODRES,v_ORIGMODRES,v_CODCPTORES,
						v_MTORES,v_MTORESMONEDA,v_MTOFACTDO,v_MTOFACTDOMON,v_MTODEDUC,v_MTODEDUCMON,v_MIGRA,v_ERROR
					);
					COMMIT;
				EXCEPTION WHEN OTHERS THEN
					NULL;
				END;
				--
				IF (v_SLDRAJ > 0) THEN
					v_MTORES := v_SLDRAJ;
					v_MTORESMONEDA := v_SLAJFO;
					v_CODCOBAS := '0';
					v_ORIGMODRES := 'O';
					--
					BEGIN
						INSERT INTO EQ_SINIESTRO (
							RAMOAS,POLIZAAS,NUMCERTAS,NUMRECAS,CODCOBAS,RECLAMAS,IDESIN,IDEPOL,NUMCERT,NUMSIN,SERIE,CODCLI,STSSIN,FECSTS,CODSIN,
							FECOCURR,HORAOCURR,FECNOTIF,HORANOTIF,FECONST,FECREGIST,HORAREGIST,CODOFIRECEP,CODOFIEMI,TIPOIDA,NUMIDA,DVIDA,NUMPLACA,
							CODPAIS,CODESTADO,CODCIUDAD,CODMUNICIPIO,DIREC,TEXTSIN,SUCANOSIN,CODRAMOCERT,CODAJUSTADOR,CAUSASIN,CODANALISTA,IDEBIEN,
							IDEASEG,IDECOBERT,IDERES,CODCOBERT,FECRES,IDEREC,CODMONEDA,PORCREEM,NUMMODRES,FECMODRES,ORIGMODRES,CODCPTORES,MTORES,
							MTORESMONEDA,MTOFACTDO,MTOFACTDOMONEDA,MTODEDUC,MTODEDUCMONEDA,MIGRA,ERROR
						)
						VALUES (
							v_RAMOAS,v_POLIZAAS,v_NUMCERTAS,v_NUMRECAS,v_CODCOBAS,v_RECLAMAS,v_IDESIN,v_IDEPOL,v_NUMCERT,v_NUMSIN,vv_SERIE,v_CODCLI,
							v_STSSIN,v_FECSTS,v_CODSIN,v_FECOCURR,v_HORAOCURR,v_FECNOTIF,v_HORANOTIF,v_FECONST,v_FECREGIST,v_HORAREGIST,v_CODOFIRECEP,
							v_CODOFIEMI,v_TIPOIDA,v_NUMIDA,v_DVIDA,v_NUMPLACA,v_CODPAIS,v_CODESTADO,v_CODCIUDAD,v_CODMUNICIPIO,v_DIREC,v_TEXTSIN,
							v_SUCANOSIN,v_CODRAMOCERT,v_CODAJUSTADOR,v_CAUSASIN,v_CODANALISTA,v_IDEBIEN,v_IDEASEG,v_IDECOBERT,v_IDERES,v_CODCOBERT,
							v_FECRES,v_IDEREC,v_CODMONEDA,v_PORCREEM,v_NUMMODRES,v_FECMODRES,v_ORIGMODRES,v_CODCPTORES,v_MTORES,v_MTORESMONEDA,
							v_MTOFACTDO,v_MTOFACTDOMON,v_MTODEDUC,v_MTODEDUCMON,v_MIGRA,v_ERROR
						);
						COMMIT;
					EXCEPTION  WHEN OTHERS  THEN
						NULL;
					END;
				END IF;
			END IF;
			--
			IF (v_RAMOAS > 0 AND v_POLIZAAS > 0 AND v_RECLAMAS > 0 AND vv_SERIE > 0) THEN
				lv_RAMOAS := v_RAMOAS;
				lv_POLIZAAS := v_POLIZAAS;
				lv_SERIE := vv_SERIE;
				lv_RECLAMAS := v_RECLAMAS;
				lv_MIGRA := '';
				lv_ESTATUS := '';
				--
				IF (iErrorWarning = TRUE) THEN	
					lv_C_ERROR := 'S';
				ELSE
					lv_C_ERROR := 'N';
				END IF;
				--
				lv_IDESIN := 0;
				lv_FECESTATUS := SYSDATE;
				--
				BEGIN
					INSERT INTO LOG_SINIESTRO_MIG (RAMOAS,POLIZAAS,SERIE,RECLAMAS,MIGRA,C_ERROR,IDESIN,ESTATUS,FECESTATUS)
					VALUES (lv_RAMOAS,lv_POLIZAAS,lv_SERIE,lv_RECLAMAS,lv_MIGRA,lv_C_ERROR,lv_IDESIN,lv_ESTATUS,lv_FECESTATUS);
					COMMIT;
				EXCEPTION WHEN OTHERS THEN
					NULL;
				END;
			END IF;
		END;
	END LOOP;
END;