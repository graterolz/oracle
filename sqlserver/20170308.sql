SELECT * FROM Profit_RG.dbo.Reclamo_Cliente ORDER BY 1 DESC
DELETE FROM Profit_RG.dbo.Reclamo_Cliente WHERE id_reclamo IN(32,33,34)
--
SELECT * FROM ELZYRA.dbo.Salas_Conferencia
SELECT * FROM ELZYRA.dbo.AspNetUsers
USE ELZYRA; EXEC sp_help 'ELZYRA.dbo.AspNetUsers';
--
ALTER TABLE ELZYRA.dbo.Salas_Conferencia ADD id_usuario nchar(256);
ALTER TABLE ELZYRA.dbo.Salas_Conferencia ADD fecha_registro date;
ALTER TABLE ELZYRA.dbo.Salas_Conferencia ADD fecha_edicion date;
--
ALTER TABLE ELZYRA.dbo.Salas_Conferencia DROP COLUMN id_usuario;
ALTER TABLE ELZYRA.dbo.Salas_Conferencia DROP COLUMN fecha_registro;
ALTER TABLE ELZYRA.dbo.Salas_Conferencia DROP COLUMN fecha_edicion;
--
SELECT * FROM ELZYRA.dbo.AspNetUsers;
SELECT * FROM ELZYRA.dbo.AspNetRoles;
SELECT * FROM ELZYRA.dbo.AspNetUserRoles;
--
DROP TABLE [ELZYRA].[dbo].[Empresas]
CREATE TABLE [ELZYRA].[dbo].[Empresas](
	[id_empresa] [int] IDENTITY(1,1) NOT NULL,
	[des_emp] [nvarchar](max) NOT NULL,
	[base_dato] [nvarchar](max) NOT NULL,
	CONSTRAINT [PK_Empresas] PRIMARY KEY CLUSTERED ([id_empresa] ASC)
) ON [PRIMARY]
GO
INSERT INTO [ELZYRA].[dbo].[Empresas] ([des_emp],[base_dato])
VALUES	('StarGas','STAR01'),('Overland','OVERLAND'),('Michigan','MICHI01'),('Services','SERVICE'),('Arcoweld','ARCOWELD')
GO
SELECT * FROM [ELZYRA].[dbo].[Empresas]
GO
--
DROP TABLE [ELZYRA].[dbo].[GrupoEmpresas]
CREATE TABLE [ELZYRA].[dbo].[GrupoEmpresas](
	[id_grpemp] [int] IDENTITY(1,1) NOT NULL,
	[des_gemp] [nvarchar](max) NOT NULL,
	CONSTRAINT [PK_GEmpresas] PRIMARY KEY CLUSTERED ([id_grpemp] ASC)	
) ON [PRIMARY]
GO
INSERT INTO [ELZYRA].[dbo].[GrupoEmpresas] ([des_gemp])
VALUES ('Grupo STARGAS'),('Grupo OVERLAND'),('Grupo O&M&A')
GO
SELECT * FROM [ELZYRA].[dbo].[GrupoEmpresas]
GO
--
DROP TABLE [ELZYRA].[dbo].[EmpresasPorGrupos]
CREATE TABLE [ELZYRA].[dbo].[EmpresasPorGrupos](
	[id_empgrp] [int] IDENTITY(1,1) NOT NULL,
	[id_grpemp] [int] NOT NULL,
	[id_empresa] [int] NOT NULL,
	CONSTRAINT [PK_EmpPorGrp] PRIMARY KEY CLUSTERED ([id_empgrp] ASC)	
) ON [PRIMARY]
GO
INSERT INTO [ELZYRA].[dbo].[EmpresasPorGrupos] ([id_grpemp],[id_empresa])
VALUES (1,1),(1,2),(2,5),(2,3),(3,2),(3,3),(3,5)
GO
SELECT * FROM [ELZYRA].[dbo].[EmpresasPorGrupos]
--
DROP TABLE [ELZYRA].[dbo].[UsuariosPorEmpresas]
CREATE TABLE [ELZYRA].[dbo].[UsuariosPorEmpresas](
	[id_usu] [int] IDENTITY(1,1) NOT NULL,
	[id_aspusu] [nvarchar](max) NOT NULL,
	[id_grpemp] [int] NULL,
	[id_empresa] [int] NULL,	
	CONSTRAINT [PK_UsuarioPorEmpresas] PRIMARY KEY CLUSTERED ([id_usu] ASC)	
) ON [PRIMARY]
GO
INSERT INTO [ELZYRA].[dbo].[UsuariosPorEmpresas] ([id_aspusu],[id_grpemp],[id_empresa])
VALUES 
('6e4f742d-8cec-4158-bec0-28ad2edb87da',1,NULL),
('786b731e-5662-46c0-813a-5b552ef66683',NULL,2),
('6e4f742d-8cec-4158-bec0-28ad2edb87da',NULL,4)
GO
SELECT * FROM [ELZYRA].[dbo].[UsuariosPorEmpresas]
--
SELECT * FROM ELZYRA.dbo.AspNetUsers
USE ELZYRA; EXEC sp_help 'ELZYRA.dbo.AspNetUsers'
--
USE ELZYRA
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE pGet_MetasVendedores
AS
DECLARE
	@Desde datetime,
	@Hasta datetime,
	@Grupo nchar(10);
BEGIN
	-- SET NOCOUNT ON added to prevent extra result SETs FROM
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @Desde = '01/01/2017';
	SET @Hasta = '28/02/2017';
	SET @Grupo = 'Demo';

	DECLARE @Resumen table (empresa nchar(10),co_ven char(6),Ven_des nchar(60),Mes nchar(16),Ventas decimal(18,2),Clientes_Facturados int)
	DECLARE @Xsql nvarchar(max),@Params nvarchar(max),@Principal nchar(10)

	SET @Principal = (SELECT co_empresa FROM Profit_RG.dbo.Emp_asoc WHERE asociada=co_empresa AND grupo=@Grupo)

	DECLARE @Xpointer char(10)
	DECLARE pointer cursor for SELECT asociada FROM Profit_RG.dbo.Emp_asoc WHERE grupo=@Grupo

	OPEN pointer
	FETCH NEXT FROM pointer into @Xpointer; 

	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		SET @Xsql = 'With CTE_Vendedor as
		(
			SELECT co_ven,ven_des 
			FROM ' + rtrim(@Principal) + '.dbo.vendedor 
			WHERE condic=0
		),
		CTE_Ventas as
		(
			SELECT co_ven,datename(m,fec_emis) Mes,sum(case when tipo_doc=''FACT'' then monto_bru else monto_bru*-1 end) Ventas
			FROM ' + rtrim(@Xpointer) + '.dbo.docum_cc
			WHERE anulado=0 AND fec_emis between @D AND @H AND tipo_doc in (''FACT'',''N/CR'')
			GROUP BY co_ven,datename(m,fec_emis)
		),
		CTE_Clientes as
		(
			SELECT CC.co_ven,datename(m,fec_emis) Mes,count(distinct CL.rif) Clientes_Facturados
			FROM ' + rtrim(@Xpointer) + '.dbo.docum_cc CC
			INNER JOIN STAR01.dbo.clientes CL on CL.co_cli=CC.co_cli
			WHERE CC.anulado=0 AND fec_emis between @D AND @H AND tipo_doc=''FACT''
			GROUP BY CC.co_ven,datename(m,fec_emis)
		)
		SELECT @E empresa,CTv.co_ven,CTv.Ven_des,CTvt.Mes,convert(decimal(18,2),isnull(CTvt.ventas,0.00)) Ventas,
		isnull(CTc.Clientes_Facturados,0) Clientes_Facturados
		FROM CTE_Vendedor CTv
		LEFT JOIN CTE_Ventas CTvt on CTvt.co_ven=CTv.co_ven 
		LEFT JOIN CTE_Clientes CTc on CTc.co_ven=Ctv.co_ven AND Ctc.mes=CTvt.mes
		ORDER BY CTv.co_ven'

		SET @PARAMS = N'@D datetime,@H datetime,@E nchar(10)'
		INSERT INTO @Resumen
		EXEC sp_executesql @Xsql,@Params,@D=@Desde,@H=@Hasta,@E=@Xpointer;

		FETCH NEXT FROM pointer into @Xpointer; 
	END
	CLOSE pointer;
	DEALLOCATE pointer;
	
	SELECT co_ven,R.ven_des,mes,sum(ventas) Ventas,sum(clientes_facturados) Clientes
	FROM @Resumen R
	WHERE mes IS NOT NULL
	GROUP BY co_ven,ven_des,mes;
END
GO
--
USE ELZYRA
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION func_ConvertMonto
(
	@valor decimal(18,2),
	@moneda nchar(5),
	@posicion int
)
RETURNS varchar(30)
AS
BEGIN
	DECLARE @result as varchar(20);
	
	SET @result = (
		SELECT STUFF(CONVERT(VARCHAR,CONVERT(MONEY,@valor),1), 1, 0,
		REPLICATE(SPACE(0), 18 - LEN(CONVERT(VARCHAR,CONVERT(MONEY,@valor),1))))
	);

	SET @result = (SELECT CASE WHEN @posicion=1 THEN @result +' '+ RTRIM(@moneda) ELSE RTRIM(@moneda) + ' ' + LTRIM(@result) END)
	RETURN @result;
END
GO