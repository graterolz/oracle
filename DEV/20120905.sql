DECLARE
	CURSOR cur_hjpf02
	IS
	SELECT * FROM (
		SELECT polizas.ramo, polizas.poliza,
			((RECIBOS.AnoDes * 10000)+ (RECIBOS.MesDes * 100)+ RECIBOS.DiaDes) desde_recibo,
			((POLIZAS.AnoDes * 10000)+ (POLIZAS.MesDes * 100)+ POLIZAS.DiaDes) desde_poliza,
			((RECIBOS.AnoHas * 10000)+ (RECIBOS.MesHas * 100)+ RECIBOS.DiaHas) hasta_recibo,
			((POLIZAS.AnoHas * 10000)+ (POLIZAS.MesHas * 100)+ POLIZAS.DiaHas) hasta_poliza
		FROM hjpf01 polizas, hjpf02 recibos
		WHERE polizas.ramo = recibos.ramo
		AND polizas.poliza = recibos.poliza
	)
	WHERE desde_recibo < desde_poliza
	OR desde_recibo > hasta_poliza
	OR hasta_recibo < desde_poliza
	OR hasta_recibo > hasta_poliza
	ORDER BY ramo, poliza;

	CURSOR cur_hjpf05
	IS
	SELECT * FROM (
		SELECT COBERTU.ramo, COBERTU.poliza, COBERTU.numrec,
			MAX (((COBERTU.AnoDco * 10000)+ (COBERTU.MesDco * 100)+ COBERTU.DiaDco)) desde_cobertura,
			MAX (((POLIZAS.AnoDes * 10000)+ (POLIZAS.MesDes * 100)+ POLIZAS.DiaDes)) desde_poliza,
			MAX (((COBERTU.AnoHco * 10000)+ (COBERTU.MesHco * 100)+ COBERTU.DiaHco)) hasta_cobertura,
			MAX (((POLIZAS.AnoHas * 10000)+ (POLIZAS.MesHas * 100)+ POLIZAS.DiaHas)) hasta_poliza
		FROM hjpf01 polizas, hjpf05 COBERTU
		WHERE polizas.ramo = COBERTU.ramo
		AND polizas.poliza = COBERTU.poliza
		GROUP BY COBERTU.ramo, COBERTU.poliza, COBERTU.numrec
	)
	WHERE desde_cobertura < desde_poliza
	OR desde_cobertura > hasta_poliza
	OR hasta_cobertura < desde_poliza
	OR hasta_cobertura > hasta_poliza;
BEGIN
	FOR i IN cur_hjpf02
	LOOP
		PM.GENERA_ERROR_CARTERA (
			cTipoError		=> 'ERR-POLIZA',
			cCodError		=> '018',
			cNomProceso		=> 'SIN ASIGNAR - SCRIPT',
			cNomTabla		=> 'HJPF01-HJPF02',
			cMigraPoliza	=> 'N',
			nRamo			=> I.ramo,
			nPoliza			=> I.poliza,
			nNumrec			=> I.Numrec
		);
		COMMIT;
	END LOOP;

	FOR i IN cur_hjpf05
	LOOP
		PM.GENERA_ERROR_CARTERA (
			cTipoError		=> 'ERR-POLIZA',
			cCodError		=> '018',
			cNomProceso		=> 'SIN ASIGNAR - SCRIPT',
			cNomTabla		=> 'HJPF01-HJPF05',
			cMigraPoliza	=> 'N',
			nRamo			=> I.ramo,
			nPoliza			=> I.poliza,
			nNumrec			=> I.Numrec
		);
		COMMIT;
	END LOOP;
END;