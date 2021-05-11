SELECT * FROM ALL_SOURCE 
WHERE UPPER(TEXT) LIKE '%FROM EQ_COBERTURAS_IND%'
AND OWNER = 'MIGRA' 
AND NAME in ('PM_AL')
and LINE in (
	389,940,1158,1185,1225,1265,1300,1598,1770,1805,1858,1892,1910,2087,
	8270,8272,5594,5731,5738,6966,6989,7001,7256,7284,8040,8063,8096,5552
);
--
SELECT ramo,poliza,idepol FROM eq_coberturas_ind
WHERE migra = 'S'
GROUP BY ramo,poliza,idepol
--
DROP TABLE SIPF41;
SELECT * INTO SIPF41 FROM OPENQUERY(DB2400,
	'SELECT a.* FROM lscadea.sipf41 a, lscadea.migsinies b
		WHERE a.RAMO =  b.RAMO
		AND a.POLIZA = b.POLIZA
		AND a.SERIE  = b.SERIE
		AND a.RECLAC = b.RECLAC
		AND a.RECLAM = b.RECLAM
		AND b.migra = ''S''
	'
);
---
DROP TABLE SIPF86;
SELECT * INTO SIPF86 FROM OPENQUERY(DB2400,
	'SELECT a.* FROM lscadea.sipf86 a, lscadea.migsinies b
		WHERE a.RAMO = b.RAMO
		AND a.POLIZA = b.POLIZA
		AND a.SERIE = b.SERIE
		AND a.RECLAC = b.RECLAC
		AND a.RECLAM = b.RECLAM
		AND b.migra = ''S''
	'
);
---
DROP TABLE SIPF90
SELECT * into SIPF90 FROM openquery(DB2400,
	'SELECT a.* FROM lscadea.sipf90 a, lscadea.migsinies b
		WHERE a.RAMO  = b.RAMO
		AND a.POLIZA =  b.POLIZA
		AND a.SERIE  =  b.SERIE
		AND a.RECLAC =  b.RECLAC
		AND a.RECLAM =  b.RECLAM
		AND b.migra = ''S''
	'
);
--
DROP TABLE SIPFR70
SELECT * into SIPFR70 FROM openquery(DB2400,
	'SELECT a.* FROM lscadea.sipfr70 a, lscadea.migsinies b
		WHERE a.RAMO = b.RAMO
		AND a.POLIZA = b.POLIZA
		AND a.SERIE = b.SERIE
		AND a.RECLAC = b.RECLAC
		AND a.RECLAM = b.RECLAM
		AND b.migra = ''S''
	'
);
--
DROP TABLE ESPF01
SELECT * into ESPF01 FROM openquery(DB2400,
	'SELECT a.* FROM lscadea.ESPF01 a, lscadea.migsinies b
		WHERE a.RAMO = b.RAMO
		AND a.POLIZA = b.POLIZA
		AND a.SERIE = b.SERIE
		AND a.RECLAC = b.RECLAC
		AND a.RECLAM = b.RECLAM
		AND b.migra=''S''
	'
);
--
DROP TABLE GIPF01
SELECT * into GIPF01 FROM openquery(DB2400,
	'SELECT b.* FROM lscadea.migfinanc a, lscadea.gipf01 b
		WHERE a.nrreg = b.nrreg
	'
);
--
DROP TABLE GIPF02
SELECT * into GIPF02 FROM openquery(DB2400,
	'SELECT b.* FROM lscadea.migfinanc a, lscadea.gipf02 b
		WHERE a.nrreg = b.nrreg
	'
)
--
DROP TABLE GIPF03
SELECT * into GIPF03 FROM openquery(DB2400, 
	'SELECT b.* FROM lscadea.migfinanc a,lscadea.gipf03 b
		WHERE a.nrreg = b.nrreg
	'
)
--
DROP TABLE GIPF16
SELECT * into GIPF16 FROM openquery(DB2400,
	'SELECT b.* FROM lscadea.migfinanc a,lscadea.gipf16 b
		WHERE a.nrreg = b.nrreg
	'
)
--
DROP TABLE GIPF55
SELECT * into GIPF55 FROM openquery(DB2400,
	'SELECT b.* FROM lscadea.migfinanc a,lscadea.gipf55 b 
		WHERE a.nrreg = b.nrreg
	'
)
--
DROP TABLE HJPF25
SELECT * into HJPF25 FROM openquery(DB2400,
	'SELECT aa.* FROM lscadea.hjpf25 aa, lscadea.migcartei bb
		WHERE aa.ramo = bb.ramo
		AND aa.poliza = bb.poliza
		AND aa.stsrec = bb.stsrec
		AND aa.numrec = bb.numrec
		AND bb.migra = ''S''
	'
)
--
DROP TABLE HJPF26
SELECT * into HJPF26 FROM openquery(DB2400,
	'SELECT aa.* FROM lscadea.hjpf26 aa, lscadea.migcartei bb
		WHERE aa.ramo = bb.ramo
		AND aa.poliza = bb.poliza
		AND aa.stsrec = bb.stsrec
		AND aa.numrec = bb.numrec
		AND bb.migra = ''S''
	'
)
--
DROP TABLE HJPF27
SELECT * into HJPF27 FROM openquery(DB2400,
	'SELECT aa.* FROM lscadea.hjpf27 aa, (
		SELECT ramo,poliza FROM lscadea.migcartei bb
		WHERE migra=''S''
		GROUP BY ramo,poliza
	) bb
	WHERE aa.ramo = bb.ramo
	AND aa.poliza = bb.poliza
	'
)
--
DROP TABLE HJPF27R
SELECT * into HJPF27R FROM openquery(DB2400,
	'SELECT aa.* FROM lscadea.hjpf27r aa, (
		SELECT ramo,poliza FROM lscadea.migcartei bb
		WHERE migra=''S''
		GROUP BY ramo,poliza
	) bb
	WHERE aa.ramo = bb.ramo                
	AND aa.poliza = bb.poliza
	'
)