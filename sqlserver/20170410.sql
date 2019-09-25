SELECT * FROM ELZYRA.dbo.Articulos_Certificacion
SELECT * FROM ELZYRA.dbo.Articulos_CertificaStockDetalle
SELECT * FROM ELZYRA.dbo.Articulos_CertificaSResultado
--
SELECT * FROM ELZYRA.dbo.Empresas
SELECT * FROM Profit_XLS.dbo.data_sg
SELECT * FROM Profit_XLS.dbo.data_se
--
UPDATE TOP(100) STAR01.dbo.not_dep
SET co_tran = (
	SELECT ID FROM Profit_XLS.dbo.data_sg B
	WHERE NDD = STAR01.dbo.not_dep.fact_num
)
WHERE fact_num IN (
	SELECT fact_num FROM Profit_XLS.dbo.data_sg A
	INNER JOIN STAR01.dbo.not_dep B ON A.NDD = B.fact_num
	WHERE A.ID <> B.co_tran
)
--
SELECT * FROM Profit_XLS.dbo.data_sg WHERE NDD = '26410'
SELECT * FROM STAR01.dbo.not_dep WHERE fact_num = '26410'
--
UPDATE TOP(1) SERVICE.dbo.not_dep
SET co_tran = (
	SELECT ID FROM Profit_XLS.dbo.data_se B
	WHERE NDD = SERVICE.dbo.not_dep.fact_num
)
WHERE fact_num IN (
	SELECT fact_num FROM Profit_XLS.dbo.data_se A
	INNER JOIN SERVICE.dbo.not_dep B ON A.NDD = B.fact_num
	WHERE A.ID <> B.co_tran
)
--
SELECT co_art,stock_com,sstock_com FROM OVERLAND.dbo.art WHERE co_art = '9003011'
SELECT co_art,co_alma,stock_com,sstock_com FROM OVERLAND.dbo.st_almac  WHERE co_art = '9003011'
--
SELECT * FROM OVERLAND.dbo.reng_ped R
INNER JOIN OVERLAND.dbo.pedidos P on P.fact_num = R.fact_num
WHERE co_art = '9003011' and R.fact_num = '9189'
--
SELECT * FROM OVERLAND.INFORMATION_SCHEMA.COLUMNS WHERE column_name = 'sstock_com'
--
SELECT * FROM ELZYRA.dbo.Comision_Genera
SELECT * FROM ELZYRA.dbo.Comision_GeneraDetalle WHERE id_comision = 17
SELECT * FROM ELZYRA.dbo.Comision_Historico WHERE id_comision = 17
--
SELECT * FROM ELZYRA.dbo.Comision_Historico
UNION ALL
SELECT * FROM ELZYRA.dbo.Comision_GeneraDetalle
--
ALTER TABLE [ELZYRA].[dbo].[Articulos_CertificaSResultado] DROP CONSTRAINT [FK_Articulos_CertificaStockDetalle]
ALTER TABLE [ELZYRA].[dbo].[Articulos_CertificaSResultado] DROP CONSTRAINT [FK_Articulos_Certificacion]
ALTER TABLE [ELZYRA].[dbo].[Articulos_CertificaSResultado] DROP CONSTRAINT [FK_Articulos_Empresas]
GO
DROP TABLE [ELZYRA].[dbo].[Articulos_CertificaSResultado]
GO
--
CREATE TABLE [ELZYRA].[dbo].[Articulos_CertificaSResultado](
	[id_artcert_st_r] [int] IDENTITY(1,1) NOT NULL,
	[id_artcerdet] [int] NOT NULL,
	[id_artcer] [int] NOT NULL,
	[id_empresa] [int] NOT NULL,
	[co_alma] [nchar](128) NOT NULL,
	[co_art] [nchar](128) NOT NULL,
	[art_des] [nchar](128) NOT NULL,
	[stock_act] [decimal](10,2) NOT NULL,
	[total_art] [decimal](10,2) NOT NULL,
	[tipo_ajus] [nchar](128) NOT NULL,
	[ajue_num] [nchar](128) NULL,
 CONSTRAINT [PK_Articulos_CertificaSResultado] PRIMARY KEY CLUSTERED 
(
	[id_artcert_st_r] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
--
ALTER TABLE [ELZYRA].[dbo].[Articulos_CertificaSResultado] WITH CHECK ADD CONSTRAINT [FK_Articulos_CertificaStockDetalle] FOREIGN KEY([id_artcerdet]) REFERENCES [ELZYRA].[dbo].[Articulos_CertificaStockDetalle] ([id_artcerdet])
ALTER TABLE [ELZYRA].[dbo].[Articulos_CertificaSResultado] WITH CHECK ADD CONSTRAINT [FK_Articulos_Certificacion] FOREIGN KEY([id_artcer]) REFERENCES [ELZYRA].[dbo].[Articulos_Certificacion] ([id_artcer])
ALTER TABLE [ELZYRA].[dbo].[Articulos_CertificaSResultado] WITH CHECK ADD CONSTRAINT [FK_Articulos_Empresas] FOREIGN KEY([id_empresa]) REFERENCES [ELZYRA].[dbo].[Empresas] ([id_empresa])
GO
--
ALTER TABLE [ELZYRA].[dbo].[Articulos_CertificaSResultado] CHECK CONSTRAINT [FK_Articulos_CertificaStockDetalle]
ALTER TABLE [ELZYRA].[dbo].[Articulos_CertificaSResultado] CHECK CONSTRAINT [FK_Articulos_Certificacion]
ALTER TABLE [ELZYRA].[dbo].[Articulos_CertificaSResultado] CHECK CONSTRAINT [FK_Articulos_Empresas]
GO
--
USE [ELZYRA]
GO
--ALTER TABLE [dbo].[Comision_Historico] DROP CONSTRAINT [FK_Comision_GeneraDetalle_Comision_Genera]
GO
--ALTER TABLE [dbo].[Comision_Historico] DROP CONSTRAINT [DF__Comision___fec_r__5E20C076]
GO
DROP TABLE [dbo].[Comision_Historico]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comision_Historico](
	[id_gcomision] [int] NOT NULL,
	[id_comision] [int] NOT NULL,
	[co_ven] [nchar](10) NOT NULL,
	[Vendedor] [nchar](60) NOT NULL,
	[Cliente] [nchar](60) NOT NULL,
	[Cobro] [int] NOT NULL,
	[Factura] [int] NOT NULL,
	[Condicion] [nchar](60) NOT NULL,
	[Fecha_Emision] [nchar](10) NULL,
	[Fecha_Recep] [nchar](10) NULL,
	[Fecha_de_Pago] [nchar](10) NULL,
	[Monto_Factura] [decimal](18, 2) NOT NULL,
	[Desgloce_Fact] [decimal](18, 2) NOT NULL,
	[NCR] [decimal](18, 2) NOT NULL,
	[Base_Com_Flete] [decimal](34, 8) NULL,
	[Grupo] [nchar](60) NOT NULL,
	[Factor] [decimal](18, 2) NOT NULL,
	[DC] [int] NOT NULL,
	[Dias_calle_final] [int] NOT NULL,
	[Penalizacion] [decimal](10, 2) NOT NULL,
	[Comision_Base_Factura] [decimal](10, 2) NULL,
	[Venta] [decimal](18, 2) NOT NULL,
	[Meta] [decimal](18, 2) NOT NULL,
	[Factor_Meta] [decimal](10, 2) NOT NULL,
	[Factor_Meta_Aplicado] [decimal](10, 2) NOT NULL,
	[Total] [decimal](18, 2) NULL,
	[Venta_Grupo] [decimal](18, 2) NOT NULL,
	[Factor_imix] [decimal](10, 2) NOT NULL,
	[Ponderacion] [decimal](18, 2) NOT NULL,
	[Factor_IMIX_Aplicado] [decimal](10, 2) NOT NULL,
	[Total_IMIX] [decimal](18, 2) NULL,
	[Factor_Comi_Incentivos] [decimal](10, 2) NULL,
	[Comision_Total] [decimal](18, 2) NOT NULL,
	[co_us_in] [nchar](128) NULL,
	[fec_registro] [datetime] NOT NULL,
 CONSTRAINT [PK_Comision_Historico] PRIMARY KEY CLUSTERED 
(
	[id_gcomision] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Comision_Historico] ADD DEFAULT (getdate()) FOR [fec_registro]
GO
--ALTER TABLE [dbo].[Comision_Historico] WITH CHECK ADD CONSTRAINT [FK_Comision_GeneraDetalle_Comision_Genera] FOREIGN KEY([id_comision]) REFERENCES [dbo].[Comision_Genera] ([id_comision])
GO
--ALTER TABLE [dbo].[Comision_GeneraDetalle] CHECK CONSTRAINT [FK_Comision_GeneraDetalle_Comision_Genera]
GO
--
USE [ELZYRA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[pELZ_Comision_Cierra] (
	@Comision int
)
AS
BEGIN
	SET NOCOUNT ON;
	--SET IDENTITY_INSERT [ELZYRA].[dbo].[Comision_Historico] ON

	INSERT INTO [ELZYRA].[dbo].[Comision_Historico] (
		[id_gcomision],[id_comision],[co_ven],[Vendedor],[Cliente],[Cobro],[Factura],[Condicion],[Fecha_Emision],[Fecha_Recep],
		[Fecha_de_Pago],[Monto_Factura],[Desgloce_Fact],[NCR],[Base_Com_Flete],[Grupo],[Factor],[DC],[Dias_calle_final],[Penalizacion],
		[Comision_Base_Factura],[Venta],[Meta],[Factor_Meta],[Factor_Meta_Aplicado],[Total],[Venta_Grupo],[Factor_imix],[Ponderacion],
		[Factor_IMIX_Aplicado],[Total_IMIX],[Factor_Comi_Incentivos],[Comision_Total],[co_us_in],[fec_registro],[Asig Vehicular]
	)
	SELECT
		[id_gcomision],[id_comision],[co_ven],[Vendedor],[Cliente],[Cobro],[Factura],[Condicion],[Fecha_Emision],[Fecha_Recep],
		[Fecha_de_Pago],[Monto_Factura],[Desgloce_Fact],[NCR],[Base_Com_Flete],[Grupo],[Factor],[DC],[Dias_calle_final],[Penalizacion],
		[Comision_Base_Factura],[Venta],[Meta],[Factor_Meta],[Factor_Meta_Aplicado],[Total],[Venta_Grupo],[Factor_imix],[Ponderacion],
		[Factor_IMIX_Aplicado],[Total_IMIX],[Factor_Comi_Incentivos],[Comision_Total],[co_us_in],[fec_registro],[Asig Vehicular]
	FROM [ELZYRA].[dbo].[Comision_GeneraDetalle]
	WHERE id_comision = @Comision

	--SET IDENTITY_INSERT [ELZYRA].[dbo].[Comision_Historico] OFF
	DELETE FROM [ELZYRA].[dbo].[Comision_GeneraDetalle]
	WHERE id_comision = @Comision
	--
	UPDATE [ELZYRA].[dbo].[Comision_Genera]
	SET status = 0
	WHERE id_comision = @Comision
	--
	SELECT * FROM [ELZYRA].[dbo].[Comision_Genera] WHERE id_comision = @Comision
END
--
USE [ELZYRA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[pELZ_Comision_Genera] (
	@Comision int,
	@Vendedor nchar(10)
)
AS
BEGIN
	SET NOCOUNT ON;

	Declare @Xsql NVARCHAR(MAX),@Xsql1 NVARCHAR(MAX),@Xsql2 NVARCHAR(MAX),@Xsql3 NVARCHAR(MAX),@Xsql4 NVARCHAR(MAX)
	DECLARE @PARAMS NVARCHAR(MAX),@Grupo nchar(10),	@Empresa nchar(10),	@Desde datetime, @Hasta datetime

	Declare @Resumen Table (
		co_ven nchar(10),ven_des nchar(60),co_cli nchar(10),cli_des nchar(60),fact_num int,
		MontoFactura decimal(18,2),grupo nchar(60),factor decimal(10,2),factorApl decimal(10,2),
		basecomision decimal(18,2),co_tran nchar(10),des_tran nchar(60),Transporte nchar(60),
		Factor_flete decimal(10,2),ncr decimal(18,2), pdesc decimal(18,6),cob_num int,fec_emis datetime,
		Frecep datetime,Ult_fecha datetime,FechaAdcCobro nchar(30),FR nchar(100),ValidaFRecep nchar(100),dc int,
		Venta decimal(18,2),Meta decimal(18,2),Factor_Mv decimal(10,2),Factor_MvApl decimal(10,2),
		VentaGrupo decimal(18,2),Ponderacion decimal(10,2),Factor_imix decimal(10,2),Factor_imixApl decimal(10,2),
		Forma_pago nchar(60),Penal_des nchar(60),Id_pc int,GrupoPenal nchar(10),Penal_Desde datetime,
		Penal_hasta datetime,DC_Inicio int,DC_Fin int,Penalizacion decimal(10,2),BaseComiDef decimal(18,2),
		FactorComiDef decimal(10,2),Comision decimal(18,2)
	)
	declare @Resumen2 table (cantidad int)

	set @Grupo = (select GE.alias from Elzyra.dbo.Comision_Genera GC inner join ELZYRA.dbo.GrupoEmpresas GE on GE.id=GC.id_grpemp where id_comision = @Comision)
	set @Empresa = (select base_dato from ELZYRA.dbo.Empresas where id_empresa = (select id_empresa from ELZYRA.dbo.Comision_Genera GC where id_comision = @Comision))
	set @Desde = (select desde from ELZYRA.dbo.Comision_Genera GC where id_comision = @Comision)
	set @Hasta = (select hasta from ELZYRA.dbo.Comision_Genera GC where id_comision = @Comision)

	if (@Grupo='DEMO')
		set @Xsql = (SELECT ELZYRA.[dbo].func_Script_ComisionSG(@Empresa) Script)

	if (@Grupo='OVERLAND')
		set @Xsql = (SELECT ELZYRA.[dbo].[func_Script_ComisionOVL] (@Empresa) Script)

	SET @PARAMS = N'@D datetime,@H datetime,@V nchar(10)'
	insert into @Resumen
	Exec sp_executesql	@Xsql,@Params,@D=@Desde,@H=@Hasta,@V=@Vendedor

	Delete from ELZYRA.dbo.Comision_GeneraDetalle where id_comision=@Comision and co_ven=@Vendedor
	
	INSERT INTO [dbo].[Comision_GeneraDetalle] (
		[id_comision],[co_ven],[Vendedor],[Cliente],[Cobro],[Factura],[Condicion],[Fecha_Emision],[Fecha_Recep],
		[Fecha_de_Pago],[Monto_Factura],[Desgloce_Fact],[NCR],[Base_Com_Flete],[Grupo],[Factor],[DC],[Dias_calle_final],
		[Penalizacion],[Comision_Base_Factura],[Venta],[Meta],[Factor_Meta],[Factor_Meta_Aplicado],[Total],[Venta_Grupo],
		[Factor_imix],[Ponderacion],[Factor_IMIX_Aplicado],[Total_IMIX],Factor_Comi_Incentivos,[Comision_Total]
	)
	SELECT @Comision,co_ven,ven_des Vendedor,cli_des Cliente,cob_num Cobro,fact_num Factura,
	Forma_pago Condicion,convert(nchar(10),fec_emis,103) [Fecha_Emision],convert(nchar(10),Frecep,103) [Fecha_Recep],
	convert(nchar(10),Ult_fecha,103) [Fecha_de_Pago], MontoFactura [Monto_Factura],basecomision [Desgloce_Fact],
	ncr NCR,basecomision - (basecomision * Factor_flete/100) [Base_Com_Flete],grupo Grupo,
	factorApl Factor, dc DC,case when dc<0 then 0 else DC end [Dias_calle_final],
	Penalizacion,Convert(decimal(18,2),round((BaseComiDef*(factorApl/100))-((BaseComiDef*(factorApl/100))*Penalizacion/100),2)) [Comision_Base_Factura],
	Venta,Meta,Factor_Mv [Factor_Meta],
	Factor_MvApl [Factor_Meta_Aplicado],(BaseComiDef * Factor_MvApl /100) Total,VentaGrupo [Venta_Grupo],Factor_imix,
	Ponderacion,Factor_ImixApl [Factor_IMIX_Aplicado], (basecomision - (basecomision * Factor_flete/100))*(Factor_ImixApl/100) [Total_IMIX],
	Factorapl+Factor_MvApl+Factor_ImixApl Factor_Comi_Incentivos,Comision [Comision_Total]
	from @Resumen
	order by cob_num,fact_num

	INSERT INTO @Resumen2
	SELECT count(*) from Elzyra.dbo.Comision_GeneraDetalle WHERE co_ven = @Vendedor

	SELECT * FROM @Resumen2
END
--
USE [ELZYRA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[pELZ_Comision_Reabrir] (
	@Comision int
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	SET IDENTITY_INSERT [ELZYRA].[dbo].[Comision_GeneraDetalle] ON
	INSERT INTO [ELZYRA].[dbo].[Comision_GeneraDetalle] (
		[id_gcomision],[id_comision],[co_ven],[Vendedor],[Cliente],[Cobro],[Factura],[Condicion],[Fecha_Emision],[Fecha_Recep],
		[Fecha_de_Pago],[Monto_Factura],[Desgloce_Fact],[NCR],[Base_Com_Flete],[Grupo],[Factor],[DC],[Dias_calle_final],[Penalizacion],
		[Comision_Base_Factura],[Venta],[Meta],[Factor_Meta],[Factor_Meta_Aplicado],[Total],[Venta_Grupo],[Factor_imix],[Ponderacion],
		[Factor_IMIX_Aplicado],[Total_IMIX],[Factor_Comi_Incentivos],[Comision_Total],[co_us_in],[fec_registro],[Asig Vehicular]
	)
	SELECT
		[id_gcomision],[id_comision],[co_ven],[Vendedor],[Cliente],[Cobro],[Factura],[Condicion],[Fecha_Emision],[Fecha_Recep],
		[Fecha_de_Pago],[Monto_Factura],[Desgloce_Fact],[NCR],[Base_Com_Flete],[Grupo],[Factor],[DC],[Dias_calle_final],[Penalizacion],
		[Comision_Base_Factura],[Venta],[Meta],[Factor_Meta],[Factor_Meta_Aplicado],[Total],[Venta_Grupo],[Factor_imix],[Ponderacion],
		[Factor_IMIX_Aplicado],[Total_IMIX],[Factor_Comi_Incentivos],[Comision_Total],[co_us_in],[fec_registro],[Asig Vehicular]
	FROM [ELZYRA].[dbo].[Comision_Historico]
	WHERE id_comision = @Comision

	SET IDENTITY_INSERT [ELZYRA].[dbo].[Comision_GeneraDetalle] OFF
	--
	DELETE FROM [ELZYRA].[dbo].[Comision_Historico]
	WHERE id_comision = @Comision
	--
	UPDATE [ELZYRA].[dbo].[Comision_Genera]
	SET status = 1
	WHERE id_comision = @Comision
	--
	SELECT * FROM [ELZYRA].[dbo].[Comision_Genera] WHERE id_comision = @Comision
END
--
DECLARE @co_art char(30)
DECLARE @entradas decimal(18,2)
DECLARE @salidas decimal(18,2)
DECLARE CUR_Arts_Det CURSOR FOR
SELECT
	co_art,
	SUM(CASE B.tipo_trans WHEN 'E' THEN total_art ELSE 0 END) entradas, 
	SUM(CASE B.tipo_trans WHEN 'S' THEN total_art ELSE 0 END) salidas 
FROM STAR01.dbo.ajuste AJ
INNER JOIN STAR01.dbo.reng_aju A ON AJ.ajue_num = A.ajue_num
INNER JOIN STAR01.dbo.tipo_aju B ON A.tipo = B.co_tipo
WHERE B.tipo_trans IN ('E','S')
AND AJ.anulada = 0
AND A.co_alma = '001'
GROUP BY co_art
ORDER BY co_art

OPEN CUR_Arts_Det
FETCH NEXT FROM CUR_Arts_Det INTO @co_art,@entradas,@salidas;
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @new_sstock_com = (
		SELECT
			(CASE
				WHEN A.relac_aut IN(1,4) THEN 0
				WHEN A.relac_aut = 2 THEN B.stock_com*A.uni_relac 
				WHEN A.relac_aut = 3 THEN B.stock_com/A.uni_relac
				ELSE 1
			END) 
		FROM STAR01.dbo.art A
		INNER JOIN STAR01.dbo.st_almac B ON A.co_art = B.co_art
		WHERE A.co_art = @co_art
		AND B.co_alma = @co_alma
	)
	--
	UPDATE TOP(1) STAR01.dbo.st_almac
	SET stock_com = @comprometido,
		sstock_com = @new_sstock_com
	WHERE co_art = @co_art
	AND @co_alma = co_alma
	
	FETCH NEXT FROM CUR_Arts_Det INTO @co_art,@entradas,@salidas;
END
CLOSE CUR_Arts_Det;
DEALLOCATE CUR_Arts_Det;