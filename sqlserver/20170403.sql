EXEC ELZYRA.dbo.pELZ_Comision_Genera @Comision = 1, @Vendedor = '001'
SELECT * FROM STAR01.dbo.docum_cc WHERE nro_doc = 11516
--
UPDATE STAR01.dbo.docum_cc
SET numcon = '00-0050901'
WHERE nro_doc = 11516
AND anulado = 1
--
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME like '%ctr%'
USE ELZYRA EXEC ELZYRA.dbo.pERP_InventarioUnificado @Grupo = 'Stargas', @Almacen = 1, @Tipo = 1
--
SELECT * FROM ELZYRA.dbo.Empresas
SELECT * FROM ELZYRA.dbo.Empresas_OLD WHERE co_empresa = 'STAR01'
--
UPDATE TOP(1) ELZYRA.dbo.Empresas
SET co_tran = (SELECT co_tran FROM ELZYRA.dbo.Empresas_OLD WHERE co_empresa = ELZYRA.dbo.Empresas.base_dato),
	forma_pag = (SELECT forma_pag FROM ELZYRA.dbo.Empresas_OLD WHERE co_empresa = ELZYRA.dbo.Empresas.base_dato),
	moneda = (SELECT moneda FROM ELZYRA.dbo.Empresas_OLD WHERE co_empresa = ELZYRA.dbo.Empresas.base_dato),
	co_sucu = (SELECT co_sucu FROM ELZYRA.dbo.Empresas_OLD WHERE co_empresa = ELZYRA.dbo.Empresas.base_dato),
	nomina = (SELECT nomina FROM ELZYRA.dbo.Empresas_OLD WHERE co_empresa = ELZYRA.dbo.Empresas.base_dato),
	contab = (SELECT contab FROM ELZYRA.dbo.Empresas_OLD WHERE co_empresa = ELZYRA.dbo.Empresas.base_dato),
	proceden = (SELECT proceden FROM ELZYRA.dbo.Empresas_OLD WHERE co_empresa = ELZYRA.dbo.Empresas.base_dato),
	Aj_Entrada = (SELECT Aj_Entrada FROM ELZYRA.dbo.Empresas_OLD WHERE co_empresa = ELZYRA.dbo.Empresas.base_dato),
	Aj_Salida = (SELECT Aj_Salida FROM ELZYRA.dbo.Empresas_OLD WHERE co_empresa = ELZYRA.dbo.Empresas.base_dato),
	Cod_recosteo = (SELECT Cod_recosteo FROM ELZYRA.dbo.Empresas_OLD WHERE co_empresa = ELZYRA.dbo.Empresas.base_dato)
WHERE co_tran IS NULL
--
ALTER TABLE ELZYRA.dbo.Empresas ADD [almacen] [nchar](10) NULL
ALTER TABLE ELZYRA.dbo.Empresas ADD [co_tran] [nchar](10) NULL
ALTER TABLE ELZYRA.dbo.Empresas ADD [forma_pag] [nchar](10) NULL
ALTER TABLE ELZYRA.dbo.Empresas ADD [moneda] [nchar](10) NULL
ALTER TABLE ELZYRA.dbo.Empresas ADD [co_sucu] [nchar](10) NULL
ALTER TABLE ELZYRA.dbo.Empresas ADD [nomina] [nchar](10) NULL
ALTER TABLE ELZYRA.dbo.Empresas ADD [contab] [nchar](10) NULL
ALTER TABLE ELZYRA.dbo.Empresas ADD [proceden] [nchar](10) NULL
ALTER TABLE ELZYRA.dbo.Empresas ADD [Aj_Entrada] [nchar](10) NULL
ALTER TABLE ELZYRA.dbo.Empresas ADD [Aj_Salida] [nchar](10) NULL
ALTER TABLE ELZYRA.dbo.Empresas ADD [Cod_recosteo] [nchar](10) NULL
--
EXEC Profit_RG.dbo.pInventarioUnificado @Grupo = 'STARGAS', @Almacen = '001', @Tipo = 'PS'
EXEC ELZYRA.dbo.pERP_InventarioUnificado @Grupo = 'STARGAS', @Almacen = '001', @Tipo = 'PS'
--
SELECT TOP (1) proceden FROM ELZYRA.dbo.Empresas 
INNER JOIN ELZYRA.dbo.Emp_asoc ON Empresas.base_dato = Emp_asoc.co_empresa COLLATE Modern_Spanish_CI_AS
WHERE grupo='STARGAS'
--
SELECT co_tipo FROM STAR01.dbo.tipo_aju WHERE tipo_trans IN ('E','S')
SELECT * FROM STAR01.dbo.ajuste WHERE anulada = 0 AND ajue_num = 1471
SELECT * FROM STAR01.dbo.reng_aju WHERE ajue_num = 1471