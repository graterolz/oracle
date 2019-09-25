EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_VendedoresMix @pGrupo ='Stargas';
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_VendedoresMix @pGrupo ='Overland';
--
SELECT DISTINCT TOP 10 desde,hasta 
FROM ELZYRA.dbo.Ventas_Metas
ORDER BY 1 DESC
--
SELECT * FROM ELZYRA.dbo.Comision_MixVentas
USE ELZYRA
EXEC sp_help 'Comision_MixVentas'
SELECT MAX(desde),MAX(hasta) FROM ELZYRA.dbo.Ventas_Metas
SELECT * FROM ELZYRA.[dbo].[func_MixVentasSG] ('001','2017-01-04 00:00:00.000','2017-04-30 00:00:00.000')
SELECT * FROM ELZYRA.[dbo].[func_MixVentasOVL] ('001','2017-01-04 00:00:00.000','2017-04-30 00:00:00.000')
--
SELECT CONVERT(DATETIME,'2017-04-30 00:00:00.000')
--
SELECT DISTINCT
	desde,
	CONVERT(DATETIME,desde),
	hasta,
	CONVERT(DATETIME,hasta)
FROM ELZYRA.dbo.Ventas_Metas
--
SELECT DISTINCT TOP 1  convert(char,desde,103), convert(char,hasta,103) 
FROM ELZYRA.dbo.Ventas_Metas
WHERE GETDATE() BETWEEN desde AND hasta
ORDER BY 1 DESC
--
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_VendedoresMix @pGrupo ='Stargas';
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_VendedoresMix @pGrupo ='Overland';
--
EXEC Profit_RG.dbo.pNotificacionEmailAdelantoComisionesSG @Co_empresa = 'STAR01'
EXEC [ELZYRA].[dbo].[pJOB_ELZYRA_Email_AdelantoComisiones]
EXEC [ELZYRA].[dbo].[pSender_Mail_AdelantoComisiones] @Co_empresa = 'STAR01'
EXEC [ELZYRA].[dbo].[pSender_Mail_AdelantoComisiones] @Co_empresa = N'Overland'
--
USE STAR01 EXEC sp_help 'dbo.vendedor'
USE ELZYRA EXEC sp_help 'dbo.Empresas'
--
USE [ELZYRA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[pJOB_ELZYRA_Email_AdelantoComisiones]
AS
BEGIN
	EXEC [ELZYRA].[dbo].[pSender_Mail_AdelantoComisiones] @Co_empresa = N'STAR01'
	EXEC [ELZYRA].[dbo].[pSender_Mail_AdelantoComisiones] @Co_empresa = N'Overland'
END
--
USE [ELZYRA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[pSender_Mail_AdelantoComisiones] 
(
	@Co_empresa NVARCHAR(MAX)
)
AS
BEGIN
	SET NOCOUNT ON;

	Declare @Xsql NVARCHAR(MAX),@PARAMS NVARCHAR(MAX)
	Declare @Resumen Table (
		co_ven nchar(10),ven_des nchar(60),co_cli nchar(10),cli_des nchar(60),fact_num int,
		MontoFactura decimal(18,2),grupo nchar(60),factor decimal(10,2),factorApl decimal(10,2),
		basecomision decimal(18,2), co_tran nchar(10),des_tran nchar(60),Transporte nchar(60),
		Factor_flete decimal(10,2),ncr decimal(18,2), pdesc decimal(18,6),cob_num int,
		fec_emis datetime,Frecep datetime,Ult_fecha datetime,FechaAdcCobro nchar(30),FR nchar(100),ValidaFRecep nchar(10),dc int,
		Venta decimal(18,2),Meta decimal(18,2),Factor_Mv decimal(10,2),Factor_MvApl decimal(10,2),VentaGrupo decimal(18,2),Ponderacion decimal(10,2),
		Factor_imix decimal(10,2),Factor_imixApl decimal(10,2),Forma_pago nchar(60),Penal_des nchar(60),
		Id_pc int,GrupoPenal nchar(10),Penal_Desde datetime,Penal_hasta datetime,DC_Inicio int,DC_Fin int,Penalizacion decimal(10,2),
		BaseComiDef decimal(18,2),FactorComiDef decimal(10,2),Comision decimal(18,2)
	)
	Declare 
		@Co_ven nchar(10),
		@Porc decimal(10,2),
		@Para nchar(250),
		@CC nchar(250),
		@CCO nchar(250),
		@Perfil nchar(250),
		@Subject nchar(100),
		@CorreoVendedor nchar(100),
		@tableHTML varchar(max),
		@Empresa nchar(100) = (select des_emp from ELZYRA.dbo.Empresas where base_dato = @Co_empresa),
		@Desde datetime = (select convert(char(10), dateadd(d,(day(getdate())*-1)+1,getdate()), 103)),
		@Hasta datetime = (select convert(char(10), dateadd(d,-2,getdate()), 103))

	Declare 
		@Vendedor nchar(60),
		@Comision nchar(18),
		@Porcentaje nchar(10),
		@Adelanto nchar(18)

	Declare @Vendedores table (Co_ven char(6), ven_des varchar(60),email char(40),comision decimal (18,2))
	SET @Xsql='select co_ven,ven_des,email,comision from '+rtrim(@Co_empresa)+'.dbo.vendedor where condic=0'

	insert into @Vendedores
	Exec sp_executesql @Xsql

	DECLARE getVendedor CURSOR FOR
	SELECT co_ven from @Vendedores
	where co_ven not in ('001','TLV01','GV')-- and co_ven = '026'--'026'

	--
	OPEN getVendedor
	FETCH NEXT FROM getVendedor into @Co_ven
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		delete from @Resumen
		
		if @Co_empresa='Overland'
			set @Xsql = (SELECT ELZYRA.[dbo].[func_Script_ComisionOVL] (@Co_empresa) Script)

		if @Co_empresa='STAR01'
			set @Xsql = (SELECT ELZYRA.[dbo].[func_Script_ComisionSG] (@Co_empresa) Script)

		SET @PARAMS = N'@D datetime,@H datetime,@V nchar(10)'

		insert into @Resumen
		Exec sp_executesql	@Xsql,@Params,@D=@Desde,@H=@Hasta,@V=@Co_ven
	
		set @Porc = (select top 1 comision from @Vendedores where co_ven = @Co_ven)

		if (select count(*) from @Resumen)>0
		begin
			set @Vendedor = (ltrim(rtrim((select ven_des from @Vendedores where co_ven = @Co_ven))))
			set @Comision = convert(nchar(18),(select isnull(convert(decimal(18,2),sum((BaseComiDef*(factorApl/100))-((BaseComiDef*(factorApl/100))*Penalizacion/100))),0.00) BaseComision from @Resumen))+' Bsf'
			set @Porcentaje = convert(nchar(10),@Porc) + ' %'
			set @Adelanto = convert(nchar(18),(select isnull(convert(decimal(18,2),sum((BaseComiDef*(factorApl/100))-((BaseComiDef*(factorApl/100))*Penalizacion/100))*(@Porc)/100),0.00) Adelanto from @Resumen))+' Bsf'

			--	Script del correo
			set @CorreoVendedor = ltrim(rtrim((select email from @Vendedores where co_ven = @Co_ven)))
			set @Para = (select case when len(@CorreoVendedor)>0 then @CorreoVendedor+';' else '' end +(select isnull(e_para,space(0)) from ELZYRA.dbo.Notificacion_email where id_tipo = 5 and empresa=@Co_Empresa))
			set @CC = (select isnull(e_cc,space(0)) from ELZYRA.dbo.Notificacion_email where id_tipo = 5 and empresa=@Co_Empresa)
			set @CCO = (select isnull(e_cco,space(0)) from ELZYRA.dbo.Notificacion_email where id_tipo = 5 and empresa=@Co_Empresa)
			set @Perfil = (select isnull(profile_name,space(0)) from ELZYRA.dbo.Notificacion_email where id_tipo = 5 and empresa=@Co_Empresa)
			set @Subject = 'Adelanto Comisiones '+' '+(ltrim(rtrim((select ven_des from @Vendedores where co_ven = @Co_ven))))+' '+datename(MM,Getdate())+' '+convert(nchar(4),year(getdate()))

			--	Maqueta HTML
			DECLARE @head NVARCHAR(MAX)
			SET @head = (select Profit_RG.dbo.func_EmailHeader(('Adelanto Comisiones'),(2)))
			DECLARE @foot NVARCHAR(MAX)
			SET @foot = (select Profit_RG.dbo.func_EmailFooter(@Co_empresa))
			DECLARE @logo NVARCHAR(MAX)
			SET @logo = (select Profit_RG.dbo.func_EmailLogo())

			set @tableHTML = 
			@logo+
			@head+
			N'<h4 style="font-size:15px;color:#2f2f2f;text-transform:uppercase; ">Estimado: '+rtrim(@Vendedor)+'.</h4>'+
			N'<p style="font-size:15px;color:#2f2f2f; ">Le notificamos el monto por Anticipo de Comisiones de la empresa: '+@Empresa+' al fecha de corte '+convert(nchar(10),@Hasta,103)+' .<br/>'+
			N'<table style="width:80%; max-width: 100%;margin:auto;table-layout: fixed;" cellpadding="0" cellspacing="0" border="0">'+
			N'<tr>'+
			N'<th style="font-family:sans-serif;color:#2f2f2f;background:#fff;border-right:0px solid #2f2f2f;border-bottom:1px solid #e4e4e4;border-top: 0px solid #2f2f2f;border-left:0px solid #2f2f2f;font-size:12px;font-weight: 600;margin-left:10px;padding:10px 5px 10px 10px;text-align:left;vertical-align:middle;">&nbsp;Comisión: <span style="font-weight: 400;">'+(Select ELZYRA.dbo.func_ConvertMonto(@Comision, 'BsF',1))+'</span></th>'+
			N'</tr>'+
			N'<tr>'+
			N'<th style="font-family:sans-serif;color:#2f2f2f;background:#fff;border-right:0px solid #2f2f2f;border-bottom:1px solid #e4e4e4;border-top: 0px solid #2f2f2f;border-left:0px solid #2f2f2f;font-size:12px;font-weight: 600;margin-left:10px;padding:10px 5px 10px 10px;text-align:left;vertical-align:middle;" >&nbsp;Porcentaje: <span style="font-weight: 400;">'+@Porcentaje+' %</span></th>'+
			N'</tr>'+
			N'<tr>'+
			N'<th style="font-family:sans-serif;color:#2f2f2f;background:#fff;border-right:0px solid #2f2f2f;border-bottom:1px solid #e4e4e4;border-top: 0px solid #2f2f2f;border-left:0px solid #2f2f2f;font-size:12px;font-weight: 600;margin-left:10px;padding:10px 5px 10px 10px;text-align:left;vertical-align:middle;text-transform:uppercase;" >&nbsp;Adelanto: <span style="font-weight: 400;">'+(Select ELZYRA.dbo.func_ConvertMonto(@Adelanto, 'BsF',1))+'</span></th>'+
			N'</tr>'+
			N'</table>'+
			@foot
			--	Fin Maqueta HTML
						
			if (Len(isnull(@Para,0))+Len(isnull(@CC,0))+Len(isnull(@CCO,0))>0 and Len(isnull(@Perfil,0))>0)
			begin				
				EXEC msdb.dbo.sp_send_dbmail
					@profile_name = @Perfil,
					@recipients = @Para,
					@copy_recipients = @CC,
					@blind_copy_recipients = 'soporte04@demo.com.ve;sistemas@demo.com.ve',--@CCO,
					@subject = @Subject,
					@body = @tableHTML,
					@body_format = 'HTML',
					@importance = 'High'									
			end    
		end
		FETCH NEXT FROM getVendedor into @Co_ven
	END
	CLOSE getVendedor
	DEALLOCATE getVendedor
END
--
USE [ARCO]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [ARCOWELD]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [ARCOWELD_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [ARCOWELD_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [Bioprofit]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [BioStar]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [BLUESTAR]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [BLUESTAR_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [BLUESTAR_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [DEKASA]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [DEKASA_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [DEKASA_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [demo]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [DEMOA]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [DEMOC]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [DEMON]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [ELZYRA]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_owner] ADD MEMBER [FrontEndEH]
GO
USE [FerreNomi]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [GLOBAL]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [GLOBAL_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [GROUP_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [GROUPTA]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [INDUSUCA]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [K2W]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [KELARA]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [KELARA_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [KELARA_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [LYDPLOT]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [LYDPLOT_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [master]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [MasterProfit]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [MasterProfitPro]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [MasterProfitPro2K12]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [MEDICAL]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [MEDICAL_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [MEDICAL_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [MICH_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [MICHI_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [MICHI01]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [mobiliza-2.7]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [mobiliza-3.1]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [model]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [msdb]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [NORDI_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [NORDIC_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [NORDICOS]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [OVER_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [OVER_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [OVERLAND]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [OVL]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [OXI_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [OXIL_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [OXILAGO]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [PICARI]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [PICARI_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [PICARI_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [Profit_RG]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [Profit_XLS]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [PSUPPLY]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [PSUPPLY_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [PSUPPLY_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [QUALITY]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [QUALITY_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [QUALITY_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [SERV_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [SERV_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [SERVICE]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [STAR01]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [Star01_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [STAR01_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [TRACO]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [TRACO_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [TRACO_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [ZEGNA]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [ZEGNA_C]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO
USE [ZEGNA_N]
GO
DROP USER [FrontEndEH]
CREATE USER [FrontEndEH] FOR LOGIN [FrontEndEH]
ALTER ROLE [db_datareader] ADD MEMBER [FrontEndEH]
ALTER ROLE [db_datawriter] ADD MEMBER [FrontEndEH]
GO