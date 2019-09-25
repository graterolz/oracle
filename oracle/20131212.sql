DECLARE
	CURSOR CUR
	IS
	SELECT * FROM POLIZAS_A_TRANSF_TOTALFAST
	WHERE INDPOLTRANSF = 'Z';
BEGIN
	FOR I IN CUR
	LOOP
		UPDATE POLIZAS_A_TRANSF_TOTALFAST
		SET INDPOLTRANSF = 'N'
		WHERE ROWID = I.ROWID;
		COMMIT;

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
		EXCEPTION WHEN OTHERS THEN
			UPDATE POLIZAS_A_TRANSF_TOTALFAST
			SET INDPOLTRANSF = 'Z'
			WHERE ROWID = I.ROWID;
	  END;
   END LOOP;
END;