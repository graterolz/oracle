DELETE FROM PRODUCTO_PERSONA WHERE NOT ID_PERSONA IN ('16120321','18808009')
DELETE FROM PERSONA WHERE NOT ID_PERSONA IN ('16120321','18808009')
DELETE FROM PRODUCTO WHERE NOT ID_TITULAR IN ('16120321','18808009')
--
DELETE FROM IMAGEN 
WHERE ID_IMAGEN NOT IN (
	SELECT ID_IMAGEN 
	FROM PRODUCTO_PERSONA 
	WHERE ID_PERSONA IN ('16120321','18808009')
)
--
SELECT * FROM PERSONA 
SELECT * FROM PRODUCTO_PERSONA
SELECT * FROM PRODUCTO
SELECT * FROM IMAGEN
--
--
--
DECLARE @Fec_Ini DATETIME, @Fec_Fin DATETIME

SET @Fec_Ini = '2013-01-01'
SET @Fec_Fin = '2013-02-01'

SELECT DISTINCT
	Rtrim(a.processname) AS PROCESSNAME,
	a.incident,
	a.starttime AS FECHA_INCIDENTE,
	CASE
		WHEN b.status IN ( 1, 13 ) THEN Cast(
		Getdate() - b.starttime AS INT)
	END AS dias,
	b.status,
	db_ultdivisas.dbo.databound.tipo_solic,
	'1' AS CONTEO
FROM ultimus_active.dbo.query_tasks B WITH (nolock)
INNER JOIN ultimus_active.dbo.query_incidents A WITH (nolock) ON b.processname = a.processname AND b.incident = a.incident
LEFT OUTER JOIN db_ultdivisas.dbo.databound WITH (nolock) ON a.processname = db_ultdivisas.dbo.databound.NAME COLLATE sql_latin1_general_cp1_ci_as AND a.incident = db_ultdivisas.dbo.databound.incident
WHERE a.processname IN ( 'Gestion de Divisas_CB' )
AND ( a.starttime BETWEEN @Fec_Ini AND @Fec_Fin )
AND b.steplabel IN ( 'F_Liquidacion GD' ) --and b.status = 3
AND a.status <> 4
--
--
--
DECLARE @Fec_Ini DATETIME, @Fec_Fin DATETIME

SET @Fec_Ini = '2013-01-01'
SET @Fec_Fin = '2013-02-01'


SELECT DISTINCT
	Rtrim(a.processname) AS PROCESSNAME,
	a.incident,
	a.starttime AS FECHA_INCIDENTE,
	CASE
		WHEN b.status IN ( 1, 13 ) THEN Cast(Getdate() - b.starttime AS INT)
	END AS dias,
	(SELECT TOP 1 Min(steplabel)
		FROM ultimus_active.dbo.tasks c WITH (nolock)
		WHERE ( steplabel IN ( 'B_Verificacion GD', 'C_Tramitacion GD')
		AND ( c.processname = b.processname )
		AND c.incident = b.incident )) AS 'ULTIMO',
	'1' AS CONTEO
FROM ultimus_active.dbo.tasks b WITH (nolock)
INNER JOIN ultimus_active.dbo.incidents a WITH (nolock) ON b.processname = a.processname AND b.incident = a.incident
LEFT OUTER JOIN ultcreditos.dbo.tbl_databound WITH (nolock) ON a.processname = ultcreditos.dbo.tbl_databound.NAME AND a.incident = ultcreditos.dbo.tbl_databound.incident
LEFT OUTER JOIN db_credito.dbo.tbl_databound WITH (nolock) ON a.processname = db_credito.dbo.tbl_databound.NAME COLLATE sql_latin1_general_cp1_ci_as AND a.incident = db_credito.dbo.tbl_databound.incident
WHERE a.processname IN ( 'Gestion de Divisas_CB' )
AND ( a.starttime BETWEEN @Fec_Ini AND @Fec_Fin )
AND b.steplabel IN ( 'A_Solicitud GD' ) --and b.status = 3
AND a.status <> 4
UNION
SELECT DISTINCT
	Rtrim(a.processname) AS PROCESSNAME,
	a.incident,
	a.starttime AS FECHA_INCIDENTE,
	CASE
		WHEN b.status IN ( 1, 13 ) THEN Cast(Getdate() - b.starttime AS INT)
	END AS dias,
	(SELECT TOP 1 Min(steplabel)
		FROM ultimus_history.dbo.tasks c WITH (nolock)
		WHERE ( steplabel IN ( 'B_Verificacion GD', 'C_Tramitacion GD' )
		AND ( c.processname = b.processname )
		AND c.incident = b.incident )) AS 'ULTIMO',
		'1' AS CONTEO
FROM ultimus_history.dbo.tasks b WITH (nolock)
INNER JOIN ultimus_history.dbo.incidents a WITH (nolock) ON b.processname = a.processname AND b.incident = a.incident
LEFT OUTER JOIN ultcreditos.dbo.tbl_databound WITH (nolock) ON a.processname = ultcreditos.dbo.tbl_databound.NAME AND a.incident = ultcreditos.dbo.tbl_databound.incident
LEFT OUTER JOIN db_credito.dbo.tbl_databound WITH (nolock) ON a.processname = db_credito.dbo.tbl_databound.NAME COLLATE sql_latin1_general_cp1_ci_as AND a.incident = db_credito.dbo.tbl_databound.incident
WHERE ( a.processname IN ( 'Gestion de Divisas_CB' ) )
AND ( a.starttime BETWEEN @Fec_Ini AND @Fec_Fin )
AND b.steplabel IN ( 'A_Solicitud GD' )-- and b.status = 3
AND a.status <> 4
--
--
--
DECLARE @Fec_Ini DATETIME, @Fec_Fin DATETIME

SET @Fec_Ini = '2013-01-01'
SET @Fec_Fin = '2013-02-01'

--select @Fec_Fin
SELECT DISTINCT
	Rtrim(a.processname) AS PROCESSNAME,
	a.incident,
	a.starttime AS FECHA_INCIDENTE,
	B.starttime AS STARTTIME_PASO,
	CASE
		WHEN b.status IN ( 1, 13 ) THEN Cast(Getdate() - b.starttime AS INT)
	END AS dias,
	b.steplabel,
	b.status
FROM ultimus_active.dbo.tasks b WITH (nolock)
INNER JOIN ultimus_active.dbo.incidents a WITH (nolock) ON b.processname = a.processname AND b.incident = a.incident
LEFT OUTER JOIN ultcreditos.dbo.tbl_databound WITH (nolock) ON a.processname = ultcreditos.dbo.tbl_databound.NAME AND a.incident = ultcreditos.dbo.tbl_databound.incident
LEFT OUTER JOIN db_credito.dbo.tbl_databound WITH (nolock) ON a.processname = db_credito.dbo.tbl_databound.NAME COLLATE sql_latin1_general_cp1_ci_as AND a.incident = db_credito.dbo.tbl_databound.incident
WHERE ( a.processname IN ( 'Gestion de Divisas_CB' ) )
AND ( a.starttime BETWEEN @Fec_Ini AND @Fec_Fin )
AND b.status IN ( 1, 13 )
AND a.status <> 4
--
--
--
DECLARE @Fec_Ini DATETIME, @Fec_Fin DATETIME, @procesos NVARCHAR

SET @Fec_Ini = '2013-01-01'
SET @Fec_Fin = '2013-02-01'

SELECT
	Rtrim(a.processname) AS PROCESSNAME,
	a.incident,
	a.starttime AS FECHA_INCIDENTE,
	a.endtime,
	Rtrim(a.initiator) AS INITIATOR,
	'1'
FROM ultcreditos.dbo.tbl_solicitudes
INNER JOIN ultcreditos.dbo.tbl_databound ON ultcreditos.dbo.tbl_solicitudes.id_sl = ultcreditos.dbo.tbl_databound.id_sl
INNER JOIN ultcreditos.dbo.tbl_clientes ON ultcreditos.dbo.tbl_solicitudes.id_cl = ultcreditos.dbo.tbl_clientes.id_cl
RIGHT OUTER JOIN ultimus_active.dbo.incidents a ON ultcreditos.dbo.tbl_databound.NAME = a.processname AND ultcreditos.dbo.tbl_databound.incident = a.incident
LEFT OUTER JOIN db_credito.dbo.tbl_databound ON a.processname = db_credito.dbo.tbl_databound.NAME COLLATE sql_latin1_general_cp1_ci_as AND a.incident = db_credito.dbo.tbl_databound.incident
LEFT OUTER JOIN db_credito.dbo.cliente ON db_credito.dbo.tbl_databound.cedula = db_credito.dbo.cliente.num_identificacion
WHERE ( a.processname IN ( 'Gestion de Divisas_CB' ) )
AND ( a.starttime BETWEEN @Fec_Ini AND @Fec_Fin )
UNION
SELECT
	Rtrim(a.processname) AS PROCESSNAME,
	a.incident,
	a.starttime AS FECHA_INCIDENTE,
	a.endtime,
	Rtrim(a.initiator),
	'1' AS INITIATOR
FROM ultcreditos.dbo.tbl_solicitudes
INNER JOIN ultcreditos.dbo.tbl_databound ON ultcreditos.dbo.tbl_solicitudes.id_sl = ultcreditos.dbo.tbl_databound.id_sl
INNER JOIN ultcreditos.dbo.tbl_clientes ON ultcreditos.dbo.tbl_solicitudes.id_cl = ultcreditos.dbo.tbl_clientes.id_cl
RIGHT OUTER JOIN ultimus_history.dbo.incidents a ON ultcreditos.dbo.tbl_databound.NAME = a.processname AND ultcreditos.dbo.tbl_databound.incident = a.incident
LEFT OUTER JOIN db_credito.dbo.tbl_databound ON a.processname = db_credito.dbo.tbl_databound.NAME COLLATE sql_latin1_general_cp1_ci_as AND a.incident = db_credito.dbo.tbl_databound.incident
LEFT OUTER JOIN db_credito.dbo.cliente ON db_credito.dbo.tbl_databound.cedula = db_credito.dbo.cliente.num_identificacion
WHERE ( a.processname IN ( 'Gestion de Divisas_CB' ) )
AND ( a.starttime BETWEEN @Fec_Ini AND @Fec_Fin )
--
--
--
SELECT
	transaction_id,
	identity_code,
	customer_id,
	To_char(process_date, 'dd/mm/yyyy hh24:mi:ss') process_date,
	user_id,
	error_text,
	module,
	subprogram,
	oratext,
	outcome
FROM transaction_log
WHERE Trunc(process_date) = '06/11/2012'
ORDER BY process_date ASC;
--
SELECT Count(*) --transaction_id PROCESO, count(transaction_id)
FROM transaction_log
WHERE Trunc(process_date) = '06/11/2012'
AND transaction_id IN (
	'CARGA', 'VAL', 'DDB', 'MDB',
	'ADB', 'ADDREL', 'APY', 'DAC',
	'DSU', 'UPDCOUNTERS', 'DSTALL', 'DDB',
	'AST', 'IWK', 'WORKLIST', 'WKLST_EQUI'
)
GROUP BY transaction_id;
--
SELECT
	transaction_id PROCESO,
	customer_id DETALLE,
	To_char(process_date, 'dd/mm/yyyy') FECHA,
	To_char(process_date, 'hh24:mi:ss') HORA,
	error_text,
	module,
	subprogram,
	oracode,
	oratext
FROM transaction_log
WHERE Trunc(process_date) = '06/11/2012'
AND transaction_id IN (
	'CARGA', 'VAL', 'DDB', 'MDB',
	'ADB', 'ADDREL', 'APY', 'DAC',
	'DSU', 'UPDCOUNTERS', 'DSTALL', 'DDB',
	'AST', 'IWK', 'WORKLIST', 'WKLST_EQUI'
)
ORDER BY process_date ASC;
--
--
--
declare @ip1_1       as varchar(12)
declare @ip1_2       as varchar(12)
declare @ip1_3       as varchar(12)
declare @ip1_4       as varchar(12)
declare @servername1 as varchar(12)
  
declare @ip2_1       as varchar(12)
declare @ip2_2       as varchar(12)
declare @ip2_3       as varchar(12)
declare @ip2_4       as varchar(12)
declare @servername2 as varchar(12)

--Ip bodstratus1
set @ip1_1 ='10.0.34.110'  
set @ip1_2 ='10.0.34.111'
set @ip1_3 ='10.0.34.112'
set @ip1_4 ='10.0.34.113'
set @servername1 ='Bodstratus1'

--IpBodstratus2
set @ip2_1 ='10.6.30.20'
set @ip2_2 ='10.6.30.22'
set @ip2_3 ='10.6.30.23'
set @ip2_4 ='Bodstratus2'
set @servername2 ='Bodstratus2'

UPDATE postilion.dbo.task SET host= @servername2 WHERE host= @servername1
UPDATE postilion.dbo.task SET host= @ip2_1 WHERE host= @ip1_1
UPDATE postilion.dbo.task SET host= @ip2_2 WHERE host= @ip1_2
UPDATE postilion.dbo.task SET host= @ip2_3 WHERE host= @ip1_3
UPDATE postilion.dbo.task SET host= @ip2_4 WHERE host= @ip1_4
--
--
--
declare @ip1_1 as varchar(12)
declare @ip1_2 as varchar(12)
declare @ip1_3 as varchar(12)
declare @ip1_4 as varchar(12)
declare @servername1 as varchar(12)
  
declare @ip2_1 as varchar(12)
declare @ip2_2 as varchar(12)
declare @ip2_3 as varchar(12)
declare @ip2_4 as varchar(12)
declare @servername2 as varchar(12)

--Ip bodstratus1
set @ip1_1 ='10.0.34.110'
set @ip1_2 ='10.0.34.111'
set @ip1_3 ='10.0.34.112'
set @ip1_4 ='10.0.34.113'
set @servername1 ='Bodstratus1'

--IpBodstratus2
set @ip2_1 ='10.6.30.20'
set @ip2_2 ='10.6.30.22'
set @ip2_3 ='10.6.30.23'
set @ip2_4 ='Bodstratus2'
set @servername2 ='Bodstratus2'

update postilion.dbo.node_saps set [address] = @servername2
where [address] = @servername1

update postilion.dbo.node_saps set [address] = @ip2_1+','+SUBSTRING([address],CHARINDEX(',',[address])+1,len([address])-CHARINDEX(',',[address])) 
where SUBSTRING ( [address] ,0 , len(address)-(len(address)-CHARINDEX(',',[address]) )) = @ip1_1

update postilion.dbo.node_saps set [address] = @ip2_2+','+SUBSTRING([address],CHARINDEX(',',[address])+1,len([address])-CHARINDEX(',',[address])) 
where SUBSTRING ( [address] ,0 , len(address)-(len(address)-CHARINDEX(',',[address]) )) = @ip1_2

update postilion.dbo.node_saps set [address] = @ip2_3+','+SUBSTRING([address],CHARINDEX(',',[address])+1,len([address])-CHARINDEX(',',[address]))
where SUBSTRING ( [address] ,0 , len(address)-(len(address)-CHARINDEX(',',[address]) )) = @ip1_3

update postilion.dbo.node_saps set [address] = @ip2_2+','+SUBSTRING([address],CHARINDEX(',',[address])+1,len([address])-CHARINDEX(',',[address])) 
where SUBSTRING ( [address] ,0 , len(address)-(len(address)-CHARINDEX(',',[address]) )) = @ip1_2

update postilion.dbo.node_saps set [address] = @ip2_3+','+SUBSTRING([address],CHARINDEX(',',[address])+1,len([address])-CHARINDEX(',',[address])) 
where SUBSTRING ( [address] ,0 , len(address)-(len(address)-CHARINDEX(',',[address]) )) = @ip1_3

update postilion.dbo.node_saps set [address] = @ip2_4 
where SUBSTRING ([address] ,0 , len(address)-(len(address)-CHARINDEX(',',[address]) )) = @ip1_4
--
--
--
SELECT * FROM [dbo].[GenParametrizacion] where Valor like '%Sief_MSA_%'
SELECT * FROM [dbo].[GenParametrizacion] where Parametro = 'DefaultProductionDatabaseName'
SELECT * FROM [dbo].GenParametrizacion where Parametro like 'ReportServer'
SELECT * FROM [dbo].GenParametrizacion where Parametro like '%ExportSettings.ReportServer%'
SELECT * FROM [dbo].secUsuarios
SELECT * FROM [dbo].GenUsuariosMail
--
UPDATE [dbo].[GenParametrizacion] set Valor = 'http://mectronics.com.co/ReportServer_SIEFMEC/Pages/ReportViewer.aspx?' where Parametro like 'ReportServer'
UPDATE [dbo].[GenParametrizacion] set Valor = 'SIEF_MSA_Pre' where Parametro = 'DefaultProductionDatabaseName'
UPDATE [dbo].[GenParametrizacion] set Valor = 'http://mectronics.com.co/ReportServer_SIEFMEC' where Parametro like '%ExportSettings.ReportServer%'
UPDATE [dbo].[GenParametrizacion] set valor = REPLACE(valor, '/Sief_MSA_Pro/', '/Sief_MSA_Pre/') where Valor like '%Sief_MSA_%'
UPDATE [dbo].[secUsuarios] set email = 'soportemsa@mectronics.co', Password = 'sgnevoy5D+/57YtwFyE3gA=='
UPDATE [dbo].[genbodegas] SET NomBodega = 'PRUEBAS '+NomBodega
UPDATE [dbo].[GenUsuariosMail] set mail = 'soportemsa@mectronics.co'
UPDATE [dbo].[Bodega] SET bodeganombre = 'PRUEBAS '+bodeganombre
--
UPDATE  Operaciones360.ProcesosMasivos.ProcesoMasivo 
SET ProcesoMasivoParametros = '<ProcesoMasivo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <Id>0</Id>
  <ProcesoMasivoNumeroHilo>1</ProcesoMasivoNumeroHilo>
  <ProcesoMasivoFechaInicio>2021-07-21T08:00:00.8050838-05:00</ProcesoMasivoFechaInicio>
  <ProcesoMasivoFechaFin xsi:nil="true" />
  <ProcesoMasivoFechaActualizacion>2021-06-24T08:00:00.8040824-05:00</ProcesoMasivoFechaActualizacion>
  <ProcesoMasivoTipo>Gestor.Procesos.NotificacionHistoricoDescargaRobotWeb</ProcesoMasivoTipo>
  <ProcesoMasivoParametros>
						&lt;?xml version="1.0" encoding="utf-16"?&gt;
					 &lt;ArrayOfParametrosProcesoMasivo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"&gt;
					 &lt;ParametrosProcesoMasivo&gt;
					 &lt;ParametrosProcesoMasivoNumero&gt;0&lt;/ParametrosProcesoMasivoNumero&gt;
					 &lt;ClaseEjecutable&gt;Gestor.Procesos.NotificacionHistoricoDescargaRobotWeb&lt;/ClaseEjecutable&gt;
					 &lt;/ParametrosProcesoMasivo&gt;
					 &lt;/ArrayOfParametrosProcesoMasivo&gt;
					 </ProcesoMasivoParametros>
  <ProcesoMasivoError>-</ProcesoMasivoError>
  <ProcesoMasivoDefinitivo>true</ProcesoMasivoDefinitivo>
  <EstadoProcesoMasivoId>2</EstadoProcesoMasivoId>
  <TipoProcesoMasivoId>40</TipoProcesoMasivoId>
  <UsuarioId>1</UsuarioId>
  <ProcesoMasivoCiclico>false</ProcesoMasivoCiclico>
</ProcesoMasivo>',ProcesoMasivoCiclico = 0
WHERE ProcesoMasivoId = 105029
--
--
--
declare @ip1_1 as varchar(22)  
declare @ip1_2 as varchar(22)
declare @ip2_1 as varchar(22)
declare @ip2_2 as varchar(22)

--Ip 1 As400 principal
set @ip1_1 ='10.0.34.11'
set @ip1_2 ='10.0.34.12'

--Ip 2 As400 Centro Alterno
set @ip2_1 ='10.6.236.20'
set @ip2_2 ='10.6.236.20'

update postilion.dbo.node_conns
set   [address] = @ip2_1+','+SUBSTRING([address],CHARINDEX(',',[address])+1,len([address])-CHARINDEX(',',[address])) 
where SUBSTRING ( [address] ,0 , len(address)-(len(address)-CHARINDEX(',',[address]) )) = @ip1_1

update postilion.dbo.node_conns
set   [address] = @ip2_2+','+SUBSTRING([address],CHARINDEX(',',[address])+1,len([address])-CHARINDEX(',',[address])) 
where SUBSTRING ( [address] ,0 , len(address)-(len(address)-CHARINDEX(',',[address]) )) = @ip1_2
--
--
--
UPDATE SEIF_LOCAL.dbo.GenParametrizacion
SET Valor = '1.58'
WHERE Parametro = 'Version BD'
--
SELECT * FROM SEIF_LOCAL.dbo.GenParametrizacion
WHERE Parametro = 'Version BD'
--
USE master
GO
BACKUP DATABASE Operaciones360
TO  DISK = N'E:\Backup\Operaciones360_2021-08-17.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'Operaciones360 Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 5
GO
--
--
--
USE master
GO
BACKUP DATABASE Sie7e
TO  DISK = N'E:\Backup\Sie7e_2021-08-17.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'Sie7e Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 5
GO
--
--
--
USE master
GO
BACKUP DATABASE SIEF_CEXP
TO  DISK = N'E:\Backup\SIEF_CEXP_2021-08-17.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'SIEF_CEXP Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 5
GO
--
--
--
ALTER TABLE [BEMEL_ENS_CARGUEBL_BUILD_APP_TX].[BEMEL].[BK_HBLS] ADD [date_create] DATETIME
ALTER TABLE [BEMEL_ENS_CARGUEBL_BUILD_APP_TX].[BEMEL].[BK_DET_HBLS] ADD [date_create] DATETIME
--
--
--
DECLARE @Fec_Ini datetime, @Fec_Fin datetime

set @Fec_Ini = '2013-01-01'
set @Fec_Fin = '2013-02-01'

SELECT DISTINCT
	RTRIM(a.PROCESSNAME) AS PROCESSNAME,
	a.INCIDENT, 
	a.STARTTIME AS FECHA_INCIDENTE,
	a.endtime AS FECHA_ABORTADO_INCIDENTE,
	b.steplabel,
	'1'
FROM ULTIMUS_ACTIVE.dbo.TASKS b WITH (nolock)
INNER JOIN ULTIMUS_ACTIVE.dbo.INCIDENTS a WITH (nolock)  ON b.PROCESSNAME = a.PROCESSNAME AND b.INCIDENT = a.INCIDENT
LEFT OUTER JOIN UltCreditos.dbo.tbl_DATABOUND WITH (nolock) ON a.PROCESSNAME = UltCreditos.dbo.tbl_DATABOUND.NAME AND a.INCIDENT = UltCreditos.dbo.tbl_DATABOUND.INCIDENT
LEFT OUTER JOIN db_credito.dbo.tbl_databound WITH (nolock) ON a.PROCESSNAME = db_credito.dbo.tbl_databound.NAME COLLATE SQL_Latin1_General_CP1_CI_AS AND a.INCIDENT = db_credito.dbo.tbl_databound.INCIDENT
WHERE (a.PROCESSNAME IN ('Gestion de Divisas_CB'))
AND (a.STARTTIME BETWEEN @Fec_Ini AND @Fec_Fin)
AND a.status = 4
UNION
SELECT DISTINCT
	RTRIM(a.PROCESSNAME) AS PROCESSNAME,
	a.INCIDENT,
	a.STARTTIME AS FECHA_INCIDENTE,
	a.endtime AS FECHA_ABORTADO_INCIDENTE,
	b.steplabel,
	'1'
FROM ULTIMUS_HISTORY.dbo.TASKS b WITH (nolock)
INNER JOIN ULTIMUS_HISTORY.dbo.INCIDENTS a WITH (nolock)  ON b.PROCESSNAME = a.PROCESSNAME AND b.INCIDENT = a.INCIDENT
LEFT OUTER JOIN UltCreditos.dbo.tbl_DATABOUND WITH (nolock) ON a.PROCESSNAME = UltCreditos.dbo.tbl_DATABOUND.NAME AND a.INCIDENT = UltCreditos.dbo.tbl_DATABOUND.INCIDENT
LEFT OUTER JOIN db_credito.dbo.tbl_databound WITH (nolock) ON a.PROCESSNAME = db_credito.dbo.tbl_databound.NAME COLLATE SQL_Latin1_General_CP1_CI_AS AND a.INCIDENT = db_credito.dbo.tbl_databound.INCIDENT
WHERE (a.PROCESSNAME IN ('Gestion de Divisas_CB'))
AND (a.STARTTIME BETWEEN @Fec_Ini AND @Fec_Fin)
AND a.status = 4
--
--
--
UPDATE dbo.Banco 
SET Maximo_Usuarios_Zeus=15000, 
    Maximo_Usuarios_Zeus_Concurrente=15000,
    Maximo_Usuarios_Urano=15000,
    Maximo_Usuarios_Urano_Concurrente=15000
--
UPDATE dbo.Usuario
SET Login_Usuario = 'master', 
	Nombre_Usuario = 'master',
    Codigo_Perfil_Usuario = 4
WHERE Login_Usuario = '<COLOCAR LOGIN USUARIO>'
--
INSERT INTO dbo.patron values('Cheques',1,1, '2008-09-04 00:00:00.000', NULL, 1, 0)
--
INSERT INTO dbo.tipodato values ('Entero')
INSERT INTO dbo.tipodato values ('Decimal')
INSERT INTO dbo.tipodato values ('Moneda')
INSERT INTO dbo.tipodato values ('String Numerico')
INSERT INTO dbo.tipodato values ('String Alfabetico')
INSERT INTO dbo.tipodato values ('String Alfanumerico')
--
INSERT INTO dbo.tipodocumento values (1,'','C')
INSERT INTO dbo.tipodocumento values (90,'','D')
INSERT INTO dbo.tipodocumento values (92,'','D')
INSERT INTO dbo.tipodocumento values (96,'','D')
--
INSERT INTO dbo.campo values ('Serial','Serial',8,0,'',400,150,0,150,'2008-09-04 00:00:00.000',null,1,1,0,1,'c','e',1,4,'')
INSERT INTO dbo.campo values ('Banco Endoso','BancoE',4,8,'%CCCE%[0,4]',360,240,590,150,'2008-09-04 00:00:00.000',null,0,0,0,0,'q','w',1,4,'')
INSERT INTO dbo.campo values ('Banco Cheque','Banco',4,1,'',0,100,0,100,'2008-09-04 00:00:00.000',null,1,1,0,0,'e','c',1,4,'')
INSERT INTO dbo.campo values ('Oficina Endoso','OficinaE',4,9,'%CCCE%[4,4]',480,240,590,150,'2008-09-04 00:00:00.000',null,0,0,0,0,'t','r',1,4,'')
INSERT INTO dbo.campo values ('Oficina Cheque','Oficina',4,2,'',30,100,0,100,'2008-09-04 00:00:00.000',null,1,1,0,0,'c','e',1,4,'')
INSERT INTO dbo.campo values ('Digito Chequeo','DC',2,3,'',70,100,0,100,'2008-09-04 00:00:00.000',null,1,1,0,0,'e','e',1,4,'')
INSERT INTO dbo.campo values ('Cuenta','Cuenta',10,4,'',110,100,0,100,'2008-09-04 00:00:00.000',null,1,1,0,0,'e','a',1,4,'')
INSERT INTO dbo.campo values ('Monto','Monto',14,6,'',570,370,0,150,'2008-09-04 00:00:00.000',null,1,1,0,0,'a','b',1,3,'')
INSERT INTO dbo.campo values ('TipoDocumento','TipoDoc',2,5,'',490,100,270,100,'2008-09-04 00:00:00.000',null,1,1,0,0,'a','a',1,4,'')
INSERT INTO dbo.campo values ('Codigo Cuenta Cliente','CCC',20,7,'%Banco%&%Oficina%&%DC%&%Cuenta%',20,200,0,150,'2008-09-04 00:00:00.000',null,1,0,0,1,'','',1,4,'')
INSERT INTO dbo.campo values ('Codigo Cuenta Cliente Endoso','CCCE',20,10,'',150,370,270,300,'2008-09-04 00:00:00.000',null,1,1,0,0,'','',1,4,'')
--
INSERT INTO dbo.campotipodoc values(9,1)
INSERT INTO dbo.campotipodoc values(9,90)
INSERT INTO dbo.campotipodoc values(9,92)
INSERT INTO dbo.campotipodoc values(9,96)
--
INSERT INTO dbo.validador values ('ValidacionCCC')
INSERT INTO dbo.campovalidador values(10,1)
INSERT INTO dbo.escaner values('Unisys SmartSource ProSeries')
--
INSERT INTO dbo.propiedad values('MICRFont')
INSERT INTO dbo.propiedad values('Formato')
INSERT INTO dbo.propiedad values('Resolucion')
INSERT INTO dbo.propiedad values('Caras')
INSERT INTO dbo.propiedad values('Contraste')
INSERT INTO dbo.propiedad values('Brillo')
--
INSERT INTO dbo.escanerpropiedad values('CMC7',0,1,1,1)
INSERT INTO dbo.escanerpropiedad values('E13B',1,0,1,1)
INSERT INTO dbo.escanerpropiedad values('100*100',0,0,1,3)
INSERT INTO dbo.escanerpropiedad values('200*200',1,1,1,3)
INSERT INTO dbo.escanerpropiedad values('200*100',3,0,1,3)
INSERT INTO dbo.escanerpropiedad values('200*100 Fast',2,0,1,3)
INSERT INTO dbo.escanerpropiedad values('Anverso',1,0,1,4)
INSERT INTO dbo.escanerpropiedad values('Reverso',2,0,1,4)
INSERT INTO dbo.escanerpropiedad values('Ambas',3,1,1,4)
INSERT INTO dbo.escanerpropiedad values('Contraste Maximo',100,0,1,5)
INSERT INTO dbo.escanerpropiedad values('Contraste Minimo',0,0,1,5)
INSERT INTO dbo.escanerpropiedad values('Contraste',50,1,1,5)
INSERT INTO dbo.escanerpropiedad values('Brillo Maximo',100,0,1,6)
INSERT INTO dbo.escanerpropiedad values('Brillo Minimo',0,0,1,6)
INSERT INTO dbo.escanerpropiedad values('Brillo',50,1,1,6)
INSERT INTO dbo.escanerpropiedad values('TIFF B/W',1,0,1,2)
INSERT INTO dbo.escanerpropiedad values('BMP Color',2,0,1,2)
INSERT INTO dbo.escanerpropiedad values('JPEG Gray Scale 16',4,1,1,2)
INSERT INTO dbo.escanerpropiedad values('JPEG Gray Scale 256',4,0,1,2)
INSERT INTO dbo.escanerpropiedad values('JPEG Color',4,0,1,2)
--
INSERT INTO dbo.accion values('ELIMINAR','LOTE')
INSERT INTO dbo.accion values('RESTAURAR','LOTE')
INSERT INTO dbo.accion values('APROBAR','LOTE')
INSERT INTO dbo.accion values('ELIMINAR','DOCUMENTO')
INSERT INTO dbo.accion values('RESTAURAR','DOCUMENTO')
INSERT INTO dbo.accion values('APROBAR','DOCUMENTO')
INSERT INTO dbo.accion values('REEMPLAZARIMAGEN','DOCUMENTO')
INSERT INTO dbo.accion values('MODIFICAR','DOCUMENTOVALOR')
INSERT INTO dbo.accion values('CREAR','LOTE')
--
INSERT INTO dbo.accionsistema values('INGRESAR SISTEMA')
INSERT INTO dbo.accionsistema values('SALIR SISTEMA')
--
INSERT INTO [dbo].[propiedad] ([id_propiedad],[nombre_propiedad]) VALUES (21 ,'tiempoEsperaErrorConexion')
INSERT INTO [dbo].[propiedad] ([id_propiedad],[nombre_propiedad]) VALUES (22 ,'identificadorNodo')
INSERT INTO [dbo].[propiedad] ([id_propiedad],[nombre_propiedad]) VALUES (23 ,'tamanoPedazos')
INSERT INTO [dbo].[propiedad] ([id_propiedad],[nombre_propiedad]) VALUES (24 ,'tiempoEntrePedazos')
INSERT INTO [dbo].[propiedad] ([id_propiedad],[nombre_propiedad]) VALUES (25 ,'encriptado')
INSERT INTO [dbo].[propiedad] ([id_propiedad],[nombre_propiedad]) VALUES (26 ,'numeroDeRepasos')
INSERT INTO [dbo].[propiedad] ([id_propiedad],[nombre_propiedad]) VALUES (27 ,'gatillo')
INSERT INTO [dbo].[propiedad] ([id_propiedad],[nombre_propiedad]) VALUES (28 ,'excluirExtensiones')
INSERT INTO [dbo].[propiedad] ([id_propiedad],[nombre_propiedad]) VALUES (29 ,'tiempoEntreBusqueda')
INSERT INTO [dbo].[propiedad] ([id_propiedad],[nombre_propiedad]) VALUES (210 ,'prioridadDeExtensiones')
INSERT INTO [dbo].[propiedad] ([id_propiedad],[nombre_propiedad]) VALUES (211,'numeroDeHilos')
INSERT INTO [dbo].[propiedad] ([id_propiedad],[nombre_propiedad]) VALUES (212 ,'numeroDeReintentos')
--
INSERT INTO [dbo].[categoria] ([id_categoria],[nombre_categoria],[id_padre_categoria],[tipo_categoria]) VALUES (1,'BOD',1,'Oficinas')
--
DECLARE @ns varchar(10)
DECLARE @cod varchar (4)
DECLARE @query varchar (5000)
--
SELECT @ns = @@servername
SELECT @cod = '1' + Right(@ns, len(@ns) - 4)

SET identity_insert nodo on;
INSERT INTO apoloDB.dbo.nodo (idnodo, nombre) values (@cod, @cod)
SET identity_insert nodo off;
--
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3312,'3312')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3313,'3313')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3315,'3315')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3322,'3322')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3209,'3209')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3346,'3346')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3323,'3323')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3317,'3317')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3594,'3594')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3331,'3331')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3349,'3349')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3321,'3321')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3214,'3214')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3334,'3334')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3100,'3100')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3101,'3101')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3102,'3102')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3104,'3104')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3106,'3106')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3108,'3108')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3109,'3109')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3110,'3110')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3111,'3111')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3112,'3112')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3113,'3113')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3114,'3114')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3116,'3116')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3117,'3117')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3118,'3118')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3122,'3122')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3123,'3123')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3127,'3127')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3130,'3130')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3132,'3132')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3134,'3134')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3138,'3138')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3140,'3140')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3142,'3142')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3144,'3144')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3147,'3147')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3148,'3148')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3149,'3149')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3150,'3150')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3151,'3151')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3152,'3152')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3153,'3153')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3160,'3160')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3161,'3161')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3163,'3163')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3165,'3165')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3166,'3166')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3175,'3175')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3190,'3190')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3783,'3783')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3128,'3128')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3131,'3131')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3258,'3258')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3168,'3168')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3170,'3170')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3126,'3126')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3155,'3155')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3750,'3750')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3121,'3121')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3506,'3506')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3141,'3141')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3350,'3350')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3710,'3710')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3115,'3115')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3719,'3719')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3737,'3737')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3162,'3162')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3738,'3738')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3725,'3725')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3129,'3129')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3708,'3708')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3169,'3169')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3705,'3705')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3731,'3731')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3713,'3713')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3723,'3723')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3716,'3716')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3135,'3135')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3137,'3137')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3143,'3143')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3310,'3310')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3305,'3305')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3202,'3202')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3224,'3224')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3219,'3219')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3206,'3206')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3200,'3200')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3216,'3216')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3223,'3223')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3204,'3204')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3208,'3208')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3220,'3220')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3784,'3784')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3221,'3221')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3207,'3207')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3210,'3210')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3211,'3211')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3316,'3316')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3330,'3330')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3544,'3544')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3300,'3300')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3301,'3301')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3302,'3302')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3303,'3303')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3304,'3304')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3309,'3309')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3318,'3318')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3344,'3344')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3307,'3307')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3314,'3314')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3325,'3325')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3326,'3326')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3329,'3329')
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (3347,'3347')
--
INSERT INTO ApoloDB.dbo.nodo (idnodo,nombre) values (100,'100')
--
INSERT INTO ApoloDB.dbo.nodo values(122,'1084',NULL,NULL,'1084','Propatria',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(122,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(122,22,'1084');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(122,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(122,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(122,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(122,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(122,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(122,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(122,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(122,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(122,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(122,212,5);
INSERT INTO ApoloDB.dbo.nodo values(123,'1086',NULL,NULL,'1086','Oficina San Antonio de los Altos ',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(123,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(123,22,'1086');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(123,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(123,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(123,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(123,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(123,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(123,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(123,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(123,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(123,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(123,212,5);
INSERT INTO ApoloDB.dbo.nodo values(124,'1087',NULL,NULL,'1087','La Urbina',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(124,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(124,22,'1087');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(124,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(124,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(124,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(124,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(124,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(124,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(124,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(124,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(124,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(124,212,5);
INSERT INTO ApoloDB.dbo.nodo values(125,'1091',NULL,NULL,'1091','Santa Monica',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(125,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(125,22,'1091');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(125,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(125,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(125,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(125,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(125,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(125,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(125,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(125,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(125,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(125,212,5);
INSERT INTO ApoloDB.dbo.nodo values(126,'1092',NULL,NULL,'1092','Metrocenter',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(126,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(126,22,'1092');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(126,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(126,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(126,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(126,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(126,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(126,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(126,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(126,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(126,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(126,212,5);
INSERT INTO ApoloDB.dbo.nodo values(127,'1096',NULL,NULL,'1096','La Trinidad',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(127,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(127,22,'1096');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(127,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(127,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(127,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(127,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(127,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(127,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(127,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(127,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(127,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(127,212,5);
INSERT INTO ApoloDB.dbo.nodo values(128,'1124',NULL,NULL,'1124','Compensacion',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(128,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(128,22,'1124');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(128,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(128,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(128,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(128,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(128,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(128,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(128,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(128,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(128,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(128,212,5);
INSERT INTO ApoloDB.dbo.nodo values(129,'1195',NULL,NULL,'1195','Catia la Mar',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(129,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(129,22,'1195');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(129,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(129,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(129,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(129,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(129,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(129,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(129,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(129,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(129,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(129,212,5);
INSERT INTO ApoloDB.dbo.nodo values(130,'1215',NULL,NULL,'1215','Dep. Regional Yaguara',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(130,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(130,22,'1215');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(130,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(130,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(130,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(130,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(130,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(130,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(130,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(130,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(130,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(130,212,5);
INSERT INTO ApoloDB.dbo.nodo values(131,'1232',NULL,NULL,'1232','Guatire Plaza',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(131,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(131,22,'1232');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(131,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(131,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(131,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(131,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(131,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(131,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(131,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(131,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(131,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(131,212,5);
INSERT INTO ApoloDB.dbo.nodo values(132,'1233',NULL,NULL,'1233','Xpress',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(132,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(132,22,'1233');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(132,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(132,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(132,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(132,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(132,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(132,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(132,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(132,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(132,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(132,212,5);
INSERT INTO ApoloDB.dbo.nodo values(133,'1234',NULL,NULL,'1234','Alcaldia de Baruta ',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(133,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(133,22,'1234');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(133,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(133,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(133,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(133,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(133,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(133,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(133,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(133,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(133,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(133,212,5);
INSERT INTO ApoloDB.dbo.nodo values(134,'1241',NULL,NULL,'1241','Alcaldía Sucre',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(134,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(134,22,'1241');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(134,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(134,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(134,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(134,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(134,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(134,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(134,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(134,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(134,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(134,212,5);
INSERT INTO ApoloDB.dbo.nodo values(135,'1248',NULL,NULL,'1248','Parque Humbolt',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(135,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(135,22,'1248');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(135,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(135,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(135,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(135,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(135,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(135,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(135,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(135,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(135,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(135,212,5);
INSERT INTO ApoloDB.dbo.nodo values(136,'1249',NULL,NULL,'1249','USI',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(136,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(136,22,'1249');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(136,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(136,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(136,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(136,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(136,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(136,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(136,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(136,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(136,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(136,212,5);
INSERT INTO ApoloDB.dbo.nodo values(137,'1027',NULL,NULL,'1027','Santa Lucia',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(137,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(137,22,'1027');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(137,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(137,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(137,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(137,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(137,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(137,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(137,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(137,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(137,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(137,212,5);
INSERT INTO ApoloDB.dbo.nodo values(138,'1031',NULL,NULL,'1031','La Castellana',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(138,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(138,22,'1031');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(138,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(138,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(138,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(138,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(138,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(138,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(138,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(138,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(138,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(138,212,5);
INSERT INTO ApoloDB.dbo.nodo values(139,'1032',NULL,NULL,'1032','Caracas Centro',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(139,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(139,22,'1032');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(139,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(139,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(139,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(139,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(139,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(139,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(139,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(139,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(139,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(139,212,5);
INSERT INTO ApoloDB.dbo.nodo values(140,'1033',NULL,NULL,'1033','Los Palos Grande',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(140,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(140,22,'1033');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(140,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(140,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(140,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(140,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(140,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(140,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(140,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(140,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(140,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(140,212,5);
INSERT INTO ApoloDB.dbo.nodo values(141,'1034',NULL,NULL,'1034','C.C. Sambil Caracas',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(141,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(141,22,'1034');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(141,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(141,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(141,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(141,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(141,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(141,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(141,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(141,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(141,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(141,212,5);
INSERT INTO ApoloDB.dbo.nodo values(142,'1035',NULL,NULL,'1035','Guatire',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(142,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(142,22,'1035');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(142,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(142,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(142,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(142,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(142,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(142,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(142,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(142,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(142,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(142,212,5);
INSERT INTO ApoloDB.dbo.nodo values(143,'1036',NULL,NULL,'1036','Macaracuay Plaza',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(143,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(143,22,'1036');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(143,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(143,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(143,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(143,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(143,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(143,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(143,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(143,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(143,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(143,212,5);
INSERT INTO ApoloDB.dbo.nodo values(144,'1037',NULL,NULL,'1037','Boleita',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(144,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(144,22,'1037');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(144,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(144,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(144,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(144,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(144,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(144,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(144,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(144,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(144,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(144,212,5);
INSERT INTO ApoloDB.dbo.nodo values(145,'1038',NULL,NULL,'1038','Las Mercedes Caracas',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(145,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(145,22,'1038');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(145,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(145,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(145,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(145,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(145,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(145,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(145,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(145,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(145,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(145,212,5);
INSERT INTO ApoloDB.dbo.nodo values(146,'1072',NULL,NULL,'1072','Centro Italo Caracas ',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(146,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(146,22,'1072');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(146,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(146,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(146,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(146,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(146,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(146,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(146,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(146,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(146,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(146,212,5);
INSERT INTO ApoloDB.dbo.nodo values(147,'1080',NULL,NULL,'1080','Aduana de Maiquetia',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(147,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(147,22,'1080');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(147,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(147,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(147,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(147,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(147,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(147,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(147,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(147,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(147,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(147,212,5);
INSERT INTO ApoloDB.dbo.nodo values(148,'1083',NULL,NULL,'1083','Quinta Crespo',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(148,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(148,22,'1083');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(148,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(148,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(148,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(148,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(148,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(148,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(148,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(148,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(148,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(148,212,5);
INSERT INTO ApoloDB.dbo.nodo values(149,'1118',NULL,NULL,'1118','Caracas El Rosal',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(149,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(149,22,'1118');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(149,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(149,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(149,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(149,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(149,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(149,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(149,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(149,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(149,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(149,212,5);
--
INSERT INTO ApoloDB.dbo.nodo values(150,'1055',NULL,NULL,'1055','Sambil Margarita',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(150,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(150,22,'1055');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(150,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(150,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(150,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(150,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(150,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(150,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(150,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(150,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(150,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(150,212,5);
INSERT INTO ApoloDB.dbo.nodo values(151,'1060',NULL,NULL,'1060','Taquilla Sambil Margarita',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(151,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(151,22,'1060');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(151,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(151,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(151,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(151,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(151,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(151,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(151,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(151,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(151,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(151,212,5);
INSERT INTO ApoloDB.dbo.nodo values(152,'1069',NULL,NULL,'1069','Las Garzas',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(152,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(152,22,'1069');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(152,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(152,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(152,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(152,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(152,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(152,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(152,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(152,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(152,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(152,212,5);
INSERT INTO ApoloDB.dbo.nodo values(153,'1142',NULL,NULL,'1142','Puerto La Cruz',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(153,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(153,22,'1142');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(153,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(153,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(153,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(153,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(153,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(153,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(153,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(153,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(153,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(153,212,5);
INSERT INTO ApoloDB.dbo.nodo values(154,'1079',NULL,NULL,'1079','Anaco',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(154,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(154,22,'1079');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(154,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(154,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(154,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(154,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(154,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(154,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(154,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(154,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(154,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(154,212,5);
INSERT INTO ApoloDB.dbo.nodo values(155,'1152',NULL,NULL,'1152','El Tigre',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(155,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(155,22,'1152');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(155,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(155,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(155,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(155,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(155,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(155,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(155,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(155,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(155,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(155,212,5);
INSERT INTO ApoloDB.dbo.nodo values(156,'1136',NULL,NULL,'1136','Maturin',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(156,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(156,22,'1136');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(156,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(156,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(156,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(156,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(156,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(156,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(156,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(156,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(156,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(156,212,5);
INSERT INTO ApoloDB.dbo.nodo values(157,'1216',NULL,NULL,'1216','Puerto Ordaz',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(157,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(157,22,'1216');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(157,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(157,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(157,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(157,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(157,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(157,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(157,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(157,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(157,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(157,212,5);
INSERT INTO ApoloDB.dbo.nodo values(158,'1094',NULL,NULL,'1094','Oficina Orinokia',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(158,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(158,22,'1094');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(158,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(158,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(158,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(158,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(158,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(158,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(158,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(158,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(158,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(158,212,5);
INSERT INTO ApoloDB.dbo.nodo values(159,'1254',NULL,NULL,'1254','Lecheria',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(159,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(159,22,'1254');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(159,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(159,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(159,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(159,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(159,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(159,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(159,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(159,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(159,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(159,212,5);
INSERT INTO ApoloDB.dbo.nodo values(160,'1073',NULL,NULL,'1073','Oficina San José de Guaribe',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(160,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(160,22,'1073');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(160,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(160,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(160,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(160,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(160,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(160,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(160,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(160,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(160,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(160,212,5);
--
INSERT INTO ApoloDB.dbo.nodo values(312,'3310',NULL,NULL,'3310','Barinas',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(312,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(312,22,'3310');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(312,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(312,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(312,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(312,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(312,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(312,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(312,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(312,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(312,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(312,212,5);
INSERT INTO ApoloDB.dbo.nodo values(313,'3305',NULL,NULL,'3305','San Fernando de Apure',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(313,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(313,22,'3305');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(313,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(313,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(313,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(313,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(313,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(313,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(313,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(313,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(313,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(313,212,5);
INSERT INTO ApoloDB.dbo.nodo values(314,'3202',NULL,NULL,'3202','El Viñedo',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(314,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(314,22,'3202');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(314,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(314,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(314,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(314,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(314,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(314,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(314,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(314,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(314,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(314,212,5);
INSERT INTO ApoloDB.dbo.nodo values(315,'3224',NULL,NULL,'3224','Patio el Trigal',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(315,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(315,22,'3224');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(315,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(315,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(315,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(315,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(315,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(315,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(315,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(315,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(315,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(315,212,5);
INSERT INTO ApoloDB.dbo.nodo values(316,'3219',NULL,NULL,'3219','Prebo',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(316,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(316,22,'3219');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(316,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(316,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(316,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(316,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(316,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(316,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(316,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(316,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(316,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(316,212,5);
INSERT INTO ApoloDB.dbo.nodo values(317,'3206',NULL,NULL,'3206','NaguaNagua',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(317,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(317,22,'3206');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(317,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(317,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(317,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(317,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(317,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(317,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(317,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(317,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(317,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(317,212,5);
INSERT INTO ApoloDB.dbo.nodo values(318,'3200',NULL,NULL,'3200','Sede Valencia',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(318,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(318,22,'3200');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(318,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(318,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(318,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(318,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(318,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(318,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(318,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(318,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(318,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(318,212,5);
INSERT INTO ApoloDB.dbo.nodo values(319,'3216',NULL,NULL,'3216','Santa Rosa',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(319,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(319,22,'3216');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(319,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(319,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(319,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(319,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(319,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(319,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(319,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(319,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(319,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(319,212,5);
INSERT INTO ApoloDB.dbo.nodo values(320,'3223',NULL,NULL,'3223','Metroplaza',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(320,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(320,22,'3223');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(320,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(320,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(320,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(320,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(320,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(320,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(320,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(320,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(320,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(320,212,5);
INSERT INTO ApoloDB.dbo.nodo values(321,'3204',NULL,NULL,'3204','Zona Industrial Valencia',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(321,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(321,22,'3204');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(321,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(321,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(321,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(321,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(321,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(321,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(321,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(321,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(321,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(321,212,5);
INSERT INTO ApoloDB.dbo.nodo values(322,'3208',NULL,NULL,'3208','Puerto Cabello',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(322,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(322,22,'3208');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(322,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(322,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(322,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(322,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(322,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(322,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(322,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(322,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(322,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(322,212,5);
INSERT INTO ApoloDB.dbo.nodo values(323,'3220',NULL,NULL,'3220','Tocuyito',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(323,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(323,22,'3220');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(323,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(323,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(323,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(323,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(323,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(323,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(323,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(323,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(323,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(323,212,5);
INSERT INTO ApoloDB.dbo.nodo values(324,'3784',NULL,NULL,'3784','Makro Tocuyito',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(324,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(324,22,'3784');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(324,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(324,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(324,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(324,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(324,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(324,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(324,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(324,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(324,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(324,212,5);
INSERT INTO ApoloDB.dbo.nodo values(325,'3221',NULL,NULL,'3221','Tinaquillo',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(325,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(325,22,'3221');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(325,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(325,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(325,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(325,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(325,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(325,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(325,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(325,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(325,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(325,212,5);
INSERT INTO ApoloDB.dbo.nodo values(326,'3207',NULL,NULL,'3207','Montalban',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(326,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(326,22,'3207');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(326,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(326,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(326,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(326,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(326,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(326,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(326,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(326,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(326,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(326,212,5);
INSERT INTO ApoloDB.dbo.nodo values(327,'3210',NULL,NULL,'3210','Acarigua',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(327,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(327,22,'3210');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(327,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(327,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(327,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(327,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(327,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(327,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(327,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(327,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(327,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(327,212,5);
INSERT INTO ApoloDB.dbo.nodo values(328,'3211',NULL,NULL,'3211','Turen',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(328,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(328,22,'3211');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(328,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(328,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(328,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(328,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(328,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(328,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(328,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(328,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(328,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(328,212,5);
INSERT INTO ApoloDB.dbo.nodo values(329,'3316',NULL,NULL,'3316','San Felipe',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(329,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(329,22,'3316');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(329,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(329,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(329,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(329,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(329,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(329,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(329,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(329,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(329,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(329,212,5);
INSERT INTO ApoloDB.dbo.nodo values(330,'3330',NULL,NULL,'3330','Guanare',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(330,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(330,22,'3330');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(330,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(330,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(330,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(330,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(330,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(330,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(330,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(330,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(330,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(330,212,5);
INSERT INTO ApoloDB.dbo.nodo values(331,'3544',NULL,NULL,'3544','Taquilla TE AZUCARERA ACARIGUA',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(331,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(331,22,'3544');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(331,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(331,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(331,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(331,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(331,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(331,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(331,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(331,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(331,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(331,212,5);
INSERT INTO ApoloDB.dbo.nodo values(332,'3300',NULL,NULL,'3300','Maracay Sede',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(332,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(332,22,'3300');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(332,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(332,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(332,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(332,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(332,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(332,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(332,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(332,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(332,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(332,212,5);
INSERT INTO ApoloDB.dbo.nodo values(333,'3301',NULL,NULL,'3301','HyperJumbo',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(333,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(333,22,'3301');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(333,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(333,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(333,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(333,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(333,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(333,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(333,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(333,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(333,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(333,212,5);
INSERT INTO ApoloDB.dbo.nodo values(334,'3302',NULL,NULL,'3302','Palo Negro',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(334,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(334,22,'3302');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(334,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(334,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(334,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(334,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(334,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(334,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(334,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(334,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(334,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(334,212,5);
INSERT INTO ApoloDB.dbo.nodo values(335,'3303',NULL,NULL,'3303','La Victoria',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(335,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(335,22,'3303');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(335,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(335,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(335,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(335,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(335,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(335,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(335,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(335,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(335,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(335,212,5);
INSERT INTO ApoloDB.dbo.nodo values(336,'3304',NULL,NULL,'3304','Turmero',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(336,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(336,22,'3304');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(336,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(336,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(336,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(336,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(336,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(336,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(336,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(336,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(336,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(336,212,5);
INSERT INTO ApoloDB.dbo.nodo values(337,'3309',NULL,NULL,'3309','Maracay Las delicias',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(337,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(337,22,'3309');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(337,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(337,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(337,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(337,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(337,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(337,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(337,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(337,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(337,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(337,212,5);
INSERT INTO ApoloDB.dbo.nodo values(338,'3318',NULL,NULL,'3318','Cagua',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(338,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(338,22,'3318');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(338,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(338,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(338,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(338,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(338,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(338,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(338,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(338,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(338,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(338,212,5);
INSERT INTO ApoloDB.dbo.nodo values(339,'3344',NULL,NULL,'3344','Maracay Av. Aragua',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(339,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(339,22,'3344');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(339,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(339,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(339,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(339,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(339,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(339,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(339,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(339,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(339,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(339,212,5);
INSERT INTO ApoloDB.dbo.nodo values(340,'3307',NULL,NULL,'3307','Barquisimeto Sede',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(340,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(340,22,'3307');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(340,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(340,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(340,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(340,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(340,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(340,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(340,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(340,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(340,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(340,212,5);
INSERT INTO ApoloDB.dbo.nodo values(341,'3314',NULL,NULL,'3314','Carora',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(341,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(341,22,'3314');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(341,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(341,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(341,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(341,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(341,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(341,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(341,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(341,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(341,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(341,212,5);
INSERT INTO ApoloDB.dbo.nodo values(342,'3325',NULL,NULL,'3325','Barquisimeto Centro',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(342,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(342,22,'3325');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(342,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(342,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(342,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(342,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(342,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(342,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(342,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(342,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(342,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(342,212,5);
INSERT INTO ApoloDB.dbo.nodo values(343,'3326',NULL,NULL,'3326','Mercabar',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(343,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(343,22,'3326');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(343,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(343,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(343,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(343,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(343,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(343,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(343,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(343,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(343,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(343,212,5);
INSERT INTO ApoloDB.dbo.nodo values(344,'3329',NULL,NULL,'3329','Quibor',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(344,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(344,22,'3329');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(344,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(344,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(344,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(344,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(344,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(344,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(344,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(344,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(344,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(344,212,5);
INSERT INTO ApoloDB.dbo.nodo values(345,'3347',NULL,NULL,'3347','Barquisimeto Zona Industrial',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(345,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(345,22,'3347');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(345,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(345,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(345,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(345,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(345,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(345,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(345,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(345,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(345,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(345,212,5);
--
INSERT INTO ApoloDB.dbo.nodo values(229,'3312',NULL,NULL,'3312','San Cristobal',NULL,NULL);
insert into nodo_propiedad values(229,21,5000);
insert into nodo_propiedad values(229,22,'3312');
insert into nodo_propiedad values(229,23,900000);
insert into nodo_propiedad values(229,24,1000);
insert into nodo_propiedad values(229,25,'false');
insert into nodo_propiedad values(229,26,3);
insert into nodo_propiedad values(229,27,'false');
insert into nodo_propiedad values(229,28,'exe,db,inf');
insert into nodo_propiedad values(229,29,12000);
insert into nodo_propiedad values(229,210,'jpg,odf,xml,txt');
insert into nodo_propiedad values(229,211,1);
insert into nodo_propiedad values(229,212,5);
INSERT INTO ApoloDB.dbo.nodo values(230,'3313',NULL,NULL,'3313','Merida',NULL,NULL);
insert into nodo_propiedad values(230,21,5000);
insert into nodo_propiedad values(230,22,'3313');
insert into nodo_propiedad values(230,23,900000);
insert into nodo_propiedad values(230,24,1000);
insert into nodo_propiedad values(230,25,'false');
insert into nodo_propiedad values(230,26,3);
insert into nodo_propiedad values(230,27,'false');
insert into nodo_propiedad values(230,28,'exe,db,inf');
insert into nodo_propiedad values(230,29,12000);
insert into nodo_propiedad values(230,210,'jpg,odf,xml,txt');
insert into nodo_propiedad values(230,211,1);
insert into nodo_propiedad values(230,212,5);
INSERT INTO ApoloDB.dbo.nodo values(231,'3315',NULL,NULL,'3315','Valera',NULL,NULL);
insert into nodo_propiedad values(231,21,5000);
insert into nodo_propiedad values(231,22,'3315');
insert into nodo_propiedad values(231,23,900000);
insert into nodo_propiedad values(231,24,1000);
insert into nodo_propiedad values(231,25,'false');
insert into nodo_propiedad values(231,26,3);
insert into nodo_propiedad values(231,27,'false');
insert into nodo_propiedad values(231,28,'exe,db,inf');
insert into nodo_propiedad values(231,29,12000);
insert into nodo_propiedad values(231,210,'jpg,odf,xml,txt');
insert into nodo_propiedad values(231,211,1);
insert into nodo_propiedad values(231,212,5);
INSERT INTO ApoloDB.dbo.nodo values(232,'3322',NULL,NULL,'3322','Punto Fijo',NULL,NULL);
insert into nodo_propiedad values(232,21,5000);
insert into nodo_propiedad values(232,22,'3322');
insert into nodo_propiedad values(232,23,900000);
insert into nodo_propiedad values(232,24,1000);
insert into nodo_propiedad values(232,25,'false');
insert into nodo_propiedad values(232,26,3);
insert into nodo_propiedad values(232,27,'false');
insert into nodo_propiedad values(232,28,'exe,db,inf');
insert into nodo_propiedad values(232,29,12000);
insert into nodo_propiedad values(232,210,'jpg,odf,xml,txt');
insert into nodo_propiedad values(232,211,1);
insert into nodo_propiedad values(232,212,5);
INSERT INTO ApoloDB.dbo.nodo values(233,'3209',NULL,NULL,'3209','Coro',NULL,NULL);
insert into nodo_propiedad values(233,21,5000);
insert into nodo_propiedad values(233,22,'3209');
insert into nodo_propiedad values(233,23,900000);
insert into nodo_propiedad values(233,24,1000);
insert into nodo_propiedad values(233,25,'false');
insert into nodo_propiedad values(233,26,3);
insert into nodo_propiedad values(233,27,'false');
insert into nodo_propiedad values(233,28,'exe,db,inf');
insert into nodo_propiedad values(233,29,12000);
insert into nodo_propiedad values(233,210,'jpg,odf,xml,txt');
insert into nodo_propiedad values(233,211,1);
insert into nodo_propiedad values(233,212,5);
INSERT INTO ApoloDB.dbo.nodo values(234,'3346',NULL,NULL,'3346','Cabimas',NULL,NULL);
insert into nodo_propiedad values(234,21,5000);
insert into nodo_propiedad values(234,22,'3346');
insert into nodo_propiedad values(234,23,900000);
insert into nodo_propiedad values(234,24,1000);
insert into nodo_propiedad values(234,25,'false');
insert into nodo_propiedad values(234,26,3);
insert into nodo_propiedad values(234,27,'false');
insert into nodo_propiedad values(234,28,'exe,db,inf');
insert into nodo_propiedad values(234,29,12000);
insert into nodo_propiedad values(234,210,'jpg,odf,xml,txt');
insert into nodo_propiedad values(234,211,1);
insert into nodo_propiedad values(234,212,5);
INSERT INTO ApoloDB.dbo.nodo values(235,'3323',NULL,NULL,'3323','Ciudad Ojeda',NULL,NULL);
insert into nodo_propiedad values(235,21,5000);
insert into nodo_propiedad values(235,22,'3323');
insert into nodo_propiedad values(235,23,900000);
insert into nodo_propiedad values(235,24,1000);
insert into nodo_propiedad values(235,25,'false');
insert into nodo_propiedad values(235,26,3);
insert into nodo_propiedad values(235,27,'false');
insert into nodo_propiedad values(235,28,'exe,db,inf');
insert into nodo_propiedad values(235,29,12000);
insert into nodo_propiedad values(235,210,'jpg,odf,xml,txt');
insert into nodo_propiedad values(235,211,1);
insert into nodo_propiedad values(235,212,5);
INSERT INTO ApoloDB.dbo.nodo values(236,'3317',NULL,NULL,'3317','Agencia La Redoma',NULL,NULL);
insert into nodo_propiedad values(236,21,5000);
insert into nodo_propiedad values(236,22,'3317');
insert into nodo_propiedad values(236,23,900000);
insert into nodo_propiedad values(236,24,1000);
insert into nodo_propiedad values(236,25,'false');
insert into nodo_propiedad values(236,26,3);
insert into nodo_propiedad values(236,27,'false');
insert into nodo_propiedad values(236,28,'exe,db,inf');
insert into nodo_propiedad values(236,29,12000);
insert into nodo_propiedad values(236,210,'jpg,odf,xml,txt');
insert into nodo_propiedad values(236,211,1);
insert into nodo_propiedad values(236,212,5);
INSERT INTO ApoloDB.dbo.nodo values(237,'3594',NULL,NULL,'3594','Clínica Paraiso',NULL,NULL);
insert into nodo_propiedad values(237,21,5000);
insert into nodo_propiedad values(237,22,'3594');
insert into nodo_propiedad values(237,23,900000);
insert into nodo_propiedad values(237,24,1000);
insert into nodo_propiedad values(237,25,'false');
insert into nodo_propiedad values(237,26,3);
insert into nodo_propiedad values(237,27,'false');
insert into nodo_propiedad values(237,28,'exe,db,inf');
insert into nodo_propiedad values(237,29,12000);
insert into nodo_propiedad values(237,210,'jpg,odf,xml,txt');
insert into nodo_propiedad values(237,211,1);
insert into nodo_propiedad values(237,212,5);
INSERT INTO ApoloDB.dbo.nodo values(238,'3331',NULL,NULL,'3331','Agencia El Varillal',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(238,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(238,22,'3331');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(238,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(238,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(238,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(238,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(238,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(238,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(238,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(238,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(238,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(238,212,5);
INSERT INTO ApoloDB.dbo.nodo values(239,'3349',NULL,NULL,'3349','Agencia MAKRO Maracaibo',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(239,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(239,22,'3349');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(239,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(239,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(239,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(239,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(239,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(239,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(239,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(239,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(239,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(239,212,5);
INSERT INTO ApoloDB.dbo.nodo values(240,'3214',NULL,NULL,'3214','Agencia Indio Mara CB',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(240,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(240,22,'3214');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(240,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(240,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(240,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(240,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(240,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(240,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(240,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(240,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(240,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(240,212,5);
INSERT INTO ApoloDB.dbo.nodo values(241,'3334',NULL,NULL,'3334','Maracaibo Norte',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(241,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(241,22,'3334');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(241,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(241,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(241,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(241,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(241,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(241,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(241,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(241,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(241,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(241,212,5);
--
INSERT INTO ApoloDB.dbo.nodo values(287,'3126',NULL,NULL,'3126','Porlamar',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(287,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(287,22,'3126');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(287,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(287,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(287,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(287,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(287,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(287,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(287,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(287,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(287,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(287,212,5);
INSERT INTO ApoloDB.dbo.nodo values(288,'3155',NULL,NULL,'3155','Galerias Fente',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(288,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(288,22,'3155');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(288,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(288,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(288,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(288,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(288,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(288,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(288,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(288,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(288,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(288,212,5);
INSERT INTO ApoloDB.dbo.nodo values(289,'3750',NULL,NULL,'3750','Juan Griego',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(289,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(289,22,'3750');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(289,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(289,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(289,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(289,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(289,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(289,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(289,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(289,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(289,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(289,212,5);
INSERT INTO ApoloDB.dbo.nodo values(290,'3121',NULL,NULL,'3121','Punta Piedras',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(290,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(290,22,'3121');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(290,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(290,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(290,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(290,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(290,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(290,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(290,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(290,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(290,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(290,212,5);
INSERT INTO ApoloDB.dbo.nodo values(291,'3506',NULL,NULL,'3506','Taq. Ext. Guamache',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(291,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(291,22,'3506');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(291,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(291,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(291,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(291,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(291,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(291,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(291,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(291,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(291,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(291,212,5);
INSERT INTO ApoloDB.dbo.nodo values(292,'3141',NULL,NULL,'3141','Puerto la Cruz Av. 5 de Julio',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(292,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(292,22,'3141');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(292,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(292,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(292,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(292,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(292,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(292,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(292,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(292,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(292,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(292,212,5);
INSERT INTO ApoloDB.dbo.nodo values(293,'3350',NULL,NULL,'3350','Makro Puerto la Cruz',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(293,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(293,22,'3350');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(293,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(293,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(293,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(293,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(293,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(293,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(293,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(293,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(293,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(293,212,5);
INSERT INTO ApoloDB.dbo.nodo values(294,'3710',NULL,NULL,'3710','Puerto Piritu',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(294,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(294,22,'3710');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(294,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(294,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(294,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(294,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(294,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(294,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(294,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(294,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(294,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(294,212,5);
INSERT INTO ApoloDB.dbo.nodo values(295,'3115',NULL,NULL,'3115','Barcelona Av. Intercomunal',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(295,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(295,22,'3115');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(295,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(295,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(295,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(295,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(295,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(295,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(295,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(295,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(295,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(295,212,5);
INSERT INTO ApoloDB.dbo.nodo values(296,'3719',NULL,NULL,'3719','Barcelona Centro',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(296,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(296,22,'3719');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(296,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(296,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(296,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(296,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(296,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(296,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(296,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(296,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(296,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(296,212,5);
INSERT INTO ApoloDB.dbo.nodo values(297,'3737',NULL,NULL,'3737','Anaco',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(297,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(297,22,'3737');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(297,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(297,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(297,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(297,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(297,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(297,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(297,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(297,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(297,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(297,212,5);
INSERT INTO ApoloDB.dbo.nodo values(298,'3162',NULL,NULL,'3162','El Tigre',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(298,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(298,22,'3162');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(298,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(298,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(298,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(298,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(298,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(298,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(298,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(298,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(298,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(298,212,5);
INSERT INTO ApoloDB.dbo.nodo values(299,'3738',NULL,NULL,'3738','Maturin La Avanzadora',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(299,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(299,22,'3738');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(299,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(299,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(299,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(299,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(299,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(299,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(299,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(299,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(299,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(299,212,5);
INSERT INTO ApoloDB.dbo.nodo values(300,'3725',NULL,NULL,'3725','Pariaguan',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(300,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(300,22,'3725');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(300,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(300,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(300,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(300,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(300,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(300,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(300,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(300,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(300,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(300,212,5);
INSERT INTO ApoloDB.dbo.nodo values(301,'3129',NULL,NULL,'3129','Puerto Ordaz Castillito',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(301,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(301,22,'3129');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(301,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(301,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(301,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(301,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(301,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(301,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(301,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(301,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(301,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(301,212,5);
INSERT INTO ApoloDB.dbo.nodo values(302,'3708',NULL,NULL,'3708','Puerto Ordaz Sede',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(302,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(302,22,'3708');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(302,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(302,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(302,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(302,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(302,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(302,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(302,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(302,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(302,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(302,212,5);
INSERT INTO ApoloDB.dbo.nodo values(303,'3169',NULL,NULL,'3169','Makro Puerto Ordaz',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(303,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(303,22,'3169');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(303,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(303,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(303,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(303,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(303,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(303,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(303,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(303,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(303,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(303,212,5);
INSERT INTO ApoloDB.dbo.nodo values(304,'3705',NULL,NULL,'3705','Alcasa',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(304,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(304,22,'3705');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(304,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(304,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(304,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(304,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(304,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(304,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(304,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(304,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(304,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(304,212,5);
INSERT INTO ApoloDB.dbo.nodo values(305,'3731',NULL,NULL,'3731','Ferrominera',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(305,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(305,22,'3731');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(305,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(305,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(305,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(305,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(305,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(305,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(305,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(305,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(305,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(305,212,5);
INSERT INTO ApoloDB.dbo.nodo values(306,'3713',NULL,NULL,'3713','Unare',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(306,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(306,22,'3713');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(306,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(306,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(306,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(306,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(306,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(306,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(306,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(306,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(306,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(306,212,5);
INSERT INTO ApoloDB.dbo.nodo values(307,'3723',NULL,NULL,'3723','Chirica',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(307,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(307,22,'3723');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(307,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(307,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(307,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(307,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(307,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(307,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(307,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(307,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(307,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(307,212,5);
INSERT INTO ApoloDB.dbo.nodo values(308,'3716',NULL,NULL,'3716','San Felix',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(308,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(308,22,'3716');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(308,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(308,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(308,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(308,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(308,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(308,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(308,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(308,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(308,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(308,212,5);
INSERT INTO ApoloDB.dbo.nodo values(309,'3135',NULL,NULL,'3135','Ciudad Bolivar',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(309,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(309,22,'3135');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(309,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(309,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(309,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(309,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(309,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(309,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(309,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(309,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(309,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(309,212,5);
INSERT INTO ApoloDB.dbo.nodo values(310,'3137',NULL,NULL,'3137',' Cumana',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(310,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(310,22,'3137');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(310,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(310,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(310,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(310,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(310,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(310,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(310,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(310,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(310,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(310,212,5);
INSERT INTO ApoloDB.dbo.nodo values(311,'3143',NULL,NULL,'3143','Carupano Centro',NULL,NULL);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(311,21,5000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(311,22,'3143');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(311,23,900000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(311,24,1000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(311,25,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(311,26,3);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(311,27,'false');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(311,28,'exe,db,inf');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(311,29,12000);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(311,210,'jpg,odf,xml,txt');
INSERT INTO ApoloDB.dbo.nodo_propiedad values(311,211,1);
INSERT INTO ApoloDB.dbo.nodo_propiedad values(311,212,5);
--
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('S105L1FM',1,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('S10A2849',1,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('CBVES201APL09',2,'10.201.40.11')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODUAP02',2,'192.168.43.24')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('CBVES201UAPBD',2,'10.201.79.20')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('CBVES201SUAFDB',2,'10.201.130.7')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODBDAPPS4',2,'10.6.34.29')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('CBVES201UAPDES',2,'10.201.82.20')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODUAPDESA',2,'192.168.43.33')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODCBDESA2',2,'10.6.8.25')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodapps16',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodapps20',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodapps23',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodapps28',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodapps29',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodapps33',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODAPPS38',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODAPPS46',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODAPPS47',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODAPPS48',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODCCENTER2',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodclu12',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODCLU13',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODCLU14',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodclu15',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodclu16',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodclu5',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodclu6',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('boddwh01',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('boddwh02',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODDWH03',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodfidedbc',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODFIDEDBP',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('boditim2',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODPRJSRV',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodrms1',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodstratus1',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodstratus2',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODVC02',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodvcenter01',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('despostilion1',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('despostilion2',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('postiliondesa2',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('postiliondesa3',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('prodoffice2',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('prodoffice3',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('BODCBD2K5',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('cbves201admin',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('CBVES201APL14',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('cbves201apl17',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('cbves201apsql',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('cbves201DesAMEX',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('cbves201firma',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodapps14',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodapps17',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodapps24',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodapps4',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodbdapps2',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodfidedbd',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodfirmas',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodintranet',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodmplus1',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodoccam',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodsql',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodsql2005',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodsql2005c',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('desofficecb',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('postilionrtd',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('prodoffice1',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('prodofficecb',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('STRATUSPROD',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodcbdesa1',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodcbprueba1',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('cbves201gestion',3,'')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodbdclu1',2,'10.6.34.24')
INSERT INTO TB_Servidor (SV_Nombre,CoDTipoServidor,NumIpServidor) VALUES ('bodbdclu2',2,'10.6.34.24')
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('BODBDAPPS4','BANKBU') 
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('BODBDAPPS4','RCAT') 
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('bodbdclu1','bankbu') 
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('BODCBDESA2','CICS') 
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('BODCBDESA2','ICSDESA') 
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('BODUAP02','SCS') 
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('BODUAPDESA','SCS') 
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('CBVES201APL09','bankbu') 
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('CBVES201SUAFDB','OEMREP') 
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('CBVES201SUAFDB','SEGMENT') 
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('CBVES201SUAFDB','SUAF') 
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('CBVES201UAPBD','scs') 
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('CBVES201UAPDES','SCS') 
INSERT INTO DetInstancias (NomServidor,NomInstancia) VALUES ('CBVES201UAPDES','scs10g') 
--
--
--
SELECT
	t.Nombre_BD,
	t.Nombre_Servidor,
	r1.Observaciones2,
	t.Cantidad
FROM (
	SELECT
		COUNT(*) AS Cantidad,
		bd.Nombre_BD,
		s.Nombre_Servidor,
		r.FK_Bd, r.Observaciones
	FROM REQUERIMIENTOS r 
	INNER JOIN BD_POR_SERVIDOR bdps ON r.fk_bd = bdps.id_Bdserver 
	INNER JOIN BASEDATO bd ON bdps.FK_BD = BD.ID_BD 
	INNER JOIN SERVIDOR s ON s.ID_Servidor = BDPS.fK_sERVIDOR
	INNER JOIN ACTIVIDAD a ON a.id_actividad = r.FK_Actividad
	INNER JOIN TipoOperacion t ON t.ID_TipoOperacion = r.FK_TipoOper
	WHERE FECHAINI >= '2009-09-19 00:00:01'
  	AND FECHAINI <= '2009-09-30 23:59:59'
  	AND Observaciones = 'Rutina Automatizada'
	GROUP BY bd.Nombre_BD, r.FK_Bd, r.Observaciones, s.Nombre_Servidor
	HAVING COUNT(*) <> 2
) AS t
INNER JOIN Requerimientos r1 ON r1.fk_bd IN (t.FK_Bd) 
WHERE t.Observaciones = r1.Observaciones
--
SELECT
	C.ID_CUENTA AS 'CUENTA',
	A.NOMBRE AS 'NOMBRE',
	C.ID_TITULAR AS 'TITULAR',
	C. FECHA_CREACION AS 'FECHA DE CREACION'
FROM PRODUCTO C
INNER JOIN PRODUCTO_PERSONA B ON C.ID_CUENTA = B.ID_CUENTA
INNER JOIN PERSONA A ON A.ID_PERSONA = B.ID_PERSONA
WHERE CONVERT(VARCHAR(8),FECHA_CREACION , 112) BETWEEN '20100801' AND '20100831'
ORDER BY 4 DESC
--
SELECT
	YEAR(OPEN_TIME) 'AÑO',
	MONTH(OPEN_TIME) 'MES',
	A.SUBCATEGORY,
	COUNT(*) 'REGISTROS'
FROM DBO.PROBSUMMARYM1 A
INNER JOIN DBO.SYSATTACHMEM1 B ON A.NUMBER = B.TOPIC
WHERE A.CATEGORY = 'INCIDENTE' 
GROUP BY YEAR(OPEN_TIME), MONTH(OPEN_TIME), A.SUBCATEGORY
ORDER BY YEAR(OPEN_TIME), MONTH(OPEN_TIME)
--
INSERT INTO dbo.bd_por_servidor (FK_BD, FK_Servidor, FK_ManejadorBD) VALUES (418,60,1)
INSERT INTO dbo.bd_por_servidor (FK_BD, FK_Servidor, FK_ManejadorBD) VALUES (419,60,1)
INSERT INTO dbo.bd_por_servidor (FK_BD, FK_Servidor, FK_ManejadorBD) VALUES (420,60,1)
INSERT INTO dbo.bd_por_servidor (FK_BD, FK_Servidor, FK_ManejadorBD) VALUES (421,60,1)
INSERT INTO dbo.bd_por_servidor (FK_BD, FK_Servidor, FK_ManejadorBD) VALUES (422,60,1)
INSERT INTO dbo.bd_por_servidor (FK_BD, FK_Servidor, FK_ManejadorBD) VALUES (423,60,1)
--
SELECT * FROM dbo.bd_por_servidor WHERE fk_BD = 10
SELECT * FROM dbo.bd_por_servidor WHERE fk_servidor in (60)
SELECT * FROM dbo.basedato WHERE nombre_BD LIKE 'ITIMDB%'