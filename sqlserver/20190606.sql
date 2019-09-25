SELECT *
FROM [BEMELTEST].[dbo].[Asientos_manuales]
WHERE DATEPART(YEAR, [Fecha_contable]) = '2016'
AND DATEPART(MONTH, [Fecha_contable]) = '12'
ORDER BY [Fecha_contable]
--
SELECT *
FROM [BEMELTEST].[dbo].[Asientos_manuales]
WHERE DATEPART(YEAR, [Fecha_contable]) = '2017'
AND DATEPART(MONTH, [Fecha_contable]) = '01'
ORDER BY [Fecha_contable]
--
SELECT * 
FROM [BEMELTEST].[dbo].[Asientos_autom]
WHERE DATEPART(YEAR, [Fecha_contable]) = '2016'
AND DATEPART(MONTH, [Fecha_contable]) = '12'
ORDER BY [Fecha_contable]
--
SELECT * 
FROM [BEMELTEST].[dbo].[Asientos_autom]
WHERE DATEPART(YEAR, [Fecha_contable]) = '2017'
AND DATEPART(MONTH, [Fecha_contable]) = '01'
ORDER BY [Fecha_contable]
--
TRUNCATE TABLE [BEMELTEST].[dbo].[tmp_tb_errores_asientos]
--
INSERT INTO [BEMELTEST].[dbo].[tmp_tb_errores_asientos] (
	[tipo_asiento],[cuit_original],[razon_social],[numero_comprobante],[numero_asiento],[tipo_transaccion],[mensaje_error]
)
SELECT DISTINCT
	'AUTOMATICO' [tipo_asiento],
	RTRIM(LTRIM([cuit])) [cuit_original],
	'N/A' [razon_social],
	RTRIM(LTRIM([NroComprobante])) [numero_comprobante],
	'N/A' [numero_asiento],
	UPPER(RTRIM(LTRIM([Tipo_Transaccion]))) [tipo_transaccion],
	'RAZON SOCIAL VACIA' [mensaje_error]
FROM [BEMELTEST].[dbo].[tmp_tb_asientos_autom] (NOLOCK)
WHERE RTRIM(LTRIM([Cliente_Prov_Pers])) = ''
UNION ALL
SELECT DISTINCT
	'AUTOMATICO' [tipo_asiento],
	RTRIM(LTRIM([cuit])) [cuit_original],
	[Cliente_Prov_Pers] [razon_social],
	RTRIM(LTRIM([NroComprobante])) [numero_comprobante],
	'N/A' [numero_asiento],
	UPPER(RTRIM(LTRIM([Tipo_Transaccion]))) [tipo_transaccion],
	'SUCURSAL NULA' [mensaje_error]
FROM [BEMELTEST].[dbo].[tmp_tb_asientos_autom] (NOLOCK)
WHERE RTRIM(LTRIM([Sucursal])) IS NULL
UNION ALL
SELECT DISTINCT
	'AUTOMATICO' [tipo_asiento],
	RTRIM(LTRIM([cuit])) [cuit_original],
	[Cliente_Prov_Pers] [razon_social],
	RTRIM(LTRIM([NroComprobante])) [numero_comprobante],
	'N/A' [numero_asiento],
	UPPER(RTRIM(LTRIM([Tipo_Transaccion]))) [tipo_transaccion],
	'CODIGO DE AGENTE VACIO' [mensaje_error]
FROM [BEMELTEST].[dbo].[tmp_tb_asientos_autom] (NOLOCK)
WHERE RTRIM(LTRIM([Codigo_Agente])) = ''
UNION ALL
SELECT DISTINCT
	'AUTOMATICO' [tipo_asiento],
	RTRIM(LTRIM([cuit])) [cuit_original],
	[Cliente_Prov_Pers] [razon_social],
	RTRIM(LTRIM([NroComprobante])) [numero_comprobante],
	'N/A' [numero_asiento],
	UPPER(RTRIM(LTRIM([Tipo_Transaccion]))) [tipo_transaccion],
	'CONCEPTO DE NEGOCIO VACIO' [mensaje_error]
FROM [BEMELTEST].[dbo].[tmp_tb_asientos_autom] (NOLOCK)
WHERE RTRIM(LTRIM([Concepto_de_Negocio])) = ''
UNION ALL
SELECT DISTINCT
	'AUTOMATICO' [tipo_asiento],
	RTRIM(LTRIM([cuit])) [cuit_original],
	[Cliente_Prov_Pers] [razon_social],
	RTRIM(LTRIM([NroComprobante])) [numero_comprobante],
	'N/A' [numero_asiento],
	UPPER(RTRIM(LTRIM([Tipo_Transaccion]))) [tipo_transaccion],
	'DESCRIPCION DE MOVIMIENTO VACIO' [mensaje_error]
FROM [BEMELTEST].[dbo].[tmp_tb_asientos_autom] (NOLOCK)
WHERE RTRIM(LTRIM([Descripcion_Movimiento])) = ''
UNION ALL
--
SELECT DISTINCT
	'MANUAL' [tipo_asiento],
	RTRIM(LTRIM([NIT_Entidad])) [cuit_original],
	RTRIM(LTRIM([Entidad])) [razon_social],
	'N/A' [numero_comprobante],
	RTRIM(LTRIM([Nro_Asiento])) [numero_asiento],
	UPPER(RTRIM(LTRIM([tipo_asiento]))) [tipo_asiento],
	'RAZON SOCIAL VACIA' [mensaje_error]
FROM [BEMELTEST].[dbo].[tmp_tb_asientos_manual] (NOLOCK)
WHERE RTRIM(LTRIM([NIT_Entidad])) = ''
UNION ALL
SELECT DISTINCT
	'MANUAL' [tipo_asiento],
	RTRIM(LTRIM([NIT_Entidad])) [cuit_original],
	RTRIM(LTRIM([Entidad])) [razon_social],
	'N/A' [numero_comprobante],
	RTRIM(LTRIM([Nro_Asiento])) [numero_asiento],
	UPPER(RTRIM(LTRIM([tipo_asiento]))) [tipo_asiento],
	'CUIT VACIO' [mensaje_error]
FROM [BEMELTEST].[dbo].[tmp_tb_asientos_manual] (NOLOCK)
WHERE RTRIM(LTRIM([Entidad])) = ''
UNION ALL
SELECT DISTINCT
	'MANUAL' [tipo_asiento],
	RTRIM(LTRIM([NIT_Entidad])) [cuit_original],
	RTRIM(LTRIM([Entidad])) [razon_social],
	'N/A' [numero_comprobante],
	RTRIM(LTRIM([Nro_Asiento])) [numero_asiento],
	UPPER(RTRIM(LTRIM([tipo_asiento]))) [tipo_asiento],
	'TIPO DE ASIENTO VACIO' [mensaje_error]
FROM [BEMELTEST].[dbo].[tmp_tb_asientos_manual] (NOLOCK)
WHERE RTRIM(LTRIM([tipo_asiento])) = ''
UNION ALL
SELECT DISTINCT
	'MANUAL' [tipo_asiento],
	RTRIM(LTRIM([NIT_Entidad])) [cuit_original],
	RTRIM(LTRIM([Entidad])) [razon_social],
	'N/A' [numero_comprobante],
	RTRIM(LTRIM([Nro_Asiento])) [numero_asiento],
	UPPER(RTRIM(LTRIM([tipo_asiento]))) [tipo_asiento],
	'CONCEPTO VACIO' [mensaje_error]
FROM [BEMELTEST].[dbo].[tmp_tb_asientos_manual] (NOLOCK)
WHERE RTRIM(LTRIM([Concepto])) = ''
UNION ALL
SELECT DISTINCT
	'MANUAL' [tipo_asiento],
	RTRIM(LTRIM([NIT_Entidad])) [cuit_original],
	RTRIM(LTRIM([Entidad])) [razon_social],
	'N/A' [numero_comprobante],
	RTRIM(LTRIM([Nro_Asiento])) [numero_asiento],
	UPPER(RTRIM(LTRIM([tipo_asiento]))) [tipo_asiento],
	'DESCRIPCION DE MOVIMIENTO VACIO' [mensaje_error]
FROM [BEMELTEST].[dbo].[tmp_tb_asientos_manual] (NOLOCK)
WHERE RTRIM(LTRIM(Desc_Movimiento)) = ''
--
SELECT [tipo_asiento],[mensaje_error], COUNT(*) [cantidad]
FROM [BEMELTEST].[dbo].[tmp_tb_errores_asientos]
GROUP BY [tipo_asiento],[mensaje_error]
ORDER BY 3 DESC
--
SELECT [cli_cuit_con_formato], COUNT(*) [cantidad_duplicado]
FROM (
	SELECT
		[cli_codigo],
		[cli_cuit],
		CAST(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM([cli_cuit])),' ',''),'.',''),'-','') AS BIGINT) [cli_cuit_con_formato]
	FROM [BEMELTEST].[dbo].[clientes_test]
	WHERE RTRIM(LTRIM([cli_cuit])) <> ''
) A
WHERE [cli_cuit_con_formato] <> 0
GROUP BY [cli_cuit_con_formato]
HAVING COUNT(*) > 1
ORDER BY 2 DESC
GO
--
SELECT [pro_cuit_con_formato], COUNT(*) [cantidad_duplicado]
FROM (
	SELECT
		[pro_codigo],
		[pro_cuit],
		CAST(REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM([pro_cuit])),' ',''),'.',''),'-',''),',','') AS BIGINT) [pro_cuit_con_formato]
	FROM [BEMELTEST].[dbo].[proveedo_test]
	WHERE RTRIM(LTRIM([pro_cuit])) <> ''
) A
WHERE [pro_cuit_con_formato] <> 0
GROUP BY [pro_cuit_con_formato]
HAVING COUNT(*) > 1
ORDER BY 2 DESC
GO
--
SELECT [cia_cuit_con_formato], COUNT(*) [cantidad_duplicado]
FROM (
	SELECT
		[cia_codigo],
		[cia_cuit],
		CAST(REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM([cia_cuit])),' ',''),'.',''),'-',''),',','') AS BIGINT) [cia_cuit_con_formato]
	FROM [BEMELTEST].[dbo].[ciatrans_test]
	WHERE RTRIM(LTRIM([cia_cuit])) <> ''
	AND RTRIM(LTRIM([cia_cuit])) <> 'N/A'
) A
WHERE [cia_cuit_con_formato] <> 0
GROUP BY [cia_cuit_con_formato]
HAVING COUNT(*) > 1
ORDER BY 2 DESC
GO
--
SELECT [age_cuit_con_formato], COUNT(*) [cantidad_duplicado]
FROM (
	SELECT
		[age_codigo],
		[age_cuit],
		CAST(REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM([age_cuit])),' ',''),'.',''),'-',''),',','') AS BIGINT) [age_cuit_con_formato]
	FROM [BEMELTEST].[dbo].[agentes_test]
	WHERE RTRIM(LTRIM([age_cuit])) <> ''
) A
WHERE [age_cuit_con_formato] <> 0
GROUP BY [age_cuit_con_formato]
HAVING COUNT(*) > 1
ORDER BY 2 DESC
GO