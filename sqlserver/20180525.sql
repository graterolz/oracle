INSERT INTO ColombiaElecciones2018PRE1.dbo.Resultados_Candidato (
	[Corporacion],[Circunscripcion],[Departamento],[Municipio],[Comuna],
	[Partido],[Candidato],[Preferente],[Nombre],[Apellido],[Cedula],[Genero]
)
SELECT [Corporacion],[Circunscripcion],[Departamento],[Municipio],[Comuna],
	[Partido],[Candidato],[Preferente],[Nombre],[Apellido],[Cedula],[Genero]
FROM ColombiaElecciones2018PRE1_Importacion.dbo.Clave_Candidatos
--
INSERT INTO ColombiaElecciones2018PRE1.dbo.Resultados_Circunscripcion ([CircunscripcionID],[Descripcion])
SELECT [Codigo],[Nombre] FROM ColombiaElecciones2018PRE1_Importacion.dbo.Clave_Circunscripcion
--
INSERT INTO ColombiaElecciones2018PRE1.dbo.Resultados_Corporacion ([Corporacion],[Nombre])
SELECT [Codigo],[Nombre] FROM ColombiaElecciones2018PRE1_Importacion.dbo.Clave_Corporacion
--
INSERT INTO [ColombiaElecciones2018PRE1].[dbo].[Resultados_Divipol] (
	[Departamento],[Municipio],[Zona],[Puesto],[Departamento_Nombre],[Municipio_Nombre],[Puesto_Nombre],
	[Indicador_Puesto],[Potencial_Hombres],[Potencial_Mujeres],[Numero_Mesas],[Comuna],[Comuna_Nombre]
)
SELECT
	[Departamento],[Municipio],[Zona],[Puesto],[Nombre_Departamento],[Nombre_Municipio],[Nombre_Puesto],
	[Indicador_Puesto],[Potencial_Hombres],[Potencial_Mujeres],[Numeros_Mesas],[Codigo_Comuna],[Nombre_Comuna]
FROM [ColombiaElecciones2018PRE1_Importacion].[dbo].[Clave_Divipol] order by 1
--
SELECT * FROM [ColombiaElecciones2018PRE1].[dbo].[Resultados_Divipol]
SELECT * FROM [ColombiaElecciones2018PRE1_Importacion].[dbo].[Clave_Divipol]
--
INSERT INTO [ColombiaElecciones2018PRE1].[dbo].[Resultados_Partido] ([Partido],[Nombre])
SELECT [Codigo],[Nombre] FROM [ColombiaElecciones2018PRE1_Importacion].[dbo].[Clave_Partidos]
--
INSERT INTO [ColombiaElecciones2018PRE1].[dbo].[Resultados_Departamento]
SELECT DISTINCT [Departamento],[Nombre_Departamento]
FROM [ColombiaElecciones2018PRE1_Importacion].[dbo].[Clave_Divipol]
ORDER BY 1
--
INSERT INTO [ColombiaElecciones2018PRE1].[dbo].[Resultados_Municipio] ([Departamento],[Municipio],[Nombre])
SELECT DISTINCT [Departamento],[Municipio],[Nombre_Municipio]
FROM [ColombiaElecciones2018PRE1_Importacion].[dbo].[Clave_Divipol]
ORDER BY 1,2