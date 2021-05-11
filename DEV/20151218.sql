SELECT max(pm.codprod) codprod,max(numpol) numpol,pm.idepol,max(aa.mensajesql) mensajesql 
FROM poliza_mig pm,ERR_MIG_POLIZAS_PATRIM aa, (
	SELECT idepol FROM data WHERE ctabla = 'PATRIMONIALES'
) bb
WHERE pm.idepol = aa.idepol
AND aa.idepol = bb.idepol
GROUP BY pm.idepol
ORDER BY codprod,idepol;
--
SELECT pm.codprod codprod,pm.numpol numpol,pm.idepol,dd.numcert,mensajesql 
FROM poliza_mig pm, (
	SELECT codprod,cc.idepol,cc.numcert,mensajesql
	FROM certificado_mig cm, (
		SELECT codprod,aa.idepol,aa.numcert,mensajesql FROM (
			SELECT codprod,idepol,numcert,max(mensajesql) mensajesql
			FROM ERR_MIG_POLIZAS_AUTO_COL 
			GROUP BY codprod,idepol,numcert
		) aa,(
			SELECT idepol,numcert FROM data WHERE ctabla = 'AUTOMOVIL'
		) bb
		WHERE bb.idepol = aa.idepol 
		AND bb.numcert = aa.numcert
	) cc    
	WHERE cm.idepol = cc.idepol
	AND cm.numcert = cc.numcert
) dd	 
WHERE dd.idepol = pm.idepol
GROUP BY pm.codprod,pm.numpol,pm.idepol,dd.numcert,mensajesql
ORDER BY codprod,idepol;
--
SELECT max(pm.codprod) codprod,max(numpol) numpol,pm.idepol,max(mensajesql) mensajesql 
FROM poliza_mig pm,ERR_MIG_POLIZAS_PERSONA aa,(
	SELECT idepol,numcert FROM data WHERE ctabla = 'PERSONAS'
) bb
WHERE pm.idepol = aa.idepol
AND bb.idepol = aa.idepol
GROUP BY pm.idepol
ORDER BY codprod,idepol;
--
BEGIN
	pm_la.inc_tablas_equiva;
	pm_la.inc_terceros_famliares_hjpf71;
	pm_eg.inc_hjpf01;
	pm_eg.inserta_eq_hjpf205;
	pm_eg.inc_eq_hjpf205;
	pm_eg.inserta_eq_fnpf01;
	pm_eg.inc_eq_fnpf01;
	pm_eg.inserta_eq_fnpf02;
	pm_eg.inc_eq_fnpf02;
	pm_eg.inserta_eq_fnpf03;
	pm_eg.inc_eq_fnpf03;
	pm_eg.inserta_eq_ordene;
	pm_eg.inc_eq_ordene;
	pm_eg.inserta_eq_orpf06;
	pm_eg.inc_eq_orpf06;
	pm_eg.inserta_eq_clpf05_fam;
	pm_eg.inc_clpf05_fam;
	pm_eg.inserta_eq_clpf07;
	pm_eg.inc_clpf07;
	pm_eg.inc_funeraria_mig;
	pm_eg.arreg_terceros;
END;
--
PROCEDURE GENERA_ERROR_CARTERA_SIN (
	nTipoError      IN ERR_MIG_SINIESTRO.tipoerror%TYPE,
	nCodError       IN ERR_MIG_SINIESTRO.coderror%TYPE,
	nNomProceso     IN ERR_MIG_SINIESTRO.nomproceso%TYPE,
	nNomTabla       IN ERR_MIG_SINIESTRO.nomtabla%TYPE,
	nRamo           IN ERR_MIG_SINIESTRO.ramo%TYPE,
	nPoliza         IN ERR_MIG_SINIESTRO.poliza%TYPE,
	nSerie          IN ERR_MIG_SINIESTRO.serie%TYPE,
	nReclam         IN ERR_MIG_SINIESTRO.reclam%TYPE,
	cObservaciones  IN ERR_MIG_SINIESTRO.observaciones%TYPE
)
IS
	nIdeError   NUMBER (14);
BEGIN
	nIdeError := PM.PROXIMA_SECUENCIA ('SQ_ERR_MIG_SINIESTRO');

	INSERT INTO ERR_MIG_SINIESTRO (
		IDEERROR,TIPOERROR,CODERROR,NOMPROCESO,NOMTABLA,
		FECOCURRENCIA,RAMO,POLIZA,SERIE,RECLAM,OBSERVACIONES
	)
	VALUES (
		nIdeError,nTipoError,nCodError,nNomProceso,nNomTabla,
		SYSDATE,nRamo,nPoliza,nSerie,nReclam,cObservaciones
	);
	COMMIT;
END GENERA_ERROR_CARTERA_SIN;
--
UPDATE tem_hjpf10 aa
SET aa.suc = (
	SELECT (suc*100) FROM hjpf10 bb
	WHERE aa.CODPRD = bb.CODPRD
)
WHERE EXISTS (
	SELECT * FROM hjpf10 bb
	WHERE aa.cedpro = bb.cedpro
	AND nvl(aa.suc,0) = 0
)
--
UPDATE tem_hjpf10 aa
SET codprdn = (
	SELECT codinter
	FROM acscert.intermediario@desa bb
	WHERE bb.tipoid = aa.nacion 
	AND bb.numid = aa.cedpro
)
WHERE EXISTS (
	SELECT * FROM acscert.intermediario@desa bb 
	WHERE bb.tipoid = aa.nacion
	AND bb.numid = aa.cedpro
	AND nvl(aa.codprdn,0) = 0
)
--
SELECT SUM (
	TO_NUMBER (
		extractvalue(dbms_xmlgen.getXMLtype ('SELECT count(*) cnt FROM '||table_name),'/ROWSET/ROW/CNT')
	)
) AS Cantidad
FROM all_tables
WHERE owner = 'MIGRA'
AND table_name IN (
	'AMPF02','AMPF03','AMPF07','AMPF14','AMPF19','CHPF05','CLPF01','CLPF02',
	'CLPF03','CLPF05','CLPF06','CLPF07','CLPF08','CLPF08N','CLPF10','CLPF18',
	'CLPF25','CLPF27','CLPF37','CLPF40','CLPF43','CLPF44','COPF02','CTRALTAB',
	'ESPF01','FNPF01','FNPF02','FNPF03','FNPF04','FNPF05','FNPF06','FNPF07',
	'FNPF08','FNPF10','FNPF11','FNPF12','FNPF13','FNPF14','FNPF15','FNPF50',
	'GIPF01','GIPF02','GIPF03','GIPF16','HJPF01','HJPF02','HJPF03','HJPF05',
	'HJPF06','HJPF07','HJPF08','HJPF09A','HJPF10','HJPF10M','HJPF13','HJPF21',
	'HJPF24','HJPF25','HJPF26','HJPF27','HJPF29','HJPF30','HJPF32C','HJPF35',
	'HJPF63','HJPF71','HJPF75','HJPF76','HJPF83','HJPF84','HJPF94','HJPF95',
	'HJPF98','HJPF205','IMPF01','IMPF02','ORDENE','MCPF01','ORPF06','ORPF07',
	'ORPF08','ORPF09','PCPF01','RBPF01','RBPF02','RBPF10','REPF14','REPF15',
	'RSPF02','RSPF04','RSPF06','RSPF80','RSPF99','RTPF07','SIPF01','SIPF05',
	'SIPF07','SIPF08','SIPF10','SIPF25','SIPF30','SIPF31','SIPF34','SIPF37',
	'SIPF39','SIPF40','SIPF41','SIPF74','SIPF86','SIPF90','SIPFR70','VAPF02',
	'VVALORES'
)
--
SELECT table_name, (
	extractvalue(xmltype(dbms_xmlgen.getxml('select count(*) cnt from '||table_name)),'/ROWSET/ROW/CNT')
) CANTIDAD_REGISTROS
FROM user_tables 
WHERE table_name IN (
	'CLIENTE_MIG','TERCERO_MIG','INSPECTOR_MIG','CLINICA_MIG','MEDICO_MIG',
	'PROVEEDOR_MIG','PROVE_ADM_CLA_MIG','PROVEEDOR_ADM_MIG','FUNERARIA_MIG',
	'INSPECTOR_MIG','TERCERO_ROL_MIG','CUENTAS_BANCARIAS_TERC_MIG','INTERMEDIARIO_MIG')
GROUP BY table_name
ORDER BY CANTIDAD_REGISTROS DESC
--
BEGIN
	DBMS_OUTPUT.put_line('INICIO DE PROCESO: '||to_char(sysdate, 'MM/DD/YYYY HH:MI AM'));
	mig_terceros;
	DBMS_OUTPUT.put_line('FIN DE PROCESO: '||to_char(sysdate, 'MM/DD/YYYY HH:MI AM'));
END;
--
SET LINE 166
BEGIN
	DBMS_METADATA.SET_TRANSFORM_PARAM (DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', FALSE);
END;
SELECT DBMS_METADATA.GET_DDL ('INDEX', U.INDEX_NAME) SCRIPT
FROM  ALL_INDEXES U
WHERE U.OWNER = USER
AND TABLE_NAME IN (
	'AMPF02','AMPF03','AMPF07','AMPF14','AMPF19','CHPF05','CLPF01','CLPF02','CLPF03','CLPF05','CLPF06',
	'CLPF07','CLPF08','CLPF08N','CLPF10','CLPF18','CLPF25','CLPF27','CLPF37','CLPF40','CLPF43','CLPF44',
	'CLPF53','COPF02','CTRALTAB','ESPF01','FNPF01','FNPF02','FNPF03','FNPF04','FNPF05','FNPF06','FNPF07',
	'FNPF08','FNPF10','FNPF11','FNPF12','FNPF13','FNPF14','FNPF15','FNPF50','GIPF01','GIPF02','GIPF03',
	'GIPF16','GIPF55','HJPF01','HJPF02','HJPF03','HJPF05','HJPF06','HJPF07','HJPF08','HJPF09A','HJPF10',
	'HJPF10M','HJPF13','HJPF21','HJPF210','HJPF24','HJPF25','HJPF26','HJPF27','HJPF27R','HJPF29','HJPF30',
	'HJPF32','HJPF32C','HJPF35','HJPF63','HJPF71','HJPF75','HJPF76','HJPF83','HJPF84','HJPF94','HJPF95',
	'HJPF98','HTFA23','IMPF01','IMPF02','MCPF01','MIGCARCER','MIGCARTEI','MIGCOBASE','MIGSINPEN','ORDENE',
	'ORPF06','ORPF07','ORPF08','ORPF09','PCPF01','RBPF01','RBPF02','RBPF10','RBPF23','REPF14','REPF15',
	'RSPF02','RSPF04','RSPF06','RSPF80','RSPF99','RTPF07','SIPF01','SIPF05','SIPF07','SIPF08','SIPF10',
	'SIPF25','SIPF27','SIPF30','SIPF31','SIPF34','SIPF37','SIPF39','SIPF40','SIPF41','SIPF74','SIPF86',
	'SIPF90','SIPFR70','VAPF02','VVALORES'
);
BEGIN
	DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'DEFAULT');
END;
--
DECLARE
	nIdepol     NUMBER(14):= 207177;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000001;
	ccodofiemi  VARCHAR2(6):= '050101';
	nCuenta     NUMBER(14):= 0;
BEGIN
	BEGINSELECT COUNT(*) INTO ncuenta FROM poliza
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;

	IF nCuenta = 0 THENUPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 229858;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000011S
	ccodofiemi  VARCHAR2(6):= '050101';
	nCuenta     NUMBER(14):= 0;
BEGIN
	BEGINSELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THENUPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 218562;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000012;
	ccodofiemi  VARCHAR2(6):= '050101';
	nCuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol
		AND codprod = ccodprod
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 230614;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000013;
	ccodofiemi  VARCHAR2(6):= '050101';
	nCuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza
		WHERE numpol = nnumpol
		AND codprod = ccodprod
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 237097;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000014;
	ccodofiemi  VARCHAR2(6):= '050101';
	nCuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;    
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 237055;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000016;
	ccodofiemi  VARCHAR2(6):= '050101';
	nCuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 218622;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000017;
	ccodofiemi  VARCHAR2(6):= '050101';
	nCuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 230129;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000018;
	ccodofiemi  VARCHAR2(6):= '050101';
	nCuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 233766;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000020;
	ccodofiemi  VARCHAR2(6):= '050101';
	nCuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 234208;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000021;
	ccodofiemi  VARCHAR2(6):= '050101';
	nCuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 234582;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000022;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 230128;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000024;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 219235;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000025;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 228814;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000026;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 234816;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000027;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 218485;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000028;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 215273;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000029;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 204084;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000030;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 231574;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000031;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 231280;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000032;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 236090;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000033;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 237338;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000034;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 236296;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000035;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 228766;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000036;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 235374;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000038;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 237040;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000039;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 204031;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000043;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 236914;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000044;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 237782;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000045;   
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 218679;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000046;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 218379;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000047;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 218773;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000048;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 232752;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000049;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 232988;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000050; 
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 232076;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000051;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 203509;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000052;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 232079;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000053;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 232080;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000054;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 232085;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000055;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 182418;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000056;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 182415;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000057;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 185982;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000058;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 186115;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000059;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 186472;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000060;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE 
	nIdepol     NUMBER(14):= 202443;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000061;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 202507;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000062;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 202600;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000063;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 202725;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000064;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 202902;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000065;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 202979;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000066;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 203036;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000067;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 203070;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000068;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 203101;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000070;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE 
	nIdepol     NUMBER(14):= 203133;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000071;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 203234;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000072;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 205485;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000073;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 205526;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000076;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 205524;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000077;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 205600;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000078;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 205927;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000081;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 238357;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000082;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 233708;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000087;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE 
	nIdepol     NUMBER(14):= 205637;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000088;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE 
	nIdepol     NUMBER(14):= 205953;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000091;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE 
	nIdepol     NUMBER(14):= 218462;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000092;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE 
	nIdepol     NUMBER(14):= 218505;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000093;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 218678;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000094;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 193695;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000095;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 218634;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000096;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 218738;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000097;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 218868;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000098;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE 
	nIdepol     NUMBER(14):= 218869;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000099;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 228505;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000100;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE 
	nIdepol     NUMBER(14):= 221676;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000102;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 228552;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000103;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
SELECT * FROM poliza WHERE idepol = 221707
SELECT * FROM recibo WHERE idepol = 221707 AND stsrec = 'COB'
SELECT distinct codusr FROM acreencia WHERE numacre IN (SELECT numacre FROM recibo WHERE idepol = 221707)
SELECT indconta FROM usuario  WHERE codusr  = 'AU061003'
--
DECLARE 
	nIdepol     NUMBER(14):= 221707;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000104;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
SELECT * FROM poliza WHERE idepol = 228576
SELECT * FROM recibo WHERE idepol = 228576 AND stsrec = 'COB'
SELECT distinct codusr FROM acreencia WHERE numacre IN (SELECT numacre FROM recibo WHERE idepol = 228576)
SELECT indconta FROM usuario  WHERE codusr  = 'AU061003'
--
DECLARE 
	nIdepol     NUMBER(14):= 228576;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000105;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
SELECT * FROM poliza WHERE idepol = 230127
SELECT * FROM recibo WHERE idepol = 230127 AND stsrec = 'COB'
SELECT distinct codusr FROM acreencia WHERE numacre IN (SELECT numacre FROM recibo WHERE idepol = 230127)
SELECT indconta FROM usuario  WHERE codusr  = 'AU061003'
--
DECLARE 
	nIdepol     NUMBER(14):= 230127;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000106;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 230654;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000142;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 203308;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000144;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 203598;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000146;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 203692;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000147;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 203771;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000148;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 235653;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000149;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 203903;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000150;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 233077;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000151;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 203946;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000153;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 205107;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000154;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 235936;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000155;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 230207;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000156;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 220910;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000157;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 235383;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000158;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 231815;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000159;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 231883;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000160;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 231958;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000161;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 234499;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000162;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 235042;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000163;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 236161;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000164;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 235629;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000165;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 236961;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000167;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 235947;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000168;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 236297;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000169;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 236344;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000170;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 233272;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000172;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 236589;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000173;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 231110;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000176;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 234442;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000177;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 238136;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000178;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 233205;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000180;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 228526;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000101;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 221676;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000102;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 228552;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000103;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 221707;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000104;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 228576;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000105;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 230127;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000106;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 192735;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000108;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 229535;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000109;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 237538;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000111;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 236328;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000112;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 236369;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000113;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 183513;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000115;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 185843;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000117;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 193365;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000119;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 182537;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000120;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 185817;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000121;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 185936;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000122;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 185972;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000123;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 186100;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000124;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 186184;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000125;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 186458;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000126;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 187893;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000127;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 188875;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000128;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 181159;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000129;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 202548;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000131;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 202590;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000132;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 202733;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000133;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 202817;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000134;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 202836;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000135;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 202849;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000136;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 202901;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000139;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
DECLARE
	nIdepol     NUMBER(14):= 203295;
	ccodprod    VARCHAR2(4):= 'AUTC';
	nnumpol     NUMBER(14):= 10000141;
	ccodofiemi  VARCHAR2(6):= '050101';
	ncuenta     NUMBER(14):= 0;
BEGIN
	BEGIN
		SELECT COUNT(*) INTO ncuenta FROM poliza 
		WHERE numpol = nnumpol 
		AND codprod = ccodprod 
		AND codofiemi = ccodofiemi;
	EXCEPTION WHEN no_data_found THEN ncuenta:= 0;
		WHEN others THEN ncuenta:= 0;
	END;
	IF nCuenta = 0 THEN
		UPDATE poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE tr_poliza SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA_T SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAU SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE REP_BORDERAUX_SIN SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE MOV_PRIMA SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TEMP_RECIBOS_VER SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T$_MASIVA_AUTO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_CERTIFICADO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE T_RECUPERACION SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE SINIESTRO SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
		UPDATE TR_SINIES SET codofiemi = ccodofiemi WHERE idepol = nIdepol;
	END IF;
END;
--
SELECT * INTO tablaOracle FROM OPENQUERY(DB2400, 'SELECT * FROM tablaSQLServer')
--
BEGIN
	EXEC DBMS_SCHEDULER.ENABLE('BD.NombreTarea');
	EXEC DBMS_SCHEDULER.DISABLE('BD.NombreTarea');
END;
--
SELECT * FROM lval 
WHERE tipolval = 'OFICINAS' 
AND codlval LIKE '80%'
--
SELECT * FROM BANCA_SEGURO;
SELECT * FROM BANCA_SEGURO_ANU;
SELECT * FROM BANCA_SEGURO_BEN;
SELECT * FROM BANCA_SEGURO_COB_DEV;
SELECT * FROM BANCA_SEGURO_DP_INCE;
SELECT * FROM BANCA_SEGURO_DP_ROBO;
SELECT * FROM BANCA_SEGURO_DP_TERRE;
SELECT * FROM BANCA_SEGURO_ERROR;
SELECT * FROM BANCA_SEGURO_HIST;
SELECT * FROM BANCA_SEGURO_MAIL;
SELECT * FROM BANCA_SEGURO_MOD;
SELECT * FROM BANCA_SEGURO_OFICINA; 
SELECT * FROM BANCA_SEGURO_PROD;
SELECT * FROM BANCA_SEGURO_PROV;
SELECT * FROM ALL_DIRECTORIES WHERE DIRECTORY_NAME LIKE '%DIREC%';