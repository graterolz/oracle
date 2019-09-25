ALTER TABLE [Profit_RG].[dbo].[Reclamo_Tab_Accion] ADD anular INT NULL;
UPDATE [Profit_RG].[dbo].[Reclamo_Tab_Accion] SET anular = 0;
--
INSERT INTO [Profit_RG].[dbo].[Reclamo_Tab_Accion] ([descripcion],[mensaje],[anular_reclamo]) 
VALUES('Anular Reclamo','Por medio del presente notificamos que su reclamo ha sido cancelado por las partes interesadas.',1);
--
USE [Profit_RG] EXEC sp_rename 'Reclamo_Tab_Accion.anular','anular_reclamo','COLUMN';
--
SELECT RIGHT(mensaje,1) FROM [Profit_RG].[dbo].[Reclamo_Tab_Accion] WHERE RIGHT(mensaje,1) <> '.';
UPDATE [Profit_RG].[dbo].[Reclamo_Tab_Accion] SET mensaje = mensaje + '.' WHERE RIGHT(mensaje,1) <> '.';
UPDATE [Profit_RG].[dbo].[Reclamo_Tab_Accion] SET mensaje = RTRIM(LTRIM(LEFT(mensaje,LEN(mensaje)-1)))+'.';
--
SELECT * FROM [Profit_RG].[dbo].[Reclamo_Tab_Accion];
SELECT * FROM [Profit_RG].[dbo].[Reclamo_Cliente];
SELECT * FROM [Profit_RG].[dbo].[Reclamo_Accion];
--
ALTER TABLE [Profit_RG].[dbo].[Notificacion_email] ALTER COLUMN [e_para] VARCHAR(250)
ALTER TABLE [Profit_RG].[dbo].[Notificacion_email] ALTER COLUMN [e_cc] VARCHAR(250)
ALTER TABLE [Profit_RG].[dbo].[Notificacion_email] ALTER COLUMN [e_cco] VARCHAR(250)