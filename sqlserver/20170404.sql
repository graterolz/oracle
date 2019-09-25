SELECT	co_art,
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
--
SELECT * FROM ARCO.dbo.ajuste WHERE ajue_num = 1
SELECT * FROM ARCO.dbo.reng_aju WHERE ajue_num = 1
SELECT * FROM ARCO.dbo.par_emp
SELECT MAX(ajus_num) + 1 FROM ARCO.dbo.par_emp
--
SELECT * FROM ELZYRA.dbo.Comision_GeneraDetalle
SELECT * FROM ELZYRA.dbo.GrupoUsuarios
USE ELZYRA EXEC sp_rename 'UsuariosPorEmpresas','GrupoUsuarios'
ALTER TABLE ELZYRA.dbo.GrupoUsuarios DROP COLUMN id_empresa
--
ALTER TABLE ELZYRA.dbo.GrupoUsuarios DROP CONSTRAINT [FK_GrupoEmpresas_GrupoEmpresas]
ALTER TABLE ELZYRA.dbo.GrupoUsuarios WITH CHECK ADD CONSTRAINT [FK_GrupoEmpresas_GrupoEmpresas] FOREIGN KEY([id_grpemp]) REFERENCES [ELZYRA].[dbo].[GrupoEmpresas] ([id_grpemp])
ALTER TABLE ELZYRA.dbo.GrupoUsuarios CHECK CONSTRAINT [FK_GrupoEmpresas_GrupoEmpresas]
--
SELECT * FROM ELZYRA.dbo.GrupoPorEmpresas
USE ELZYRA EXEC sp_rename 'EmpresasPorGrupos','GrupoPorEmpresas'
USE ARCO EXEC sp_help 'dbo.ajuste'
--
USE ELZYRA EXEC dbo.pIncluyeAjuste
SELECT * FROM ARCO.dbo.ajuste ORDER BY ajue_num DESC
--
USE ELZYRA EXEC dbo.pIncluyeAjusteReng @ajue_num = 10
SELECT * FROM ARCO.dbo.reng_aju WHERE ajue_num = 10 ORDER BY 2 DESC
--
USE ELZYRA
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE pIncluyeAjuste
	@fecha smalldatetime = NULL,
	@motivo varchar(80) = NULL,
	@total decimal(18,5) = NULL,
	@seriales int = NULL,
	@feccom smalldatetime = NULL,
	@numcom int = NULL,
	@tasa decimal(18,5) = NULL,
	@moneda char(6) = NULL,
	@dis_cen text = NULL,
	@campo1 varchar(60) = NULL,
	@campo2 varchar(60) = NULL,
	@campo3 varchar(60) = NULL,
	@campo4 varchar(60) = NULL,
	@campo5 varchar(60) = NULL,
	@campo6 varchar(60) = NULL,
	@campo7 varchar(60) = NULL,
	@campo8 varchar(60) = NULL,
	@co_us_in char(6) = NULL,
	@fe_us_in datetime = NULL,
	@co_us_mo char(6) = NULL,
	@fe_us_mo datetime = NULL,
	@co_us_el char(6) = NULL,
	@fe_us_el datetime = NULL,
	@revisado char(1) = NULL,
	@trasnfe char(1) = NULL,
	@co_sucu char(6) = NULL,
	@rowguid uniqueidentifier = NULL,
	@anulada bit = NULL,
	@aux01 decimal(18,5) = NULL,
	@aux02 varchar(30) = NULL,
	@produccion bit = NULL,
	@imp_num int = NULL,
	@fact_num int = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET @fecha = CONVERT(smalldatetime,GETDATE())
	SET @feccom = CONVERT(smalldatetime,GETDATE())
	SET @fe_us_in = CONVERT(datetime,GETDATE())
	SET @fe_us_mo = CONVERT(datetime,GETDATE())
	SET @fe_us_el = CONVERT(datetime,GETDATE())
	SET @motivo = ''
	SET @total = 0
	SET @seriales = 0
	SET @numcom = 0
	SET @tasa = 1
	SET @moneda = 'BSF'
	SET @dis_cen = ''
	SET @campo1 = ''
	SET @campo2 = ''
	SET @campo3 = ''
	SET @campo4 = ''
	SET @campo5 = ''
	SET @campo6 = ''
	SET @campo7 = ''
	SET @campo8 = ''
	SET @co_us_in = ''
	SET @co_us_mo = ''
	SET @co_us_el = ''
	SET @revisado = ''
	SET @trasnfe = ''
	SET @co_sucu = '01'
	SET @rowguid = NEWID()
	SET @anulada = 0
	SET @aux01 = 0
	SET @aux02 = ''
	SET @produccion = 1
	SET @imp_num = 1
	SET @fact_num = 1
	--
	DECLARE @ajue_num INT SET @ajue_num = (SELECT MAX(ajus_num) + 1 FROM ARCO.dbo.par_emp)
	--
	BEGIN TRY
		INSERT INTO [ARCO].[dbo].[ajuste] (
			[ajue_num],[fecha],[motivo],[total],[seriales],[feccom],[numcom],[tasa],[moneda],[dis_cen],
			[campo1],[campo2],[campo3],[campo4],[campo5],[campo6],[campo7],[campo8],[co_us_in],[fe_us_in],
			[co_us_mo],[fe_us_mo],[co_us_el],[fe_us_el],[revisado],[trasnfe],[co_sucu],[rowguid],[anulada],
			[aux01],[aux02],[produccion],[imp_num],[fact_num]
		)
		VALUES (
			@ajue_num,@fecha,@motivo,@total,@seriales,@feccom,@numcom,@tasa,@moneda,@dis_cen,
			@campo1,@campo2,@campo3,@campo4,@campo5,@campo6,@campo7,@campo8,@co_us_in,@fe_us_in,
			@co_us_mo,@fe_us_mo,@co_us_el,@fe_us_el,@revisado,@trasnfe,@co_sucu,@rowguid,@anulada,
			@aux01,@aux02,@produccion,@imp_num,@fact_num
		)
		--
		UPDATE TOP(1) ARCO.dbo.par_emp
		SET ajus_num = @ajue_num
		WHERE cod_emp = 'ARCOWELD'
		--
	END TRY 
	BEGIN CATCH 
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
	--
END
GO
--
USE ELZYRA
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE pIncluyeAjusteReng
	@ajue_num int,
	@reng_num int = NULL,
	@dis_cen text = NULL,
	@tipo char(6) = NULL,
	@co_art char(30) = NULL,
	@total_art decimal(18,5) = NULL,
	@uni_compra char(6) = NULL,
	@stotal_art decimal(18,5) = NULL,
	@suni_compr char(6) = NULL,
	@co_alma char(6) = NULL,
	@cost_unit_om decimal(18,5) = NULL,
	@cost_unit decimal(18,5) = NULL,
	@feccom smalldatetime = NULL,
	@numcom int = NULL,
	@uni_venta char(6) = NULL,
	@suni_venta char(6) = NULL,
	@cos_pro_un decimal(18,5) = NULL,
	@ult_cos_om decimal(18,5) = NULL,
	@cos_pro_om decimal(18,5) = NULL,
	@rowguid uniqueidentifier = NULL,
	@total_uni decimal(18,5) = NULL,
	@nro_lote char(20) = NULL,
	@fec_lote smalldatetime = NULL,
	@pendiente2 decimal(18,5) = NULL,
	@tipo_doc2 char(1) = NULL,
	@reng_doc2 int = NULL,
	@num_doc2 int = NULL,
	@aux01 decimal(18,5) = NULL,
	@aux02 varchar(30) = NULL,
	@mo_cant decimal(18,5) = NULL,
	@gf_cant decimal(18,5) = NULL,
	@mo_cant_om decimal(18,5) = NULL,
	@gf_cant_om decimal(18,5) = NULL,
	@produccion bit = NULL
AS
BEGIN
	SET NOCOUNT ON;
	--SET @ajue_num = NULL
	SET @reng_num = (SELECT COUNT(*) + 1 FROM ARCO.dbo.reng_aju WHERE ajue_num = @ajue_num)
	SET @dis_cen = ''
	SET @tipo = 'CP'
	SET @co_art = '1001001001'
	SET @total_art = 0
	SET @uni_compra = ''
	SET @stotal_art = 0
	SET @suni_compr = ''
	SET @co_alma = '001'
	SET @cost_unit_om = 0
	SET @cost_unit = 0
	SET @feccom = CONVERT(smalldatetime,GETDATE())
	SET @numcom = 0
	SET @uni_venta = ''
	SET @suni_venta = ''
	SET @cos_pro_un = 0
	SET @ult_cos_om = 0
	SET @cos_pro_om = 0
	SET @rowguid = NEWID()
	SET @total_uni = 0
	SET @nro_lote = ''
	SET @fec_lote = CONVERT(smalldatetime,GETDATE())
	SET @pendiente2 = 0
	SET @tipo_doc2 = ''
	SET @reng_doc2 = 0
	SET @num_doc2 = 0
	SET @aux01 = 0
	SET @aux02 = ''
	SET @mo_cant = 0
	SET @gf_cant = 0
	SET @mo_cant_om = 0
	SET @gf_cant_om = 0
	SET @produccion = 0
	--
	BEGIN TRY
		INSERT INTO [ARCO].[dbo].[reng_aju] (
			[ajue_num],[reng_num],[dis_cen],[tipo],[co_art],[total_art],[uni_compra],[stotal_art],[suni_compr],[co_alma],[cost_unit_om],[cost_unit],
			[feccom],[numcom],[uni_venta],[suni_venta],[cos_pro_un],[ult_cos_om],[cos_pro_om],[rowguid],[total_uni],[nro_lote],[fec_lote],[pendiente2],
			[tipo_doc2],[reng_doc2],[num_doc2],[aux01],[aux02],[mo_cant],[gf_cant],[mo_cant_om],[gf_cant_om],[produccion]
		)
		VALUES (
			@ajue_num,@reng_num,@dis_cen,@tipo,@co_art,@total_art,@uni_compra,@stotal_art,@suni_compr,@co_alma,@cost_unit_om,@cost_unit,
			@feccom,@numcom,@uni_venta,@suni_venta,@cos_pro_un,@ult_cos_om,@cos_pro_om,@rowguid,@total_uni,@nro_lote,@fec_lote,@pendiente2,
			@tipo_doc2,@reng_doc2,@num_doc2,@aux01,@aux02,@mo_cant,@gf_cant,@mo_cant_om,@gf_cant_om,@produccion
		)
		--
	END TRY 
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
	--
END
GO