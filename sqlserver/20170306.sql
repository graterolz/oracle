SELECT fact_completa FROM Profit_RG.dbo.Reclamo_Cliente WHERE id_reclamo = 1;
SELECT cli_des FROM Profit_RG.dbo.Reclamo_Cliente WHERE id_reclamo = (SELECT id_reclamo FROM Profit_RG.dbo.Reclamo_Accion WHERE id_reclamo = 1);
--
SELECT * FROM Profit_RG.dbo.Reclamo_Cliente WHERE id_reclamo = 1;
SELECT * FROM Profit_RG.dbo.Reclamo_Accion WHERE id_reclamo = 1;
SELECT * FROM Profit_RG.dbo.Reclamo_tab_Accion WHERE id_tab_accion IN (4,11);
SELECT * FROM Profit_RG.dbo.Reclamo_Doc_Asoc WHERE id_reclamo = 1;
SELECT * FROM Profit_RG.dbo.Reclamo_Razon WHERE id_razon = 1;
--
SELECT des_emp FROM Profit_RG.dbo.Empresas WHERE co_empresa = (SELECT empresa FROM Profit_RG.dbo.Reclamo_Cliente WHERE id_reclamo = 1);
--
SELECT * FROM Profit_RG.dbo.Reclamo_Accion ORDER BY 1 DESC;
DELETE FROM Profit_RG.dbo.Reclamo_Accion WHERE id_accion = 68;
--
SELECT * FROM Profit_RG.dbo.Notificacion_email WHERE id_tipo = 2
SELECT MAX(id_email) FROM Profit_RG.dbo.Notificacion_email
--
INSERT INTO [Profit_RG].[dbo].[Notificacion_email] ([id_tipo],[empresa],[e_para],[e_cc],[e_cco],[profile_name])
VALUES('2','OVERLAND','soporte03@demo.com.ve','sistemas@demo.com.ve',NULL,'Avisos Overland');
--
SELECT * FROM ELZYRA.dbo.Encuestas;
INSERT INTO [ELZYRA].[dbo].[Encuestas]([id_encuesta],desde,[hasta],[titulo],[anulado],[fec_registro],[co_usuario],[votounico])
VALUES (0,GETDATE(),GETDATE(),'DEMO',0,GETDATE(),'DEMO',0);
--
USE [ELZYRA]
GO
DROP TABLE [ELZYRA].[dbo].[Encuestas]
CREATE TABLE [dbo].[Encuestas](
	[id_encuesta] [int] IDENTITY(1,1) NOT NULL,
	[desde] [datetime] NOT NULL,
	[hasta] [datetime] NOT NULL,
	[titulo] [nvarchar](max) NOT NULL,
	[anulado] [bit] NOT NULL,
	[fec_registro] [datetime] NOT NULL,
	[co_usuario] [nchar](10) NOT NULL,
	[votounico] [bit] NOT NULL,
 CONSTRAINT [PK_Encuestas] PRIMARY KEY CLUSTERED 
(
	[id_encuesta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
--
USE [Profit_RG]
GO
DROP TABLE [dbo].[FactorC_Vta]
CREATE TABLE [dbo].[FactorC_Vta](
	[id_fc] [int] NOT NULL IDENTITY(1,1),
	[grupo] [nchar](10) NOT NULL,
	[desde] [date] NOT NULL,
	[hasta] [date] NULL,
	[inicio_fc] [decimal](10, 2)NOT NULL,
	[fin_fc] [decimal](10, 2)NOT NULL,
	[factor] [decimal](10, 2)NOT NULL
) ON [PRIMARY]
GO