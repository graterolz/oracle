SELECT CodSistAnterior, COUNT(*) cantidad
FROM [FWD_BEMEL_MIGRACION].[dbo].tmp_v_infoflex_compra_operacion_casos
WHERE src_KERNEL_EntGestion IS NOT NULL
GROUP BY CodSistAnterior
HAVING COUNT(*) > 1
ORDER BY 2 DESC
----------
SELECT *--CodSistAnterior,COUNT(*)
FROM [FWD_BEMEL_MIGRACION].[dbo].[tmp_v_infoflex_compra_operacion]
WHERE CodSistAnterior = '51711000117110152'
----------
SELECT CodSistAnterior,COUNT(*)
FROM [FWD_BEMEL_MIGRACION].[dbo].[tmp_v_infoflex_compra_operacion]
GROUP BY CodSistAnterior
HAVING COUNT(*) > 1
ORDER BY 2 DESC
--
SELECT CUIT,* FROM [dbo].[tmp_tb_asientos_autom]
WHERE Transacion = '51805000118052179'
--
SELECT cuit,* FROM [dbo].Asientos_autom 
WHERE Transacion = '51805000118052179'
--
SELECT *
FROM [FWD_BEMEL_MIGRACION].[dbo].[tmp_v_infoflex_compra_operacion]
WHERE CodSistAnterior = '51805000118052179'
--
SELECT tipo_transaccion,count(*) FROM [dbo].[tmp_tb_asientos_autom] AU
WHERE cuit IS NULL
group by tipo_transaccion
order by 2 desc
--
SELECT *
FROM [FWD_BEMEL_MIGRACION].[dbo].[tmp_reglas2]
WHERE cuit_nuevo IS NOT NULL
AND [accion] IN ('SET-ALL','SET-NIT')
AND cuit_origen = '900.394.396-6'
--
UPDATE [FWD_BEMEL_MIGRACION].[dbo].[tmp_tb_asientos_autom]
SET [Cliente_Prov_Pers] = B.[descripcion_nueva]
FROM [FWD_BEMEL_MIGRACION].[dbo].[tmp_reglas2] B
WHERE [CUIT] = B.[cuit_origen]
AND [cuit_nuevo] IS NOT NULL