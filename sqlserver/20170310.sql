WITH Query (usuario, empresa, base_datos, grupo, id_empresa)  
AS(
	SELECT id_aspusu, em.des_emp, em.base_dato, ge.id_grpemp, u.id_empresa 
	FROM ELZYRA.dbo.EmpresasPorGrupos g
	JOIN ELZYRA.dbo.GrupoEmpresas ge ON ge.id_grpemp = g.id_grpemp
	JOIN ELZYRA.dbo.Empresas em ON em.id_empresa = g.id_empresa
	JOIN ELZYRA.dbo.UsuariosPorEmpresas u ON u.id_grpemp = ge.id_grpemp 
	WHERE u.id_aspusu = '6e4f742d-8cec-4158-bec0-28ad2edb87da'
)
SELECT empresa, base_datos
FROM Query q
UNION ALL
SELECT des_emp, base_dato 
FROM ELZYRA.dbo.Empresas e
JOIN ELZYRA.dbo.UsuariosPorEmpresas u ON u.id_empresa = e.id_empresa
WHERE u.id_aspusu = '6e4f742d-8cec-4158-bec0-28ad2edb87da' 
AND 
des_emp not IN (
	SELECT em.des_emp 
	FROM ELZYRA.dbo.EmpresasPorGrupos g
	JOIN ELZYRA.dbo.GrupoEmpresas ge ON ge.id_grpemp = g.id_grpemp
	JOIN ELZYRA.dbo.Empresas em ON em.id_empresa = g.id_empresa
	JOIN ELZYRA.dbo.UsuariosPorEmpresas u ON u.id_grpemp = ge.id_grpemp 
	WHERE u.id_aspusu = '6e4f742d-8cec-4158-bec0-28ad2edb87da'
)
--
USE ELZYRA
EXEC pGet_EmpresaPorUsuario @id_usuasp = N'6e4f742d-8cec-4158-bec0-28ad2edb87da'
--
SELECT * FROM sys.databases WHERE UPPER(name) = 'MASTER'
USE ELZYRA
EXEC pGet_ExisteDatabase @name ='STAR012'
--
INSERT INTO ELZYRA.dbo.Notificacion_email
SELECT * FROM Profit_Rg.dbo.Notificacion_email B
WHERE NOT EXISTS (
	SELECT * FROM ELZYRA.dbo.Notificacion_email A
	WHERE A.id_email = b.id_email
)
--
USE [ELZYRA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE pGet_EmpresaPorUsuario
	@id_usuasp nchar(50)
AS
BEGIN
	-- CTE Query.
	WITH QUERY (usuario, empresa, basedeDatos, grupo, id_empresa)
	AS (
		SELECT id_aspusu, em.des_emp, em.base_dato, ge.id_grpemp, u.id_empresa 
		FROM ELZYRA.dbo.EmpresasPorGrupos g
		JOIN ELZYRA.dbo.GrupoEmpresas ge ON ge.id_grpemp = g.id_grpemp
		JOIN ELZYRA.dbo.Empresas em ON em.id_empresa = g.id_empresa
		JOIN ELZYRA.dbo.UsuariosPorEmpresas u ON u.id_grpemp = ge.id_grpemp
		WHERE u.id_aspusu = @id_usuasp
	)
	SELECT empresa, basedeDatos
	FROM Query q
	UNION ALL
	SELECT des_emp, base_dato 
	FROM ELZYRA.dbo.Empresas e
	JOIN ELZYRA.dbo.UsuariosPorEmpresas u ON u.id_empresa = e.id_empresa
	WHERE u.id_aspusu = @id_usuasp
	AND des_emp not IN (
		SELECT em.des_emp 
		FROM ELZYRA.dbo.EmpresasPorGrupos g
		JOIN ELZYRA.dbo.GrupoEmpresas ge ON ge.id_grpemp = g.id_grpemp
		JOIN ELZYRA.dbo.Empresas em ON em.id_empresa = g.id_empresa
		JOIN ELZYRA.dbo.UsuariosPorEmpresas u ON u.id_grpemp = ge.id_grpemp 
		WHERE u.id_aspusu = @id_usuasp
	)
END
GO
--
USE [ELZYRA]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE pGet_ExisteDatabase
	@name nchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	IF EXISTS (SELECT * FROM sys.databases WHERE UPPER(name) = @name)
		SELECT 1
	else
		SELECT 0
END
GO