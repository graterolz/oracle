SELECT * FROM ELZYRA.dbo.Articulos_Certificacion
ALTER TABLE ELZYRA.dbo.Articulos_Certificacion ADD culminada BIT DEFAULT 0
ALTER TABLE ELZYRA.dbo.Articulos_Certificacion DROP COLUMN culminada
--
RESTORE HEADERONLY FROM DISK = 'C:\STAR01_backup_2017_04_06_200010_7441835.bak'
SELECT @@VERSION
--
SELECT * FROM SERVICE.dbo.art WHERE co_art ='E308-16 1/8'
SELECT * FROM SERVICE.dbo.st_almac WHERE co_art ='E308-16 1/8'
--
SELECT * FROM STAR01.dbo.not_dep WHERE fact_num = '25719'
SELECT * FROM Profit_XLS.dbo.new_datos_seguro WHERE NDD = '25719'
ALTER TABLE Profit_XLS.dbo.new_datos_seguro DROP COLUMN F3
--
UPDATE TOP(0) STAR01.dbo.not_dep
SET co_tran = (
	SELECT ID FROM Profit_XLS.dbo.new_datos_seguro B
	WHERE NDD = STAR01.dbo.not_dep.fact_num
)
WHERE fact_num IN (
	SELECT fact_num FROM Profit_XLS.dbo.new_datos_seguro A
	INNER JOIN STAR01.dbo.not_dep B ON A.NDD = B.fact_num
	WHERE A.ID <> B.co_tran
)
--
SELECT B.* FROM Profit_XLS.dbo.new_datos_seguro A
INNER JOIN STAR01.dbo.not_dep B ON A.NDD = B.fact_num
--
UPDATE TOP(0) SERVICE.dbo.not_dep
SET co_tran = (
	SELECT ID FROM Profit_XLS.dbo.new_datos_seguro B
	WHERE NDD = SERVICE.dbo.not_dep.fact_num
)
WHERE fact_num IN (
	SELECT fact_num FROM Profit_XLS.dbo.new_datos_seguro A
	INNER JOIN SERVICE.dbo.not_dep B ON A.NDD = B.fact_num
	WHERE A.ID <> B.co_tran
)
--
UPDATE TOP(0) STAR01.dbo.not_dep
SET co_tran = (
	SELECT co_tran FROM SERVICE.dbo.not_dep A
	WHERE A.fact_num = STAR01.dbo.not_dep.fact_num
)
WHERE fact_num IN (
	SELECT A.fact_num FROM SERVICE.dbo.not_dep A
	INNER JOIN STAR01.dbo.not_dep B ON A.fact_num = B.fact_num
	WHERE A.co_tran <> B.co_tran
	AND A.fact_num IN (
		5503,5504,5505,5506,5507,5508,5509,5510,5511,5512,
		5513,5514,5515,5516,5517,5518,5519,5520,5521,5522
	)
)
--
SELECT * FROM STAR01.dbo.not_dep WHERE fact_num IN (
	5503,5504,5505,5506,5507,5508,5509,5510,5511,5512,
	5513,5514,5515,5516,5517,5518,5519,5520,5521,5522
)
--
SELECT * FROM SERVICE.dbo.not_dep WHERE fact_num IN (
	5503,5504,5505,5506,5507,5508,5509,5510,5511,5512,
	5513,5514,5515,5516,5517,5518,5519,5520,5521,5522
)
--
USE ELZYRA EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_Vendedores @pGrupo ='Stargas';
USE ELZYRA EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_Vendedores @pGrupo ='Overland';
--
USE ELZYRA EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_VendedoresMix @pGrupo ='Stargas';
USE ELZYRA EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_VendedoresMix @pGrupo ='Overland';