DECLARE
	CURSOR CUR
	IS
	SELECT DISTINCT 
		A.SISI_FE_OCURRENCIA FE_OCURRENCIA,
		B.SICE_COD_PRODUCTO PRODUCTO,
		B.SICE_CACE_CAPO_NU_POLIZA NU_POLIZA,
		B.SICE_CACE_NU_CERTIFICADO NU_CERTIFICADO,
		B.SICE_CARE_CASU_CD_SUCURSAL CD_SUCURSAL,
		B.SICE_SISI_NU_SINIESTRO NU_SINIESTRO,
		B.SICE_CARE_NU_RECIBO RECIBO_MALO,
		C.AF_RECIBO RECIBO_BUENO
	FROM SINT_SINIESTROS A, SINT_CERTIFICADOS_SINIESTROS B,AF_CTRL_RESERVA_COBERTURA_CERT C
	WHERE A.SISI_CASU_CD_SUCURSAL = B.SICE_SISI_CASU_CD_SUCURSAL
	AND A.SISI_NU_SINIESTRO = B.SICE_SISI_NU_SINIESTRO
	AND A.SISI_CASU_CD_SUCURSAL = C.AF_SICC_SISI_CASU_CD_SUCURSAL
	AND A.SISI_NU_SINIESTRO = C.AF_SICC_SICO_SISI_NU_SINIESTRO
	AND B.SICE_CACE_NU_CERTIFICADO = C.AF_SICC_CACE_NU_CERTIFICADO
	AND B.SICE_CARE_NU_RECIBO <> C.AF_RECIBO;
BEGIN
	FOR I IN CUR
	LOOP
		UPDATE AF_CTRL_RESERVA_COBERTURA_CERT
		SET AF_RECIBO = I.RECIBO_MALO
		WHERE AF_SICC_SISI_CASU_CD_SUCURSAL = I.CD_SUCURSAL
		AND AF_SICC_CACE_CAPO_NU_POLIZA = I.NU_POLIZA
		AND AF_SICC_CACE_NU_CERTIFICADO = I.NU_CERTIFICADO
		AND AF_SICC_SICO_SISI_NU_SINIESTRO = I.NU_SINIESTRO
		AND AF_RECIBO = I.RECIBO_BUENO;
		COMMIT;
	END LOOP;
END;