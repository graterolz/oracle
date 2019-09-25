SELECT * FROM Profit_RG.dbo.Metas_Vendedor
WHERE co_ven = '001'
AND DATENAME(YEAR,desde) = '2017'
AND DATENAME(MONTH,desde) = 'Enero';
--
SELECT DISTINCT co_ven,ven_des FROM STAR01.dbo.vendedor WHERE condic=0 and co_ven = '001';
--
SELECT * FROM Profit_RG.dbo.Reclamo_Cliente
ALTER TABLE Profit_RG.dbo.Reclamo_Cliente ADD nombre nchar(50);
ALTER TABLE Profit_RG.dbo.Reclamo_Cliente ADD telefono nchar(50);
ALTER TABLE Profit_RG.dbo.Reclamo_Cliente ADD email nchar(50);
USE Profit_RG; EXEC sp_help 'Reclamo_Cliente';
--
SELECT * FROM Profit_RG.dbo.Reclamo_Cliente WHERE id_reclamo IN (25,26,31)
DELETE FROM Profit_RG.dbo.Reclamo_Cliente WHERE id_reclamo IN (25,26,31)
--
SELECT * FROM Profit_RG.dbo.Reclamo_Accion WHERE id_reclamo IN (25,26,31)
DELETE FROM Profit_RG.dbo.Reclamo_Accion WHERE id_reclamo = 25
--
SELECT * FROM Profit_RG.dbo.Reclamo_Doc_Asoc WHERE id_reclamo = 25
DELETE FROM Profit_RG.dbo.Reclamo_Doc_Asoc WHERE id_reclamo = 25