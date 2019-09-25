SELECT * FROM sys.databases
EXEC Profit_RG.dbo.pNotificacionEmailAdelantoComisionesSG @Co_empresa = 'STAR01'
--
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_Gerencia @pGrupo ='Stargas';
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_Gerencia @pGrupo ='Overland';
SELECT * FROM ELZYRA.dbo.Notificacion_email
--
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_GerenciaMix @pGrupo ='Stargas';
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_GerenciaMix @pGrupo ='Overland';
--
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_Vendedores @pGrupo ='Stargas';
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_Vendedores @pGrupo ='Overland';
--
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_VendedoresMix @pGrupo ='Stargas';
EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_VendedoresMix @pGrupo ='Overland';
--
EXEC ELZYRA.dbo.pSender_Mail_Productos_por_llegar @Empresa = 'OVERLAND';
EXEC ELZYRA.dbo.pSender_Mail_Productos_por_llegar @Empresa = 'STAR01';
--
ALTER LOGIN [FrontEndEH] WITH DEFAULT_DATABASE = master
--
SELECT * FROM ELZYRA.dbo.GrupoUsuarios
SELECT * FROM demo.dbo.pistas
SELECT * FROM msdb.dbo.sysjobs WHERE name like '%META%'
SELECT * FROM ELZYRA.dbo.Comision_GeneraDetalle
--
EXEC ELZYRA.dbo.pAjustaInventarios
EXEC ELZYRA.dbo.pELZ_Comision_Genera @Comision = 20, @Vendedor = '023'