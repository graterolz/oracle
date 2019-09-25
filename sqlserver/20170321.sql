SELECT * FROM ELZYRA.dbo.AspNetUsers
SELECT * FROM ELZYRA.dbo.AspNetRoles
--
USE ELZYRA EXEC sp_help 'dbo.AspNetRoles'
USE ELZYRA EXEC sp_help 'dbo.AspNetUsers'
--
SELECT * FROM ELZYRA.dbo.Notificacion_email ORDER BY id_email
SELECT * FROM ELZYRA.dbo.Notificacion_tipo
--
ALTER TABLE [dbo].Notificacion_email WITH CHECK ADD  CONSTRAINT [FK_Notificacion_email_Notificacion_tipo] FOREIGN KEY([id_tipo])
REFERENCES [dbo].[Notificacion_tipo] ([id_tipo])
--
ALTER TABLE [dbo].Notificacion_email CHECK CONSTRAINT [FK_Notificacion_email_Notificacion_tipo]
--
INSERT INTO [ELZYRA].[dbo].[Notificacion_tipo] ([tipo]) VALUES ('Ventas por Gerencia')
--
ALTER TABLE [ELZYRA].[dbo].[Notificacion_email] DROP COLUMN [id_email_new]
ALTER TABLE [ELZYRA].[dbo].[Notificacion_email] ADD [id_email_new] int IDENTITY(1,1)
ALTER TABLE [ELZYRA].[dbo].[Notificacion_email] DROP COLUMN [id_email]
USE ELZYRA EXEC sp_rename 'Notificacion_email.id_email_new', 'id_email', 'Column'
--
INSERT INTO [ELZYRA].[dbo].[Notificacion_email](
	[id_tipo],[empresa],[e_para],[e_cc],[e_cco],[profile_name]
)
VALUES(6,'STAR01',NULL,NULL,NULL,'Avisos DEMO')
--
SELECT * FROM [ELZYRA].[dbo].[Notificacion_email]
WHERE id_tipo = 6
--
UPDATE [ELZYRA].[dbo].[Notificacion_email]
SET e_para = 'omacazana@demo.com.ve;ggeneral@demo.com.ve;vicepresidencia@demo.com.ve;presidencia@demo.com.ve'
WHERE id_tipo = 6
--
USE [ELZYRA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notificacion_email_new](
	[id_email] [int] IDENTITY(1,1) NOT NULL,
	[id_tipo] [int] NOT NULL,
	[empresa] [nchar](10) NOT NULL,
	[e_para] [varchar](250) NULL,
	[e_cc] [varchar](250) NULL,
	[e_cco] [varchar](250) NULL,
	[profile_name] [nchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_tipo] ASC,
	[empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Notificacion_email_new] WITH CHECK ADD CONSTRAINT [FK_Notificacion_email_Notificacion_tipo] FOREIGN KEY([id_tipo])
REFERENCES [dbo].[Notificacion_tipo] ([id_tipo])
GO

ALTER TABLE [dbo].[Notificacion_email_new] CHECK CONSTRAINT [FK_Notificacion_email_Notificacion_tipo]
GO
--
USE [ELZYRA]
GO
DROP TABLE [dbo].[Notificacion_tipo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notificacion_tipo](
	[id_tipo] [int] IDENTITY(1,1) NOT NULL,
	[tipo] [nchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT [dbo].[Notificacion_tipo] ([tipo]) VALUES (N'Productos por Llegar')
GO
INSERT [dbo].[Notificacion_tipo] ([tipo]) VALUES (N'Ordenes de Compras Importacion')
GO
INSERT [dbo].[Notificacion_tipo] ([tipo]) VALUES (N'Registro de Embarque')
GO
INSERT [dbo].[Notificacion_tipo] ([tipo]) VALUES (N'Registro de Reclamo')
GO
INSERT [dbo].[Notificacion_tipo] ([tipo]) VALUES (N'Adelanto Comisiones Demo')
GO
--
USE [ELZYRA]
GO
DROP TABLE [dbo].[Reportes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reportes](
	[id_reporte] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [nvarchar](150) NOT NULL,
	[comentario] [nvarchar](150) NOT NULL,
	[estado] [int] NOT NULL,
	[fec_registro] [datetime] DEFAULT GETDATE() NOT NULL,
	[co_us_in] [nchar](128) NOT NULL,
 CONSTRAINT [PK_Reportes] PRIMARY KEY CLUSTERED 
(
	[id_reporte] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
--
USE [ELZYRA]
GO
ALTER TABLE [dbo].[ReportesPorRol] DROP CONSTRAINT [FK_Reportes_ReportesPorRol]
ALTER TABLE [dbo].[ReportesPorRol] DROP CONSTRAINT [FK_AspNetRoles]
GO

DROP TABLE [dbo].[ReportesPorRol]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportesPorRol](
	[id_rpte_rol] [int] IDENTITY(1,1) NOT NULL,
	[id_reporte] [int] NOT NULL,
	[id_rol] [nvarchar](128) NOT NULL,
	[fec_registro] [datetime] DEFAULT GETDATE() NOT NULL,
	[co_us_in] [nchar](128) NOT NULL,
 CONSTRAINT [PK_ReportesPorRol] PRIMARY KEY CLUSTERED 
(
	[id_rpte_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ReportesPorRol] WITH CHECK ADD CONSTRAINT [FK_Reportes_ReportesPorRol] FOREIGN KEY([id_reporte])
REFERENCES [dbo].[Reportes] ([id_reporte])
GO

ALTER TABLE [dbo].[ReportesPorRol] WITH CHECK ADD CONSTRAINT [FK_AspNetRoles] FOREIGN KEY([id_rol])
REFERENCES [dbo].[AspNetRoles] ([id])
GO

ALTER TABLE [dbo].[ReportesPorRol] CHECK CONSTRAINT [FK_Reportes_ReportesPorRol]
GO

ALTER TABLE [dbo].[ReportesPorRol] CHECK CONSTRAINT [FK_AspNetRoles]
GO
--
USE [ELZYRA]
GO

ALTER TABLE [dbo].[ReportesPorUsuario] DROP CONSTRAINT [FK_Reportes_ReportesPorUsuario]
ALTER TABLE [dbo].[ReportesPorUsuario] DROP CONSTRAINT [FK_AspNetUsers]
GO

DROP TABLE [dbo].[ReportesPorUsuario]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportesPorUsuario](
	[id_rpte_usr] [int] IDENTITY(1,1) NOT NULL,
	[id_reporte] [int] NOT NULL,
	[id_idusuasp] [nvarchar](128) NOT NULL,
	[fec_registro] [datetime] DEFAULT GETDATE() NOT NULL,
	[co_us_in] [nchar](128) NOT NULL,
 CONSTRAINT [PK_ReportesPorUsuario] PRIMARY KEY CLUSTERED 
(
	[id_rpte_usr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ReportesPorUsuario] WITH CHECK ADD CONSTRAINT [FK_Reportes_ReportesPorUsuario] FOREIGN KEY([id_reporte])
REFERENCES [dbo].[Reportes] ([id_reporte])
GO

ALTER TABLE [dbo].[ReportesPorUsuario] WITH CHECK ADD CONSTRAINT [FK_AspNetUsers] FOREIGN KEY([id_idusuasp])
REFERENCES [dbo].[AspNetUsers] ([id])
GO

ALTER TABLE [dbo].[ReportesPorUsuario] CHECK CONSTRAINT [FK_Reportes_ReportesPorUsuario]
GO

ALTER TABLE [dbo].[ReportesPorUsuario] CHECK CONSTRAINT [FK_AspNetUsers]
GO