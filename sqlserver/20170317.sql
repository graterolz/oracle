SELECT TOP (1000) [id_razon],[descripcion],[leyenda],[mensaje] FROM [ELZYRA].[dbo].[Reclamo_Razon]
SELECT TOP (1000) [id_tab_accion],[descripcion],[mensaje],[anular_reclamo] FROM [ELZYRA].[dbo].[Reclamo_Tab_Accion]
--
USE [ELZYRA] EXEC [dbo].[pGet_Reservas_SC]
--
SELECT * FROM [ELZYRA].[dbo].[Empresas]
SELECT * FROM [ELZYRA].[dbo].[GrupoEmpresas]
SELECT * FROM [ELZYRA].[dbo].[EmpresasPorGrupos]
SELECT * FROM [ELZYRA].[dbo].[UsuariosPorEmpresas]
--
ALTER TABLE [dbo].[EmpresasPorGrupos]  WITH CHECK ADD  CONSTRAINT [FK_Empresas] FOREIGN KEY([id_grpemp])
REFERENCES [dbo].[GrupoEmpresas] ([id_grpemp])
--
ALTER TABLE [dbo].[EmpresasPorGrupos]  WITH CHECK ADD  CONSTRAINT [FK_GrupoEmpresas] FOREIGN KEY([id_grpemp])
REFERENCES [dbo].[GrupoEmpresas] ([id_grpemp])
--
ALTER TABLE [dbo].[UsuariosPorEmpresas]  WITH CHECK ADD  CONSTRAINT [FK_Empresas_UsuariosPorEmpresas] FOREIGN KEY([id_grpemp])
REFERENCES [dbo].[GrupoEmpresas] ([id_grpemp])
--
ALTER TABLE [dbo].[UsuariosPorEmpresas]  WITH CHECK ADD  CONSTRAINT [FK_GrupoEmpresas_UsuariosPorEmpresas] FOREIGN KEY([id_empresa])
REFERENCES [dbo].[Empresas] ([id_empresa])
--
USE [ELZYRA]
GO
DROP TABLE [dbo].[Empresas]
CREATE TABLE [dbo].[Empresas](
	[id_empresa] [int] IDENTITY(1,1) NOT NULL,
	[des_emp] [nvarchar](max) NOT NULL,
	[base_dato] [nvarchar](max) NOT NULL,
	[fec_registro] [datetime] NOT NULL,
	[co_us_in] [nchar](128) NOT NULL,
 CONSTRAINT [PK_Empresas] PRIMARY KEY CLUSTERED 
(
	[id_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
--
SELECT * FROM Empresas
--
USE [ELZYRA]
GO
DROP TABLE [dbo].[EmpresasPorGrupos]
CREATE TABLE [dbo].[EmpresasPorGrupos](
	[id_empgrp] [int] IDENTITY(1,1) NOT NULL,
	[id_grpemp] [int] NOT NULL,
	[id_empresa] [int] NOT NULL,
	[fec_registro] [datetime] NOT NULL,
	[co_us_in] [nchar](128) NOT NULL,
 CONSTRAINT [PK_EmpPorGrp] PRIMARY KEY CLUSTERED 
(
	[id_empgrp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
--
USE [ELZYRA]
GO
DROP TABLE [dbo].[GrupoEmpresas]
CREATE TABLE [dbo].[GrupoEmpresas](
	[id_grpemp] [int] IDENTITY(1,1) NOT NULL,
	[des_gemp] [nvarchar](max) NOT NULL,
	[fec_registro] [datetime] NOT NULL,
	[co_us_in] [nchar](128) NOT NULL,
 CONSTRAINT [PK_GEmpresas] PRIMARY KEY CLUSTERED 
(
	[id_grpemp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
--
USE [ELZYRA]
GO
ALTER TABLE [dbo].[Reclamo_Doc_Asoc] DROP CONSTRAINT [FK_Reclamo_Doc_Asoc_Tipo_Documento]
ALTER TABLE [dbo].[Reclamo_Doc_Asoc] DROP CONSTRAINT [FK_Reclamo_Doc_Asoc_Reclamo_Accion]
--
DROP TABLE [dbo].[Reclamo_Doc_Asoc]
CREATE TABLE [dbo].[Reclamo_Doc_Asoc](
	[id_documento] [int] IDENTITY(1,1) NOT NULL,
	[id_reclamo] [int] NOT NULL,
	[id_accion] [int] NOT NULL,
	[comentario] [nchar](100) NOT NULL,
	[num_doc] [nchar](20) NOT NULL,
	[id_tipo_documento] [int] NOT NULL,
	[fec_emis] [datetime] NOT NULL,
	[co_us_in] [nchar](128) NOT NULL,
 CONSTRAINT [PK_Reclamo_Doc_Asoc] PRIMARY KEY CLUSTERED 
(
	[id_documento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
--
ALTER TABLE [dbo].[Reclamo_Doc_Asoc] WITH CHECK ADD CONSTRAINT [FK_Reclamo_Doc_Asoc_Reclamo_Accion] FOREIGN KEY([id_accion])
REFERENCES [dbo].[Reclamo_Accion] ([id_accion])

ALTER TABLE [dbo].[Reclamo_Doc_Asoc] CHECK CONSTRAINT [FK_Reclamo_Doc_Asoc_Reclamo_Accion]

ALTER TABLE [dbo].[Reclamo_Doc_Asoc] WITH CHECK ADD CONSTRAINT [FK_Reclamo_Doc_Asoc_Tipo_Documento] FOREIGN KEY([id_tipo_documento])
REFERENCES [dbo].[Tipo_Documento] ([id_tipo_documento])

ALTER TABLE [dbo].[Reclamo_Doc_Asoc] CHECK CONSTRAINT [FK_Reclamo_Doc_Asoc_Tipo_Documento]
--
USE [ELZYRA]
GO
DROP TABLE [dbo].[Reclamo_Razon]
CREATE TABLE [dbo].[Reclamo_Razon](
	[id_razon] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [nvarchar](max) NOT NULL,
	[leyenda] [nvarchar](max) NOT NULL,
	[mensaje] [nvarchar](max) NULL,
	[fec_registro] [datetime] NOT NULL,
	[co_us_in] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_Devo_Razon] PRIMARY KEY CLUSTERED 
(
	[id_razon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
--
USE [ELZYRA]; 
GO 
ALTER TABLE [dbo].[Reclamo_Cliente] CHECK CONSTRAINT [FK_Reclamo_Cliente_Reclamo_Razon]; 
GO 
--
USE [ELZYRA]
GO
ALTER TABLE [dbo].[Reclamo_Cliente] DROP CONSTRAINT [FK_Reclamo_Cliente_Reclamo_Razon]

ALTER TABLE [dbo].[Reclamo_Cliente] WITH NOCHECK ADD CONSTRAINT [FK_Reclamo_Cliente_Reclamo_Razon] FOREIGN KEY([id_razon])
REFERENCES [dbo].[Reclamo_Razon] ([id_razon])

ALTER TABLE [dbo].[Reclamo_Cliente] CHECK CONSTRAINT [FK_Reclamo_Cliente_Reclamo_Razon]
--
USE [ELZYRA]
GO
DROP TABLE [dbo].[Reclamo_Tab_Accion]
CREATE TABLE [dbo].[Reclamo_Tab_Accion](
	[id_tab_accion] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [nchar](100) NOT NULL,
	[mensaje] [nvarchar](max) NULL,
	[anular_reclamo] [int] NULL,
	[fec_registro] [datetime] NOT NULL,
	[co_us_in] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_Reclamo_Tab_Accion] PRIMARY KEY CLUSTERED 
(
	[id_tab_accion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
--
TRUNCATE TABLE dbo.Reclamo_Accion
SELECT * FROM dbo.[Reclamo_Accion]
--
USE [ELZYRA]
GO
DROP TABLE [dbo].[Tipo_Documento]
CREATE TABLE [dbo].[Tipo_Documento](
	[id_tipo_documento] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [nchar](100) NOT NULL,
	[fec_registro] [datetime] NOT NULL,
	[co_us_in] [nchar](128) NOT NULL,
 CONSTRAINT [PK_Tipo_Documento] PRIMARY KEY CLUSTERED 
(
	[id_tipo_documento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
--
USE [ELZYRA]
GO
ALTER TABLE [dbo].[Reclamo_Doc_Asoc] DROP CONSTRAINT [FK_Reclamo_Doc_Asoc_Tipo_Documento]

ALTER TABLE [dbo].[Reclamo_Doc_Asoc] WITH CHECK ADD CONSTRAINT [FK_Reclamo_Doc_Asoc_Tipo_Documento] FOREIGN KEY([id_tipo_documento])
REFERENCES [dbo].[Tipo_Documento] ([id_tipo_documento])

ALTER TABLE [dbo].[Reclamo_Doc_Asoc] CHECK CONSTRAINT [FK_Reclamo_Doc_Asoc_Tipo_Documento]