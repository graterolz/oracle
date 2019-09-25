DECLARE
	CURSOR cur
	IS
	SELECT DISTINCT 
		SUBSTR (referencia, 15, 6) sucursal,
		SUBSTR (referencia, 22, 8) siniestro
	FROM error_transferencia_totalfast
	WHERE coderror = 'OTHERS-0084';	
BEGIN
	FOR i IN cur
	LOOP
		UPDATE SINT_RESERVA_COBERTURA_CERTIFI
		SET aviso_cia = 1
		WHERE SICC_SISI_CASU_CD_SUCURSAL = i.sucursal
		AND SICC_SICO_SISI_NU_SINIESTRO = i.siniestro
		AND aviso_cia = 0;
		
		UPDATE SINT_CERTIFICADOS_SINIESTROS
		SET aviso_cia = 1
		WHERE SICE_SISI_CASU_CD_SUCURSAL = i.sucursal
		AND SICE_SISI_NU_SINIESTRO = i.siniestro
		AND aviso_cia = 0;

		COMMIT;
   END LOOP;
END;