SELECT * FROM proveedor WHERE numid = 40046869;
SELECT * FROM codigos_equivalencias_totalfas;
--
INSERT INTO codigos_equivalencias_totalfas VALUES ('TIPO_PROVEEDOR', '08', '53');
--
SELECT * FROM lval 
WHERE TIPOLVAL LIKE '%TIPOPRVE%'
AND descrip LIKE '%TALLER%';
--
SELECT * FROM tercero WHERE numid = 293771;
SELECT * FROM cliente WHERE numid = 312771283;
SELECT * FROM af_clientes WHERE nu_cedula_rif = 303297595;
--
UPDATE af_clientes 
SET nu_cedula_rif = 31277128
WHERE nu_cedula_rif = 312771283;
--
SELECT * FROM cart_proveedores_servicios 
WHERE caps_nu_cedula_rif = 7019310;
--
SELECT * FROM eq_cart_proveedores_servicios
WHERE caps_cd_proveedor_new = '000540';
--
INSERT INTO eq_cart_proveedores_servicios VALUES(53,null,53, '000540');
--
UPDATE eq_cart_proveedores_servicios 
SET caps_cd_proveedor_new = '00514'
WHERE caps_cd_proveedor_old = 081566;
COMMIT;
--
UPDATE af_ctrl_liquidaciones 
SET af_cjch_st_cheque = null, 
    af_cjeg_st_egreso = null 
WHERE af_sili_sisi_nu_siniestro = 32938219
AND af_cjch_st_cheque = 6 
AND af_cjeg_st_egreso = 6
AND af_sili_nu_liquidacion = 3;
--
SELECT * FROM af_ctrl_liquidaciones
WHERE af_sili_sisi_nu_siniestro = 32948405
AND af_sili_nu_liquidacion = 1;
--
UPDATE af_ctrl_liquidaciones
SET af_status_avisoor = 0, af_cjeg_st_egreso = 7
WHERE af_sili_sisi_nu_siniestro = 32948405
AND af_sili_nu_liquidacion = 1;
COMMIT;
--
SELECT * FROM fact_iva WHERE numero = '2507';
SELECT * FROM poliza WHERE idepol = 193842;
SELECT * FROM af_polizas
WHERE statuspoliza = '11'
AND FECDESPOL >= TO_DATE ('01/01/2013', 'DD/MM/RRRR');
--
UPDATE af_polizas
SET statuspoliza = '1'
WHERE statuspoliza = '11'
AND FECDESPOL >= TO_DATE ('01/01/2013', 'DD/MM/RRRR');
--
SELECT *
FROM af_riesgos_cubiertos
WHERE nu_poliza = 10000119 
AND certificado = 157;
--
SELECT *
FROM af_polizas
WHERE nu_poliza = 1181653 
AND cd_ramo = 0114 
AND nu_certificado = 157;
--
SELECT *
FROM af_recibos
WHERE nu_poliza = 2000176
AND recibo = 349;
--
UPDATE af_recibos
SET statusrecibo = 4
WHERE nu_poliza = 134663
AND cd_sucursal = 010101
AND recibo = 294706;
COMMIT;
--
SELECT * FROM certificado
WHERE idepol = 23501
AND numcert = 2072;
--
SELECT *
FROM causa_sin
WHERE causasin = 'A001';
--
SELECT *
FROM sin_ramo_cert
WHERE idesin = 10230097;
--
SELECT *
FROM sint_causa_siniestros
WHERE sics_cd_causa_siniestro = 'A001';
--
SELECT *
FROM aprob_sin
WHERE idesin = 10251796
AND numliquid = 2;
--
UPDATE aprob_sin
SET tipoaprob = 'P'
WHERE idesin = 10251796
AND numliquid = 2;
COMMIT;
--
SELECT * FROM cart_proveedores_servicios
WHERE caps_nu_cedula_rif = 40046869;
--
SELECT *
FROM af_riesgos_cubiertos
WHERE nu_poliza = 2000118
AND codcobertura = '0104-0001'
AND recibo = 18
AND cd_sucursal = '010101'
AND certificado = 4031;
--
UPDATE af_riesgos_cubiertos 
SET sistema='ACSEL'
WHERE nu_poliza = 2000118
AND cd_sucursal = 020601
AND CD_RAMO = 0100
AND RECIBO = 288232;
COMMIT;
--
UPDATE af_riesgos_cubiertos
SET sumaasegurada = 10
WHERE nu_poliza = 1228347 
AND codcobertura = '0104-0001'
AND recibo=18;
--
SELECT *
FROM af_riesgos_cubiertos
WHERE cod_producto = 'AUTI'
AND status_cobertura = '*'
AND status_recibo_anulado = ' ';
--
UPDATE af_riesgos_cubiertos 
SET status_cobertura = ' ' 
WHERE cod_producto = 'AUTI'
AND status_cobertura = '*'
AND status_recibo_anulado = ' '
COMMIT;
--
UPDATE af_riesgos_cubiertos
SET status_cobertura = ' '
WHERE nu_poliza = 1090799
AND fe_efectiva = TO_DATE ('28/06/2012', 'DD/MM/YYYY');
--
SELECT * FROM det_aprob WHERE ideres = 2866977;
SELECT * FROM cob_res_gen WHERE idesin = 11945573;
SELECT * FROM cob_res_mod WHERE idesin = 15512521;
--
SELECT * FROM sint_reserva_cobertura_certifi
WHERE sicc_sico_sisi_nu_siniestro = 32929711;
--
SELECT * FROM sint_movimientos_coberturas_ce
WHERE smcc_sims_sisi_nu_siniestro = 33910441;
--
SELECT * FROM af_ctrl_reserva_cobertura_cert
WHERE af_sicc_sico_sisi_nu_siniestro = 32940959;
--
SELECT * FROM sint_certificados_siniestros
WHERE sice_sisi_nu_siniestro = 32923593;
--
SELECT * FROM sint_liquidacion_coberturas_ce
WHERE slcc_sili_sisi_nu_siniestro = 32940959;
--
SELECT * FROM sint_siniestros
WHERE sisi_nu_siniestro = 32933853;
--
UPDATE sint_siniestros
SET sisi_fe_ocurrencia = to_date('14/09/2013','DD,MM,RRRR') 
WHERE sisi_nu_siniestro = 32952370;
COMMIT;
--
SELECT * FROM siniestro WHERE numsin = 32946376;
--
SELECT * FROM sint_liquidaciones
WHERE sili_sisi_nu_siniestro = '32945525';
--
SELECT * FROM error_transferencia_totalfast
WHERE descerror || referencia LIKE '%32927104%';
--
UPDATE sint_liquidaciones
SET sili_tp_beneficiario = 'TALL'
WHERE sili_sisi_nu_siniestro = '32952790'
AND SILI_NU_LIQUIDACION = 4;
--
SELECT * FROM fact_iva WHERE numoblig = '37180';
UPDATE fact_iva SET numero = '005249-' WHERE numoblig = '37180';
--
UPDATE sint_liquidaciones
SET aviso_cia = '1'
WHERE sili_sisi_nu_siniestro = '32954013'
AND sili_nu_liquidacion = 1;
--
UPDATE sint_siniestros
SET sisi_fe_ocurrencia = to_date('29/08/2013','DD/MM/YYYY')
WHERE sisi_nu_siniestro = 32950726
AND sisi_casu_cd_sucursal = 020601;
--
UPDATE sint_liquidaciones
SET sili_nu_cedula = 31284982
WHERE sili_sisi_nu_siniestro = '32938629'
AND sili_nu_cedula = 312849827;
COMMIT;
--
UPDATE sint_liquidaciones
SET sili_cjte_cd_ramo = '0101'
WHERE sili_sisi_nu_siniestro = '32954103'
AND sili_nu_liquidacion = 1;
--
SELECT * FROM benef_sin_ramo WHERE codRAMO = '0103';
SELECT * FROM causa_sin WHERE causasin = 'A001';
--
SELECT * FROM eq_sint_causa_siniestros
WHERE Sics_cd_causa_siniestro_new = 'A001';
--
SELECT * FROM polizas_a_transf_totalfast
WHERE idepol = 193365 AND ideop = 1967983;
--
UPDATE polizas_a_transf_totalfast
SET indpoltransf = 'N'
WHERE idepol = 121385
AND ideop = 1967983;
COMMIT;
--
SELECT * FROM sint_liquidaciones
WHERE sili_nu_control_factura IS NULL
AND sili_tp_beneficiario NOT IN ('ASEG', 'TERC')
AND sili_sifi_nu_factura IS NOT NULL;
--
UPDATE sint_liquidaciones
SET sili_nu_control_factura = sili_sifi_nu_factura
WHERE sili_nu_control_factura IS NULL
AND sili_tp_beneficiario NOT IN ('ASEG', 'TERC')
AND sili_sifi_nu_factura IS NOT NULL;
--
UPDATE sint_liquidaciones
SET sili_sifi_nu_factura = sili_nu_control_factura
WHERE sili_sifi_nu_factura IS NULL
AND sili_tp_beneficiario NOT IN ('ASEG', 'TERC');
COMMIT;
--
SELECT * FROM SINT_LIQUIDACIONES
WHERE AVISO_CIA = '1';
--
SELECT COUNT (*) FROM sint_liquidaciones
WHERE sili_fe_factura IS NULL
AND sili_tp_beneficiario NOT IN ('ASEG', 'TERC');
--
UPDATE sint_liquidaciones 
SET sili_fe_factura = SYSDATE
WHERE sili_fe_factura IS NULL 
AND sili_tp_beneficiario NOT INT ('ASEG', 'TERC')
COMMIT;
--
UPDATE sint_liquidaciones
SET sili_nu_cedula = 7589218 
WHERE sili_sisi_nu_siniestro = '32925937'
AND sili_nu_cedula = 75892186
AND sili_dvid = 6;
--
SELECT COUNT (*), TRUNC (a.fecsts)
FROM aprob_sin a, siniestro c, sint_siniestros d
WHERE d.sisi_casu_cd_sucursal = c.codofiemi
AND d.sisi_nu_siniestro = c.numsin
AND c.idesin = a.idesin
AND TRUNC(a.fecsts) = to_date('30/10/2013','dd/mm/rrrr')
AND stsaprob = 'ACT'
GROUP BY TRUNC (a.fecsts);
--
SELECT MAX (a.fecsts)
FROM aprob_sin a, siniestro c, sint_siniestros d
WHERE d.sisi_casu_cd_sucursal = c.codofiemi
AND d.sisi_nu_siniestro = c.numsin
AND c.idesin = a.idesin
AND stsaprob = 'ACT';
--
UPDATE af_riesgos_cubiertos
SET status_cobertura = ' '
WHERE nu_poliza = 1000717 
AND certificado = 25;
--
UPDATE cob_res_mod 
SET stsmodres = 'VAL'
WHERE idesin = 10230097
AND nummodres = 4;
--
SELECT * FROM POLIZAS_A_TRANSF_TOTALFAST
WHERE idepol = 193217 
AND ideop = 7416207;
--
UPDATE POLIZAS_A_TRANSF_TOTALFAST
SET indpoltransf = 'N'
WHERE idepol = 193217
AND ideop = 7416207;
COMMIT;
--
SELECT DISTINCT
    tipoproceso, nomproceso, COUNT (*) AS cantidad
FROM POLIZAS_A_TRANSF_TOTALFAST
WHERE indpoltransf = 'Z'
GROUP BY tipoproceso, nomproceso;
--
SELECT * FROM POLIZAS_A_TRANSF_TOTALFAST
WHERE indpoltransf = 'Z' AND tipoproceso = '1';
--
SELECT * FROM user_scheduler_jobs;
--
BEGIN
    pr_transferencia_acsel.crear_siniestro_numsin ('011201', 32944493);
END;
--
SELECT
    tipoproceso, fecproceso, idepol, numcert, codramocert,
    numrec, fecexc, ideop, idecobert, indpoltransf, nomproceso
FROM POLIZAS_A_TRANSF_TOTALFAST
WHERE NVL (indpoltransf, 'N') = 'N' 
AND tipoproceso NOT IN ('2')
ORDER BY fecproceso;
--
SELECT *
FROM poliza p, cert_veh CV
WHERE CV.idepol = p.idepol
AND p.stspol <> 'VAL'
AND CV.codmarca IS NULL;