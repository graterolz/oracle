SELECT * FROM COBERT_PLAN_PROD
WHERE CODPROD = 'VMPP';
--
SELECT * FROM LVAL
WHERE TIPOLVAL = 'PARTARIF';
--
INSERT INTO LVAL 
VALUES('PARTARIF','TARVMPP','PROTECCION PERSONAL')