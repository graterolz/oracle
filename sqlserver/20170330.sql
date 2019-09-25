SELECT * FROM ELZYRA.dbo.Comision_EspecialArt
SELECT * FROM ELZYRA.dbo.Comision_FactorCumplimiento
SELECT * FROM ELZYRA.dbo.Comision_FormaPago
SELECT * FROM ELZYRA.dbo.Comision_Genera
SELECT * FROM ELZYRA.dbo.Comision_GeneraDetalle
SELECT * FROM ELZYRA.dbo.Comision_Grupo
SELECT * FROM ELZYRA.dbo.Comision_GrupoArt
SELECT * FROM ELZYRA.dbo.Comision_GrupoMix
SELECT * FROM ELZYRA.dbo.Comision_GrupoMixArt
SELECT * FROM ELZYRA.dbo.Comision_Historico
SELECT * FROM ELZYRA.dbo.Comision_MixVentas
SELECT * FROM ELZYRA.dbo.Comision_Penalizaciones
--
SELECT * FROM ELZYRA.dbo.Modulos
SELECT * FROM ELZYRA.dbo.Modulos_Usuarios WHERE id_modulo = '0AC34253-CD3F-431D-B7B2-B06996F41D22'
SELECT * FROM ELZYRA.dbo.AspNetUsers
USE ELZYRA EXEC sp_help 'dbo.AspNetUsers'
--
ALTER TABLE ELZYRA.dbo.Comision_FactorCumplimiento ADD [co_us_in] [nchar](128) NULL
ALTER TABLE ELZYRA.dbo.Comision_FactorCumplimiento ADD [fec_registro] [datetime] NOT NULL DEFAULT GETDATE()
--
ALTER TABLE ELZYRA.dbo.Comision_FormaPago ADD [co_us_in] [nchar](128) NULL
ALTER TABLE ELZYRA.dbo.Comision_FormaPago ADD [fec_registro] [datetime] NOT NULL DEFAULT GETDATE()
--
ALTER TABLE ELZYRA.dbo.Comision_GeneraDetalle ADD [co_us_in] [nchar](128) NULL
ALTER TABLE ELZYRA.dbo.Comision_GeneraDetalle ADD [fec_registro] [datetime] NOT NULL DEFAULT GETDATE()
--
ALTER TABLE ELZYRA.dbo.Comision_Grupo ADD [co_us_in] [nchar](128) NULL
ALTER TABLE ELZYRA.dbo.Comision_Grupo ADD [fec_registro] [datetime] NOT NULL DEFAULT GETDATE()
--
ALTER TABLE ELZYRA.dbo.Comision_Historico ADD [co_us_in] [nchar](128) NULL
ALTER TABLE ELZYRA.dbo.Comision_Historico ADD [fec_registro] [datetime] NOT NULL DEFAULT GETDATE()
--
ALTER TABLE ELZYRA.dbo.Comision_MixVentas ADD [co_us_in] [nchar](128) NULL
ALTER TABLE ELZYRA.dbo.Comision_MixVentas ADD [fec_registro] [datetime] NOT NULL DEFAULT GETDATE()
--
ALTER TABLE ELZYRA.dbo.Comision_Penalizaciones ADD [co_us_in] [nchar](128) NULL
ALTER TABLE ELZYRA.dbo.Comision_Penalizaciones ADD [fec_registro] [datetime] NOT NULL DEFAULT GETDATE()
--
ALTER TABLE [dbo].[Modulos_Pantallas] DROP CONSTRAINT [FK_Modulos]
GO
--
DROP TABLE [ELZYRA].[dbo].[Modulos_Pantallas]
GO
--
CREATE TABLE [ELZYRA].[dbo].[Modulos_Pantallas](
	[id_modpan] [nchar](128) NOT NULL,
	[id_modulo] [nchar](128) NOT NULL,
	[descripcion] [nvarchar](max) NOT NULL,
	[habilitada] [bit] NOT NULL,
 CONSTRAINT [PK_Modulos_Pantallas] PRIMARY KEY CLUSTERED 
(
	[id_modpan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
--
ALTER TABLE [ELZYRA].[dbo].[Modulos_Pantallas] ADD DEFAULT (newid()) FOR [id_modpan]
GO
--
ALTER TABLE [ELZYRA].[dbo].[Modulos_Pantallas] WITH CHECK ADD CONSTRAINT [FK_Modulos] FOREIGN KEY([id_modulo]) REFERENCES [dbo].[Modulos] ([id_modulo])
GO
--
ALTER TABLE [ELZYRA].[dbo].[Modulos_Pantallas] CHECK CONSTRAINT [FK_Modulos]
GO
--
ALTER TABLE [dbo].[Modulos_PantallasUsuarios] DROP CONSTRAINT [FK_Modulos_AspNetUsers]
ALTER TABLE [dbo].[Modulos_PantallasUsuarios] DROP CONSTRAINT [FK_Modulos_Modulos_PantallasUsuarios]
ALTER TABLE [dbo].[Modulos_PantallasUsuarios] DROP CONSTRAINT [FK_Modulos_Modulos_Pantallas]
GO
--
DROP TABLE [ELZYRA].[dbo].[Modulos_PantallasUsuarios]
GO
--
CREATE TABLE [ELZYRA].[dbo].[Modulos_PantallasUsuarios](
	[id_modpanusr] [nchar](128) NOT NULL,
	[id_aspuser] [nvarchar](128) NOT NULL,
	[id_modulo] [nchar](128) NOT NULL,
	[id_modpan] [nchar](128) NOT NULL,
	[post] [bit] NOT NULL,
	[put] [bit] NOT NULL,
	[delete] [bit] NOT NULL,
	[fec_registro] [datetime] NOT NULL,
	[co_us_in] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_Modulos_PantallasUsuarios] PRIMARY KEY CLUSTERED 
(
	[id_modpanusr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
--
ALTER TABLE [ELZYRA].[dbo].[Modulos_PantallasUsuarios] ADD DEFAULT (newid()) FOR [id_modpanusr]
ALTER TABLE [ELZYRA].[dbo].[Modulos_PantallasUsuarios] ADD DEFAULT (1) FOR [post]
ALTER TABLE [ELZYRA].[dbo].[Modulos_PantallasUsuarios] ADD DEFAULT (1) FOR [put]
ALTER TABLE [ELZYRA].[dbo].[Modulos_PantallasUsuarios] ADD DEFAULT (1) FOR [delete]
GO
--
ALTER TABLE [ELZYRA].[dbo].[Modulos_PantallasUsuarios] WITH CHECK ADD CONSTRAINT [FK_Modulos_AspNetUsers] FOREIGN KEY([id_aspuser]) REFERENCES [dbo].[AspNetUsers] ([id])
ALTER TABLE [ELZYRA].[dbo].[Modulos_PantallasUsuarios] WITH CHECK ADD CONSTRAINT [FK_Modulos_Modulos_PantallasUsuarios] FOREIGN KEY([id_modulo]) REFERENCES [dbo].[Modulos] ([id_modulo])
ALTER TABLE [ELZYRA].[dbo].[Modulos_PantallasUsuarios] WITH CHECK ADD CONSTRAINT [FK_Modulos_Modulos_Pantallas] FOREIGN KEY([id_modpan]) REFERENCES [dbo].[Modulos_Pantallas] ([id_modpan])
GO
--
ALTER TABLE [ELZYRA].[dbo].[Modulos_PantallasUsuarios] CHECK CONSTRAINT [FK_Modulos_AspNetUsers]
ALTER TABLE [ELZYRA].[dbo].[Modulos_PantallasUsuarios] CHECK CONSTRAINT [FK_Modulos_Modulos_PantallasUsuarios]
ALTER TABLE [ELZYRA].[dbo].[Modulos_PantallasUsuarios] CHECK CONSTRAINT [FK_Modulos_Modulos_Pantallas]
GO