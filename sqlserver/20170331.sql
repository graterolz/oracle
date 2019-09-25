SELECT * FROM ELZYRA.dbo.AspNetUsers
ALTER TABLE ELZYRA.dbo.AspNetUsers ADD nombre_completo NCHAR(128) NULL
ALTER TABLE ELZYRA.dbo.AspNetUsers ALTER COLUMN nombre_completo NCHAR(128) NOT NULL
--
SELECT * FROM ELZYRA.dbo.Articulos_Certificacion
SELECT * FROM ELZYRA.dbo.Empresas
USE ELZYRA EXEC sp_help 'dbo.Empresas'
--
SELECT TOP (1) * FROM ELZYRA.dbo.Reclamo_Cliente ORDER BY 1 DESC
DELETE TOP (1) FROM ELZYRA.dbo.Reclamo_Cliente WHERE id_reclamo = 57
--
DROP TABLE [ELZYRA].[dbo].[Articulos_Certificacion]
GO
--
CREATE TABLE [ELZYRA].[dbo].[Articulos_Certificacion](
	[id_artcer] [int] IDENTITY(1,1) NOT NULL,
	[grupo_empresa] [nchar](20) NOT NULL,
	[co_alma] [nvarchar](128) NOT NULL,	
	[fec_prog] [datetime] NOT NULL,
	[auditor] [nvarchar](128) NOT NULL,
	[fec_registro] [datetime] NOT NULL,
	[co_us_in] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_Articulos_Certificacion] PRIMARY KEY CLUSTERED 
(
	[id_artcer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
--
ALTER TABLE [ELZYRA].[dbo].[Articulos_CertificaStockDetalle] DROP CONSTRAINT [FK_Articulos_Articulos_Certificacion]
GO
--
DROP TABLE [ELZYRA].[dbo].[Articulos_CertificaStockDetalle]
GO
--
CREATE TABLE [ELZYRA].[dbo].[Articulos_CertificaStockDetalle](
	[id_artcerdet] [int] IDENTITY(1,1) NOT NULL,
	[id_artcer] [int] NOT NULL,
	[co_art] [nvarchar](128) NOT NULL,
	[art_desc] [nvarchar](128) NOT NULL,	
	[stock_act] [decimal](18,5) NOT NULL,	
	[stock_real] [decimal](18,5) NOT NULL,	
	[fec_registro] [datetime] NOT NULL,
	[co_us_in] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_Articulos_Certificacion2] PRIMARY KEY CLUSTERED 
(
	[id_artcerdet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
--
ALTER TABLE [ELZYRA].[dbo].[Articulos_CertificaStockDetalle] WITH CHECK ADD CONSTRAINT [FK_Articulos_Articulos_Certificacion] FOREIGN KEY([id_artcer]) REFERENCES [dbo].[Articulos_Certificacion] ([id_artcer])
GO
--
ALTER TABLE [ELZYRA].[dbo].[Articulos_CertificaStockDetalle] CHECK CONSTRAINT [FK_Articulos_Articulos_Certificacion]
GO