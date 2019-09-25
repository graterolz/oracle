USE ELZYRA EXEC ELZYRA.dbo.pIncluyeAjuste
USE ELZYRA EXEC ELZYRA.dbo.pIncluyeAjusteReng @ajue_num = 59
--
SELECT * FROM ARCO.dbo.ajuste
SELECT * FROM ARCO.dbo.reng_aju WHERE ajue_num = 59
--
SELECT * FROM STAR01.dbo.pedidos WHERE fact_num = 35751
SELECT * FROM STAR01.dbo.st_almac
--
SELECT TOP(10)
max(p.fact_num) fact_num,
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
	END) new_sstock_act,
	P.status,
	relac_aut
FROM STAR01.dbo.art A
LEFT JOIN STAR01.dbo.reng_ped R ON A.co_art=R.co_art
INNER JOIN STAR01.dbo.pedidos P ON P.fact_num=R.fact_num
INNER JOIN STAR01.dbo.st_almac S ON S.co_alma = R.co_alma AND S.co_art = R.co_art
WHERE P.anulada=0
AND status<=1
AND A.co_art = '2001706'
AND uni_relac > 0
GROUP BY A.co_art,R.co_alma,P.status,relac_aut
ORDER BY A.co_art
--
SELECT R.co_art,SUM(pendiente) Stock_com
FROM STAR01.dbo.pedidos P
INNER JOIN STAR01.dbo.reng_ped R ON R.fact_num=P.fact_num
WHERE P.anulada=0
AND P.status<=1
AND R.co_art='2001706'
AND pendiente>0
GROUP BY R.co_art
--
SELECT R.co_art,SUM(pendiente) Stock_com
FROM STAR01.dbo.pedidos P
INNER JOIN STAR01.dbo.reng_ped R ON R.fact_num=P.fact_num
WHERE P.anulada=0
AND P.status<=1
AND R.co_art='2001706'
AND pendiente>0
AND co_alma='001'
GROUP BY R.co_art
--
EXEC ELZYRA.dbo.pAjustaInventarios
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_AdelantoComisiONes
EXEC ELZYRA.dbo.pSender_Mail_AdelantoComisiONes @Co_empresa = 'STAR01'
EXEC ELZYRA.dbo.pSender_Mail_AdelantoComisiONes @Co_empresa = N'OverlAND'
--
USE [ELZYRA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[pAjustaInventarios]
AS
BEGIN
	SET NOCOUNT ON;
	--	
	--
	Declare @Xsql nvarchar(max),@Almacen nchar(10),@Empresa nchar(20),@Params nvarchar(max),@Articulo nchar(30),@Stock_C decimal(10,5),@Stock_CS decimal(10,5),@Mensaje nchar(100)
	Declare @Cert_Global table (co_art nchar(30),relac_aut int,uni_relac decimal(10,5),Stock_com_cert decimal(10,5), SStock_com_cert decimal(10,5));
	Declare @Cert_Global_Almacen table (co_art nchar(30),relac_aut int,uni_relac decimal(10,5),Stock_com_cert decimal(10,5), SStock_com_cert decimal(10,5));

	Declare empresas Cursor FOR select 'STAR01' --select base_dato from ELZYRA.dbo.Empresas
	Open empresas 
	FETCH NEXT FROM empresas into @Empresa
    WHILE @@FETCH_STATUS = 0 
    BEGIN	
		set @Almacen = (select top (1) almacen from ELZYRA.dbo.Empresas where base_dato = @Empresa)

		set @Xsql = 'With CTE_Com as
			(
				select R.co_art,sum(pendiente) Stock_com
				from '+rtrim(@Empresa)+'.dbo.pedidos P
				inner join '+rtrim(@Empresa)+'.dbo.reng_ped R on R.fact_num=P.fact_num
				where P.anulada=0 and P.status<=1 and pendiente>0
				group by R.co_art
			)
			select A.co_art,A.relac_aut,A.uni_relac,isnull(C.Stock_com,0.00000) Stock_com_cert,
			(CASE
				WHEN relac_aut IN (1,4) THEN 0
				WHEN relac_aut = 2 THEN (isnull(C.Stock_com,0.00000)*A.uni_relac) 
				WHEN relac_aut = 3 THEN (isnull(C.Stock_com,0.00000)/A.uni_relac)
				ELSE 1
			END) SStock_com_cert
			from '+rtrim(@Empresa)+'.dbo.Art A
			left join CTE_Com C on C.co_art=A.co_art
			where A.tipo<>''S'';'

		insert into @Cert_Global
		EXEC sp_executesql @Xsql

		set @Xsql = 'With CTE_Com as
			(
				select R.co_art,sum(pendiente) Stock_com
				from '+rtrim(@Empresa)+'.dbo.pedidos P
				inner join '+rtrim(@Empresa)+'.dbo.reng_ped R on R.fact_num=P.fact_num
				where P.anulada=0 and P.status<=1 and pendiente>0 and co_alma = @A
				group by R.co_art
			)
			select A.co_art,A.relac_aut,A.uni_relac,isnull(C.Stock_com,0.00000) Stock_com_cert,
			(CASE
				WHEN relac_aut IN (1,4) THEN 0
				WHEN relac_aut = 2 THEN (isnull(C.Stock_com,0.00000)*A.uni_relac) 
				WHEN relac_aut = 3 THEN (isnull(C.Stock_com,0.00000)/A.uni_relac)
				ELSE 1
			END) SStock_com_cert
			from '+rtrim(@Empresa)+'.dbo.Art A
			left join CTE_Com C on C.co_art=A.co_art
			where A.tipo<>''S'' '

		set @Params = N'@A nchar(10)'
		insert into @Cert_Global_Almacen
		EXEC sp_executesql @Xsql,@Params,@A=@Almacen

		Declare cur_art cursor for select co_art from @Cert_Global where co_art='2001706'
		Open cur_art 
		FETCH NEXT FROM cur_art into @Articulo
		WHILE @@FETCH_STATUS = 0 
		BEGIN
			set @Xsql = 'update '+rtrim(@Empresa)+'.dbo.Art set stock_com = @SC, sstock_com=@SCS where co_art = @A'
			Set @Params = N'@SC decimal(10,5),@SCS decimal(10,5), @A nchar(30)'
			set @Stock_C = (select Stock_com_cert from @Cert_Global where co_art=@Articulo)
			set @Stock_CS = (select SStock_com_cert from @Cert_Global where co_art=@Articulo)

			EXEC sp_executesql @Xsql,@Params,@SC=@Stock_C,@SCS=@Stock_CS,@A=@Articulo

			set @Xsql = 'update '+rtrim(@Empresa)+'.dbo.ST_almac set stock_com = @SC, sstock_com=@SCS where co_art = @A and co_alma=@C'
			Set @Params = N'@SC decimal(10,5),@SCS decimal(10,5), @A nchar(30),@C nchar(10)'
			set @Stock_C = (select Stock_com_cert from @Cert_Global where co_art=@Articulo)
			set @Stock_CS = (select SStock_com_cert from @Cert_Global where co_art=@Articulo)
			EXEC sp_executesql @Xsql,@Params,@SC=@Stock_C,@SCS=@Stock_CS,@A=@Articulo,@C=@Almacen

			FETCH NEXT FROM cur_art into @Articulo
		END
		CLOSE cur_art
		DEALLOCATE cur_art

		set @Mensaje = 'Se realizo la actualizacion de los stocks para: '+rtrim(@Empresa)
		
		EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'Avisos Demo',
		--@recipients = '', 
		--@copy_recipients = '',
		@blind_copy_recipients = 'soporte04@demo.com.ve;sistemas@demo.com.ve',
		@subject = 'Actualizacion de STOCKS',
		@body = @Mensaje,
		@body_format = 'HTML',
		@importance = 'High'
		
		FETCH NEXT FROM empresas into @Empresa
	END
	CLOSE empresas
	DEALLOCATE empresas
END