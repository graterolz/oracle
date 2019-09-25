SELECT TOP 100 * FROM ColombiaElecciones2018_Importacion.dbo.Resultados_AvanceCircunscripcionCandidato
SELECT TOP 100 * FROM ColombiaElecciones2018_Importacion.dbo.Resultados_AvanceCircunscripcionPartido
SELECT TOP 100 * FROM ColombiaElecciones2018_Importacion.dbo.Resultados_AvanceCircunscripcionPartidoTotales
--
SELECT TOP 100 * FROM ColombiaElecciones2018_Importacion.dbo.Resultados_AvanceCircunscripcion ORDER BY 4 DESC
SELECT TOP 100 * FROM ColombiaElecciones2018_Importacion.dbo.Resultados_Avance WHERE Corporacion = 'PRESIDENTE'
SELECT TOP 100 * FROM ColombiaElecciones2018_Importacion.dbo.Resultados_Archivo WHERE Ruta LIKE '%BOL_PRE1%' ORDER BY 3 DESC
SELECT TOP 100 * FROM ColombiaElecciones2018_Importacion.dbo.Resultados_AvanceCircunscripcionCurules
--
SELECT TOP 100 * FROM ColombiaElecciones2018_Importacion.dbo.Clave_Divipol
SELECT TOP 100 * FROM ColombiaElecciones2018_Importacion.dbo.Clave_Candidatos
SELECT TOP 100 * FROM ColombiaElecciones2018_Importacion.dbo.Clave_Partidos
SELECT TOP 100 * FROM ColombiaElecciones2018_Importacion.dbo.Clave_Circunscripcion
SELECT TOP 100 * FROM ColombiaElecciones2018_Importacion.dbo.Clave_Corporacion
--
EXECUTE [ColombiaElecciones2018PRE1].[dbo].[sp_Resultados_Avance_Importacion]
--
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_AvanceCircunscripcionCandidato
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_AvanceCircunscripcionPartido
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_AvanceCircunscripcionPartidoTotales
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_AvanceCircunscripcion
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_Avance WHERE Corporacion = 'PRESIDENTE'
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_Divipol
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_Candidato
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_Municipio
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_AvanceCircunscripcionCurules
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_Partido
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_Departamento
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_Corporacion
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_Circunscripcion
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_Comuna
SELECT TOP 100 * FROM ColombiaElecciones2018.dbo.Resultados_Foto