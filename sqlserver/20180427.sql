EXECUTE [Horoscopo].[dbo].[sp_Admin_getAllHoroscopo]
EXECUTE [Horoscopo].[dbo].[sp_Admin_getHoroscopo] @Fecha = '17/04/2016'
EXECUTE [Horoscopo].[dbo].[sp_Admin_getHoroscopo] @Fecha = 'NULL'
--
SELECT * FROM Horoscopo.dbo.Horoscopo_Signo
SELECT * FROM Horoscopo.dbo.Horoscopo_Signo_Dia
--
USE [Objetos]
SELECT *  FROM dbo.Fuentes where Estado = 1
--
EXEC sp_Admin_listarObjetos
--
SELECT * FROM [Objetos].[dbo].[Objetos] WHERE ObjetosID = 168
SELECT * FROM [Objetos].dbo.Objeto_Tag WHERE IDObjeto = 168