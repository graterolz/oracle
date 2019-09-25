SELECT * FROM ELZYRA.dbo.Reclamo_Cliente;
USE ELZYRA EXEC sp_help 'Reclamo_Accion';
SELECT * FROM [ELZYRA].[dbo].[Reclamo_Accion];
--
EXEC Profit_RG.dbo.pNotificacionEmailAdelantoComisionesSG @Co_empresa = 'STAR01'
--
EXEC ELZYRA.dbo.pSender_Mail_Productos_por_llegar @Empresa = 'OVERLAND';
EXEC ELZYRA.dbo.pSender_Mail_Productos_por_llegar @Empresa = 'STAR01';
--
EXEC ELZYRA.dbo.pSender_Mail_MetasVtasVendedores @Desde = '01/02/2017',@Hasta = '28/02/2017',@Grupo ='Stargas';
EXEC ELZYRA.dbo.pSender_Mail_MetasVtasGerencia @Desde = '01/02/2017',@Hasta = '28/02/2017',@Grupo ='Stargas';
--
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_Vendedores @pGrupo ='Stargas';
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_Gerencia @pGrupo ='Stargas';
--
SELECT * FROM ELZYRA.dbo.UsuariosPorEmpresas
--
USE ELZYRA
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE pJOB_ELZYRA_Email_Meta_Vta_Gerencia (
	@pGrupo nchar(10)
)
AS
BEGIN
	DECLARE 
	@vDesde datetime = (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(getdate())-1),getdate()),103)) , 
	@vHasta datetime = (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,getdate()))),DATEADD(mm,1,getdate())),103))
	
	EXEC ELZYRA.dbo.pSender_Mail_MetasVtasGerencia 
		@Desde = @vDesde,
		@Hasta = @vHasta,
		@Grupo = @pGrupo;
END
GO
--
USE ELZYRA
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE pJOB_ELZYRA_Email_Meta_Vta_Vendedores (
	@pGrupo nchar(10)
)
AS
BEGIN
	DECLARE 
	@vDesde datetime = (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(getdate())-1),getdate()),103)) , 
	@vHasta datetime = (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,getdate()))),DATEADD(mm,1,getdate())),103))
	
	EXEC ELZYRA.dbo.pSender_Mail_MetasVtasVendedores 
		@Desde = @vDesde,
		@Hasta = @vHasta,
		@Grupo = @pGrupo;
END
GO