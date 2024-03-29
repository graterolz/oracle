UPDATE eq_coberturas_ind aa
SET idepol = (
	SELECT bb.idepol FROM EQ_COBERTURAS_IND bb
	WHERE aa.poliza = bb.POLIZA
	AND ramo = 33
	GROUP BY bb.idepol
)
WHERE exists (
	SELECT 1 FROM EQ_COBERTURAS_IND bb
	WHERE aa.poliza = bb.POLIZA
	AND ramo = 33
)
AND aa.ramo IN (32,34,35)
AND poliza = 1013608
--
INSERT INTO APLICACION (CODAPLIC, DESAPLIC, INDFORMA) VALUES ('BIENESM', 'Mant. de Bienes para la Migracion', 'S');
--
INSERT INTO MNUACSEL (CODAPLIC,CODGRPUSR,NIVEL,SECUENCIA,OPCION,INDFORMA)
VALUES ('MMIGRA','0CONFI01',4,(
	SELECT MAX (SECUENCIA) + 1 FROM MNUACSEL 
	WHERE CODAPLIC = 'MMIGRA'
	AND CODGRPUSR = '0CONFI01'
),'BIENESM','S');
--
INSERT INTO MNUACSEL (CODAPLIC,CODGRPUSR,NIVEL,SECUENCIA,OPCION,INDFORMA)
VALUES ('MMIGRA','CONTABIL',4,(
	SELECT MAX (SECUENCIA) + 1 FROM MNUACSEL
	WHERE CODAPLIC = 'MMIGRA'
	AND CODGRPUSR = 'CONTABIL'
),'BIENESM','S');
--
INSERT INTO MNUACSEL (CODAPLIC,CODGRPUSR,NIVEL,SECUENCIA,OPCION,INDFORMA)
VALUES ('MMIGRA','DESARROL',4, (
	SELECT MAX (SECUENCIA) + 1 FROM MNUACSEL
	WHERE CODAPLIC = 'MMIGRA'
	AND CODGRPUSR = 'DESARROL'
),'BIENESM','S');