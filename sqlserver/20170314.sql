SELECT * FROM Profit_RG.dbo.Emp_asoc WHERE co_empresa = 'KELARA'
--
UPDATE Profit_RG.dbo.Emp_asoc
SET grupo = 'OVERLAND',co_empresa = 'OVERLAND'
WHERE rowguid = '1846DC69-194C-4D7D-82CB-36C302B4BAF2'
--
SELECT comision from STAR01.dbo.vendedor WHERE co_ven = '025'
SELECT co_ven from STAR01.dbo.vendedor where condic=0 and co_ven not in ('001','TLV01','GV')
SELECT * FROM Profit_RG.dbo.Emp_asoc WHERE asociada = 'KELARA'
SELECT Profit_RG.[dbo].[funcScript_ComisionSG] ('STAR01') Script
--
UPDATE Profit_RG.dbo.Emp_asoc
SET co_empresa = asociada, grupo = asociada
WHERE rowguid = '1846DC69-194C-4D7D-82CB-36C302B4BAF2'
--
EXEC Profit_RG.dbo.pNotificacionEmailAdelantoComisionesSG @Co_empresa = N'STAR01'
--
INSERT INTO ELZYRA.dbo.Notificacion_email2
SELECT * FROM ELZYRA.dbo.Notificacion_email
--
SELECT * FROM ELZYRA.dbo.Notificacion_email
--
ALTER TABLE [ELZYRA].[dbo].[Notificacion_tipo] ADD PRIMARY KEY CLUSTERED (
	[id_tipo] ASC
)WITH (
	PAD_INDEX = OFF, 
	STATISTICS_NORECOMPUTE = OFF, 
	SORT_IN_TEMPDB = OFF, 
	IGNORE_DUP_KEY = OFF, 
	ONLINE = OFF, 
	ALLOW_ROW_LOCKS = ON, 
	ALLOW_PAGE_LOCKS = ON
) ON [PRIMARY]
GO
--
ALTER TABLE [ELZYRA].[dbo].[Notificacion_email] ADD PRIMARY KEY CLUSTERED (
	[id_tipo] ASC,
	[empresa] ASC
)WITH (
	PAD_INDEX = OFF, 
	STATISTICS_NORECOMPUTE = OFF,
	SORT_IN_TEMPDB = OFF,
	IGNORE_DUP_KEY = OFF,
	ONLINE = OFF, 
	ALLOW_ROW_LOCKS = ON,
	ALLOW_PAGE_LOCKS = ON
) ON [PRIMARY]
--
ALTER TABLE [ELZYRA].[dbo].[Notificacion_email]  WITH CHECK ADD FOREIGN KEY([id_tipo])
REFERENCES [ELZYRA].[dbo].[Notificacion_tipo] ([id_tipo])
--
SELECT * FROM Profit_RG.dbo.Reclamo_Accion_Email
SELECT * FROM Profit_RG.dbo.Reclamo_Tab_Accion_Email
--
SELECT * FROM Profit_RG.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'Reclamo_%'
--
SELECT * FROM ELZYRA.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'Reclamo_%'
--
SELECT * FROM ELZYRA.dbo.Reclamo_Tab_Accion_Email
DROP TABLE ELZYRA.dbo.Reclamo_Tab_Accion_Email
SELECT * FROM ELZYRA.dbo.Reclamo_Razon_Email
DROP TABLE ELZYRA.dbo.Reclamo_Razon_Email
--
DROP TABLE [ELZYRA].[dbo].[Reclamo_Accion]
DROP TABLE [ELZYRA].[dbo].[Reclamo_Cliente]
DROP TABLE [ELZYRA].[dbo].[Reclamo_Doc_Asoc]
DROP TABLE [ELZYRA].[dbo].[Reclamo_Razon]
DROP TABLE [ELZYRA].[dbo].[Reclamo_Tab_Accion]