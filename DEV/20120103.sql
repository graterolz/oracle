UPDATE [db_Olimpo].[dbo].[0116_Firma_Saliente_historico]
SET img_anverso = NULL
WHERE year(fecha) = 2012
AND month(fecha) = 8

UPDATE [db_Olimpo].[dbo].[0116_Firma_Saliente_historico]
SET img_reverso = NULL
WHERE year(fecha) = 2012
AND month(fecha) = 8

UPDATE [db_Olimpo].[dbo].[0116_Firma_Entrante_historico]
SET img_anverso = NULL
WHERE year(fecha) = 2012
AND month(fecha) = 8

UPDATE [db_Olimpo].[dbo].[0116_Firma_Entrante_historico]
SET img_reverso = NULL
WHERE year(fecha) = 2012
AND month(fecha) = 8
--
UPDATE [db_Olimpo].[dbo].[0116_Firma_Saliente_historico]
SET img_anverso = NULL
WHERE CONVERT(VARCHAR, FECHA, 112) < = convert(varchar, getdate() - 365, 112)

UPDATE [db_Olimpo].[dbo].[0116_Firma_Saliente_historico]
SET img_reverso = NULL
WHERE CONVERT(VARCHAR, FECHA, 112) < = convert(varchar, getdate() - 365, 112)

UPDATE [db_Olimpo].[dbo].[0116_Firma_Entrante_historico]
SET img_anverso = NULL
WHERE CONVERT(VARCHAR, FECHA, 112) < = convert(varchar, getdate() - 365, 112)

UPDATE [db_Olimpo].[dbo].[0116_Firma_Entrante_historico]
SET img_reverso = NULL
WHERE CONVERT(VARCHAR, FECHA, 112) < = convert(varchar, getdate() - 365, 112)
--
DECLARE @fechafin VARCHAR(10)
SET @fechafin = '02/10/2011'

SELECT
	Substring(CONVERT(VARCHAR, requerimientos.fechaini, 111), 1, 7) AS Fecha,
	Count(*) Cantidad
FROM resultado
INNER JOIN requerimientos
INNER JOIN tipooperacion ON requerimientos.fk_tipooper = tipooperacion.id_tipooperacion ON resultado.id_resultado = requerimientos.fk_resultado
INNER JOIN estatus ON requerimientos.fk_estatus = estatus.id_estatus
INNER JOIN bd_por_servidor ON requerimientos.fk_bd = bd_por_servidor.id_bdserver
INNER JOIN manejadorbd ON bd_por_servidor.fk_manejadorbd = manejadorbd.id_manejadorbd
INNER JOIN servidor
INNER JOIN ambiente ON servidor.fk_ambiente = ambiente.id_ambiente ON bd_por_servidor.fk_servidor = servidor.id_servidor
INNER JOIN basedato ON bd_por_servidor.fk_bd = basedato.id_bd
INNER JOIN actividad ON requerimientos.fk_actividad = actividad.id_actividad
INNER JOIN macroactividad ON actividad.fk_macroactividad = macroactividad.id_macroactividad
LEFT JOIN analistasxrequerimiento ON requerimientos.id_requerimiento = analistasxrequerimiento.id_requerimiento
LEFT JOIN dba ON analistasxrequerimiento.id_analista = dba.id_dba
WHERE tipooperacion.tipooperacion <> 'Trabajos Planificados DBA'
GROUP BY Substring(CONVERT(VARCHAR, requerimientos.fechaini, 111), 1, 7)
ORDER BY Substring(CONVERT(VARCHAR, requerimientos.fechaini, 111), 1, 7)

------ Version POrtal SilverLight
DECLARE @fechafin VARCHAR(10)

SET @fechafin = '02/10/2011' --MM/dd/yyyy
SELECT
	Substring(CONVERT(VARCHAR, requerimientos.fechaini, 111), 1, 7) AS Fecha,
	Count(*) AS Cantidad
FROM resultado
INNER JOIN requerimientos
INNER JOIN tipooperacion ON requerimientos.fk_tipooper = tipooperacion.id_tipooperacion ON resultado.id_resultado = requerimientos.fk_resultado
GROUP  BY Substring(CONVERT(VARCHAR, requerimientos.fechaini, 111), 1, 7)
ORDER  BY Substring(CONVERT(VARCHAR, requerimientos.fechaini, 111), 1, 7)
--
USE [Debitos_Directos]
GO

CREATE TABLE #usuarios(
	nombre varchar(50),
	usuario varchar (65),
	fechaUltimoAcceso datetime,
	estadoUsuario varchar (10)	
)

INSERT INTO #usuarios
SELECT
	su.nombre,
	su.usuario,
	su.fechaUltimoAcceso,
	su.estadoUsuario
FROM seguridad_Profile as sp, seguridad_Usuario as su 
WHERE su.profile=sp.id and su.estadoUsuario=10
ORDER BY su.nombre

UPDATE #usuarios
SET estadoUsuario = 'Activo'
WHERE estadoUsuario=10 

SELECT * FROM #usuarios
DROP TABLE #usuarios
--
use SIEF_BlueBird

IF OBJECT_ID('TempGenMateriales') IS NOT NULL DROP TABLE TempGenMateriales
IF OBJECT_ID('TempGenEquivalencias2') IS NOT NULL DROP TABLE TempGenEquivalencias2
IF OBJECT_ID('TempAlmMatUbicaciones') IS NOT NULL DROP TABLE TempAlmMatUbicaciones
--
USE SIEF_EXPF_Prod
IF OBJECT_ID('TempGenEquivalencias2') IS NOT NULL DROP TABLE TempGenEquivalencias2
CREATE TABLE TempGenEquivalencias2 (
	TablaEquivalencia nvarchar (50), IDSIEF nvarchar(30), IDEXT nvarchar(30)
)

INSERT INTO TempGenEquivalencias2 (TablaEquivalencia, IDSIEF, IDEXT)
SELECT TablaEquivalencia, IDSIEF, IDEXT
FROM GenEquivalencias
WHERE TablaEquivalencia = 'comIvas' OR TablaEquivalencia = 'AlmClaDetalles'
--
USE SIEF_EXPF_Prod

INSERT INTO GenEquivalencias (TablaEquivalencia, IDSIEF, IDEXT)
SELECT TablaEquivalencia, IDSIEF, IDEXT
FROM TempGenEquivalencias

DROP TABLE TempGenEquivalencias
--
USE sief_bliebird

INSERT INTO AlmMatUbicaciones (IdMaterial, IdUbicacion, iMinimo, iReorden, iMaximo, iStock, CostoProm, IdConteo, IdEstado, IvaPromedio, idbodega, CantidadReserva)
SELECT IdMaterial, IdUbicacion, iMinimo, iReorden, iMaximo, iStock, CostoProm, IdConteo, IdEstado, IvaPromedio, idbodega, CantidadReserva
FROM TempAlmMatUbicaciones
--
SELECT * FROM ProcesosMasivos.ProcesoMasivo
SELECT * FROM genMaterialesInteroperabilidad where procesado = 0
SELECT COUNT(*) FROM AlmmatubicacionesInteroperabilidad where Procesado = 0
SELECT * FROM AlmSolicitudesInterOperabilidad where procesado = 0
--
UPDATE ProcesosMasivos.ProcesoMasivo
SET ProcesoMasivoError = '-',
	EstadoProcesoMasivoId = 2
WHERE ProcesoMasivoid in (1,2,3)
--
SELECT @@SERVERNAME EquipoRemoto,db_name() BaseEjecucion,getdate() HoraEjecucionRemota
--
SELECT * FROM AlmmatubicacionesInteroperabilidad WHERE id = 1181792
--
UPDATE AlmmatubicacionesInteroperabilidad
SET Procesado = 0
WHERE id = 1181792
--
SELECT a.*,b.Nombres,b.Apellidos,b.Email
FROM ManTempKM a
INNER JOIN secUsuarios b on a.IdUsuario = b.Id
--
SELECT * FROM secusuarios 
--
SELECT * FROM genauditorias
WHERE argumentos LIKE '%Admin%'
AND descripcion LIKE '%ManCargarArchivoTxt%'
--
SELECT *
FROM genAuditoriasRespaldoGeneral
WHERE argumentos LIKE '%Admin%'
AND descripcion LIKE '%ManCargarArchivoTxt%'
--
SELECT *
FROM secUsuarios
WHERE Id = (
	SELECT IdUsuario
	FROM secSesion
	WHERE IdSesion = 262953
)
--
SELECT *
FROM genAuditoriasRespaldoGeneral
WHERE Operacion = 'ManCargarArchivoTxt' 
AND Fecha > '01/03/2015'
AND SesionId = 262953
--
SELECT
	s.NoOC NroOrden,
	ds.NoOt OT,
	s.FechaSol FechaOrden,
	p.NomProveedor Proveedor,
	b.NomBodega Bodega,
	e.NomSolEstado Estado,
	ds.Valor ValorSinIva,
	i.FactorIva,
	(ds.Valor * i.FactorIva) ValorIva,
	ds.Valor + (ds.Valor * i.FactorIva) ValorConIVa
FROM comDetalleOrdenServicio ds
INNER JOIN AlmSolicitudes s ON ds.idsolicitud = s.IdSolicitud
INNER JOIN genProveedores p ON s.IdProveedor = p.IdProveedor
INNER JOIN genBodegas b ON s.idbodega = b.idbodega
INNER JOIN AlmSolEstados e ON s.IdSolEstado = e.IdSolEstado
INNER JOIN comIvas i ON i.Id = ds.IdIva
WHERE IdRadicacion IS NULL
ORDER BY s.FechaSol 
--
SELECT * FROM dbo.genMateriales WHERE IdMaterial = 10013273
SELECT * FROM lla_diseño WHERE NOM_DISEÑO LIKE '%G667_235/75R17.5%'
SELECT * FROM LLA_MARCABANDA
SELECT * FROM lla_profundidad
--
BEGIN TRAN 
	SELECT * FROM dbo.genMateriales WHERE IdMaterial = 10013273
	UPDATE dbo.genMateriales SET iddiseño = 71 WHERE IdMaterial = 10013273
	SELECT * FROM dbo.genMateriales WHERE IdMaterial = 10013273
ROLLBACK
--
SELECT * FROM genpersonal WHERE apellidos like '%rojano%'
SELECT * FROM perdotacion WHERE identificacion = '1118863056'
SELECT * FROM perdotacion WHERE identificacion = '1118883058'
SELECT * FROM almmovimientos WHERE recibeentrega = '1118863056'
SELECT * FROM almmovimientos WHERE recibeentrega = '1118883058'
SELECT * FROM percapacitacion WHERE identificacion = '1118863056'
SELECT * FROM percapacitacion WHERE identificacion = '1118883058'
--
SELECT * FROM [Seguridad].[Usuario]
SELECT * FROM [Administracion].[Bodega]
SELECT * FROM genbodegas
--
SELECT
	UsuarioIdentificacion,
	BodegaCodigo,
	BodegaNombre,
	UsuarioBodegaPorDefecto
FROM [Seguridad].[Usuario] U
INNER JOIN [Seguridad].[UsuarioBodega] ub on u.UsuarioId = ub.UsuarioId
INNER JOIN [Administracion].[Bodega] b on ub.BodegaId= b.BodegaId
WHERE u.usuarioid = 3
ORDER BY UsuarioBodegaPorDefecto desc
--
SELECT * FROM [Seguridad].[UsuarioPatio]
SELECT * FROM [dbo].[MANLugarDeReporte]
SELECT * FROM [dbo].[GenClientes]
--

UPDATE a
SET a.fechacompromiso =  d.fechacompromiso
FROM AlmDetMovimientos a
INNER JOIN AlmMovimientos b on a.idmovimiento = b.idmovimiento
INNER JOIN almsolicitudes c on b.nooc = c.nooc
INNER JOIN almdetsolicitudes d on c.idsolicitud = d.idsolicitud and d.idmaterial = a.idmaterial
WHERE a.idmovimiento IN (
	SELECT idmovimiento
	FROM almmovimientos
	WHERE nooc in (61,134,175,6245)
)
AND a.fechacompromiso IS NULL
AND idconcepto = 6
AND b.idproveedor = 49
--
SELECT
	a.idmaterial as Cod_Sief,
	a.nommaterial as Nom_Material,
	d.nomclamayor as ClasificacionMayor,
	e.nomcladetalle as ClasificacionMenor,
	c.nombodega as Bodega
FROM
	genmateriales a,
	almmatubicaciones b,
	genbodegas c,
	almclamayores d,
	almcladetalles e
WHERE a.idmaterial = b.idmaterial
AND b.idbodega = c.idbodega
AND a.idcladetalle = e.idcladetalle
AND e.idclamayor = d.idclamayor
AND a.idestado = 2
AND b.idbodega IN (1,8,7)
ORDER BY b.idbodega,a.idmaterial
--
SELECT * FROM prg.PRGTipologiaOBA
SELECT * FROM [dbo].[GenEmpresas]
SELECT * into MANEstadoCargueKm_bk_09072015 FROM MANEstadoCargueKm
--
SELECT
	aot.NoOT,
	aot.NoDeposito,
	aot.NoBus,
	aot.Noact,
	gact.Descripcion GrupoActividad,
	act.Descripcion NombreActividad,
	aot.Observacion ObsActividad,
	tp.Descripcion TipoBus
FROM dbo.ManActividadesOT aot
INNER JOIN dbo.ManTipoBus tp ON aot.TipoBus = tp.NoTipoBus
INNER JOIN dbo.ManActividades act ON act.noact = aot.noact
INNER JOIN dbo.ManGrupoAct gact ON act.Nogrupo = gact.NoGrupo
--
SELECT
	SolAct.Noot,
	SolAct.nodeposito,
	SolAct.NoAct,
	SolAct.NoBus,
	solact.NoSolucion,
	solact.Observacion,
	solact.fecha,
	sol.Nombre NombreSolucion,
	solact.CantSoluciones
FROM dbo.ManSolucionAct solact
INNER JOIN dbo.MANSoluciones sol ON sol.NoSolucion = SolAct.NoSolucion
--
SELECT
	lo.Consecutivo NoOT,
	lo.Codbodega NoDeposito,
	upper(u.Nombres + ' ' + u.Apellidos) UsuarioApertura
FROM dbo.ManLogOT lo
INNER JOIN dbo.secUsuarios u ON lo.idusuario = u.Id
WHERE Descripcion = 'Apertura OT'
--
SELECT
	lo.Consecutivo NoOT,
	lo.Codbodega NoDeposito,
	upper(u.Nombres + ' ' + u.Apellidos) UsuarioEjecuta
FROM dbo.ManLogOT lo
INNER JOIN dbo.secUsuarios u ON lo.idusuario = u.Id
WHERE Descripcion = 'Ejecuta OT'
--
SELECT
	lo.Consecutivo NoOT,
	lo.Codbodega NoDeposito,
	upper(u.Nombres + ' ' + u.Apellidos) UsuarioCierre
FROM dbo.ManLogOT lo
INNER JOIN dbo.secUsuarios u ON lo.idusuario = u.Id
WHERE Descripcion = 'Cierre OT'
--
SELECT
	lo.Consecutivo NoOT,
	lo.Codbodega NoDeposito,
	upper(u.Nombres + ' ' + u.Apellidos) UsuarioAnula
FROM dbo.ManLogOT lo
INNER JOIN dbo.secUsuarios u ON lo.idusuario = u.Id
WHERE Descripcion = 'OT Anulada'
--
SELECT
	lo.Consecutivo NoOT,
	lo.Codbodega NoDeposito,
	upper(u.Nombres + ' ' + u.Apellidos) UsuarioAnula
FROM dbo.ManLogOT lo
INNER JOIN dbo.secUsuarios u ON lo.idusuario = u.Id
WHERE Descripcion = 'OT Anulada'
--
SELECT
	Cs.Noot,
	Cs.nodeposito,
	Cs.NoBus,
	Cs.NoAct,
	c.NoCausa,
	c.Nombre,
	cs.Observacion,
	cs.Fecha
FROM dbo.ManCausaSol cs
INNER JOIN dbo.ManCausas c ON cs.NoCausa = c.NoCausa
--
USE SIE7E_PRE
BEGIN TRAN
	SELECT *
	FROM Configuracion.ParametrosAplicacion
	WHERE ParametrosAplicacionValor like '%172%'
	--
	UPDATE Configuracion.ParametrosAplicacion
	SET ParametrosAplicacionValor = REPLACE(ParametrosAplicacionValor,'.32','.35')
	WHERE ParametrosAplicacionValor LIKE '%172%'
	--
	SELECT * FROM Configuracion.ParametrosAplicacion
	WHERE ParametrosAplicacionValor LIKE '%172%'
ROLLBACK
--
SELECT * FROM [Configuracion].[ParametrosAplicacion] where 
--
UPDATE Configuracion.ParametrosAplicacion
SET ParametrosAplicacionValor = REPLACE(ParametrosAplicacionValor,'253.32','253.35')
WHERE ParametrosAplicacionValor LIKE '%253.32%'
--
DECLARE @operacion varchar(max) = 'Modificar informacion de activo', @IdActivo int = 2669

SELECT TOP 100
	usuario.Usuario,
	usuario.Nombres+' '+usuario.Apellidos usuario,auditoria.* 
FROM dbo.GenAuditorias auditoria
JOIN dbo.secSesion sesion ON auditoria.SesionId=sesion.IdSesion
JOIN dbo.secUsuarios usuario ON sesion.IdUsuario = usuario.Id
WHERE auditoria.Operacion = @operacion
AND auditoria.Consecutivo = @IdActivo
ORDER BY id DESC
--
use SIE7E_CSC

DELETE FROM [prg].[PRGPublicPrg]
WHERE fecha >= '29-02-2016' 
AND fecha <= '06-03-2016'
AND idtipologia = 20
--
SELECT * FROM [prg].[PRGPublicPrg]
WHERE fecha >= '29-02-2016'
AND fecha <= '06-03-2016'
AND idtipologia = 20
--
SELECT * FROM [prg].[PRGTipologiaOBA]
--
UPDATE AspNetUsers 
SET PasswordHash = 'AFLyImFGn8KHWUNs+ar6dOCFPB1lCYvVJdIPqs4DPBeneUi+ZnCD9ihm6/+5ybZFHA==' 
WHERE UserName = '1018441900'
--
SELECT * FROM [dbo].[AlmOperadores]
SELECT * FROM [dbo].[almRestringirMovimientosGrupo]
SELECT * FROM [dbo].[almConfigCamposEsInventario]
--
SELECT
	CONVERT(DATE,a.FechaCargue) 'Fecha Cargue',
	c.nombre,
	b.NomEstacion 'Estacion'
FROM MANEstadoCargueKm  AS a
JOIN dbo.ManGrupoEstacion AS b ON a.idEstacion_Fk = b.IdEstacion
JOIN dbo.MANGrupoCargaKilometraje AS c ON a.GrupoCargueKM = c.id
WHERE convert(date,FechaCargue) BETWEEN convert(date,'29-06-2017') AND convert(date,'14-07-2017')
ORDER BY 1 DESC
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
SELECT
	*,
	a.idmaterial AS Cod_Sief,
	a.nommaterial AS Nom_Material,
	d.nomclamayor AS ClasificacionMayor,
	e.nomcladetalle AS ClasificacionMenor,
	c.nombodega AS Bodega
FROM
	genmateriales a,
	almmatubicaciones b,
	genbodegas c,
	almclamayores d,
	almcladetalles e
WHERE a.idmaterial = b.idmaterial
AND b.idbodega = c.idbodega
AND a.idcladetalle = e.idcladetalle
AND e.idclamayor = d.idclamayor
AND a.idestado = 2
AND b.idbodega IN (1,8,7)
ORDER BY b.idbodega, a.idmaterial
--
SELECT
	c.nombres,
	c.apellidos,
	a.identificacion,
	e.descargo as Cargo,
	d.Nombre as CentrodeCosto,
	c.fechaingreso,
	a.codMaterial,
	b.NomMaterial as 'Material/Talla',
	c.estadolaboral 
FROM PERDotacionEmpleado a
INNER JOIN GenMateriales b on a.codmaterial = b.idmaterial
INNER JOIN Genpersonal c on a.identificacion = c.identificacion
INNER JOIN GenAreas d on c.IdArea = d.IdArea
INNER JOIN gencargo e on c.codcargo = e.codcargo
WHERE a.estado = 2
AND c.estadolaboral = 'ACTIVO'
AND c.idestadolaboral = 2
ORDER BY a.identificacion
--
SELECT * FROM GenPersonal WHERE codigo = '110597'
--
SELECT
	servicio.Servicio,prg.tabla,prg.*
FROM OPEProgramacion prg
JOIN ACCServicio servicio ON servicio.codServicio = prg.codServicio
WHERE prg.fecha = '11/02/2020'
AND prg.identificacion = 1072425688
--
SELECT * FROM GenPersonal WHERE identificacion = '1072425688'
--
SELECT * FROM almacen.MaterialUbicacion
WHERE bodegaid = 42
AND materialid = 799
--
SELECT * FROM almacen.Material
WHERE MaterialCodigoSief = '2143'
-- 
SELECT * FROM administracion.Bodega
--
SELECT * FROM AlmmatubicacionesInteroperabilidad
WHERE idmaterial = '799'
AND procesado = 0
--
UPDATE AlmmatubicacionesInteroperabilidad
SET [insert] = 1
FROM AlmmatubicacionesInteroperabilidad
WHERE idmaterial = '2143'
AND procesado = 0
--
SELECT * FROM AlmmatubicacionesInteroperabilidad
WHERE Procesado = 0