SELECT	Grupo,
		Meta,
		VentaGrupo,
		CONVERT(decimal(18,2),Meta*Ponderacion/100) MetaGrupo,
		CONVERT(decimal(10,2),VentaGrupo/(CONVERT(decimal(18,2),Meta*Ponderacion/100))*100) Alcance 
FROM [Profit_RG].dbo.[func_MixVentasSG] ('001','01/01/2017','31/03/2017')
--
SELECT MIN(desde), MAX(hasta) FROM ELZYRA.dbo.Metas_Vendedor ORDER BY 1 DESC
EXEC ELZYRA.dbo.pSender_Mail_MetasVtasVendedoresMix @Desde = '01/03/2017',@Hasta = '31/03/2017',@Grupo ='Stargas';
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_VendedoresMix @pGrupo ='Stargas';
--
SELECT	GC.descripcion Descripcion,
		VentaGrupo,
		CONVERT(decimal(18,2),Meta*Ponderacion/100) MetaGrupo,
		CONVERT(decimal(10,2),VentaGrupo/(CONVERT(decimal(18,2),Meta*Ponderacion/100))*100) Alcance 
FROM [dbo].[func_MixVentasSG] ('025','01/03/2017','31/03/2017') M
INNER JOIN Profit_RG.dbo.Grupo_Comision GC ON GC.Alias = M.Grupo
--
SELECT * FROM ELZYRA.dbo.AspNetUserRoles WHERE UserId = 'ff650c46-4964-4691-9112-be323e1ac030'
DELETE FROM ELZYRA.dbo.AspNetUserRoles WHERE UserId = 'ff650c46-4964-4691-9112-be323e1ac030'
--
USE [ELZYRA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[pJOB_ELZYRA_Email_Meta_Vta_VendedoresMix] (
	@pGrupo nchar(10)
)
AS
BEGIN
	DECLARE 
	@vDesde datetime = (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(getdate())-1),getdate()),103)) , 
	@vHasta datetime = (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,getdate()))),DATEADD(mm,1,getdate())),103))
	
	EXEC ELZYRA.dbo.pSender_Mail_MetasVtasVendedoresMix 
		@Desde = @vDesde,
		@Hasta = @vHasta,
		@Grupo = @pGrupo;
END