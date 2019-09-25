SELECT DISTINCT poliza, cd_sucursal, cd_ramo, nu_poliza,
		nu_certificado,cod_producto,sucursal, PR.BUSCA_LVAL ('OFICINAS', cd_sucursal)
FROM af_polizas
WHERE sucursal <> PR.BUSCA_LVAL ('OFICINAS', cd_sucursal)
ORDER BY 1;
--
SELECT * FROM af_polizas afp
WHERE NOT EXISTS(
	SELECT 1 FROM poliza p
	WHERE (p.CODOFIEMI || p.CODPROD || LPAD (p.NUMPOL, 10, '0') = afp.poliza)
);
--
SELECT * FROM af_polizas afp
WHERE NOT EXISTS(
	SELECT 1 FROM af_recibos afr
	WHERE afp.poliza = afr.poliza
	AND afp.nu_poliza = afr.nu_poliza
	AND afp.cd_sucursal = afr.cd_sucursal
);
--
SELECT DISTINCT nu_poliza, recibo
FROM af_recibos afr
WHERE NOT EXISTS(
	SELECT 1 FROM af_riesgos_cubiertos afrc
	WHERE AFRC.POLIZA = AFR.POLIZA
	AND afrc.nu_poliza = afr.nu_poliza
	AND afrc.cd_sucursal = afr.cd_sucursal
	AND afrc.recibo = afr.recibo
	AND AFRC.CD_RAMO = AFR.CD_RAMO
	AND AFRC.NU_CERTIFICADO = AFR.NU_CERTIFICADO)
AND recibo in (13409,98029);
--
SELECT DISTINCT idepol, ideop
FROM POLIZAS_A_TRANSF_TOTALFAST p
WHERE tipoproceso = 1
AND indpoltransf = 'S'
AND NOT EXISTS(
	SELECT * FROM af_polizas
	WHERE cd_sucursal = (SELECT codofisusc FROM poliza WHERE idepol = p.idepol)
	AND cod_producto = (SELECT codpol FROM poliza WHERE idepol = p.idepol)
	AND nu_poliza = (SELECT numpol FROM poliza WHERE idepol = p.idepol)
)
AND EXISTS(
	SELECT 1 FROM poliza pp WHERE pp.idepol = p.idepol
);
--				
UPDATE polizas_a_transf_totalfast p
SET indpoltransf = 'N'
WHERE tipoproceso = 1
AND indpoltransf = 'S'
AND NOT EXISTS(
	SELECT * FROM af_polizas
	WHERE cd_sucursal = (SELECT codofisusc FROM poliza WHERE idepol = p.idepol)
	AND cod_producto = (SELECT codpol FROM poliza WHERE idepol = p.idepol)
	AND nu_poliza = (SELECT numpol FROM poliza WHERE idepol = p.idepol)
)
AND EXISTS(
	SELECT 1 FROM poliza pp WHERE pp.idepol = p.idepol
);