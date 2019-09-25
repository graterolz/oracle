SELECT * FROM OVERLAND.dbo.art WHERE co_art = '9003011'
SELECT * FROM OVERLAND.dbo.st_almac WHERE co_art = '9003011'
--
SELECT * FROM OVERLAND.INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE '%stock_com%'
--
ALTER TABLE ELZYRA.dbo.Comision_GeneraDetalle ADD [Asig Vehicular] decimal (18,2) NULL
ALTER TABLE ELZYRA.dbo.Comision_Historico ADD [Asig Vehicular] decimal (18,2) NULL
--
SELECT * FROM ELZYRA.dbo.Emp_asoc where grupo = 'STARGAS'
--
SELECT *
FROM OVERLAND.dbo.art
WHERE co_art = '1102001PB'
--
SELECT *
FROM OVERLAND.dbo.st_almac
WHERE co_art = '1102001PB'
AND co_alma = '0002'
--
SELECT DISTINCT TOP(10)
	A.co_art,
	R.co_alma,
	S.stock_com,
	MAX(uni_relac),
	(CASE
		WHEN relac_aut IN (1,4) THEN 0
		WHEN relac_aut = 2 THEN (S.stock_com*A.uni_relac) 
		WHEN relac_aut = 3 THEN (S.stock_com/A.uni_relac)
		ELSE 1
	END) new_sstock_com
FROM OVERLAND.dbo.art A
LEFT JOIN OVERLAND.dbo.reng_ped R on A.co_art=R.co_art
INNER JOIN OVERLAND.dbo.pedidos P on P.fact_num=R.fact_num
INNER JOIN OVERLAND.dbo.st_almac S ON S.co_alma = R.co_alma AND S.co_art = R.co_art
WHERE P.anulada=0
AND status<=1
AND uni_relac > 0
AND A.co_art = '1004200'
GROUP BY A.co_art,R.co_alma,relac_aut,S.stock_com,uni_relac
ORDER BY A.co_art