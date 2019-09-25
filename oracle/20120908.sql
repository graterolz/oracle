BEGIN
	DELETE FROM acsmigra.cobert_aseg_rec_mig@desa;
	COMMIT;

	PM_EG.LOG_EJECUCION ('pm_of.MIGRA_COBER_ASEG_REC', 'I', 1);
	PM_OF.MIGRA_COBER_ASEG_REC;
	PM_EG.LOG_TABLAS ('cobert_aseg_rec_mig');
	PM_EG.LOG_EJECUCION ('pm_of.MIGRA_COBER_ASEG_REC', 'F', 1);
	--
	PM_EG.LOG_EJECUCION ('pm_of.migra_cobert_cert', 'I', 1);
	PM_OF.migra_cobert_cert;
	PM_EG.LOG_TABLAS ('cobert_cert_mig');
	PM_EG.LOG_EJECUCION ('pm_of.migra_cobert_cert', 'F', 1);
	--
	IF USER = 'MIGRA' THEN
		PM_EG.LOG_EJECUCION ('pm_al.mig_benef_cert', 'I', 1);
		pm_al.mig_benef_cert;
		PM_EG.LOG_TABLAS ('benef_cert_mig');
		PM_EG.LOG_TABLAS ('beneficiario_mig');
		PM_EG.LOG_EJECUCION ('pm_al.mig_benef_cert', 'F', 1);
	END IF;
	--
	PM_EG.LOG_EJECUCION ('pm_al.mig_datos_particulares', 'I', 1);
	pm_al.mig_datos_particulares;
	PM_EG.LOG_TABLAS ('cert_veh_mig');
	PM_EG.LOG_TABLAS ('cond_veh_mig');
	PM_EG.LOG_EJECUCION ('pm_al.mig_datos_particulares', 'F', 1);
	--
	PM_EG.LOG_EJECUCION ('pm_of.MIGRA_AFIANZADO', 'I', 1);
	pm_of.MIGRA_AFIANZADO;
	PM_EG.LOG_TABLAS ('afianzado_mig');
	PM_EG.LOG_EJECUCION ('pm_of.MIGRA_AFIANZADO', 'F', 1);
	--
	PM_EG.LOG_EJECUCION ('pm_of.MIGRA_CONTRAGARANTE_VALUACION', 'I', 1);
	pm_of.MIGRA_CONTRAGARANTE_VALUACION;
	PM_EG.LOG_TABLAS ('contragarante_mig');
	PM_EG.LOG_TABLAS ('valuaciones_fian_mig');
	PM_EG.LOG_EJECUCION ('pm_of.MIGRA_CONTRAGARANTE_VALUACION', 'F', 1);
	--
	PM_EG.LOG_EJECUCION ('pm_of.MIGRA_DATOS_PARTICULARES', 'I', 1);
	pm_of.MIGRA_DATOS_PARTICULARES;
	PM_EG.LOG_TABLAS ('datos_part_fianzas_mig');
	PM_EG.LOG_EJECUCION ('pm_of.MIGRA_DATOS_PARTICULARES', 'F', 1);
	--
	PM_EG.LOG_EJECUCION ('pm_of.MIGRA_NOTARIAS', 'I', 1);
	pm_of.MIGRA_NOTARIAS;
	PM_EG.LOG_TABLAS ('datos_notaria_fian_mig');
	PM_EG.LOG_EJECUCION ('pm_of.MIGRA_NOTARIAS', 'F', 1);
	--
	PM_EG.LOG_EJECUCION ('pm_al.mig_prestamos', 'I', 1);
	pm_al.mig_prestamos;
	PM_EG.LOG_TABLAS ('prestamo_vida_mig');
	PM_EG.LOG_TABLAS ('det_prest_vida_mig');
	PM_EG.LOG_TABLAS ('rec_prest_vida_mig');
	PM_EG.LOG_TABLAS ('rescate_mig');
	PM_EG.LOG_TABLAS ('datos_part_vida_mig');
	PM_EG.LOG_EJECUCION ('pm_al.mig_prestamos', 'F', 1);
	--
	PM_EG.LOG_EJECUCION ('POLIZAS', 'F', 1);
	MIG_BIENES;
	MIG_REASEGURO;
END;