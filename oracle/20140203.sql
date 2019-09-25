DELETE error_transferencia_totalfast;
COMMIT;
--
SELECT * FROM error_transferencia_totalfast;
SELECT * FROM SYS.ALL_SCHEDULER_JOBS WHERE OWNER = 'TFAUTO';
EXEC DBMS_SCHEDULER.ENABLE('TFAUTO.JOB_TFAUTO_CARTERA_MAESTROS');
EXEC DBMS_SCHEDULER.ENABLE('TFAUTO.JOB_TFAUTO_SINIESTROS_Y_PAGOS');
EXEC DBMS_SCHEDULER.DISABLE('TFAUTO.JOB_TFAUTO_CARTERA_MAESTROS');
EXEC DBMS_SCHEDULER.DISABLE('TFAUTO.JOB_TFAUTO_SINIESTROS_Y_PAGOS');
--
BEGIN
    pr_transferencia_totalfast.TRANSFERENCIA_CART_BANCOS;
    pr_transferencia_totalfast.TRANSFEREN_CART_RAMOS_POLIZAS;
    pr_transferencia_totalfast.TRANSFERENCIA_CART_COBERTURAS;
    pr_transferencia_totalfast.TRANSFERENCIA_CART_PRODUCTORES;
    pr_transferencia_totalfast.TRA_CART_PROVEEDORES_SERVICIOS;
    pr_transferencia_totalfast.TRANSFERENCIA_CART_PAISES;
    pr_transferencia_totalfast.transferencia_cart_estados;
    pr_transferencia_totalfast.transferencia_cart_ciudades;
    pr_transferencia_totalfast.transferencia_cart_sucursales;
    pr_transferencia_totalfast.tran_sint_documentos_por_ramos;
    pr_transferencia_totalfast.tra_sint_tipo_beneficiario_pag;
    pr_transferencia_totalfast.TRANSFERENCIA_CART_USUARIOS;
    pr_transferencia_totalfast.transfer_sint_causa_siniestros;
    pr_transferencia_totalfast.transferen_sint_causa_rechazos;
    pr_transferencia_totalfast.transferencia_af_polizas;
    pr_transferencia_totalfast.MODIFICAR_STS_AF_RECIBOS;
    COMMIT;
END;
--
BEGIN
    pr_transferencia_acsel.chg_est_1;
    pr_transferencia_acsel.chg_est_3;
    pr_transferencia_acsel.chg_est_4;
    pr_transferencia_acsel.chg_est_5;
    pr_transferencia_acsel.chg_est_6;
    pr_transferencia_acsel.chg_cristalerias;
    pr_transferencia_acsel.CREAR_SINIESTRO;
    PR_TRANSFERENCIA_ACSEL.CREAR_SOLICITUD_PAGO;
    COMMIT;
END;
--
SELECT 
    OWNER, JOB_NAME, JOB_CREATOR, JOB_ACTION, START_DATE,
    REPEAT_INTERVAL, ENABLED, STATE, COMMENTS, LAST_START_DATE,
    LAST_RUN_DURATION 
FROM SYS.ALL_SCHEDULER_JOBS WHERE job_creator = 'TFAUTO';
--
DECLARE
    CURSOR cur
    IS
    SELECT DISTINCT 
        CODOFIEMI || CODPROD || LPAD (NUMPOL, 10, '0') poliza,
		codpol,numpol,codofiemi,codofisusc
	FROM poliza a,(
		SELECT DISTINCT COD_PRODUCTO, CD_SUCURSAL, NU_POLIZA FROM AF_polizas
		WHERE sucursal <> PR.BUSCA_LVAL ('OFICINAS', cd_sucursal)
		AND TO_DATE (fecha_creado, 'DD/MM/RRRR') >= '17/01/2014'
		AND TO_DATE (fecha_creado, 'DD/MM/RRRR') <= '29/01/2014'
	) b
	WHERE a.codpol = b.cod_producto
	AND a.codofiemi = b.cd_sucursal
	AND a.numpol = b.nu_poliza
	AND a.codofisusc <> b.cd_sucursal;
BEGIN
	FOR i IN cur
	LOOP
        BEGIN
            UPDATE AF_polizas
			SET cd_sucursal = i.codofisusc
			WHERE poliza = i.poliza
			AND nu_poliza = i.numpol
			AND cod_producto = i.codpol
			AND cd_sucursal = i.codofiemi;
            --
			DBMS_OUTPUT.PUT_LINE ('ACTUALIZADO: ' || i.codpol || i.codofiemi || i.numpol);            
		EXCEPTION WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE ('ERROR ACTUALIZADO: '|| i.codpol || i.codofiemi || i.numpol || ' - ' || SQLERRM);
		END;
	END LOOP;
END;