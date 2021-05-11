SELECT Acargu TipoVehAs, AcFunc Descripcion, TipoVeh, (
	SELECT DESCRIP FROM ACSEL.LVAL@CERT
	WHERE TipoLval = 'TIPOVEH'
	AND CodLval = EQ.TipoVeh
	) Descripcion,
	ClaseVeh, (
		SELECT DESCRIP FROM ACSEL.LVAL@CERT
		WHERE TipoLval = 'CLASEVEH'
		AND CodLval = EQ.ClaseVeh
	) Descripcion,
	PlanApov,(
		SELECT DESCRIP FROM ACSEL.LVAL@CERT
		WHERE TipoLval = 'PLNAPOV'
		AND CodLval = EQ.PlanApov
	) Descripcion
FROM TB_REF_TIPOVEH EQ;
--
SELECT CodCobert, DescCobert, SumaSe, COUNT (*) FROM (
	SELECT DISTINCT IdePol, CodCobert, DescCobert, SumAse
	FROM EQ_COBERTURAS_IND
	WHERE Ramo = 35
	AND CodRamo = 0105
	AND Migra = 'S'
	ORDER BY IdePol, CodCobert
)
GROUP BY CodCobert, DescCobert, SumAse
ORDER BY COUNT (*) DESC;
--
SELECT CodCobert, DescCobert, SumaSe, COUNT (*) FROM (
	SELECT DISTINCT IdePol, CodCobert, DescCobert, SumAse
	FROM EQ_COBERTURAS_IND
	WHERE Ramo = 33
	AND CodRamo = 0112
	AND Migra = 'S'
	ORDER BY IdePol, CodCobert
)
GROUP BY CodCobert, DescCobert, SumAse
ORDER BY COUNT (*) DESC;
--
SELECT CodCobert, DescCobert, MonCob, COUNT (*) FROM (
	SELECT DISTINCT IdePol, CodCobert, DescCobert, MonCob
	FROM EQ_COBERTURAS_IND
	WHERE Ramo = 31
	AND CodRamo = 0105
	AND Migra = 'S'
	ORDER BY IdePol, CodCobert
)
GROUP BY CodCobert, DescCobert, MonCob
ORDER BY COUNT (*) DESC;
--
SELECT CodCobert, DescCobert, MonCob, COUNT (*) FROM (
	SELECT DISTINCT IdePol, CodCobert, DescCobert, MonCob
	FROM EQ_COBERTURAS_IND
	WHERE Ramo = 31
	AND CodRamo = 0112
	AND Migra = 'S'
	ORDER BY IdePol, CodCobert
)
GROUP BY CodCobert, DescCobert, MonCob
ORDER BY COUNT (*) DESC;