DECLARE
	vFecha DATE := SYSDATE-1;
	--
	CURSOR curContabilidad
	IS
	SELECT
		PROCESS_DATE Fecha_Proceso,
		currency Moneda,
		CARD_NUMBER Tarjeta,
		accountant_default_age Mora,
		ACCOUNT_CODE Cuenta,
		DEBIT_AMOUNT Debito,
		CREDIT_AMOUNT Credito,
		ORIGIN Origen,
		INTERNAL_TRANSACTION Transaccion,
		ACCOUNTANT_IDENTIFIER Identificador,
		ACCOUNTANT_CONCEPT Concepto,
		BIN,
		CREDIT_MODALITY Modalidad,
		MERCHANT Afiliacion
	FROM OPENCARD.AC_ACCOUNTANT_BALANCE_FLOW
	WHERE Process_date BETWEEN TO_CHAR (vFecha, 'DD/MM/YY') AND TO_CHAR (vFecha, 'DD/MM/YY');
	--
	rows_curContabilidad curContabilidad%ROWTYPE;
	--
	Lv_Archivo_Out UTL_FILE.File_Type;
	Lv_Linea_Out VARCHAR2(2000) := NULL;
	Lv_Path_Out VARCHAR2(4000) := 'SALIDA'; -- /InOut/BANKBU/BOD/Out
	Lv_Nombrearchivo_Out VARCHAR2(500) := 'CONTABILIDAD-'||TO_CHAR (vFecha, 'YYYY-MM-DD')||'.csv';
	--
BEGIN
	OPEN curContabilidad;
	LOOP
		FETCH curContabilidad INTO rows_curContabilidad;
		--
		IF curContabilidad%FOUND THEN
			IF (curContabilidad%ROWCOUNT) = 1 THEN
				Lv_Archivo_Out := UTL_FILE.FOPEN(Lv_Path_Out,Lv_Nombrearchivo_Out,'w');
				Lv_Linea_Out := 'Fecha_Proceso;Moneda;Tarjeta;Mora;Cuenta;Debito;Credito;Origen;Transaccion;Identificador;Concepto;BIN;Modalidad;Afiliacion';
				UTL_FILE.PUT_LINE(Lv_Archivo_Out, Lv_Linea_Out);
			ELSE
				Lv_Linea_Out := 
					rows_curContabilidad.Fecha_Proceso || ';' ||
					rows_curContabilidad.Tarjeta || ';' ||
					rows_curContabilidad.Moneda || ';' ||
					rows_curContabilidad.Tarjeta || ';' ||
					rows_curContabilidad.Mora || ';' ||
					rows_curContabilidad.Cuenta || ';' ||
					rows_curContabilidad.Debito || ';' ||
					rows_curContabilidad.Credito || ';' ||
					rows_curContabilidad.Origen || ';' ||
					rows_curContabilidad.Transaccion || ';' ||
					rows_curContabilidad.Identificador || ';' ||
					rows_curContabilidad.Concepto || ';' ||
					rows_curContabilidad.BIN || ';' ||
					rows_curContabilidad.Modalidad || ';' ||
					rows_curContabilidad.Afiliacion;
				--				
				UTL_FILE.PUT_LINE(Lv_Archivo_Out, Lv_Linea_Out);
			END IF;
		END IF;
		--
		EXIT WHEN curContabilidad%NOTFOUND;
	END LOOP;
	CLOSE curContabilidad;
	--
EXCEPTION WHEN OTHERS THEN
	UTL_FILE.FCLOSE(Lv_Archivo_Out);
END;