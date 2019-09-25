SELECT TABLAORIGEN, COUNT (*) FROM terceros_migracion
GROUP BY TABLAORIGEN;
--
SELECT TABLAORIGEN, COUNT (*) FROM terceros_migracion_existente
GROUP BY TABLAORIGEN;
--
SELECT COUNT (*) FROM acsmigra.tercero_mig@desa;
--
SELECT COUNT (*) "Total Migrados Terceros" FROM acsmigra.tercero_mig@desa aa
WHERE NOT EXISTS (
	SELECT * FROM acsel.tercero@cert bb
	WHERE aa.tipoid = bb.tipoid
	AND aa.numid = bb.numid
	AND aa.dvid = bb.dvid
);
--
SELECT COUNT (*) "Total EQ_HJPF01" FROM eq_hjpf01 aa
WHERE NOT EXISTS (
	SELECT * FROM acsel.tercero@cert bb
	WHERE aa.tipoid = bb.tipoid
	AND aa.numid = bb.numid
	AND aa.dvid = bb.dvid
);
--
SELECT COUNT (*) "Total EQ_HJPF71" FROM eq_hjpf71 aa
WHERE NOT EXISTS (
	SELECT * FROM acsel.tercero@cert bb
	WHERE aa.tipoid = bb.tipoid
	AND aa.numid = bb.numid
	AND aa.dvid = bb.dvid
);
--
SELECT COUNT (*) "Total EQ_HJPF205" FROM eq_hjpf205 aa
WHERE NOT EXISTS (
	SELECT * FROM acsel.tercero@cert bb
	WHERE aa.tipoid = bb.tipoid
	AND aa.numid = bb.numid
	AND aa.dvid = bb.dvid
);
--
SELECT COUNT (*) "Total EQ_FNPF01" FROM eq_fnpf01 aa
WHERE NOT EXISTS (
	SELECT * FROM acsel.tercero@cert bb
	WHERE aa.tipoid = bb.tipoid
	AND aa.numid = bb.numid
	AND aa.dvid = bb.dvid
);
--
SELECT COUNT (*) "Total EQ_FNPF01" FROM eq_fnpf01 aa
WHERE NOT EXISTS (
	SELECT * FROM acsel.tercero@cert bb
	WHERE aa.tipoid = bb.tipoid
	AND aa.numid = bb.numid
	AND aa.dvid = bb.dvid
);
--
SELECT COUNT (*) "Total EQ_ORDENE" FROM eq_ordene aa
WHERE NOT EXISTS (
	SELECT * FROM acsel.tercero@cert bb
	WHERE aa.tipoid = bb.tipoid
	AND aa.numid = bb.numid
	AND aa.dvid = bb.dvid
);
--
SELECT COUNT (*) "Total EQ_ORPF06" FROM eq_orpf06 aa
WHERE NOT EXISTS (
	SELECT * FROM acsel.tercero@cert bb
	WHERE aa.tipoid = bb.tipoid
	AND aa.numid = bb.numid
	AND aa.dvid = bb.dvid
);
--
SELECT COUNT (*) "Total EQ_CLPF05_FAM" FROM eq_clpf05_fam aa
WHERE NOT EXISTS (
	SELECT * FROM acsel.tercero@cert bb
	WHERE aa.tipoid = bb.tipoid
	AND aa.numid = bb.numid
	AND aa.dvid = bb.dvid
);
--
SELECT COUNT (*) "Total EQ_CLPF07" FROM eq_clpf07 aa
WHERE NOT EXISTS (
	SELECT * FROM acsel.tercero@cert bb
	WHERE aa.tipoid = bb.tipoid
	AND aa.numid = bb.numid
	AND aa.dvid = bb.dvid
);
--
SELECT COUNT (*) "Total EQ_HJPF06" FROM eq_hjpf06 aa
WHERE NOT EXISTS (
	SELECT * FROM acsel.tercero@cert bb
	WHERE aa.tipoid = bb.tipoid
	AND aa.numid = bb.numid
	AND aa.dvid = bb.dvid
);
--
DECLARE
	CURSOR EQ
	IS
	SELECT ROWID, TIPOID, NUMID, DVID FROM terceros_migracion
	WHERE TRIM (tablaorigen) IS NULL;
	--
	CURSOR EQ_MENOR (
		p_tipoid	acsmigra.tercero_mig.tipoid@desa%TYPE,
		p_numid		acsmigra.tercero_mig.numid@desa%TYPE,
		p_dvid		acsmigra.tercero_mig.dvid@desa%TYPE,
		p_tabla		eq_mig_menores.nomtabla%TYPE
	)
	IS
	SELECT ROWID, TIPOID, NUMID, DVID
	FROM EQ_MIG_MENORES
	WHERE numlogproceso = 81
	AND tipoid = p_tipoid
	AND numid = p_numid
	AND dvid = p_dvid
	AND nomtabla = p_tabla;
	--
	CURSOR C_EQ_HJPF01 (
		p_tipoid	acsmigra.tercero_mig.tipoid@desa%TYPE,
		p_numid		acsmigra.tercero_mig.numid@desa%TYPE,
		p_dvid		acsmigra.tercero_mig.dvid@desa%TYPE
	)
	IS
	SELECT ROWID, tipoid, numid, dvid
	FROM EQ_HJPF01
	WHERE tipoid = p_tipoid
	AND numid = p_numid
	AND dvid = p_dvid;
	--
	CURSOR C_EQ_HJPF71 (
		p_tipoid	acsmigra.tercero_mig.tipoid@desa%TYPE,
		p_numid		acsmigra.tercero_mig.numid@desa%TYPE,
		p_dvid		acsmigra.tercero_mig.dvid@desa%TYPE
	)
	IS
	SELECT ROWID, tipoid, numid, dvid
	FROM EQ_HJPF71
	WHERE tipoid = p_tipoid 
	AND numid = p_numid
	AND dvid = p_dvid;
	--
	CURSOR C_EQ_HJPF205 (
		p_tipoid	acsmigra.tercero_mig.tipoid@desa%TYPE,
		p_numid		acsmigra.tercero_mig.numid@desa%TYPE,
		p_dvid		acsmigra.tercero_mig.dvid@desa%TYPE
	)
	IS
	SELECT ROWID, tipoid, numid, dvid
	FROM EQ_HJPF205
	WHERE tipoid = p_tipoid
	AND numid = p_numid
	AND dvid = p_dvid;
	--
	CURSOR C_EQ_FNPF01 (
		p_tipoid	acsmigra.tercero_mig.tipoid@desa%TYPE,
		p_numid		acsmigra.tercero_mig.numid@desa%TYPE,
		p_dvid		acsmigra.tercero_mig.dvid@desa%TYPE
	)
	IS
	SELECT ROWID, tipoid, numid, dvid
	FROM EQ_FNPF01
	WHERE tipoid = p_tipoid
	AND numid = p_numid
	AND dvid = p_dvid;
	--
	CURSOR C_EQ_ORDENE (
		p_tipoid 	acsmigra.tercero_mig.tipoid@desa%TYPE,
		p_numid		acsmigra.tercero_mig.numid@desa%TYPE,
		p_dvid		acsmigra.tercero_mig.dvid@desa%TYPE
	)
	IS
	SELECT ROWID, tipoid, numid, dvid FROM EQ_ORDENE
	WHERE tipoid = p_tipoid
	AND numid = p_numid
	AND dvid = p_dvid;
	--
	CURSOR C_EQ_ORPF06 (
		p_tipoid    acsmigra.tercero_mig.tipoid@desa%TYPE,
		p_numid     acsmigra.tercero_mig.numid@desa%TYPE,
		p_dvid      acsmigra.tercero_mig.dvid@desa%TYPE
	)
	IS
	SELECT ROWID, tipoid, numid, dvid
	FROM EQ_ORPF06
	WHERE tipoid = p_tipoid
	AND numid = p_numid
	AND dvid = p_dvid;
	--
	CURSOR C_EQ_CLPF05_FAM (
		p_tipoid	acsmigra.tercero_mig.tipoid@desa%TYPE,
		p_numid		acsmigra.tercero_mig.numid@desa%TYPE,
		p_dvid		acsmigra.tercero_mig.dvid@desa%TYPE
	)
	IS
	SELECT ROWID, tipoid, numid, dvid
	FROM EQ_CLPF05_FAM
	WHERE tipoid = p_tipoid
	AND numid = p_numid
	AND dvid = p_dvid;
	--
	CURSOR C_EQ_CLPF07 (
		p_tipoid	acsmigra.tercero_mig.tipoid@desa%TYPE,
		p_numid		acsmigra.tercero_mig.numid@desa%TYPE,
		p_dvid		acsmigra.tercero_mig.dvid@desa%TYPE
	)
	IS
	SELECT ROWID, tipoid, numid, dvid FROM EQ_CLPF07
	WHERE tipoid = p_tipoid
	AND numid = p_numid
	AND dvid = p_dvid;
	--
	CURSOR C_EQ_HJPF06 (
		p_tipoid 	acsmigra.tercero_mig.tipoid@desa%TYPE,
		p_numid		acsmigra.tercero_mig.numid@desa%TYPE,
		p_dvid		acsmigra.tercero_mig.dvid@desa%TYPE
	)
	IS
	SELECT ROWID, tipoid, numid, dvid
	FROM EQ_HJPF06
	WHERE tipoid = p_tipoid
	AND numid = p_numid
	AND dvid = p_dvid;
	--
	rt_C_EQ_HJPF01	C_EQ_HJPF01%ROWTYPE;
	pOrigen			VARCHAR2 (20);
BEGIN
	EXECUTE IMMEDIATE
	'DROP TABLE terceros_migracion';

	EXECUTE IMMEDIATE
	'CREATE TABLE terceros_migracion AS (
		SELECT * FROM acsmigra.tercero_mig@desa aa
		WHERE NOT EXISTS (
			SELECT * FROM acsel.tercero@cert bb
			WHERE aa.tipoid = bb.tipoid
			AND aa.numid = bb.numid
			AND aa.dvid = bb.dvid)
		)
	';

	EXECUTE IMMEDIATE
	'ALTER TABLE terceros_migracion ADD(tablaorigen VARCHAR2(20))';

	pOrigen := 'EQ_HJPF01';

	FOR I IN EQ
	LOOP
		OPEN C_EQ_HJPF01 (i.tipoid, i.numid, i.dvid);
		FETCH C_EQ_HJPF01 INTO rt_C_EQ_HJPF01;

		IF C_EQ_HJPF01%FOUND THEN
			UPDATE terceros_migracion
			SET tablaorigen = pOrigen
			WHERE ROWID = i.ROWID;
			COMMIT;
		END IF;

		CLOSE C_EQ_HJPF01;
	END LOOP;

	pOrigen := 'EQ_HJPF71';

	FOR I IN EQ
	LOOP
		OPEN C_EQ_HJPF71 (i.tipoid, i.numid, i.dvid);
		FETCH C_EQ_HJPF71 INTO rt_C_EQ_HJPF01;

		IF C_EQ_HJPF71%FOUND THEN
			UPDATE terceros_migracion
			SET tablaorigen = pOrigen
			WHERE ROWID = i.ROWID;
			COMMIT;
		END IF;

		CLOSE C_EQ_HJPF71;
	END LOOP;

	pOrigen := 'EQ_HJPF205';

	FOR I IN EQ
	LOOP
		OPEN C_EQ_HJPF205 (i.tipoid, i.numid, i.dvid);
		FETCH C_EQ_HJPF205 INTO rt_C_EQ_HJPF01;

		IF C_EQ_HJPF205%FOUND THEN
			UPDATE terceros_migracion
			SET tablaorigen = pOrigen
			WHERE ROWID = i.ROWID;

			COMMIT;
		END IF;

		CLOSE C_EQ_HJPF205;
	END LOOP;

	pOrigen := 'EQ_FNPF01';

	FOR I IN EQ
	LOOP
		OPEN C_EQ_FNPF01 (i.tipoid, i.numid, i.dvid);
		FETCH C_EQ_FNPF01 INTO rt_C_EQ_HJPF01;

		IF C_EQ_FNPF01%FOUND THEN
			UPDATE terceros_migracion
			SET tablaorigen = pOrigen
			WHERE ROWID = i.ROWID;
			COMMIT;
		END IF;

		CLOSE C_EQ_FNPF01;
	END LOOP;

	pOrigen := 'EQ_ORDENE';

	FOR I IN EQ
	LOOP
		OPEN C_EQ_ORDENE (i.tipoid, i.numid, i.dvid);
		FETCH C_EQ_ORDENE INTO rt_C_EQ_HJPF01;

		IF C_EQ_ORDENE%FOUND THEN
			UPDATE terceros_migracion
			SET tablaorigen = pOrigen
			WHERE ROWID = i.ROWID;

			COMMIT;
		END IF;

		CLOSE C_EQ_ORDENE;
	END LOOP;

	pOrigen := 'EQ_ORPF06';

	FOR I IN EQ
	LOOP
		OPEN C_EQ_ORPF06 (i.tipoid, i.numid, i.dvid);
		FETCH C_EQ_ORPF06 INTO rt_C_EQ_HJPF01;

		IF C_EQ_ORPF06%FOUND THEN
			UPDATE terceros_migracion
			SET tablaorigen = pOrigen
			WHERE ROWID = i.ROWID;

			COMMIT;
		END IF;

		CLOSE C_EQ_ORPF06;
	END LOOP;

	pOrigen := 'EQ_CLPF05_FAM';

	FOR I IN EQ
	LOOP
		OPEN C_EQ_CLPF05_FAM (i.tipoid, i.numid, i.dvid);
		FETCH C_EQ_CLPF05_FAM INTO rt_C_EQ_HJPF01;

		IF C_EQ_CLPF05_FAM%FOUND THEN
			UPDATE terceros_migracion
			SET tablaorigen = pOrigen
			WHERE ROWID = i.ROWID;

			COMMIT;
		END IF;

		CLOSE C_EQ_CLPF05_FAM;
	END LOOP;

	pOrigen := 'EQ_CLPF07';

	FOR I IN EQ
	LOOP
		OPEN C_EQ_CLPF07 (i.tipoid, i.numid, i.dvid);
		FETCH C_EQ_CLPF07 INTO rt_C_EQ_HJPF01;

		IF C_EQ_CLPF07%FOUND THEN
			UPDATE terceros_migracion
			SET tablaorigen = pOrigen
			WHERE ROWID = i.ROWID;

			COMMIT;
		END IF;

		CLOSE C_EQ_CLPF07;
	END LOOP;

	pOrigen := 'EQ_HJPF06';

	FOR I IN EQ
	LOOP
		OPEN C_EQ_HJPF06 (i.tipoid, i.numid, i.dvid);
		FETCH C_EQ_HJPF06 INTO rt_C_EQ_HJPF01;
		IF C_EQ_HJPF06%FOUND THEN
			UPDATE terceros_migracion
			SET tablaorigen = pOrigen
			WHERE ROWID = i.ROWID;
			COMMIT;
		END IF;

		CLOSE C_EQ_HJPF06;
	END LOOP;

	pOrigen := 'EQ_HJPF71';

	FOR I IN EQ
	LOOP
		OPEN EQ_MENOR (i.tipoid, i.numid, i.dvid, 'EQ_HJPF71');
		FETCH EQ_MENOR INTO rt_C_EQ_HJPF01;

		IF EQ_MENOR%FOUND THEN
			UPDATE terceros_migracion
			SET tablaorigen = pOrigen
			WHERE TIPOID = I.TIPOID
			AND NUMID = I.NUMID
			AND DVID = I.DVID
			AND TRIM (TABLAORIGEN) IS NULL;
			COMMIT;
		END IF;

		CLOSE EQ_MENOR;
	END LOOP;

	pOrigen := 'EQ_CLPF05_FAM';

	FOR I IN EQ
	LOOP
		OPEN EQ_MENOR (i.tipoid, i.numid, i.dvid, 'EQ_CLPF05_FAM');
		FETCH EQ_MENOR INTO rt_C_EQ_HJPF01;

		IF EQ_MENOR%FOUND THEN
			UPDATE terceros_migracion
			SET tablaorigen = pOrigen
			WHERE TIPOID = I.TIPOID
			AND NUMID = I.NUMID
			AND DVID = I.DVID
			AND TRIM (TABLAORIGEN) IS NULL;

			COMMIT;
		END IF;

		CLOSE EQ_MENOR;
	END LOOP;
END;