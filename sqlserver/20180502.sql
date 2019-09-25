SELECT * FROM vw_Objetos AS Obj ORDER BY FechaSubida DESC
SELECT DISTINCT CategoriaID FROM Objetos.dbo.vw_Objetos ORDER BY 1
SELECT CategoriaID,COUNT(*) FROM Objetos.dbo.vw_Objetos GROUP BY CategoriaID ORDER BY 1 DESC
--
SELECT [CategoriasID],[Nombre],[Estado] FROM [Objetos].[dbo].[Categorias]
SELECT [FuentesID],[Nombre],[Estado]FROM [Objetos].[dbo].[Fuentes]
SELECT [ObjetoTagID],[IDObjeto],[IDTag] FROM [Objetos].[dbo].[Objeto_Tag]
SELECT [ObjetosID],[Descripcion],[Ruta],[TipoID],[Autor],[CategoriaID],[FuenteID],[FechaSubida],[Width],[Height] FROM [Objetos].[dbo].[Objetos]
SELECT [TagsID],[Nombre] FROM [Objetos].[dbo].[Tags]
SELECT [TiposID],[NombreTipo] FROM [Objetos].[dbo].[Tipos]
--
SELECT Obj.* FROM Objetos.dbo.vw_Objetos As Obj
WHERE Obj.TipoID = 1
AND Obj.CategoriaID = CASE WHEN ISNULL(1, 0) = 0 THEN CategoriaID ELSE 1 END
AND Obj.FuenteID = CASE WHEN ISNULL(1, 0) = 0 THEN FuenteID ELSE 1 END
ORDER BY 1 DESC
--
SELECT * FROM [Objetos].[dbo].[Objetos] ORDER BY 1 DESC
--
INSERT INTO [Objetos].[dbo].[Fuentes] ([Nombre],[Estado]) VALUES ('EFE',1)
GO
INSERT INTO [Objetos].[dbo].[Categorias] ([Nombre],[Estado])
VALUES ('Vida y Estilo',1),
('Tecnologia',1),
('Cine',1),
('Musica',1),
('Turismo',1)
GO