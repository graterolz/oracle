SELECT * FROM App_Produccion.dbo.Departamentos
SELECT * FROM App_Pruebas.dbo.Departamentos
TRUNCATE TABLE App_Produccion.dbo.Departamentos
--
SET IDENTITY_INSERT App_Produccion.dbo.Departamentos ON 
INSERT INTO App_Produccion.dbo.Departamentos ([id],[descripcion])
SELECT TOP 1000 [id],[descripcion] FROM App_Pruebas.[dbo].[Departamentos]
SET IDENTITY_INSERT App_Produccion.dbo.Departamentos OFF
--
SELECT * FROM App_Produccion.dbo.Departamentos
--
UPDATE TOP (1) App_Produccion.dbo.Departamentos
SET descripcion = GETDATE()
WHERE id = 1
--
BEGIN TRY
	SELECT 1/0 
END TRY  
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage  
END CATCH
--
BEGIN TRANSACTION
DELETE TOP (1) FROM App_Pruebas.dbo.Departamentos WHERE id = 9
ROLLBACK  
--
SELECT * FROM App_Pruebas.dbo.Departamentos
--
UPDATE BASE_DATOS.ESQUEMA.USERS SET estado = true WHERE id = 1
SELECT id, estado FROM BASE_DATOS.ESQUEMA.USERS WHERE id = 1
UPDATE TOP (1) BASE_DATOS.ESQUEMA.USERS SET estado = true WHERE id = 1
DELETE TOP (1) BASE_DATOS.ESQUEMA.USERS WHERE id = 1
--
CREATE TABLE BASE_DATOS.ESQUEMA.ValueTable (id int)
BEGIN TRANSACTION  
	INSERT INTO BASE_DATOS.ESQUEMA.ValueTable VALUES(1)
	INSERT INTO BASE_DATOS.ESQUEMA.ValueTable VALUES(2)
ROLLBACK
--
SELECT * FROM App_Pruebas.dbo.Persons
INSERT INTO App_Pruebas.dbo.Persons (ID,LastName,FirstName,Age)
VALUES (1,'1','B',17)
DROP TABLE App_Pruebas.dbo.Persons
--
SELECT * FROM App_Produccion.dbo.Departamentos ORDER BY 2
SELECT * FROM App_Pruebas.dbo.Departamentos ORDER BY 2
SELECT NEWID()