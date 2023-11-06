SELECT * FROM op_processes
WHERE corporation = 1
AND group_code = 52
AND process_code = 7;

UPDATE op_processes
SET status = 'NE'
WHERE corporation = 1
AND group_code = 52
AND process_code = 7;
COMMIT;

SELECT * FROM OP_PROCESSES_HISTORY
WHERE group_code = 52 AND process_code = 7
AND execution_date = to_date('fecha','ddmmyyyy');

DELETE OP_PROCESSES_HISTORY
WHERE group_code = 52 AND process_code = 7
AND execution_date = to_date('fecha','ddmmyyyy');
COMMIT;

SELECT * FROM op_processes
WHERE corporation = 1
AND group_code = 52
AND process_code = 7;
--
DELETE FROM requerimientos 
WHERE year(fechaini) = 2012
AND month(fechaini) = 2
AND observaciones <> 'Rutina Automatizada'
AND id_requerimiento in (select id_requerimiento from analistasxrequerimiento)
--
DELETE FROM analistasxrequerimiento
WHERE id_requerimiento IN (SELECT id_requerimiento from #AA)
--
INSERT INTO dbo.BaseDato (Nombre_BD) values ('AmexDB')
INSERT INTO dbo.BaseDato (Nombre_BD) values ('CLAuditoria')
INSERT INTO dbo.BaseDato (Nombre_BD) values ('CorpBanca')
INSERT INTO dbo.BaseDato (Nombre_BD) values ('CorpLine')
INSERT INTO dbo.BaseDato (Nombre_BD) values ('IMOLKO')
INSERT INTO dbo.BaseDato (Nombre_BD) values ('amexclusivas')
--
SELECT
	[servidor],
	COUNT(usuario)
FROM [prueba_restore].[dbo].[tb_repUsuario]
WHERE USUARIO LIKE '%\%'
GROUP BY [servidor]
ORDER BY 1
--
SELECT
	[servidor],
	[usuario]
FROM [prueba_restore].[dbo].[tb_repUsuario]
WHERE USUARIO LIKE '%\%'
--
--
--
UPDATE dbo.Banco
SET Archivo_Saliente = '\\10.0.8.111\truncamiento\CCE_BOD\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set Repositorio_Temporal = '\\10.0.8.111\truncamiento\ARCHIVOS_IMAGENES\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set Repositorio_Imagenes = '\\10.0.8.111\truncamiento\imagenes\0116\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set Archivo_SalienteF = '\\10.0.8.111\truncamiento\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set Servidor_Firmas = '10.0.62.101'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set BD_Firmas = 'fisdb'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set Usuario_Firmas = 'Userfis'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set Password_Firmas = '\u00f2\u0047\u0082\u0047\u0092\u0079\u007e\u008c\u002d\u0096\u0092\u00e9\u003c\u0082\u00c5\u0096'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set UAP_COM = '\172.29.18.3\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set CRA_Local = '\\172.29.18.3\ROOT_SIB\000\CRA\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
SET CRJ_Local = '\\172.29.18.3\ROOT_SIB\000\CRJ\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set CRL_Local = '\\172.29.18.3\ROOT_SIB\000\CRL\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set CRO_Local = '\\172.29.18.3\ROOT_SIB\000\CRO\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set CRX_Local = '\\172.29.18.3\ROOT_SIB\000\CRX\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set IDX_Local = '\\172.29.18.3\ROOT_SIB\000\IDX\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set IDXR_Local = '\\172.29.18.3\ROOT_SIB\000\IDXR\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set IMG_Local = '\\172.29.18.3\ROOT_SIB\000\IMG\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set IMGR_Local = '\\172.29.18.3\ROOT_SIB\000\IMGA\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set INF_Local = '\\172.29.18.3\ROOT_SIB\000\INF\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set INFR_Local = '\\172.29.18.3\ROOT_SIB\000\INFR\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set LOT_Local = '\\172.29.18.3\ROOT_SIB\000\LOT\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set ECHEA_Local = '\\172.29.18.3\ROOT_SIB\ECHEA\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set ORD_Local = '\\172.29.18.3\ROOT_SIB\ORD\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set REP_Local = '\\172.29.18.3\ROOT_SIB\REP\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set STATI_Local = '\\172.29.18.3\ROOT_SIB\STATI\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
set STATO_Local = '\\172.29.18.3\ROOT_SIB\STATO\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
SET SYNTI_Local = '\\172.29.18.3\ROOT_SIB\SYNTI\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
SET SYNTO_Local = '\\172.29.18.3\ROOT_SIB\SYNTO\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
SET SYNTR_Local = '\\172.29.18.3\ROOT_SIB\SYNTR\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
SET Mailo_Local = '\\172.29.18.3\ROOT_SIB\000\IMGR\'
WHERE codigo_banco = '0116'

UPDATE dbo.Banco
SET CRI_Local = '\\172.29.18.3\ROOT_SIB\000\CRI\'
WHERE codigo_banco = '0116'
--