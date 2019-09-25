USE ELZYRA
DROP PROCEDURE [dbo].[pGet_FacturaInfo]
DROP PROCEDURE [dbo].[pGet_ConsultaRifCliente]
DROP PROCEDURE [dbo].[pGet_SeleccionarReng_Fac]
--
EXEC ELZYRA.dbo.pGet_ConsultarRif @Empresa = 'STAR01', @Rif = 'J317108108'
--
SELECT Rif FROM STAR01.dbo.clientes
USE STAR01 EXEC sp_help 'dbo.clientes'
--
SELECT TOP(1) c.email, respons, c.telefonos, co_cli, cli_des
FROM STAR01.dbo.clientes C 
INNER JOIN STAR01.dbo.vendedor V ON V.co_ven=C.co_ven 
WHERE rif = 'J317108108'
--
SELECT * FROM ELZYRA.dbo.Reclamo_Doc_Asoc
--
USE [ELZYRA]
GO
ALTER TABLE [dbo].[Reclamo_Doc_Asoc] DROP CONSTRAINT [FK_Reclamo_Doc_Asoc_Reclamo_Accion]
ALTER TABLE [dbo].[Reclamo_Doc_Asoc] DROP CONSTRAINT [FK_Reclamo_Doc_Asoc_Tipo_Documento]
--
DROP TABLE [dbo].[Reclamo_Doc_Asoc]
GO
CREATE TABLE [dbo].[Reclamo_Doc_Asoc](
	[id_documento] [int] IDENTITY(1,1) NOT NULL,
	[id_reclamo] [int] NOT NULL,
	[id_accion] [int] NOT NULL,
	[comentario] [nchar](100) NOT NULL,
	[num_doc] [nchar](20) NOT NULL,
	[id_tipo_documento] [int] NOT NULL,
	[fec_emis] [datetime] NOT NULL,
	[co_us_in] [int] NOT NULL,
 CONSTRAINT [PK_Reclamo_Doc_Asoc] PRIMARY KEY CLUSTERED 
(
	[id_documento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
--
ALTER TABLE [dbo].[Reclamo_Doc_Asoc] WITH CHECK ADD CONSTRAINT [FK_Reclamo_Doc_Asoc_Reclamo_Accion] FOREIGN KEY([id_accion])
REFERENCES [dbo].[Reclamo_Accion] ([id_accion])
GO
--
ALTER TABLE [dbo].[Reclamo_Doc_Asoc] WITH CHECK ADD CONSTRAINT [FK_Reclamo_Doc_Asoc_Tipo_Documento] FOREIGN KEY([id_tipo_documento])
REFERENCES [dbo].[Tipo_Documento] ([id_tipo_documento])
GO
--
ALTER TABLE [dbo].[Reclamo_Doc_Asoc] CHECK CONSTRAINT [FK_Reclamo_Doc_Asoc_Reclamo_Accion]
ALTER TABLE [dbo].[Reclamo_Doc_Asoc] CHECK CONSTRAINT [FK_Reclamo_Doc_Asoc_Tipo_Documento]
GO
--
USE [ELZYRA]
GO
DROP TABLE [ELZYRA].[dbo].[Tipo_Documento]
CREATE TABLE [ELZYRA].[dbo].[Tipo_Documento](
	[id_tipo_documento] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [nchar](100) NOT NULL,
	[fec_registro] [datetime] NOT NULL,
	[co_us_in] [nvarchar](max) NOT NULL,	
 CONSTRAINT [PK_Tipo_Documento] PRIMARY KEY CLUSTERED 
(
	[id_tipo_documento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
--
SELECT * FROM Tipo_Documento
--
USE [ELZYRA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[pGet_ConsultarRif] (
	@Empresa nchar(10),
	@Rif nchar(10)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Resumen table (
		email nchar(60), 
		respons nchar(60), 
		telefonos nchar(60), 
		co_cli nchar(10),
		cli_des varchar(100)
	)
	DECLARE @Xsql nvarchar(max),@Params nvarchar(max)

	SET @Xsql =
	'SELECT TOP(1) c.email, respons, c.telefonos, co_cli, cli_des
		FROM ' + RTRIM(LTRIM(@Empresa)) + '.dbo.clientes C 
		INNER JOIN ' + RTRIM(LTRIM(@Empresa)) + '.dbo.vendedor V on V.co_ven=C.co_ven 
		WHERE rif = ''' + RTRIM(LTRIM(@Rif)) + ''''

	PRINT @Xsql
	
	INSERT INTO @Resumen 
	EXEC sp_executesql @Xsql
	
	SELECT * FROM @Resumen
END
--
EXECUTE msdb.dbo.sysmail_add_account_sp 
	@account_name = 'No Reply demo',
	@description = '',
	@email_address = 'no-reply@demo.com.ve',
	@replyto_address = 'no-reply@demo.com.ve',
	@display_name = 'no-reply@demo.com.ve',
	@mailserver_name = 'smtp.gmail.com',
	@port = 25,
	@username = 'no-reply@demo.com.ve',
	@password = 'J311377140-',
	@enable_ssl = 1;
--
USE msdb
EXEC sysmail_delete_account_sp @account_name = 'No Reply demo'
EXEC sp_help 'sysmail_add_account_sp'
EXEC sp_help 'sysmail_delete_account_sp'