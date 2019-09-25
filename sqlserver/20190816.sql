SELECT * FROM [dbo].[tmp_tb_asientos_autom] WHERE Transacion = '51701000117010001'
SELECT * FROM [dbo].[tmp_v_infoflex_compra_movimiento] WHERE MrcMoreAttributesIntrinsicRelSource = '51701000117010001'
--
SELECT [CodigoFWD],COUNT(*) cantidad
FROM [FWD_BEMEL_MIGRACION].[dbo].[tmp_reglas4_conceptos]
GROUP BY [CodigoFWD]
ORDER BY 2 DESC
--
SELECT [CodigoFWD],COUNT(*) cantidad
FROM [FWD_BEMEL_MIGRACION].[dbo].[tmp_reglas4_conceptos]
WHERE Codigo_CtaCtb = '1330200101'
AND [CodigoFWD] = '#N/A'
--
SELECT DISTINCT Cod_Cuenta_Contable,Codigo_Concepto,descripcion_concepto
FROM [dbo].[tmp_tb_asientos_autom]
WHERE Cod_Cuenta_Contable = '1330200101'
--
SELECT Cod_Cuenta_Contable, Codigo_Concepto, descripcion_concepto --,COUNT(*)
FROM [dbo].[tmp_tb_asientos_autom]
WHERE [tipo_transaccion] = 'FACTURA de Compra'
AND descripcion_concepto = 'DESCARGUE'
GROUP BY Cod_Cuenta_Contable, Codigo_Concepto,descripcion_concepto
ORDER BY 3 DESC
--
SELECt [FWD_BEMEL_MIGRACION].[dbo].[tmp_udfTrim](Concepto)
FROM [FWD_BEMEL_MIGRACION].[dbo].[tmp_reglas4_conceptos] 
WHERE [CodigoFWD] = '0'
--
SELECT *
FROM [FWD_BEMEL_MIGRACION].[dbo].[tmp_reglas4_conceptos] 
WHERE CAST([CodigoFWD]AS VARCHAR) = '0'