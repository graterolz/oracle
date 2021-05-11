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
	Lv_Nombrearchivo_Out VARCHAR2(500) := 'CONTABILIDAD-'||TO_CHAR (vFecha, 'YYYY-MM-DD')||'.xls';	
	--
BEGIN
	OPEN curContabilidad;
	LOOP
		FETCH curContabilidad INTO rows_curContabilidad;
		--
		IF curContabilidad%FOUND THEN
			IF (curContabilidad%ROWCOUNT) = 1 THEN
				Lv_Archivo_Out := UTL_FILE.FOPEN(Lv_Path_Out,Lv_Nombrearchivo_Out,'w');
				--
				UTL_FILE.PUT_LINE(Lv_Archivo_Out, '<?xml version="1.0"?>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out, '<ss:Workbook xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out, '<ss:Worksheet ss:Name="'||TO_CHAR (vFecha, 'YYYY-MM-DD')||'">');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out, '<ss:Table>');
				--
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Row>');
				-- 1
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">Fecha_Proceso</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 2
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">Moneda</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 3
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">Tarjeta</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 4
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">Mora</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 5
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">Cuenta</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 6
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">Debito</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 7
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">Credito</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 8
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">Origen</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 9
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">Transaccion</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 10
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">Identificador</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 11
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">Concepto</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 12
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">BIN</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 13
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">Modalidad</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 14
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">Afiliacion</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				--
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Row>');
			ELSE
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Row>');
				-- 1
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.Fecha_Proceso||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 2
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.Moneda||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 3
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.Tarjeta||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 4
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.Mora||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 5
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.Cuenta||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 6
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.Debito||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 7
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.Credito||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 8
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.Origen||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 9
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.Transaccion||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 10
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.Identificador||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 11
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.Concepto||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 12
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.BIN||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 13
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.Modalidad||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				-- 14
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Cell>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'<ss:Data ss:Type="String">'||rows_curContabilidad.Afiliacion||'</ss:Data>');
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Cell>');
				--
				UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Row>');
			END IF;
		ELSE
			IF (curContabilidad%ROWCOUNT) > 0 THEN
			UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Table>');
			UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Worksheet>');
			UTL_FILE.PUT_LINE(Lv_Archivo_Out,'</ss:Workbook>');
			UTL_FILE.FCLOSE(Lv_Archivo_Out);
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