WITH
Metas_Vendedor AS (
SELECT DATENAME(YEAR,desde) anio,DATENAME(MONTH,desde) mes,co_ven,meta_bs FROM Profit_RG.dbo.Metas_Vendedor
),
Vendedores AS(
SELECT DISTINCT co_ven,ven_des FROM STAR01.dbo.vendedor
),
Clientes AS(
SELECT DISTINCT c.co_cli, c.co_ven, c.rif 
FROM STAR01.dbo.clientes c
JOIN STAR01.dbo.docum_cc d ON c.co_cli = d.co_cli AND c.co_ven = d.co_ven
WHERE d.tipo_doc = 'FACT' AND d.anulado = 0 AND c.inactivo = 0
),
Ventas AS(
SELECT
	DATENAME(YEAR,fec_emis) anio,
	DATENAME(MONTH,fec_emis) mes,
	co_ven,
	co_cli,
	SUM(CASE tipo_doc WHEN 'FACT' THEN monto_bru ELSE (monto_bru*-1) END) monto_bru
FROM STAR01.dbo.docum_cc 
WHERE tipo_doc IN ('FACT','N/CR') AND anulado = 0
GROUP BY DATENAME(YEAR,fec_emis), DATENAME(MONTH,fec_emis), co_ven,co_cli
)
SELECT 
	mv.anio,
	mv.mes,
	mv.co_ven,
	SUM(mv.meta_bs) Meta,
	SUM(ven.monto_bru) Ventas,
	NULL Alcance,
	COUNT(DISTINCT c.rif) Clientes
FROM Ventas ven 
JOIN Metas_Vendedor mv ON ven.anio = mv.anio AND ven.mes = mv.mes AND ven.co_ven = mv.co_ven
JOIN Vendedores v ON ven.co_ven = v.co_ven
JOIN Clientes c ON ven.co_cli = c.co_cli AND v.co_ven = c.co_ven
WHERE ven.co_ven = '003'
GROUP BY mv.anio,mv.mes,mv.co_ven
ORDER BY 1,2,3;