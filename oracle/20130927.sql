SELECT DISTINCT RAMO, POLIZA, FECINIVIG, FECFINVIG FROM SINIESTROS_MIGRA_REN
WHERE APTO = 'S'
AND SUBSTR (PM.BUSCA_PRODUCTO_PLAN (RAMO, POLIZA, NUMCERT), 1, 4) = 'AUTI'
ORDER BY 2,3,4;
--
SELECT DISTINCT RAMO, POLIZA, FECINIVIG, FECFINVIG FROM SINIESTROS_MIGRA_REN
WHERE RAMO = 32
AND POLIZA = 1193603;
--
SELECT RAMO,POLIZA,DIADES,MESDES,ANODES,DIAHAS,MESHAS,ANOHAS FROM HJPF01_REN
WHERE RAMO = 32
AND POLIZA = 1066033;
--
SELECT * FROM HJPF02_REN WHERE RAMO = 32 AND POLIZA = 1066033;