USE ColombiaElecciones2018_Importacion
--
SELECT * FROM Resultados_Archivo
SELECT * FROM Resultados_Avance
SELECT * FROM Resultados_AvanceCircunscripcion
SELECT * FROM Resultados_AvanceCircunscripcionPartidoTotales
SELECT * FROM Resultados_AvanceCircunscripcionPartido
SELECT * FROM Resultados_AvanceCircunscripcionCandidato
SELECT * FROM Resultados_AvanceCircunscripcionCurules
--
EXECUTE MASTER.dbo.xp_enum_oledb_providers
--
SELECT * FROM [ColombiaElecciones2018].[dbo].[PARTIDOS]
SELECT * FROM [ColombiaElecciones2018].[dbo].[CANDIDATOS]
SELECT * FROM [ColombiaElecciones2018].[dbo].[DIVIPOL]
SELECT * FROM [ColombiaElecciones2018].[dbo].[CIRCUNSCRIPCION]
SELECT * FROM [ColombiaElecciones2018].[dbo].[CORPORACION]
--
SELECT * FROM Resultados_Archivo
SELECT * FROM Resultados_Avance
SELECT * FROM Resultados_AvanceCircunscripcion
SELECT * FROM Resultados_AvanceCircunscripcionPartidoTotales
SELECT * FROM Resultados_AvanceCircunscripcionPartido
SELECT * FROM Resultados_AvanceCircunscripcionCandidato
SELECT * FROM Resultados_AvanceCircunscripcionCurules
--
SELECT * FROM [ColombiaElecciones2018].[dbo].[PARTIDOS]
SELECT * FROM [ColombiaElecciones2018].[dbo].[CANDIDATOS]
SELECT * FROM [ColombiaElecciones2018].[dbo].[DIVIPOL]
SELECT * FROM [ColombiaElecciones2018].[dbo].[CIRCUNSCRIPCION]
SELECT * FROM [ColombiaElecciones2018].[dbo].[CORPORACION]
--
DECLARE @Corporacion varchar(50) SET @Corporacion = 'SE'
DECLARE @Departamento int SET @Departamento = '11'
EXECUTE .[dbo].[sp_Resultados_Avance] @Corporacion,@Departamento
--
DECLARE @AvanceID int SET @AvanceID = 10682
EXECUTE [ColombiaElecciones2018].[dbo].[sp_Resultados_Avance_Circunscripcion] @AvanceID
--
DECLARE @AvanceCircunscripcionID int SET @AvanceCircunscripcionID = 18597
EXECUTE [ColombiaElecciones2018].[dbo].[sp_Resultados_Avance_Circunscripcion_Partido] @AvanceCircunscripcionID
--
DECLARE @AvanceCircunscripcionID int SET @AvanceCircunscripcionID = 18597
EXECUTE [ColombiaElecciones2018].[dbo].[sp_Resultados_Avance_Circunscripcion_PartidoTotales] @AvanceCircunscripcionID
--
DECLARE @AvanceCircunscripcionID int SET @AvanceCircunscripcionID = 18597
DECLARE @Partido int
EXECUTE [ColombiaElecciones2018].[dbo].[sp_Resultados_Avance_Circunscripcion_Candidato] @AvanceCircunscripcionID
--
DECLARE @AvanceCircunscripcionID int SET @AvanceCircunscripcionID = 18597
EXECUTE [ColombiaElecciones2018].[dbo].[sp_Resultados_Avance_Circunscripcion_Curul] @AvanceCircunscripcionID