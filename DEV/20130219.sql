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
	AND NOT EXISTS (
		SELECT * FROM TERCEROS_MIGRACION bb
		WHERE aa.tipoid = bb.tipoid
		AND aa.numid = bb.numid
		AND aa.dvid = bb.dvid
	)
	AND NOT EXISTS (
		SELECT * FROM EQ_MIG_MENORES bb
		WHERE nomtabla = 'EQ_HJPF71'
		AND numlogproceso = (
			SELECT MAX (numlogproceso) FROM eq_mig_menores
		)
		AND TRIM (bb.nacion) IS NULL
		AND bb.CEDULA = aa.cedben
	)
	AND NOT EXISTS (
		SELECT * FROM acsmigra.tercero_mig@desa bb
		WHERE aa.tipoid = bb.tipoid
		AND aa.numid = bb.numid
		AND aa.dvid = bb.dvid
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
	AND NOT EXISTS (
		SELECT * FROM TERCEROS_MIGRACION bb
		WHERE aa.tipoid = bb.tipoid
		AND aa.numid = bb.numid
		AND aa.dvid = bb.dvid
	)
	AND NOT EXISTS (
		SELECT * FROM EQ_MIG_MENORES bb
		WHERE nomtabla = 'EQ_CLPF05_FAM'
		AND numlogproceso = (
			SELECT MAX (numlogproceso) FROM eq_mig_menores
		)
		AND bb.nacion = aa.nacion
		AND bb.CEDULA = aa.cedcol
	)
	AND NOT EXISTS (
		SELECT * FROM acsmigra.tercero_mig@desa bb
		WHERE aa.tipoid = bb.tipoid
		AND aa.numid = bb.numid
		AND aa.dvid = bb.dvid
	)
	GROUP BY TIPOID, NUMID, DVID, CODCLI
)