SELECT * FROM OVERLAND.dbo.st_almac
SELECT * FROM SERVICE.dbo.st_almac
SELECT * FROM OVERLAND.dbo.art
--
SELECT *
FROM STAR01.dbo.art A
INNER JOIN STAR01.dbo.st_almac B ON A.co_art = B.co_art
WHERE A.stock_act <= A.pto_pedido
AND B.co_alma = '001'
AND A.co_art = '00001001'
--
SELECT
	co_art,
	art_des,
	stock_com,
	sstock_com,
	(CASE
		WHEN relac_aut IN (1,4) THEN 0
		WHEN relac_aut = 2 THEN stock_com*uni_relac 
		WHEN relac_aut = 3 THEN stock_com/uni_relac
		ELSE 1
	END) new_sstock_com,
	relac_aut,uni_relac
FROM OVERLAND.dbo.art A WHERE co_art = '1001115B'
--
SELECT * FROM OVERLAND.dbo.st_almac WHERE co_art = '1001115B'