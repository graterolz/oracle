SELECT * FROM [ELZYRA].[dbo].[ReportesPorUsuario]
--
SELECT LC_DESCRIP2 FROM SERVICE.dbo.art WHERE co_art = '8003005'
UNION ALL
SELECT LC_DESCRIP2 FROM STAR01.dbo.art WHERE co_art = '8003005'
--
USE SERVICE EXEC sp_help 'dbo.art'
USE STAR01 EXEC sp_help 'dbo.art'
--
SELECT * FROM STAR01.dbo.art S
WHERE not EXISTS (
	SELECT 1 FROM SERVICE.dbo.art SE
	WHERE SE.co_art = S.co_art
	AND SE.LC_DESCRIP2 NOT LIKE S.LC_DESCRIP2
);
--
UPDATE STAR01.dbo.art
SET LC_DESCRIP2 = (
	SELECT LC_DESCRIP2 FROM SERVICE.dbo.art SE
	WHERE SE.co_art = STAR01.dbo.art.co_art
)
WHERE EXISTS (
	SELECT 1 FROM SERVICE.dbo.art SE
	WHERE SE.co_art = STAR01.dbo.art.co_art
)