SELECT codpol, numpol, codofiemi, codofisusc, idepol,STSPOL
FROM poliza p
WHERE idepol IN (
	SELECT IDEPOL FROM POLIZAS_A_TRANSF_TOTALFAST 
	WHERE TIPOPROCESO = 1 
	AND INDPOLTRANSF = 'S'
)
AND NOT EXISTS (
	SELECT 1 FROM af_polizas afp 
	WHERE afp.cod_producto = p.codpol
	AND SUBSTR (afp.poliza, 1, 6) = p.codofiemi
	AND afp.nu_poliza = p.numpol
	AND (p.CODOFIEMI || p.CODPROD || LPAD (p.NUMPOL, 10, '0')) = afp.poliza
)
AND EXISTS(
	SELECT 1 FROM SINT_CERTIFICADOS_SINIESTROS SCS
	WHERE SCS.SICE_COD_PRODUCTO = P.CODPOL
	AND SCS.SICE_CACE_CASU_CD_SUCURSAL = P.codofisusc
	AND SCS.SICE_CACE_CAPO_NU_POLIZA = P.NUMPOL AND AVISO_CIA = 1
)
ORDER BY 2;
--
SELECT * FROM af_polizas 
WHERE nu_poliza = 2000520 
AND cd_sucursal = '020601';
--
SELECT DISTINCT 
	CODOFIEMI || CODPROD || LPAD (NUMPOL, 10, '0') poliza,
	codpol, numpol, codofiemi, codofisusc, b.*
FROM poliza a, (
	SELECT DISTINCT COD_PRODUCTO, CD_SUCURSAL, NU_POLIZA FROM AF_polizas
	WHERE TO_DATE (fecha_creado, 'DD/MM/RRRR') >= '17/01/2014'
	AND TO_DATE (fecha_creado, 'DD/MM/RRRR') <= '29/01/2014'
) b
WHERE a.codpol = b.cod_producto
AND a.codofiemi = b.cd_sucursal
AND a.numpol = b.nu_poliza
AND a.codofisusc <> b.cd_sucursal;
--
SELECT * FROM SINT_CERTIFICADOS_SINIESTROS
WHERE SICE_CACE_CAPO_NU_POLIZA IN (1182129,1235166,1250751,2000146);
--
SELECT * FROM AF_polizas 
WHERE poliza = '020601AUTI0002001098'
ORDER BY 34;
--
SELECT PR.BUSCA_LVAL ('OFICINAS', '021701') SUCURSAL FROM dual;
--
SELECT * FROM af_polizas
WHERE sucursal <> PR.BUSCA_LVAL ('OFICINAS', cd_sucursal);
--
SELECT * FROM AF_recibos
WHERE nu_poliza = 2000001 
AND recibo = 3 
AND nu_certificado = 22;
--
SELECT * FROM poliza 
WHERE codpol = 'AUTC' 
AND numpol = 2000001;
--
SELECT * FROM recibo
WHERE idepol = 169598 
AND numrec = 3 
AND NUMCERT = 22;
--
SELECT * FROM POLIZAS_A_TRANSF_TOTALFAST 
WHERE idepol = 11475
AND ideop = 6214450;