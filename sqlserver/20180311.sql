SELECT * FROM [ColombiaElecciones2018_Importacion].[dbo].[Resultados_Avance]
WHERE Boletin_Departamental = '0019' AND Tipo = 'NACIONAL' AND Corporacion = 'CAMARA'
--
SELECT * FROM [ColombiaElecciones2018_Importacion].[dbo].[Resultados_AvanceCircunscripcion]
WHERE AvanceID = '82830'
--
TRUNCATE TABLE ColombiaElecciones2018_Importacion.dbo.Resultados_Archivo
TRUNCATE TABLE ColombiaElecciones2018_Importacion.dbo.Resultados_Avance
TRUNCATE TABLE ColombiaElecciones2018_Importacion.dbo.Resultados_AvanceCircunscripcion
TRUNCATE TABLE ColombiaElecciones2018_Importacion.dbo.Resultados_AvanceCircunscripcionCandidato
TRUNCATE TABLE ColombiaElecciones2018_Importacion.dbo.Resultados_AvanceCircunscripcionCurules
TRUNCATE TABLE ColombiaElecciones2018_Importacion.dbo.Resultados_AvanceCircunscripcionPartido
TRUNCATE TABLE ColombiaElecciones2018_Importacion.dbo.Resultados_AvanceCircunscripcionPartidoTotales
--
INSERT INTO ColombiaElecciones2018_Importacion.dbo.Clave_Candidatos SELECT * FROM ColombiaElecciones2018_Importacion.dbo.CANDIDATOS$
INSERT INTO ColombiaElecciones2018_Importacion.dbo.Clave_Circunscripcion SELECT * FROM ColombiaElecciones2018_Importacion.dbo.CIRCUNSCRIPCION$
INSERT INTO ColombiaElecciones2018_Importacion.dbo.Clave_Corporacion SELECT * FROM ColombiaElecciones2018_Importacion.dbo.CORPORACION$
INSERT INTO ColombiaElecciones2018_Importacion.dbo.Clave_Partidos SELECT * FROM ColombiaElecciones2018_Importacion.dbo.PARTIDOS$
INSERT INTO ColombiaElecciones2018_Importacion.dbo.Clave_Divipol SELECT * FROM ColombiaElecciones2018_Importacion.dbo.DIVIPOL$
--
DROP TABLE ColombiaElecciones2018_Importacion.dbo.CANDIDATOS$
DROP TABLE ColombiaElecciones2018_Importacion.dbo.CIRCUNSCRIPCION$
DROP TABLE ColombiaElecciones2018_Importacion.dbo.CORPORACION$
DROP TABLE ColombiaElecciones2018_Importacion.dbo.PARTIDOS$
DROP TABLE ColombiaElecciones2018_Importacion.dbo.DIVIPOL$
--
INSERT INTO ColombiaElecciones2018.dbo.Resultados_Candidato (
	[Corporacion],[Circunscripcion],[Departamento],[Municipio],[Comuna],
	[Partido],[Candidato],[Preferente],[Nombre],[Apellido],[Cedula],[Genero]
)
SELECT [Corporacion],[Circunscripcion],[Codigo_Departamento],[Codigo_Municipio],[Codigo_Comuna],
	[Codigo_Partido],[Codigo_Candidato],[Preferente_Tipo],[Nombre],[Apellido],[Cedula],[Genero]
FROM ColombiaElecciones2018_Importacion.dbo.Clave_Candidatos
--
INSERT INTO ColombiaElecciones2018.dbo.Resultados_Circunscripcion ([CircunscripcionID],[Descripcion])
SELECT [Codigo],[Tipo_Circunscripcion] FROM ColombiaElecciones2018_Importacion.dbo.Clave_Circunscripcion
--
INSERT INTO ColombiaElecciones2018.dbo.Resultados_Corporacion ([Corporacion],[Nombre])
SELECT [Codigo],[Nombre_Corporacion] FROM ColombiaElecciones2018_Importacion.dbo.Clave_Corporacion
--
INSERT INTO [ColombiaElecciones2018].[dbo].[Resultados_Divipol] (
	[Departamento],[Municipio],[Zona],[Puesto],[Departamento_Nombre],[Municipio_Nombre],[Puesto_Nombre],
	[Indicador_Puesto],[Potencial_Hombres],[Potencial_Mujeres],[Numero_Mesas],[Comuna],[Comuna_Nombre]
)
SELECT
	[Codigo_Departamento],[Codigo_Municipio],[Codigo_Zona],[Codigo_Puesto],[Nombre_Departamento],[Nombre_Municipio],[Nombre_Puesto],
	[Indicador_Puesto],[Potencial_Hombres],[Potencial_Mujeres],[Numero_Mesas],[Codigo_Comuna],[Nombre_Comuna]
FROM [ColombiaElecciones2018_Importacion].[dbo].[Clave_Divipol]
--
INSERT INTO [ColombiaElecciones2018].[dbo].[Resultados_Partido] ([Partido],[Nombre])
SELECT [Codigo_Partido],[Nombre_Partido] FROM [ColombiaElecciones2018_Importacion].[dbo].[Clave_Partidos]
------
INSERT INTO [ColombiaElecciones2018].[dbo].[Resultados_Departamento]
SELECT DISTINCT [Codigo_Departamento],[Nombre_Departamento]
FROM [ColombiaElecciones2018_Importacion].[dbo].[Clave_Divipol]
ORDER BY 1
--
INSERT INTO [ColombiaElecciones2018].[dbo].[Resultados_Municipio] ([Departamento],[Municipio],[Nombre])
SELECT DISTINCT [Codigo_Departamento],[Codigo_Municipio],[Nombre_Municipio]
FROM [ColombiaElecciones2018_Importacion].[dbo].[Clave_Divipol]
ORDER BY 1,2