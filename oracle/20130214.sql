SELECT 'EQ_HJPF01', COUNT (*) FROM (
	SELECT COUNT (*) FROM EQ_HJPF01 aa
	WHERE NOMASE <> ' '
	AND TIPOID NOT IN ('N', 'M')
	AND NOT EXISTS (
		SELECT * FROM acsel.tercero@cert bb
		WHERE aa.tipoid = bb.tipoid
		AND aa.numid = bb.numid
		AND aa.dvid = bb.dvid
	)
	GROUP BY TIPOID, NUMID, DVID, CODCLI
)
UNION ALL
SELECT 'EQ_HJPF71', COUNT (*) FROM (
	SELECT COUNT (*) FROM EQ_HJPF71 aa
	WHERE NOMBEN <> ' '
	AND ANONAC > 0
	AND (COFAAM < 99 OR COFAAM > 99)
	AND COFAAM > 0
	AND TRIM (TIPOID) IS NOT NULL
	AND NOT EXISTS (
		SELECT * FROM acsel.tercero@cert bb
		WHERE aa.tipoid = bb.tipoid
		AND aa.numid = bb.numid
		AND aa.dvid = bb.dvid
	)
	GROUP BY TIPOID, NUMID, DVID, CODCLI
)
UNION ALL
SELECT 'EQ_HJPF205', COUNT (*) FROM (
	SELECT COUNT (*) FROM EQ_HJPF205 AA, MCPF01 BB
	WHERE AA.TIPOID = BB.CCLI1(+)
	AND AA.NUMID = BB.CCLI2(+)
	AND TIPOID NOT IN ('N', 'M')
	AND NOT EXISTS (
		SELECT * FROM acsel.tercero@cert cc
		WHERE aa.tipoid = cc.tipoid
		AND aa.numid = cc.numid
		AND aa.dvid = cc.dvid
	)
	GROUP BY AA.TIPOID, AA.NUMID, AA.DVID, AA.CODCLI
)
UNION ALL
SELECT 'EQ_FNPF01', COUNT (*) FROM (
	SELECT COUNT (*) FROM EQ_FNPF01 aa
	WHERE TIPOID NOT IN ('N', 'M')
	AND NOT EXISTS (
		SELECT * FROM acsel.tercero@cert bb
		WHERE aa.tipoid = bb.tipoid
		AND aa.numid = bb.numid
		AND aa.dvid = bb.dvid
	)
	GROUP BY TIPOID, NUMID, DVID, CODCLI
)
UNION ALL
SELECT 'EQ_ORDENE', COUNT (*) FROM (
	SELECT COUNT (*) FROM EQ_ORDENE aa
	WHERE TIPOID NOT IN ('N', 'M')
	AND NOT EXISTS (
		SELECT * FROM acsel.tercero@cert bb
		WHERE aa.tipoid = bb.tipoid
		AND aa.numid = bb.numid
		AND aa.dvid = bb.dvid
	)
	GROUP BY TIPOID, NUMID, DVID, CODCLI
)
UNION ALL
SELECT 'EQ_ORPF06', COUNT (*) FROM (
	SELECT COUNT (*) FROM EQ_ORPF06 AA, SIPF05 BB
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
	AND tipoid NOT IN ('N', 'M')
	AND NOT EXISTS (
		SELECT * FROM acsel.tercero@cert cc
		WHERE aa.tipoid = cc.tipoid
		AND aa.numid = cc.numid
		AND aa.dvid = cc.dvid
	)
	GROUP BY TIPOID, NUMID, DVID, CODCLI
)
UNION ALL
SELECT 'EQ_CLPF05_FAM', COUNT (*) FROM (
	SELECT COUNT (*) FROM EQ_CLPF05_FAM AA, HJPF01 BB
	WHERE COLASE <> ' '
	AND AA.RAMO = BB.RAMO
	AND AA.POLIZA = BB.POLIZA
	AND NOT EXISTS (
		SELECT * FROM acsel.tercero@cert cc
		WHERE aa.tipoid = cc.tipoid
		AND aa.numid = cc.numid
		AND aa.dvid = cc.dvid
	)
	GROUP BY TIPOID, NUMID, DVID, CODCLI
)
UNION ALL
SELECT 'EQ_CLPF07', COUNT (*) FROM (
	SELECT COUNT (*) FROM EQ_CLPF07 AA, HJPF01 BB
	WHERE COLASE <> ' '
	AND AA.RAMO = BB.RAMO
	AND AA.POLIZA = BB.POLIZA
	AND TIPOID NOT IN ('N', 'M')
	AND NOT EXISTS (
		SELECT * FROM acsel.tercero@cert cc
		WHERE aa.tipoid = cc.tipoid
		AND aa.numid = cc.numid
		AND aa.dvid = cc.dvid
	)
	GROUP BY TIPOID, NUMID, DVID, CODCLI
)
UNION ALL
SELECT 'EQ_HJPF06', COUNT (*) FROM (
	SELECT COUNT (*) FROM EQ_hjpf06 AA, HJPF01 BB
	WHERE nomben <> ' '
	AND AA.RAMO = BB.RAMO
	AND AA.POLIZA = BB.POLIZA
	AND TIPOID NOT IN ('N', 'M')
	AND NOT EXISTS (
		SELECT * FROM acsel.tercero@cert cc
		WHERE aa.tipoid = cc.tipoid
		AND aa.numid = cc.numid
		AND aa.dvid = cc.dvid
	)
	GROUP BY TIPOID, NUMID, DVID, CODCLI
);