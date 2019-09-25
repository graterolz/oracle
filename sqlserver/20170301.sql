SELECT COUNT(*) FROM [Profit_RG].[dbo].[Reclamo_Accion]
SELECT COUNT(*) FROM [Profit_RG].[dbo].[Reclamo_Cliente]
SELECT COUNT(*) FROM [Profit_RG].[dbo].[Reclamo_Doc_Asoc]
SELECT COUNT(*) FROM [Profit_RG].[dbo].[Reclamo_Razon]
SELECT COUNT(*) FROM [Profit_RG].[dbo].[Reclamo_Tab_Accion]
--
DELETE FROM Profit_RG.dbo.Reclamo_Accion where id_accion = 56
DELETE FROM Profit_RG.dbo.Reclamo_Accion where id_accion = 57
DELETE FROM Profit_RG.dbo.Reclamo_Accion where id_accion = 58
DELETE FROM Profit_RG.dbo.Reclamo_Accion where id_accion = 59
--
SELECT	DATENAME(YEAR,mv.desde) anio,
		DATENAME(MONTH,mv.desde) mes,
		v.co_ven, 
		v.ven_des,
		v.cedula, 
		mv.meta_bs presupuesto,
		SUM(d.ventas) ventas,
		COUNT(*) clientes
FROM STAR01.dbo.vendedor v
INNER JOIN Profit_RG.dbo.Metas_Vendedor mv ON v.co_ven = mv.co_ven
INNER JOIN (
	SELECT 	d.co_ven,
			c.rif,
			SUM(d.monto_bru) ventas,
			DATENAME(YEAR,d.fec_emis) anio,
			DATENAME(MONTH,d.fec_emis) mes
	FROM STAR01.dbo.docum_cc d INNER JOIN STAR01.dbo.clientes c ON d.co_cli = c.co_cli
	WHERE tipo_doc IN ('FACT','N/CR') 
	AND anulado = 0
	AND d.co_ven = '003'
	GROUP BY d.co_ven,c.rif,DATENAME(YEAR,d.fec_emis), DATENAME(MONTH,d.fec_emis)
) d ON  d.co_ven = v.co_ven AND DATENAME(YEAR,mv.desde) = d.anio AND DATENAME(MONTH,mv.desde) = d.mes
GROUP BY v.co_ven,ven_des,cedula,meta_bs,mv.desde,mv.desde