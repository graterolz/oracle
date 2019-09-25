SELECT TOP (1000) [ID],[fecha],[Texto],[IdSigno] FROM [Horoscopo].[dbo].[Horoscopo_Signo_Dia] ORDER BY 1 DESC
SELECT TOP (1000) [ID],[Nombre],[Descripcion],[UrlImagen],[Inicio] ,[Fin] FROM [Horoscopo].[dbo].[Horoscopo_Signo]
--
EXECUTE [Horoscopo].[dbo].[sp_Admin_getAllHoroscopo]
EXECUTE [Horoscopo].[dbo].[sp_Admin_getFechaMax]
EXECUTE [Horoscopo].[dbo].[sp_Admin_getHoroscopoFecha] @fecha = GETDATE()
EXECUTE [Horoscopo].[dbo].[sp_Admin_getHoroscopoHoy]
EXECUTE [Horoscopo].[dbo].[sp_getSignoDiaFecha] @signo = 2
--
SELECT * FROM Horoscopo.dbo.Horoscopo_Signo
SELECT * FROM Horoscopo.dbo.Horoscopo_Signo_Dia
--
SELECT
	Horoscopo.dbo.Horoscopo_Signo_Dia.ID,
	Horoscopo.dbo.Horoscopo_Signo_Dia.Fecha,
	Horoscopo.dbo.Horoscopo_Signo_Dia.Texto,
	Horoscopo.dbo.Horoscopo_Signo_Dia.IdSigno,
	Horoscopo.dbo.Horoscopo_Signo.Nombre,
	Horoscopo.dbo.Horoscopo_Signo.Descripcion,
	Horoscopo.dbo.Horoscopo_Signo.UrlImagen,
	Horoscopo.dbo.Horoscopo_Signo.Inicio,
	Horoscopo.dbo.Horoscopo_Signo.Fin
FROM Horoscopo.dbo.Horoscopo_Signo_Dia
LEFT OUTER JOIN Horoscopo.dbo.Horoscopo_Signo ON Horoscopo.dbo.Horoscopo_Signo_Dia.IdSigno = Horoscopo.dbo.Horoscopo_Signo.ID
WHERE CONVERT(VARCHAR(10),Horoscopo.dbo.Horoscopo_Signo_Dia.Fecha,120) = CONVERT(VARCHAR(10),GETDATE(),120)
--
SELECT * FROM Horoscopo.dbo.Horoscopo_Signo_Dia
SELECT * FROM Horoscopo.dbo.Horoscopo_Signo
--
DECLARE @Fecha DATE = NULL--'2016-02-07';
SELECT
	Horoscopo.dbo.Horoscopo_Signo_Dia.ID ID,
	@Fecha Fecha,	
	Horoscopo.dbo.Horoscopo_Signo_Dia.Texto,
	Horoscopo.dbo.Horoscopo_Signo_Dia.IdSigno,
	Horoscopo.dbo.Horoscopo_Signo.Nombre
FROM Horoscopo_Signo
LEFT OUTER JOIN Horoscopo.dbo.Horoscopo_Signo_Dia ON Horoscopo.dbo.Horoscopo_Signo_Dia.IdSigno = Horoscopo.dbo.Horoscopo_Signo.ID
AND CONVERT(VARCHAR(10),Horoscopo.dbo.Horoscopo_Signo_Dia.Fecha,120) = CONVERT(VARCHAR(10),@Fecha,120)
ORDER BY Horoscopo.dbo.Horoscopo_Signo_Dia.IdSigno