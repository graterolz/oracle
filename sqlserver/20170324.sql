EXEC ELZYRA.dbo.pSender_Mail_MetasVtasGerenciaMix @Desde = '01/02/2017',@Hasta = '28/02/2017',@Grupo ='Stargas';
--
ALTER TABLE [ELZYRA].[dbo].[GrupoEmpresas] DROP CONSTRAINT Alias_Unico
ALTER TABLE [ELZYRA].[dbo].[GrupoEmpresas] DROP COLUMN alias
ALTER TABLE [ELZYRA].[dbo].[GrupoEmpresas] ADD alias nchar(10)
--
UPDATE [ELZYRA].[dbo].[GrupoEmpresas]
SET alias = 'STARGAS'
WHERE id_grpemp = 1;
--
UPDATE [ELZYRA].[dbo].[GrupoEmpresas]
SET alias = 'TEST'
WHERE id_grpemp = 2;
--
ALTER TABLE [ELZYRA].[dbo].[GrupoEmpresas] ALTER COLUMN alias nchar(10) NOT NULL;
ALTER TABLE [ELZYRA].[dbo].[GrupoEmpresas] ADD CONSTRAINT Alias_Unico UNIQUE (alias);
--
SELECT * FROM [ELZYRA].[dbo].[GrupoEmpresas]
SELECT * FROM Profit_RG.dbo.Grupo_Comision
--
SELECT * FROM Vendedores
PIVOT (
	SUM(Alcance) FOR
	alias IN(CCE,CRNP,ELEC,MM)
) AS Ven
--
USE ELZYRA EXEC ELZYRA.dbo.pJOB_ELZYRA_Email_Meta_Vta_GerenciaMix @pGrupo ='Stargas'; 
USE ELZYRA EXEC sp_rename 'Metas_Vendedor','Ventas_Metas'
--
SELECT * FROM ELZYRA.dbo.Notificacion_email WHERE id_tipo = 6
SELECT * FROM ELZYRA.dbo.AspNetUsers
--
SELECT * FROM ELZYRA.dbo.Usuarios
USE ELZYRA EXEC sp_rename 'Usuarios','Usuarios_OLD'
--
USE ELZYRA
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE pJOB_ELZYRA_Email_Meta_Vta_GerenciaMix(
	@pGrupo nchar(10)
)
AS
BEGIN
	DECLARE 
	@vDesde datetime = (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(getdate())-1),getdate()),103)) , 
	@vHasta datetime = (SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,getdate()))),DATEADD(mm,1,getdate())),103))
	
	EXEC ELZYRA.dbo.pSender_Mail_MetasVtasGerenciaMix 
		@Desde = @vDesde,
		@Hasta = @vHasta,
		@Grupo = @pGrupo;
END
GO