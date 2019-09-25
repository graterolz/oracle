SELECT * FROM ELZYRA.dbo.Comision_Historico
SELECT Profit_RG.[dbo].[funcScript_ComisionOVL] ('STAR01')
--
EXEC [ELZYRA].[dbo].[pELZ_Comision_Genera]
	@Empresa = 'STAR01',
	@Desde = '01/03/2017',
	@Hasta = '31/03/2017',
	@Vendedor = '001',
	@Comision = 1
--
USE ELZYRA EXEC sp_help 'dbo.Comision_GeneraDetalle'
USE ELZYRA EXEC sp_help 'dbo.Comision_GeneraDetalle_NEW'
SELECT * FROM ELZYRA.dbo.Comision_GeneraDetalle
SELECT * FROM ELZYRA.dbo.Comision_GeneraDetalle
SELECT * FROM ELZYRA.dbo.Comision_GeneraDetalle_NEW
--
DROP TABLE ELZYRA.dbo.Comision_GeneraDetalle_NEW
SELECT * INTO ELZYRA.dbo.Comision_GeneraDetalle_NEW FROM (
	SELECT
		1 [id_gcomision],
		1 [id_comision],	 
		co_ven,
		ven_des Vendedor,
		cli_des Cliente,
		cob_num Cobro,
		fact_num Factura,
		Forma_pago Condicion,
		CONVERT(nchar(10),fec_emis,103) [Fecha_Emision],
		CONVERT(nchar(10),Frecep,103) [Fecha_Recep],
		CONVERT(nchar(10),Ult_fecha,103) [Fecha_de_Pago],
		MontoFactura [Monto_Factura],
		basecomision [Desgloce_Fact],
		ncr NCR,
		basecomision - (basecomision * Factor_flete/100) [Base_Com_Flete],
		grupo Grupo,
		factorApl Factor,
		dc DC,
		case when dc<0 then 0 else DC end [Dias_calle_final],
		Penalizacion,
		CONVERT(DECIMAL(18,2),round((BaseComiDef*(factorApl/100))-((BaseComiDef*(factorApl/100))*Penalizacion/100),2)) [Comision_Base_Factura],
		Venta,
		Meta,
		Factor_Mv [Factor_Meta],
		Factor_MvApl [Factor_Meta_Aplicado],
		(BaseComiDef * Factor_MvApl/100) Total,
		VentaGrupo [Venta_Grupo],
		Factor_imix,
		Ponderacion,
		Factor_ImixApl [Factor_IMIX_Aplicado],
		(basecomision - (basecomision * Factor_flete/100))*(Factor_ImixApl/100) [Total_IMIX],
		Factorapl+Factor_MvApl+Factor_ImixApl [Factor Comi  + Incentivos],Comision [Comision_Total] 
	FROM Elzyra.dbo.Comision_GeneraDetalle CD
	WHERE id_comision = 1
) A
--
sp_configure 'Show Advanced Options', 1
GO
RECONFIGURE
GO
sp_configure 'Ad Hoc Distributed Queries', 1
GO
RECONFIGURE
GO
--
DROP TABLE #MyTempTable
SELECT * INTO #MyTempTable FROM OPENROWSET('SQLNCLI',
	'Server=172.16.1.4;Trusted_Connection=YES;',
	'EXEC [MICHI01].[dbo].[pInventarioUnificado] @Id_equipo = ''3'''
)
--
SELECT B.*,isnull(A.uni_min,1) uni_min 
FROM #MyTempTable B
LEFT JOIN Profit_RG.dbo.Art_min A ON A.co_art = B.co_art COLLATE SQL_Latin1_General_CP1_CI_AS