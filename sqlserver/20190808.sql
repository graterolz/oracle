CREATE TABLE #tmp (
	[id] INT IDENTITY (1, 1),
	[entidad] VARCHAR(100),
	[codigo] VARCHAR(100),
	[cliente] VARCHAR(100),
	[cli_cuit_original] VARCHAR(100),
	[cli_cuit_con_formato] VARCHAR(100),
	[mensaje_error] VARCHAR(100),
	[cantidad_duplicado] VARCHAR(100)
)
GO
-- H1. Numero de Identificacion (cli_cuit) vacio.
INSERT INTO #tmp 
SELECT
	'DIM_CLIENTES' [entidad],
	[codigocliente],
	[cliente],
	[nit],
	'N/A' [cli_cuit_con_formato],
	'NIT VACIO' [mensaje_error],
	0 [cantidad_duplicado]
FROM [BEMELTEST].[dbo].[DimClientes_test]
WHERE RTRIM(LTRIM([nit])) = ''
AND RTRIM(LTRIM([cliente])) <> ''
GO
-- H2. Numero de Identificacion (cli_descripcion) vacio.
INSERT INTO #tmp 
SELECT
	'DIM_CLIENTES' [entidad],
	[codigocliente],
	[cliente],
	[nit],
	'N/A' [cli_cuit_con_formato],
	'NOMBRE VACIO' [mensaje_error],
	0 [cantidad_duplicado]
FROM [BEMELTEST].[dbo].[DimClientes_test]
WHERE RTRIM(LTRIM([nit])) <> ''
AND RTRIM(LTRIM([cliente])) = ''
GO
-- H3. Numeros de Idenficacion (cli_cuit) repetidos.
WITH lista_adptos AS (
	SELECT
		[codigocliente],
		[cliente],
		[nit],
		CAST(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM([nit])),' ',''),'.',''),'-','') AS BIGINT) [cli_cuit_con_formato]
	FROM [BEMELTEST].[dbo].[DimClientes_test]
	WHERE RTRIM(LTRIM([nit])) <> ''
	AND RTRIM(LTRIM([cliente])) <> ''
),
lista_clientes_aptos_agrupados AS(
	SELECT [cli_cuit_con_formato], COUNT(*) [cantidad_duplicado]
	FROM lista_adptos
	WHERE [cli_cuit_con_formato] <> 0
	GROUP BY [cli_cuit_con_formato]
	HAVING COUNT(*) > 1
)
--
INSERT INTO #tmp
SELECT
	'DIM_CLIENTES' [entidad],
	[codigocliente],
	[cliente],
	[nit],
	[cli_cuit_con_formato],
	'NIT DUPLICADO' [mensaje_error],
	COUNT(*) [cantidad_duplicado]
FROM lista_adptos
WHERE [cli_cuit_con_formato] IN (
	SELECT [cli_cuit_con_formato] FROM lista_clientes_aptos_agrupados
)
GROUP BY [codigocliente],[cliente],[nit],[cli_cuit_con_formato] 
GO
-- H4. Numero de identificación (cli_cuit) en ceros o con ceros.
INSERT INTO #tmp
SELECT
	'DIM_CLIENTES' [entidad],
	[codigocliente],
	[cliente],
	[nit],[cli_cuit_con_formato],
	'NIT EN CEROS' [mensaje_error],
	0 [cantidad_duplicado]
FROM (
	SELECT
		[codigocliente],
		[cliente],
		[nit],
		CAST(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM([nit])),' ',''),'.',''),'-','') AS BIGINT) [cli_cuit_con_formato]
	FROM [BEMELTEST].[dbo].[DimClientes_test]
	WHERE RTRIM(LTRIM([nit])) <> ''
) A
WHERE [cli_cuit_con_formato] = 0
GO
--SQL1
SELECT MAX([id]) [id], [entidad], [mensaje_error], COUNT(*) 'cantidad_errores'
FROM #tmp
GROUP BY [entidad], [mensaje_error]
ORDER BY 1
--SQL2
SELECT *
FROM #tmp
ORDER BY 1
--
DROP TABLE #tmp