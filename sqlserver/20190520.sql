sp_helptext 'domain.s_DX_GetCiudad'
--
EXEC domain.s_DX_GetCiudad 
SELECT * FROM sys.objects where name = 's_DX_GetCiudad'
--
SELECT TOP (1000) [value],[Nombre]
FROM [BEMEL_TEST_MIG.FWD_BUILD_APP_TX].[domain].[DX_GetCiudad_a931f87b7da74926ae1bd924f7935c2f]
--
SELECT * FROM more.MoreObjectAttributeValue WHERE MoreObjectID = '245693'
--
DECLARE @test NVARCHAR(MAX) = 'África'
SET @test = UPPER(@test) 
print @test
--
SELECT
	MoreObjectId AS value,
	(
		SELECT ValueString
		FROM more.MoreObjectAttributeValue AS MOAV WITH (NOLOCK)
		WHERE (MoreObjectID = MO.MoreObjectId)
		AND (MoreClassAttributeName = 'Nombre')
	) AS Nombre,
	(
		SELECT ValueString
		FROM more.MoreObjectAttributeValue AS MOAV WITH (NOLOCK)
		WHERE (MoreObjectID = MO.MoreObjectId)
		AND (MoreClassAttributeName = 'Abreviatura')
	) AS Abreviatura
FROM more.MoreObject AS MO WITH (NOLOCK)
WHERE (MoreKey = 'ciudad')
--
SELECT * FROM more.MoreObject AS MO WITH (NOLOCK)
WHERE (MoreKey = 'KERNEL_Indexador_Indices')
--
SELECT * FROM more.MoreObjectAttributeValue AS MOAV WITH (NOLOCK)
WHERE (MoreObjectID = '29256')
AND (MoreClassAttributeName = 'Nombre')) AS Nombre,
--
SELECT DISTINCT MoreKey FROM more.MoreObject WITH (NOLOCK) ORDER BY 1