SELECT 	U1.*,
		PR_TRANSFERENCIA.busq_marca_veh (c.codmarca) MARCA,
		PR_TRANSFERENCIA.busq_modelo_veh (c.codmarca, c.codmodelo) MODELO,
		c.color,
		c.serialcarroceria
FROM (
	SELECT DISTINCT
		cd_sucursal, cd_productor, nu_poliza,
		nu_certificado, marca, modelo, a.color,
		placa, a.serialcarroceria, fecdespol,
		fechaspol, b.idepol
	FROM af_polizas a, poliza b
	WHERE nu_poliza = numpol
	AND FECDESPOL = FECINIVIG
	AND FECHASPOL = FECFINVIG and nu_poliza = 1106863
) U1, cert_veh C
WHERE U1.IDEPOL = C.IDEPOL
AND PR_TRANSFERENCIA.busq_marca_veh (c.codmarca) <> U1.MARCA
AND PR_TRANSFERENCIA.busq_modelo_veh (c.codmarca, c.codmodelo) <> U1.MODELO;
--
SELECT * FROM SINT_CERTIFICADOS_SINIESTROS B, AF_CTRL_RESERVA_COBERTURA_CERT C
WHERE B.SICE_SISI_CASU_CD_SUCURSAL = C.AF_SICC_SISI_CASU_CD_SUCURSAL
AND B.SICE_SISI_NU_SINIESTRO = C.AF_SICC_SICO_SISI_NU_SINIESTRO
AND B.SICE_CACE_NU_CERTIFICADO = C.AF_SICC_CACE_NU_CERTIFICADO
AND B.SICE_CARE_NU_RECIBO <> C.AF_RECIBO;
--
SELECT * FROM poliza WHERE numpol = 1058246;
--
SELECT * FROM cert_veh
WHERE idepol = (
	SELECT idepol FROM poliza
	WHERE codpol = 'AUTI'
	AND numpol = 1195429
	AND codofiemi = '010101'
	AND STSPOL = 'ACT'
);
--
SELECT * FROM poliza WHERE codpol = 'AUTI' AND numpol = 1195429 AND codofiemi = '010101';