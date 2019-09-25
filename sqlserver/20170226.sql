SELECT * FROM STAR01.dbo.art a 
INNER JOIN STAR01.dbo.proceden p ON a.procedenci = p.cod_proc
--
SELECT a.*, u.* FROM STAR01.dbo.art a 
INNER JOIN STAR01.dbo.unidades u ON a.uni_venta = u.co_uni
--
SELECT a.*, t.* FROM STAR01.dbo.art a 
INNER JOIN STAR01.dbo.tabulado t ON a.tipo_imp = t.tipo
--
SELECT u.* FROM STAR01.dbo.art a 
INNER JOIN STAR01.dbo.unidades u ON a.uni_venta = u.co_uni
--
SELECT * FROM STAR01.dbo.art a 
INNER JOIN STAR01.dbo.lin_art la ON a.co_lin = la.co_lin
INNER JOIN STAR01.dbo.sub_lin sl ON la.co_lin = sl.co_lin
WHERE a.co_art = '00001001'
ORDER BY 1
--
SELECT p.* FROM STAR01.dbo.art a 
INNER JOIN STAR01.dbo.prov p ON a.co_prov = p.co_prov
--
SELECT * FROM STAR01.dbo.almacen a 
INNER JOIN STAR01.dbo.sub_alma s ON a.co_alma = s.co_alma
--
SELECT * FROM STAR01.dbo.art WHERE co_art = '00001001';
SELECT * FROM STAR01.dbo.st_almac WHERE co_art = '00001001';
--
SELECT * FROM STAR01.dbo.st_almac sta
INNER JOIN STAR01.dbo.sub_alma sa ON sta.co_alma = sa.co_alma
INNER JOIN STAR01.dbo.almacen a ON sa.co_alma = a.co_alma