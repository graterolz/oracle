SELECT * FROM STAR01.dbo.tras_alm
SELECT * FROM STAR01.dbo.reng_tra
--
USE ELZYRA EXEC pIncluyeTraslado
--
SELECT * FROM ELZYRA.dbo.Comision_AsVeh
SELECT * FROM ELZYRA.dbo.Comision_AsVehDetalle
--
SELECT * FROM ELZYRA.dbo.Comision_AsigVeh
SELECT * FROM ELZYRA.dbo.Comision_AsigVehDetalle
--
ALTER TABLE [ELZYRA].[dbo].[Comision_AsVehDetalle] DROP CONSTRAINT [FK_Comision_AsVehDetalle]
ALTER TABLE [ELZYRA].[dbo].[Comision_AsVehDetalle] WITH CHECK ADD CONSTRAINT [FK_Comision_AsVehDetalle] FOREIGN KEY([id_caveh]) REFERENCES [ELZYRA].[dbo].[Comision_AsVeh] ([id_caveh])
ALTER TABLE [ELZYRA].[dbo].[Comision_AsVehDetalle] CHECK CONSTRAINT [FK_Comision_AsVehDetalle]
--
ALTER TABLE [ELZYRA].[dbo].[Comision_AsigVehDetalle] DROP CONSTRAINT [FK_Comision_AsigVehDetalle]
ALTER TABLE [ELZYRA].[dbo].[Comision_AsigVehDetalle] WITH CHECK ADD CONSTRAINT [FK_Comision_AsigVehDetalle] FOREIGN KEY([id_comi_aveh]) REFERENCES [ELZYRA].[dbo].[Comision_AsigVeh] ([id_comi_aveh])
ALTER TABLE [ELZYRA].[dbo].[Comision_AsigVehDetalle] CHECK CONSTRAINT [FK_Comision_AsigVehDetalle]
--
SELECT * FROM MICHI01.dbo.descuen
DELETE FROM MICHI01.dbo.descuen
--
USE STAR01 EXEC sp_help 'dbo.art'
USE STAR01 EXEC sp_help 'dbo.reng_ped'
--
DROP TABLE [ELZYRA].[dbo].[Comision_AsigVeh]
GO
--
CREATE TABLE [ELZYRA].[dbo].[Comision_AsigVeh](
	[id_comi_aveh] [int] IDENTITY(1,1) NOT NULL,
	[grupo] [nvarchar](128) NOT NULL,
	[desde] [datetime] NOT NULL,
	[hasta] [datetime] NOT NULL
 CONSTRAINT [PK_Comision_AsigVeh] PRIMARY KEY CLUSTERED 
(
	[id_comi_aveh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
--
DROP TABLE [ELZYRA].[dbo].[Comision_AsigVehDetalle]
GO
--
CREATE TABLE [ELZYRA].[dbo].[Comision_AsigVehDetalle](
	[id_avehdet] [int] IDENTITY(1,1) NOT NULL,
	[id_comi_aveh] [int] NOT NULL, 
	[alcance_desde] [datetime] NOT NULL,
	[alcance_hasta] [datetime] NOT NULL,
	[grupo] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_Comision_AsigVehDetalle] PRIMARY KEY CLUSTERED 
(
	[id_avehdet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
--
DROP TABLE [ELZYRA].[dbo].[Comision_AsVeh]
GO
--
CREATE TABLE [ELZYRA].[dbo].[Comision_AsVeh](
	[id_caveh] [int] IDENTITY(1,1) NOT NULL,
	[grupo] [nvarchar](128) NOT NULL,	 
	[desde] [datetime] NOT NULL,
	[hasta] [datetime] NOT NULL	
 CONSTRAINT [PK_Comision_AsVeh] PRIMARY KEY CLUSTERED 
(
	[id_caveh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
--
DROP TABLE [ELZYRA].[dbo].[Comision_AsVehDetalle]
GO
--
CREATE TABLE [ELZYRA].[dbo].[Comision_AsVehDetalle](
	[id_civehd] [int] IDENTITY(1,1) NOT NULL,
	[id_caveh] [int] NOT NULL,
	[alcance_d] [decimal](10,2) NOT NULL,
	[alcance_h] [decimal](10,2) NOT NULL,
	[asignacion] [nvarchar](128) NOT NULL
 CONSTRAINT [PK_Comision_AsVehDetalle] PRIMARY KEY CLUSTERED 
(
	[id_civehd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
--
DECLARE @co_art char(30)
DECLARE @co_alma char(6)
DECLARE @new_sstock_com decimal(18,2)
DECLARE @new_sstock_act decimal(18,2)
--
DECLARE CUR_Arts_Det CURSOR FOR
SELECT --TOP(10)
	A.co_art,
	R.co_alma,
	MAX(CASE
		WHEN relac_aut IN (1,4) THEN 0
		WHEN relac_aut = 2 THEN (S.stock_com*A.uni_relac) 
		WHEN relac_aut = 3 THEN (S.stock_com/A.uni_relac)
		ELSE 1
	END) new_sstock_com,
	MAX(CASE
		WHEN relac_aut IN (1,4) THEN 0
		WHEN relac_aut = 2 THEN (S.stock_act*A.uni_relac) 
		WHEN relac_aut = 3 THEN (S.stock_act/A.uni_relac)
		ELSE 1
	END) new_sstock_act
FROM STAR01.dbo.art A
LEFT JOIN STAR01.dbo.reng_ped R on A.co_art=R.co_art
INNER JOIN STAR01.dbo.pedidos P on P.fact_num=R.fact_num
INNER JOIN STAR01.dbo.st_almac S ON S.co_alma = R.co_alma AND S.co_art = R.co_art
WHERE P.anulada=0
AND status<=1
--AND A.co_art = '1102001PB'
AND uni_relac > 0
GROUP BY A.co_art,R.co_alma
ORDER BY A.co_art
--
DECLARE CUR_Arts CURSOR FOR 
SELECT --TOP(10)
	A.co_art,	
	MAX(CASE
		WHEN A.relac_aut IN (1,4) THEN 0
		WHEN A.relac_aut = 2 THEN (A.stock_com*A.uni_relac)
		WHEN A.relac_aut = 3 THEN (A.stock_com/A.uni_relac)
		ELSE 1
	END) new_sstock_com,
	MAX(CASE
		WHEN A.relac_aut IN (1,4) THEN 0
		WHEN A.relac_aut = 2 THEN (A.stock_act*A.uni_relac) 
		WHEN A.relac_aut = 3 THEN (A.stock_act/A.uni_relac)
		ELSE 1
	END) new_sstock_act
FROM STAR01.dbo.art A
LEFT JOIN STAR01.dbo.reng_ped R on A.co_art=R.co_art
INNER JOIN STAR01.dbo.pedidos P on P.fact_num=R.fact_num
WHERE P.anulada=0
AND status<=1
--AND A.co_art = '1102001PB'
AND uni_relac > 0
GROUP BY A.co_art
ORDER BY A.co_art
--
OPEN CUR_Arts_Det
FETCH NEXT FROM CUR_Arts_Det INTO @co_art,@co_alma,@new_sstock_com,@new_sstock_act;
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE TOP(1) STAR01.dbo.st_almac
	SET sstock_com = @new_sstock_com
	WHERE co_art = rtrim(ltrim(@co_art))
	AND co_alma = rtrim(ltrim(@co_alma))
	
	FETCH NEXT FROM CUR_Arts_Det INTO @co_art,@co_alma,@new_sstock_com,@new_sstock_act;
END
CLOSE CUR_Arts_Det; 
DEALLOCATE CUR_Arts_Det;
--
OPEN CUR_Arts
FETCH NEXT FROM CUR_Arts INTO @co_art,@new_sstock_com,@new_sstock_act;
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE TOP(1) STAR01.dbo.art
	SET sstock_com = @new_sstock_com
	WHERE co_art = rtrim(ltrim(@co_art))
	FETCH NEXT FROM CUR_Arts INTO @co_art,@new_sstock_com,@new_sstock_act;
END
CLOSE CUR_Arts; 
DEALLOCATE CUR_Arts;
--
DELETE FROM MICHI01.dbo.descuen
GO
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'Avisos Demo',
@recipients = 'sistemas@demo.com.ve',
@blind_copy_recipients = 'soporte04@demo.com.ve',
@subject = 'Confirmacion de borrado de Descuentos del 30% y 50% en MICHI01',
@body = 'Confirmacion de borrado de Descuentos del 30% y 50% en MICHI01',
@body_format = 'HTML',
@importance = 'High'