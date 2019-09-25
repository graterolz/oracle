SELECT TOP 10 * FROM Documento ORDER BY 3 DESC
--
ALTER TABLE Documento ADD Firmado bit
UPDATE Documento SET Firmado = 0
--
SELECT COUNT(*) FROM Documento
--
DECLARE @Search VARCHAR(255) SET @Search='SQLSERVER4'
--
SELECT DISTINCT
	o.name AS Object_Name,
	o.type_desc
FROM sys.sql_modules m
INNER JOIN sys.objects  o ON m.object_id=o.object_id
WHERE m.definition Like '%' + @Search + '%'
ORDER BY 2,1;
--
SELECT TOP 10 * FROM [SDI].[dbo].[Documento]
WHERE Ctitdoc LIKE '%James Rodríguez y el Bayern Múnich estrenan el título de la Bundesliga con goleada%'
--
UPDATE [SDI].[dbo].[Documento]
SET Firmado = 1
WHERE Ctitdoc LIKE '%James Rodríguez y el Bayern Múnich estrenan el título de la Bundesliga con goleada%'
--
SELECT TOP 10 * FROM [SDI].[dbo].[Documentos]