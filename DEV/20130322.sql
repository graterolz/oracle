DELETE FROM TERCERO_MIG_PRUEBA;
COMMIT;
--
DELETE FROM CLIENTE_MIG_PRUEBA;
COMMIT;
--
DELETE FROM TERCERO_ROL_MIG_PRUEBA;
COMMIT;
--
DELETE FROM ERR_MIG_CLIENTE;
COMMIT;
--
BEGIN
	MIGRA.MIG_TERCERO_EG.GENERA_TABLAS_EQ_TERCEROS;
	MIGRA.MIG_TERCERO_EG.GENERA_TABLAS_EQ_TERCEROS_M;
	--
	MIGRA.MIG_TERCERO_EG.GENERA_EQ_MENORES;
	MIGRA.MIG_TERCERO_EG.GENERA_DATA_SIN_EQ;
	--
	MIGRA.MIG_TERCERO_EG.MIGRACION_GENERAL_TERCEROS;
	MIGRA.MIG_TERCERO_EG.MIGRACION_GENERAL_TERCEROS_M;
END;