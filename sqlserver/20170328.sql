EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_VendedoresMix @pGrupo ='Stargas';
--
SELECT * FROM MICHI01.dbo.art
SELECT * FROM ELZYRA.dbo.ReportesPorUsuario
SELECT * FROM ELZYRA.dbo.ReportesPorRol
USE ELZYRA EXEC sp_rename 'Modules','Modulos'
USE ELZYRA EXEC sp_rename 'ModulesUsers','Modulos_Usuarios'
SELECT * FROM ELZYRA.dbo.Notificacion_email WHERE empresa = 'OVERLAND' AND id_tipo = 2
--
UPDATE TOP(1) ELZYRA.dbo.Notificacion_email
SET e_para = RTRIM(LTRIM(e_para))+';nsocorro@demo.com.ve;presidencia@demo.com.ve'
WHERE empresa = 'OVERLAND' AND id_tipo = 2
--
SELECT * FROM ELZYRA.dbo.Notificacion_email
WHERE e_cco LIKE '%sistemas%'
--
UPDATE TOP(1) ELZYRA.dbo.Notificacion_email
SET e_para = 'c.proyectos@demo.com.ve'
WHERE id_email = 5
--
UPDATE TOP(1) ELZYRA.dbo.Notificacion_email
SET e_cco = NULL
WHERE e_cco LIKE '%sistemas%'
--
SELECT co_art,art_des,B.lin_des,C.subl_des,D.des_proc,E.cat_des
FROM MICHI01.dbo.art A
INNER JOIN MICHI01.dbo.lin_art B ON A.co_lin = B.co_lin
INNER JOIN MICHI01.dbo.sub_lin C ON A.co_subl = C.co_subl AND C.co_lin = B.co_lin
INNER JOIN MICHI01.dbo.proceden D ON A.procedenci = D.cod_proc
INNER JOIN MICHI01.dbo.cat_art E ON A.co_cat = E.co_cat
WHERE A.tipo = 'V'
AND A.procedenci <> '000003'
AND (SELECT stock_act FROM MICHI01.dbo.st_almac F WHERE F.co_alma = '005' AND F.co_art = A.co_art) > 0
ORDER BY co_art
--
SELECT * FROM Profit_RG.dbo.Art_min
SELECT * FROM Profit_XLS.SYS.tables ORDER BY create_date DESC
DROP TABLE Profit_XLS.dbo.demo_arts
--
SELECT * FROM Profit_XLS.dbo.Hoja1$ WHERE UNI_MIN = 100 and cod is null
UPDATE TOP (1) Profit_XLS.dbo.demo_arts
SET COD = '00001800'
WHERE UNI_MIN = 100
AND cod IS NULL
--
INSERT INTO Profit_RG.dbo.Art_min
SELECT empresa,cod,uni_min,NEWID() rowid FROM Profit_XLS.dbo.mch_umv2 WHERE uni_min = 100
--
SELECT * FROM Profit_RG.dbo.Art_min WHERE uni_min = 100
SELECT * FROM MICHI01.dbo.descuen
--
USE ELZYRA
GO
ALTER TABLE [dbo].[Reclamo_Accion] DISABLE TRIGGER [TriggI_Reclamo_Accion]
ALTER TABLE [dbo].[Reclamo_Cliente] DISABLE TRIGGER [TrigI_Reclamo_Cliente]
--
ALTER TABLE [dbo].[Reclamo_Razon_Email] DROP CONSTRAINT [FK_Reclamo_Razon_Email_Reclamo_Razon]
ALTER TABLE [dbo].[Reclamo_Doc_Asoc] DROP CONSTRAINT [FK_Reclamo_Doc_Asoc_Reclamo_Accion]
ALTER TABLE [dbo].[Reclamo_Accion] DROP CONSTRAINT [FK_Reclamo_Accion_Reclamo_Tab_Accion]
ALTER TABLE [dbo].[Reclamo_Accion] DROP CONSTRAINT [FK_Reclamo_Accion_Reclamo_Cliente]
ALTER TABLE [dbo].[Reclamo_Cliente] DROP CONSTRAINT [DF_Reclamo_Cliente_art_des]
ALTER TABLE [dbo].[Reclamo_Cliente] DROP CONSTRAINT [DF_Reclamo_Cliente_cli_des]
ALTER TABLE [dbo].[Reclamo_Cliente] DROP CONSTRAINT [DF_Reclamo_Cliente_ven_des]
ALTER TABLE [dbo].[Reclamo_Cliente] DROP CONSTRAINT [DF_Reclamo_Cliente_co_ven]
ALTER TABLE [dbo].[Reclamo_Cliente] DROP CONSTRAINT [DF_Reclamo_Cliente_co_us_in]
ALTER TABLE [dbo].[Reclamo_Cliente] DROP CONSTRAINT [DF_Reclamo_Cliente_anulado]
ALTER TABLE [dbo].[Reclamo_Cliente] DROP CONSTRAINT [FK_Reclamo_Cliente_Reclamo_Razon]
--
DROP INDEX [IX_Reclamo_Razon_Email] ON [dbo].[Reclamo_Razon_Email]
GO
TRUNCATE TABLE [dbo].[Reclamo_Tab_Accion]
TRUNCATE TABLE [dbo].[Reclamo_Razon_Email]
TRUNCATE TABLE [dbo].[Reclamo_Razon]
TRUNCATE TABLE [dbo].[Reclamo_Doc_Asoc]
TRUNCATE TABLE [dbo].[Reclamo_Cliente]
TRUNCATE TABLE [dbo].[Reclamo_Accion]
--
SET IDENTITY_INSERT [dbo].[Reclamo_Accion] ON

INSERT INTO [ELZYRA].[dbo].[Reclamo_Accion] ([id_accion], [id_reclamo], [id_tab_accion], [fec_emis], [comentario], [val_c], [val_d], [val_f], [co_us_in])
SELECT [id_accion], [id_reclamo], [id_tab_accion], [fec_emis], [comentario], [val_c], [val_d], [val_f],'7d8a26c2-a663-4c2f-8f27-57fe0fe61604' [co_us_in]
FROM [Profit_RG].[dbo].[Reclamo_Accion]

SET IDENTITY_INSERT [dbo].[Reclamo_Accion] OFF
--
SET IDENTITY_INSERT [dbo].[Reclamo_Cliente] ON 

INSERT [ELZYRA].[dbo].[Reclamo_Cliente] ([id_reclamo], [id_razon], [fec_emis], [empresa], [factura], [rif], [fact_completa], [co_art], [fec_cierre], [comentario], [anulado], [fec_anulado], [co_us_in], [co_ven], [ven_des], [cli_des], [art_des], [nombre], [telefono], [email])
SELECT [id_reclamo], [id_razon], [fec_emis], [empresa], [factura], [rif], [fact_completa], [co_art], [fec_cierre], [comentario], [anulado], [fec_anulado], '7d8a26c2-a663-4c2f-8f27-57fe0fe61604' [co_us_in], [co_ven], [ven_des], [cli_des], [art_des], [nombre], [telefono], [email]
FROM [Profit_RG].[dbo].[Reclamo_Cliente]

SET IDENTITY_INSERT [dbo].[Reclamo_Cliente] OFF
--
SET IDENTITY_INSERT [dbo].[Reclamo_Doc_Asoc] ON 

INSERT [ELZYRA].[dbo].[Reclamo_Doc_Asoc] ([id_documento], [id_reclamo], [id_accion], [comentario], [num_doc], [id_tipo_documento], [fec_emis], [co_us_in])
SELECT [id_documento], [id_reclamo], [id_accion], [comentario], [num_doc], 3 [id_tipo_documento], [fec_emis], '7d8a26c2-a663-4c2f-8f27-57fe0fe61604' [co_us_in] FROM [Profit_RG].[dbo].[Reclamo_Doc_Asoc]

SET IDENTITY_INSERT [dbo].[Reclamo_Doc_Asoc] OFF
--
SET IDENTITY_INSERT [dbo].[Reclamo_Razon] ON 

INSERT [ELZYRA].[dbo].[Reclamo_Razon] ([id_razon], [descripcion], [leyenda], [mensaje],[co_us_in],[fec_registro])
SELECT [id_razon], [descripcion], [leyenda], [mensaje],'7d8a26c2-a663-4c2f-8f27-57fe0fe61604' [co_us_in],GETDATE() FROM [Profit_RG].[dbo].[Reclamo_Razon]

SET IDENTITY_INSERT [dbo].[Reclamo_Razon] OFF
--
SET IDENTITY_INSERT [dbo].[Reclamo_Tab_Accion] ON 

INSERT [ELZYRA].[dbo].[Reclamo_Tab_Accion] ([id_tab_accion], [descripcion], [mensaje], [anular_reclamo], [co_us_in])
SELECT [id_tab_accion], [descripcion], [mensaje], [anular_reclamo],'7d8a26c2-a663-4c2f-8f27-57fe0fe61604' [co_us_in] FROM [Profit_RG].[dbo].[Reclamo_Tab_Accion]

SET IDENTITY_INSERT [dbo].[Reclamo_Tab_Accion] OFF
--
CREATE UNIQUE NONCLUSTERED INDEX [IX_Reclamo_Razon_Email] ON [dbo].[Reclamo_Razon_Email]
(
	[id_razon] ASC,
	[empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reclamo_Cliente] ADD CONSTRAINT [DF_Reclamo_Cliente_anulado] DEFAULT ((0)) FOR [anulado]
GO
ALTER TABLE [dbo].[Reclamo_Cliente] ADD CONSTRAINT [DF_Reclamo_Cliente_co_us_in] DEFAULT (space((0))) FOR [co_us_in]
GO
ALTER TABLE [dbo].[Reclamo_Cliente] ADD CONSTRAINT [DF_Reclamo_Cliente_co_ven] DEFAULT (space((0))) FOR [co_ven]
GO
ALTER TABLE [dbo].[Reclamo_Cliente] ADD CONSTRAINT [DF_Reclamo_Cliente_ven_des] DEFAULT (space((0))) FOR [ven_des]
GO
ALTER TABLE [dbo].[Reclamo_Cliente] ADD CONSTRAINT [DF_Reclamo_Cliente_cli_des] DEFAULT (space((0))) FOR [cli_des]
GO
ALTER TABLE [dbo].[Reclamo_Cliente] ADD CONSTRAINT [DF_Reclamo_Cliente_art_des] DEFAULT (space((0))) FOR [art_des]
GO
ALTER TABLE [dbo].[Reclamo_Accion] WITH CHECK ADD CONSTRAINT [FK_Reclamo_Accion_Reclamo_Cliente] FOREIGN KEY([id_reclamo])
REFERENCES [dbo].[Reclamo_Cliente] ([id_reclamo])
GO
ALTER TABLE [dbo].[Reclamo_Accion] CHECK CONSTRAINT [FK_Reclamo_Accion_Reclamo_Cliente]
GO
ALTER TABLE [dbo].[Reclamo_Accion] WITH CHECK ADD CONSTRAINT [FK_Reclamo_Accion_Reclamo_Tab_Accion] FOREIGN KEY([id_tab_accion])
REFERENCES [dbo].[Reclamo_Tab_Accion] ([id_tab_accion])
GO
ALTER TABLE [dbo].[Reclamo_Accion] CHECK CONSTRAINT [FK_Reclamo_Accion_Reclamo_Tab_Accion]
GO
ALTER TABLE [dbo].[Reclamo_Cliente] WITH CHECK ADD CONSTRAINT [FK_Reclamo_Cliente_Reclamo_Razon] FOREIGN KEY([id_razon])
REFERENCES [dbo].[Reclamo_Razon] ([id_razon])
GO
ALTER TABLE [dbo].[Reclamo_Cliente] CHECK CONSTRAINT [FK_Reclamo_Cliente_Reclamo_Razon]
GO
ALTER TABLE [dbo].[Reclamo_Doc_Asoc] WITH CHECK ADD CONSTRAINT [FK_Reclamo_Doc_Asoc_Reclamo_Accion] FOREIGN KEY([id_accion])
REFERENCES [dbo].[Reclamo_Accion] ([id_accion])
GO
ALTER TABLE [dbo].[Reclamo_Doc_Asoc] CHECK CONSTRAINT [FK_Reclamo_Doc_Asoc_Reclamo_Accion]
GO
ALTER TABLE [dbo].[Reclamo_Razon_Email] WITH CHECK ADD CONSTRAINT [FK_Reclamo_Razon_Email_Reclamo_Razon] FOREIGN KEY([id_razon])
REFERENCES [dbo].[Reclamo_Razon] ([id_razon])
GO
ALTER TABLE [dbo].[Reclamo_Razon_Email] CHECK CONSTRAINT [FK_Reclamo_Razon_Email_Reclamo_Razon]
GO
--
ALTER TABLE [dbo].[Reclamo_Accion] ENABLE TRIGGER [TriggI_Reclamo_Accion]
ALTER TABLE [dbo].[Reclamo_Cliente] ENABLE TRIGGER [TrigI_Reclamo_Cliente]