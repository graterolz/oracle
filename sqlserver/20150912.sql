UPDATE sitos.dbo.t_produccion
SET inv_col = 35637.25,
	inv_trans = 6727.18,
	inv_ceiba = 76921.60,
	desc_venta = 583.77,
	ventas_ceiba = 0
WHERE fechaLlegada = '2014-07-17';
--
UPDATE sitos.dbo.t_produccion
SET inv_col = 38156.85, 
	inv_trans = 6457.93,
	inv_ceiba = 78356.71,
	desc_venta = 0,
	ventas_ceiba = 0
WHERE fechaLlegada = '2014-07-21';
--
UPDATE sitos.dbo.t_produccion
SET inv_col = 40663.05,
	inv_trans = 6457.93 ,
	inv_ceiba = 78557.38,
	desc_venta = 0,
	ventas_ceiba = 0
WHERE fechaLlegada = '2014-07-28';
--
UPDATE sitos.dbo.t_produccion
SET inv_col = 44164.61,
	inv_trans = 6429.09,
	inv_ceiba = 78652.73,
	desc_venta = 0,
	ventas_ceiba = 0
WHERE fechaLlegada = '2014-08-06';
--
USE sitos
SELECT DISTINCT
	w.relac,
	w.fecha,
	isnull(a.entrada,0) patio1_entrada,
	isnull(a.salida,0) patio1_despacho,
	isnull(b.entrada,0) patio2_entrada,
	isnull(b.salida,0) patio2_despacho,
	isnull(c.entrada,0) patio3_entrada,
	isnull(c.salida,0) patio3_despacho,
	isnull(d.entrada,0) patio3A_entrada,
	isnull(d.salida,0) patio3A_despacho,
	isnull(E.entrada,0) patio4_entrada,
	isnull(e.salida,0) patio4_despacho
FROM (SELECT DISTINCT RELAC,FECHA FROM dbo.T_IRT) w
LEFT OUTER JOIN (
	SELECT RELAC,fecha,entrada,salida,patio FROM dbo.T_IRT
	WHERE patio = '1'
) A ON w.fecha = a.fecha
LEFT OUTER JOIN (
	SELECT RELAC,fecha,entrada,salida,patio FROM dbo.T_IRT
	WHERE patio = '2'
) B ON w.fecha = b.fecha
LEFT OUTER JOIN (
	SELECT RELAC,fecha,entrada,salida,patio FROM dbo.T_IRT
	WHERE patio = '3'
) C ON w.fecha = C.fecha
LEFT OUTER JOIN (
	SELECT RELAC,fecha,entrada,salida,patio FROM dbo.T_IRT
	WHERE patio = '3A'
) D ON w.fecha = D.fecha
LEFT OUTER JOIN (
	SELECT RELAC,fecha,entrada,salida FROM dbo.T_IRT
	WHERE patio = '4'
) E ON w.fecha = E.fecha
WHERE datepart(year,w.fecha) = 2014
AND DATEPART(ISO_WEEK,w.fecha) = 32
ORDER BY w.fecha;
--
SELECT * FROM dbo.t_irttemp 
WHERE datepart(year,fecha) = 2014
AND DATEPART(ISO_WEEK,fecha) = 32
ORDER BY 1;
--
SELECT name,collation_name, object_id
FROM sys.columns
WHERE collation_name IS NULL
ORDER BY 1 DESC;
--
SELECT * FROM sys.all_objects WHERE object_id = 1470628282;
--
DELETE FROM dbo.t_produccion WHERE relac = '2014-40';
DELETE FROM dbo.t_spa WHERE relac = '2014-40';
DELETE FROM dbo.spa_viaje WHERE relac = '2014-40';
--
EXEC sp_dataSpa;
EXEC dbo.speg_generaCalendario;
--
SELECT * FROM dbo.t_produccion WHERE relac = '2014-40';
--
USE traz
INSERT INTO dbo.usuarios
SELECT NEWID() idUsuario,'egraterol','Emilio Graterol',1,1,1,1,1,1,'eg123456',1,1,1,1,1,1,1,1,1,1;
--
SELECT
	'Cucuta - La Ceiba' 'Por Rutas',
	SUM(transCeibaCucuta) 'Toneladas', 
	SUM(cTransCeibaCucuta) 'Viajes'
FROM sitos.dbo.t_produccion
WHERE RELAC = '2014-49'
UNION ALL
SELECT
	'Ureña - La Ceiba',
	SUM(transCeibaUrena),
	SUM(cTransCeibaUrena)
FROM sitos.dbo.t_produccion
WHERE RELAC = '2014-49';
--
SELECT
	'Total (La Ceiba)' 'Por Destino',
	SUM(transCeibaCucuta+transCeibaUrena) 'Toneladas', 
	SUM(cTransCeibaCucuta+cTransCeibaUrena) 'Viajes'
FROM sitos.dbo.t_produccion
WHERE RELAC = '2014-49'
UNION ALL 
SELECT
	'Total (Ureña)',
	SUM(transUrenaCucuta),
	SUM(cTransUrenaCucuta)
FROM sitos.dbo.t_produccion
WHERE RELAC = '2014-49';
--
SELECT
	'Total Produccion',
	SUM(Toneladas) 'Toneladas',
	SUM(Viajes) 'Viajes'
FROM (
	SELECT
		SUM(transCeibaCucuta+transCeibaUrena) 'Toneladas',
		SUM(cTransCeibaCucuta+cTransCeibaUrena) 'Viajes'
	FROM sitos.dbo.t_produccion
	WHERE RELAC = '2014-49'
	UNION ALL 
	SELECT
		SUM(transUrenaCucuta),
		SUM(cTransUrenaCucuta)
	FROM sitos.dbo.t_produccion
	WHERE RELAC = '2014-49'
) A;
--
SELECT
	Relac,
	Ticket,
	CONVERT(VARCHAR,FechaSalida,103) FechaSalida,
	CONVERT(VARCHAR,FechaLlegada,103) FechaLlegada,
	TicketInterno,
	Placa,
	Transportista,
	ISNULL(CAST(PesoBrutoSalidaas float(2)),0) PesoBrutoSalida,
	ISNULL(CAST(PesoTaraSalidaas float(2)),0) PesoTaraSalida,
	ISNULL(CAST(PesoNetoSalidaas float(2)),0) PesoNetoSalida,
	ISNULL(CAST(PesoBrutoLlegadaas float(2)),0) PesoBrutoLlegada,
	ISNULL(CAST(PesoTaraLlegadaas float(2)),0) PesoTaraLlegada,
	ISNULL(CAST(PesoNetoLlegadaas float(2)),0) PesoNetoLlegada,
	ISNULL(CAST(DifePesoNetoas float(2)),0) DifePesoNeto,
	ISNULL(CAST(PorDifePesoNetoas float(2)),0) PorDifePesoNeto,
	SitiOrigen,
	SitioDestino,
	Unidad,
	Proveedor,
	Numeral,
	FactTransp,
	FactProv,
	FactCliente,
	Prod,
	Chofer,
	FactPesosProv,
	FactPesosTrans
FROM sitos.dbo.t_spa
WHERE relac = '2014-49'
ORDER BY 1;
--
SELECT TOP 1000
	Semana,
	CONVERT(VARCHAR,Fecha,103)Fecha,
	ReciboRecepcion,
	Empresa,
	Tiquete,
	Remision,
	Clasificacion,
	Placa,
	Conductor,
	BrutoRecepcion,
	VacioRecepcion,
	NetoRecepcion,
	Origen,
	Proveedor,
	Recepcionado,
	'S/I' Zona,
	Transportador,
	Ruta,
	Mes,
	relac,
	Papeleria,
	PILA,
	Lote
FROM sitos.dbo.t_trazapp
WHERE semana = 42
ORDER BY 1,2;
--
USE sitos
DROP TABLE dbo.t_irt;

SELECT * INTO dbo.t_irt FROM (
	SELECT
		relac,
		Fecha,
		SUM(entrada) Entrada
	FROM dbo.irt_dia
	GROUP BY relac,Fecha
	UNION ALL
	SELECT
		relac,
		fecha,
		SUM(NetoRecepcion) Entrada
	FROM dbo.irt_viaje
	GROUP BY relac,Fecha
) A
WHERE entrada <> 0
ORDER BY FECHA;
--
SELECT
	RELAC,
	SUM(transCeibaCucuta) 'T la Ceiba Col1',
	SUM(transUrenaCucuta) 'T Ureña Col2',
	SUM(transCeibaUrena) 'T la Ceiba Ureña3',
	SUM(transUrenaCucuta) 'R Cucuta Ureña4',
	0 'T la ceiba MX5',
	SUM(transCeibaOrope) 'T la ceiba Ccb6',
	SUM(PesoBrutoSalida) 'PesoBrutoSalida7',
	SUM(PesoNetoSalida) 'PesoNetoSalida8',
	SUM(PesoBrutoLlegada) 'PesoBrutoLlegada9',
	SUM(PesoNetoLlegada) 'PesoNetoLlegada10'
FROM sitos.dbo.t_produccion
WHERE RELAC = '2014-49'
GROUP BY RELAC
ORDER BY 1;
--
SELECT
	relac,
	SUM(comprasIRTCucuta) IRT,
	SUM(comprasTrazappCucuta) Trazapp
FROM sitos.dbo.t_produccion
GROUP BY RELAC
ORDER BY 1;
--
SELECT * FROM sitos.dbo.t_spa
WHERE Relac = '2014-48'
AND Ticket = '26670';
--
SELECT * FROM sitos.dbo.t_calidad
WHERE relac = '2014-48'
AND NroTicket = '26670';
--
UPDATE sitos.dbo.t_calidad
SET newPeso = 0;
--
DECLARE CUR CURSOR FOR
SELECT DISTINCT NroTicket FROM sitos.dbo.t_calidad
WHERE newPeso = 0;

DECLARE @vNroTicket NVARCHAR(MAX);
OPEN cur
FETCH cur INTO @vNroTicket

WHILE (@@FETCH_STATUS=0)
BEGIN
	UPDATE sitos.dbo.t_calidad
	SET NewPeso = (
		SELECT ISNULL(CAST(SUM(PesoNetoSalida) as decimal(10,2)),0)
		FROM sitos.dbo.t_spa
		WHERE Ticket = @vNroTicket
	)
	WHERE NroTicket = @vNroTicket
	FETCH cur INTO @vNroTicket
END
CLOSE cur
DEALLOCATE cur
--
SELECT
	TipoMaterial,
	SUM(NewPeso) PNS,
	COUNT(*) Viajes
FROM sitos.dbo.t_calidad
WHERE Relac = '2014-50'
GROUP BY RELAC,TipoMaterial
ORDER BY 3 DESC;
--
DROP TABLE dbo.t_ventasCucuta;
SELECT * INTO t_ventasCucuta FROM dbtraz.traz.dbo.vexporttoorbis3;
--
SELECT * FROM dbo.t_ventasCucuta b
WHERE NOT EXISTS(
	SELECT 1 FROM dbo.HojaExporta A
	WHERE a.ReciboEmpresa COLLATE Modern_Spanish_CI_AS = b.ReciboRecepcion COLLATE Modern_Spanish_CI_AS
)
ORDER BY 2;
--
DECLARE CUR CURSOR FOR
SELECT DISTINCT ReciboRecepcion FROM dbo.t_ventasCucuta

DECLARE @Rebibo VARCHAR(MAX)
DECLARE @Relac VARCHAR(7)

OPEN CUR
FETCH CUR INTO @Rebibo
WHILE ( @@FETCH_STATUS = 0 )
	BEGIN
		UPDATE t_ventasCucuta
		SET RelacWeekly = ISNULL(
			(SELECT Weekly FROM dbo.HojaExporta
				WHERE ReciboEmpresa = @Rebibo),'XXXX-XX'),
			FechaIso = ISNULL((	SELECT FechaIso FROM dbo.HojaExporta 
				WHERE ReciboEmpresa = @Rebibo),NULL)
		WHERE ReciboRecepcion = @Rebibo		
		FETCH cur INTO @Rebibo
	END
CLOSE cur
DEALLOCATE cur;
--
SELECT RelacWeekly,SUM(netorecepcion)
FROM dbo.t_ventasCucuta
WHERE RelacWeekly <> 'XXXX-XX'
GROUP BY RelacWeekly
ORDER BY 1;
--
SELECT DISTINCT ReciboRecepcion
FROM dbo.t_ventasCucuta
WHERE RelacWeekly <> 'XXXX-XX';
--
SELECT weekly,sum(toneladasnetas)
FROM dbo.HojaExporta
GROUP BY weekly;
--
SELECT * FROM dbo.t_ventasCucuta
WHERE relacWeekly = '2014-03'
AND ReciboRecepcion = 'D-5768'
ORDER BY 3;
--
SELECT * FROM dbo.HojaExporta
WHERE Weekly = '2014-03'
AND reciboEmpresa = 'D-5768'
ORDER BY 3;