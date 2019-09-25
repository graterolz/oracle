SELECT (
	ramo || '-' || poliza || '-' || 
	numrec || ' ' || diasts || '/' || 
	messts || '/' || anosts
) recibo, stssit
FROM HJPF02
WHERE numrec IN (13769153);
--
SELECT * FROM migcartei_nm WHERE numrec IN (13769153);
SELECT * FROM CTRALTAB WHERE ACTIAR = 101;