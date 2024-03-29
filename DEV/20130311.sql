SELECT
	TIPOID,
	NUMID,
	DVID,
	MAX (NOMTER) NOMTER,
	MAX (APETER) APETER,
	MAX (CODPAIS) CODPAIS,
	MAX (CODESTADO) CODESTADO,
	MAX (CODCIUDAD) CODCIUDAD,
	MAX (CODMUNICIPIO) CODMUNICIPIO,
	MAX (DIREC) DIREC,
	MAX (TELEF1) TELEF1,
	MAX (TELEF2) TELEF2,
	MAX (TELEF3) TELEF3,
	MAX (FAX) FAX,
	MAX (TELEX) TELEX,
	MAX (ZIP) ZIP,
	MAX (INDNACIONAL) INDNACIONAL,
	MAX (STSTER) STSTER,
	MAX (FECSTS) FECSTS,
	MAX (NUMCTAAUXI) NUMCTAAUXI,
	MAX (EMAIL) EMAIL,
	MAX (TIPOTER) TIPOTER,
	MAX (RIF) RIF,
	MAX (NIT) NIT,
	MAX (CODPARROQUIA) CODPARROQUIA,
	MAX (CODSECTOR) CODSECTOR,
	MAX (WEBSITE) WEBSITE,
	MAX (RAZONSOCIAL) RAZONSOCIAL,
	MAX (INDMIGRA) INDMIGRA,
	MAX (MIGRA) MIGRA,
	CODCLI CODCLI,
	MAX (CLASECLI) CLASECLI,
	MAX (TIPOCLI) TIPOCLI,
	MAX (SEXO) SEXO,
	MAX (FECNAC) FECNAC,
	MAX (EDOCIVIL) EDOCIVIL,
	MAX (CODACT) CODACT,
	MAX (CODFUERZA) CODFUERZA,
	MAX (CODGRADO) CODGRADO,
	MAX (FECVINC) FECVINC,
	MAX (FECLISTANEGRA) FECLISTANEGRA,
	MAX (CODLISTANEGRA) CODLISTANEGRA,
	MAX (MTOINGANUAL) MTOINGANUAL,
	MAX (FECINGANUAL) FECINGANUAL,
	MAX (TIPOCONYUGE) TIPOCONYUGE,
	MAX (NUMIDCONYUGE) NUMIDCONYUGE,
	MAX (NOMCONYUGE) NOMCONYUGE,
	MAX (APECONYUGE) APECONYUGE,
	MAX (INDCONTRAGARANTE) INDCONTRAGARANTE,
	MAX (CODINGANUAL) CODINGANUAL,
	MAX (NUMEXP) NUMEXP,
	MAX (NOMBRETABLA) NOMBRETABLA
FROM (
	SELECT
		TIPOID TIPOID,
		NUMID NUMID,
		DVID DVID,
		NOMASE NOMTER,
		NULL APETER,
		'001' CODPAIS,
		'999' CODESTADO,
		'999' CODCIUDAD,
		'999' CODMUNICIPIO,
		PM.ELIMINA_ESPACIOS (UPPER (
			(CASE
				WHEN TRIM (DIRRG1) IS NULL
				THEN 'SIN DIRECCION'
				ELSE TRIM (DIRRG1)
			END)
		)) DIREC,
		TO_CHAR (TELEF) TELEF1,
		NULL TELEF2,
		NULL TELEF3,
		NULL FAX,
		NULL TELEX,
		NULL ZIP,
		INDNACIONAL INDNACIONAL,
		'INA' STSTER,
		'01/01/2000' FECSTS,
		NULL NUMCTAAUXI,
		NULL EMAIL,
		'CI' TIPOTER,
		NULL RIF,
		NULL NIT,
		'999' CODPARROQUIA,
		'999' CODSECTOR,
		NULL WEBSITE,
		PM.ELIMINA_ESPACIOS (UPPER (
			(CASE
				WHEN TIPOID = 'J' THEN TRIM (NOMASE)
				ELSE NULL
			END)
		)) RAZONSOCIAL,
		NULL INDMIGRA,
		NULL MIGRA,
		CODCLI CODCLI,
		'006' CLASECLI,
		(CASE TIPOID
			WHEN 'J' THEN 'E'
			WHEN 'G' THEN 'G'
			WHEN 'V' THEN 'P'
			WHEN 'E' THEN 'P'
		END) TIPOCLI,
		(CASE
			WHEN tipoid IN ('J', 'G') THEN 'N'
			ELSE
			(CASE SEXO
				WHEN 2 THEN 'M'
				WHEN 1 THEN 'F'
				ELSE 'M'
			END)
		END) SEXO,
		TO_CHAR (PM.VALIDA_CONVIERTE_FECHA (DIANAC, MESNAC, ANONAC)) FECNAC,
		'9' EDOCIVIL,
		'9999' CODACT,
		NULL CODFUERZA,
		NULL CODGRADO,
		'01/01/2000' FECVINC,
		NULL FECLISTANEGRA,
		NULL CODLISTANEGRA,
		NULL MTOINGANUAL,
		'01/01/2000' FECINGANUAL,
		NULL TIPOCONYUGE,
		NULL NUMIDCONYUGE,
		NULL NOMCONYUGE,
		NULL APECONYUGE,
		NULL INDCONTRAGARANTE,
		NULL CODINGANUAL,
		NULL NUMEXP,
		'EQ_HJPF01' NOMBRETABLA
	FROM EQ_HJPF01
	UNION ALL
	SELECT 
		AA.TIPOID TIPOID,
		AA.NUMID NUMID,
		AA.DVID DVID,
		BB.NOMCLI NOMTER,
		NULL APETER,
		'001' CODPAIS,
		'999' CODESTADO,
		'999' CODCIUDAD,
		'999' CODMUNICIPIO,
		PM.ELIMINA_ESPACIOS (UPPER (
			(CASE
			WHEN TRIM (BB.DIRCLI) IS NULL THEN 'SIN DIRECCION'
			ELSE TRIM (BB.DIRCLI)
			END)
		)) DIREC,
		TO_CHAR (BB.TELCL1) TELEF1,
		TO_CHAR (BB.TELCL2) TELEF2,
		TO_CHAR (BB.TELCL3) TELEF3,
		NULL FAX,
		NULL TELEX,
		NULL ZIP,
		AA.INDNACIONAL INDNACIONAL,
		'INA' STSTER,
		'01/01/2000' FECSTS,
		NULL NUMCTAAUXI,
		NULL EMAIL,
		'CI' TIPOTER,
		NULL RIF,
		NULL NIT,
		'999' CODPARROQUIA,
		'999' CODSECTOR,
		NULL WEBSITE,
		PM.ELIMINA_ESPACIOS (UPPER (
			(CASE
			WHEN AA.TIPOID = 'J' THEN TRIM (BB.NOMCLI)
			ELSE NULL
			END)
		)) RAZONSOCIAL,
		NULL INDMIGRA,
		NULL MIGRA,
		AA.CODCLI CODCLI,
		'006' CLASECLI,
		(CASE PM.BUSQUEDA_NACION (AA.TIPOID)
			WHEN 'J' THEN 'E'
			WHEN 'G' THEN 'G'
			WHEN 'V' THEN 'P'
			WHEN 'E' THEN 'P'
		END) TIPOCLI,
		(CASE
			WHEN tipoid IN ('J', 'G') THEN 'N'
			ELSE
			(CASE BB.SEXCLI
				WHEN '2' THEN 'M'
				WHEN '1' THEN 'F'
				WHEN 'M' THEN 'M'
				WHEN 'F' THEN 'F'
				ELSE 'M'
			END)
		END) SEXO,
		'01/01/2000' FECNAC,
		'9' EDOCIVIL,
		'9999' CODACT,
		NULL CODFUERZA,
		NULL CODGRADO,
		'01/01/2000' FECVINC,
		NULL FECLISTANEGRA,
		NULL CODLISTANEGRA,
		NULL MTOINGANUAL,
		'01/01/2000' FECINGANUAL,
		NULL TIPOCONYUGE,
		NULL NUMIDCONYUGE,
		NULL NOMCONYUGE,
		NULL APECONYUGE,
		NULL INDCONTRAGARANTE,
		NULL CODINGANUAL,
		NULL NUMEXP,
		'EQ_HJPF205' NOMBRETABLA
	FROM EQ_HJPF205 AA, MCPF01 BB
	WHERE AA.TIPOID = BB.CCLI1(+) AND AA.NUMID = BB.CCLI2(+)
	UNION ALL
	SELECT
		TIPOID TIPOID,
		NUMID NUMID,
		DVID DVID,
		NOMAF NOMTER,
		NULL APETER,
		'001' CODPAIS,
		'999' CODESTADO,
		'999' CODCIUDAD,
		'999' CODMUNICIPIO,
		PM.ELIMINA_ESPACIOS (UPPER (
			(CASE
				WHEN TRIM (DIRAF) IS NULL THEN 'SIN DIRECCION'
			 	ELSE TRIM (DIRAF)
			END)
		)) DIREC,
		TO_CHAR (TELAF) TELEF1,
		NULL TELEF2,
		NULL TELEF3,
		NULL FAX,
		NULL TELEX,
		NULL ZIP,
		INDNACIONAL INDNACIONAL,
		'INA' STSTER,
		'01/01/2000' FECSTS,
		NULL NUMCTAAUXI,
		NULL EMAIL,
		'CI' TIPOTER,
		TO_CHAR (CCLI2) RIF,
		NULL NIT,
		'999' CODPARROQUIA,
		'999' CODSECTOR,
		NULL WEBSITE,
		PM.ELIMINA_ESPACIOS( UPPER (
			(CASE
				WHEN TIPOID = 'J' THEN TRIM (NOMAF)
				ELSE NULL
		  	END)
		)) RAZONSOCIAL,
		NULL INDMIGRA,
		NULL MIGRA,
		CODCLI CODCLI,
		'006' CLASECLI,
		(CASE TIPOID
			WHEN 'J' THEN 'E'
			WHEN 'G' THEN 'G'
			WHEN 'V' THEN 'P'
			WHEN 'E' THEN 'P'
		END) TIPOCLI,
		(CASE WHEN tipoid IN ('J', 'G') THEN 'N' ELSE 'M' END) SEXO,
		'01/01/2000' FECNAC,
		'9' EDOCIVIL,
		'9999' CODACT,
		NULL CODFUERZA,
		NULL CODGRADO,
		'01/01/2000' FECVINC,
		NULL FECLISTANEGRA,
		NULL CODLISTANEGRA,
		NULL MTOINGANUAL,
		'01/01/2000' FECINGANUAL,
		NULL TIPOCONYUGE,
		NULL NUMIDCONYUGE,
		NULL NOMCONYUGE,
		NULL APECONYUGE,
		NULL INDCONTRAGARANTE,
		NULL CODINGANUAL,
		NULL NUMEXP,
		'EQ_FNPF01' NOMBRETABLA
	FROM EQ_FNPF01
	UNION ALL
	SELECT
		TIPOID TIPOID,
		NUMID NUMID,
		DVID DVID,
		NOMORD NOMTER,
		NULL APETER,
		'001' CODPAIS,
		'999' CODESTADO,
		'999' CODCIUDAD,
		'999' CODMUNICIPIO,
		'SIN DIRECCION' DIREC,
		NULL TELEF1,
		NULL TELEF2,
		NULL TELEF3,
		NULL FAX,
		NULL TELEX,
		NULL ZIP,
		INDNACIONAL INDNACIONAL,
		'INA' STSTER,
		'01/01/2000' FECSTS,
		NULL NUMCTAAUXI,
		NULL EMAIL,
		'CI' TIPOTER,
		TO_CHAR (RIF) RIF,
		NULL NIT,
		'999' CODPARROQUIA,
		'999' CODSECTOR,
		NULL WEBSITE,
		(CASE WHEN TIPOID = 'J' THEN TRIM (NOMORD) ELSE NULL END) RAZONSOCIAL,
		NULL INDMIGRA,
		NULL MIGRA,
		CODCLI CODCLI,
		'006' CLASECLI,
		(CASE TIPOID
			WHEN 'J' THEN 'E'
			WHEN 'G' THEN 'G'
			WHEN 'V' THEN 'P'
			WHEN 'E' THEN 'P'
		END) TIPOCLI,
		(CASE WHEN tipoid IN ('J', 'G') THEN 'N' ELSE 'M' END) SEXO,
		'01/01/2000' FECNAC,
		'9' EDOCIVIL,
		'9999' CODACT,
		NULL CODFUERZA,
		NULL CODGRADO,
		'01/01/2000' FECVINC,
		NULL FECLISTANEGRA,
		NULL CODLISTANEGRA,
		NULL MTOINGANUAL,
		'01/01/2000' FECINGANUAL,
		NULL TIPOCONYUGE,
		NULL NUMIDCONYUGE,
		NULL NOMCONYUGE,
		NULL APECONYUGE,
		NULL INDCONTRAGARANTE,
		NULL CODINGANUAL,
		NULL NUMEXP,
		'EQ_ORDENE' NOMBRETABLA
	FROM EQ_ORDENE
	UNION ALL
	SELECT
		TIPOID TIPOID,
		NUMID NUMID,
		DVID DVID,
		NOMOPA NOMTER,
		NULL APETER,
		'001' CODPAIS,
		'999' CODESTADO,
		'999' CODCIUDAD,
		'999' CODMUNICIPIO,
		'SIN DIRECCION' DIREC,
		NULL TELEF1,
		NULL TELEF2,
		NULL TELEF3,
		NULL FAX,
		NULL TELEX,
		NULL ZIP,
		PM.BUSQUEDA_INDNACIONAL (TIPOID) INDNACIONAL,
		'INA' STSTER,
		'01/01/2000' FECSTS,
		NULL NUMCTAAUXI,
		NULL EMAIL,
		'CI' TIPOTER,
		TO_CHAR (RIF) RIF,
		NULL NIT,
		'999' CODPARROQUIA,
		'999' CODSECTOR,
		NULL WEBSITE,
		(CASE
			WHEN PM.BUSQUEDA_NACION (TIPOID) = 'J' THEN TRIM (NOMOPA)
			ELSE NULL
		END) RAZONSOCIAL,
		NULL INDMIGRA,
		NULL MIGRA,
		CODCLI CODCLI,
		'006' CLASECLI,
		(CASE PM.BUSQUEDA_NACION (TIPOID)
			WHEN 'J' THEN 'E'
			WHEN 'G' THEN 'G'
			WHEN 'V' THEN 'P'
			WHEN 'E' THEN 'P'
		END) TIPOCLI,
		(CASE WHEN tipoid IN ('J', 'G') THEN 'N' ELSE 'M' END) SEXO,
		'01/01/2000' FECNAC,
		'9' EDOCIVIL,
		'9999' CODACT,
		NULL CODFUERZA,
		NULL CODGRADO,
		'01/01/2000' FECVINC,
		NULL FECLISTANEGRA,
		NULL CODLISTANEGRA,
		NULL MTOINGANUAL,
		'01/01/2000' FECINGANUAL,
		NULL TIPOCONYUGE,
		NULL NUMIDCONYUGE,
		NULL NOMCONYUGE,
		NULL APECONYUGE,
		NULL INDCONTRAGARANTE,
		NULL CODINGANUAL,
		NULL NUMEXP,
		'EQ_ORPF06' NOMBRETABLA
	FROM EQ_ORPF06 AA, SIPF05 BB
	WHERE AA.ANOEMI > NVL (2005, UID)
	AND AA.STSOPA = 'C'
	AND AA.ANOEMI = BB.ANOEMI
	AND TRIM (NOMOPA) IS NOT NULL
	AND BB.CORORD = AA.CORORD
	AND AA.MOTOPA > 0
	AND AA.CORORD > 0
	AND AA.NMROPA > 0
	AND AA.ANOOPA > 0
	AND BB.STSBEN <> 'A'
	AND BB.TIPOPG <> 'R'
	UNION ALL
	SELECT
		TIPOID TIPOID,
		NUMID NUMID,
		DVID DVID,
		COLASE NOMTER,
		NULL APETER,
		'001' CODPAIS,
		'999' CODESTADO,
		'999' CODCIUDAD,
		'999' CODMUNICIPIO,
		PM.ELIMINA_ESPACIOS (UPPER (
			(CASE
				WHEN TRIM (BB.DIRRG1) IS NULL THEN 'SIN DIRECCION'
				ELSE TRIM (BB.DIRRG1)
			END)
		)) DIREC,
		TO_CHAR (BB.TELEF) TELEF1,
		NULL TELEF2,
		NULL TELEF3,
		NULL FAX,
		NULL TELEX,
		NULL ZIP,
		INDNACIONAL INDNACIONAL,
		'INA' STSTER,
		'01/01/2000' FECSTS,
		NULL NUMCTAAUXI,
		NULL EMAIL,
		'CI' TIPOTER,
		NULL RIF,
		NULL NIT,
		'999' CODPARROQUIA,
		'999' CODSECTOR,
		NULL WEBSITE,
		PM.ELIMINA_ESPACIOS (UPPER (TRIM (
			(CASE
			WHEN TIPOID = 'J' THEN TRIM (COLASE)
			ELSE NULL
			 END)
		))) RAZONSOCIAL,
		NULL INDMIGRA,
		NULL MIGRA,
		CODCLI CODCLI,
		'006' CLASECLI,
		(CASE TIPOID
			WHEN 'J' THEN 'E'
			WHEN 'G' THEN 'G'
			WHEN 'V' THEN 'P'
			WHEN 'E' THEN 'P'
		END) TIPOCLI,
		(CASE
			WHEN tipoid IN ('J', 'G') THEN 'N'
			ELSE
			(CASE BB.SEXO
				WHEN 2 THEN 'M'
			  	WHEN 1 THEN 'F'
			  	ELSE 'M'
			END)
		END) SEXO,
		TO_CHAR (
			PM.VALIDA_CONVIERTE_FECHA (BB.DIANAC,BB.MESNAC,BB.ANONAC)
		) FECNAC,
		'9' EDOCIVIL1,
		'9999' CODACT1,
		NULL CODFUERZA1,
		NULL CODGRADO1,
		'01/01/2000' FECVINC1,
		NULL FECLISTANEGRA1,
		NULL CODLISTANEGRA1,
		NULL MTOINGANUAL1,
		'01/01/2000' FECINGANUAL1,
		NULL TIPOCONYUGE,
		NULL NUMIDCONYUGE,
		NULL NOMCONYUGE,
		NULL APECONYUGE1,
		NULL INDCONTRAGARANTE,
		NULL CODINGANUAL,
		NULL NUMEXP,
		'EQ_CLPF07' NOMBRETABLA
	FROM EQ_CLPF07 AA, HJPF01 BB
	WHERE AA.RAMO = BB.RAMO AND AA.POLIZA = BB.POLIZA
	UNION ALL
	SELECT
		TIPOID TIPOID,
		NUMID NUMID,
		DVID DVID,
		nomben NOMTER,
		NULL APETER,
		'001' CODPAIS,
		'999' CODESTADO,
		'999' CODCIUDAD,
		'999' CODMUNICIPIO,
		PM.ELIMINA_ESPACIOS ( UPPER (
			(CASE
				WHEN BB.DIRRG1 = ' ' THEN 'SIN DIRECCION'
		 		WHEN BB.DIRRG1 IS NULL THEN 'SIN DIRECCION'
		 		ELSE TRIM (BB.DIRRG1)
		 	END)
		)) DIREC,
		TO_CHAR (BB.TELEF) TELEF1,
		NULL TELEF2,
		NULL TELEF3,
		NULL FAX,
		NULL TELEX,
		NULL ZIP,
		INDNACIONAL INDNACIONAL,
		'INA' STSTER,
		'01/01/2000' FECSTS,
		NULL NUMCTAAUXI,
		NULL EMAIL,
		'CI' TIPOTER,
		NULL RIF,
		NULL NIT,
		'999' CODPARROQUIA,
		'999' CODSECTOR,
		NULL WEBSITE,
		PM.ELIMINA_ESPACIOS (UPPER (TRIM (
			(CASE
				WHEN PM.BUSQUEDA_NACION (TIPOID) = 'J' THEN TRIM (nomben)
				ELSE NULL
			END)
		))) RAZONSOCIAL,
		NULL INDMIGRA,
		NULL MIGRA,
		CODCLI CODCLI,
		'006' CLASECLI,
		(CASE TIPOID
			WHEN 'J' THEN 'E'
			WHEN 'G' THEN 'G'
			WHEN 'V' THEN 'P'
			WHEN 'E' THEN 'P'
		END) TIPOCLI,
		(CASE
			WHEN tipoid IN ('J', 'G') THEN 'N'
			ELSE
			(CASE BB.SEXO
				WHEN 2 THEN 'M'
				WHEN 1 THEN 'F'
				ELSE 'M'
			END)
		END) SEXO,
		TO_CHAR (PM.VALIDA_CONVIERTE_FECHA (BB.DIANAC,BB.MESNAC,BB.ANONAC)) FECNAC,
		'9' EDOCIVIL1,
		'9999' CODACT1,
		NULL CODFUERZA1,
		NULL CODGRADO1,
		'01/01/2000' FECVINC1,
		NULL FECLISTANEGRA1,
		NULL CODLISTANEGRA1,
		NULL MTOINGANUAL1,
		'01/01/2000' FECINGANUAL1,
		NULL TIPOCONYUGE,
		NULL NUMIDCONYUGE,
		NULL NOMCONYUGE,
		NULL APECONYUGE1,
		NULL INDCONTRAGARANTE,
		NULL CODINGANUAL,
		NULL NUMEXP,
		'EQ_HJPF06' NOMBRETABLA
	FROM EQ_hjpf06 AA, HJPF01 BB
	WHERE AA.RAMO = BB.RAMO AND AA.POLIZA = BB.POLIZA
)
WHERE ROWNUM = 1
GROUP BY TIPOID,NUMID,DVID,CODCLI;