SELECT * FROM [ELZYRA].[dbo].[Reclamo_Razon_Email]
DROP TABLE [ELZYRA].[dbo].[Reclamo_Razon_Email]
SELECT Profit_RG.[dbo].[funcScript_ComisionSG] ('STAR01') Script
--
USE [Profit_RG]
DROP PROCEDURE [dbo].[pNotificacionEmailAdelantoComisionesSG_OLD]
--
EXEC Profit_RG.dbo.pNotificacionEmailAdelantoComisionesSG @Co_empresa = N'STAR01'
--
USE [Profit_RG]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[funcScript_ComisiONSG] (
	@Empresa nchar(10)
)
RETURNS nvarchar(MAX)
AS
BEGIN
	DECLARE @Xsql NVARCHAR(MAX),@Xsql1 NVARCHAR(MAX),@Xsql2 NVARCHAR(MAX),@Xsql3 NVARCHAR(MAX),@Xsql4 NVARCHAR(MAX)

	SET @Xsql1 = 
		'WITH CTE_Comi AS (
			SELECT
				doc_num fact_cob,MAX(Rc.cob_num) Ult_cobro,
				CC.fec_emis,CC.mONto_bru MONtoFactura,
				CONVERT(datetime,
					CASE
						WHEN isdate(ltrim(rtrim(CC.campo8))) = 0
							THEN CC.fec_emis 
						ELSE 
							ltrim(rtrim(CC.campo8)) 
					END
				,103) Frecep,
				CC.campo8,
				(SELECT campo1 FROM ' + rtrim(@Empresa) + '.dbo.Cobros
					WHERE cob_num = Max(Rc.cob_num)) campo1
			FROM ' + rtrim(@Empresa) + '.dbo.reng_cob Rc
			INNER JOIN ' + rtrim(@Empresa) + '.dbo.cobros C ON C.cob_num=Rc.cob_num
			INNER JOIN ' + rtrim(@Empresa) + '.dbo.docum_cc CC ON CC.nro_doc=doc_num AND CC.tipo_doc=''FACT''
			WHERE C.anulado=0 
			AND C.fec_cob BETWEEN @D AND @H 
			AND tp_doc_cob=''FACT'' 
			AND CC.saldo=0 
			AND C.co_ven=@V
			GROUP BY doc_num,CC.fec_emis,CC.mONto_bru,CC.campo8,CC.fec_emis
		),
		CTE_FecCobro AS (
			SELECT
				doc_num,
				CASE
					WHEN isdate((SELECT campo1 FROM '+ rtrim(@Empresa) +'.dbo.Cobros WHERE cob_num = Max(C.cob_num)))=1
						THEN CONVERT(date,left(rtrim(ltrim((SELECT campo1 FROM '+ rtrim(@Empresa) +'.dbo.Cobros WHERE cob_num = Max(C.cob_num)))),10)) 
					ELSE
						MAX(CONVERT(date,fec_cheq)) 
				END Ult_fecha,
				(
					SELECT campo1 FROM '+ rtrim(@Empresa) +'.dbo.Cobros 
					WHERE cob_num = Max(C.cob_num)
				) FechaAdcCobro 
			FROM '+ rtrim(@Empresa) +'.dbo.reng_tip Rtp
			INNER JOIN '+ rtrim(@Empresa) +'.dbo.cobros C ON C.cob_num=Rtp.cob_num
			INNER JOIN '+ rtrim(@Empresa) +'.dbo.reng_cob R ON R.cob_num=C.cob_num
			WHERE fec_cob BETWEEN @D AND getdate() AND C.co_ven=@V AND C.anulado=0 AND tp_doc_cob=''FACT'' 
			GROUP BY doc_num
		),'

	SET @Xsql2 = 
		'CTE_Fact AS (
			SELECT
				co_ven,co_cli,fact_num,fORma_pag,co_tran,fec_emis,MONtoFactura,
				CTE_Comi.Ult_cobro,Ult_fecha,FechaAdcCobro,Frecep,CTE_Comi.campo8,
				id_gcomi,T.Grupo,factOR,SUM(bASe) BASe,
				ISNULL((
					SELECT id_pc 
					FROM Profit_RG.dbo.Penal_comi Pc 
					WHERE id_fp=Fp.id_fp 
					AND grupo=''Demo'' 
					AND fec_emis BETWEEN PC.desde AND ISNULL(Pc.hASta,getdate()) 
					AND DATEDIFF(d,Frecep,Ult_fecha) BETWEEN inicio AND fin
				),-1) Id_pc
			FROM (
				SELECT 
					F.co_ven,F.co_cli,F.fact_num,F.fORma_pag,F.co_tran,
					GC.id_gcomi,GC.AliAS Grupo,Gc.factOR,SUM(reng_neto) BASe
				FROM '+rtrim(@Empresa)+'.dbo.factura F
				INNER JOIN '+rtrim(@Empresa)+'.dbo.Fact_reng Rf ON Rf.fact_num=F.fact_num
				INNER JOIN '+rtrim(@Empresa)+'.dbo.Art A ON A.co_art=Rf.co_art
				INNER JOIN Profit_RG.dbo.Grupo_ComisiON GC ON GC.id_gcomi=A.grado_al
				INNER JOIN CTE_Comi ON fact_cob=F.fact_num
				WHERE F.anulada=0 
				GROUP BY F.co_ven, F.co_cli, F.fact_num, F.fORma_pag, F.co_tran, GC.id_gcomi, GC.AliAS, Gc.factOR
				UNION ALL
				SELECT
					F.co_ven, F.co_cli, Rf.num_doc fact_num, F.fORma_pag, F.co_tran,
					GC.id_gcomi, GC.AliAS Grupo, Gc.factOR, SUM(reng_neto)*-1 BASe
				FROM '+rtrim(@Empresa)+'.dbo.dev_cli F
				INNER JOIN '+rtrim(@Empresa)+'.dbo.reng_dvc Rf ON Rf.fact_num=F.fact_num
				INNER JOIN '+rtrim(@Empresa)+'.dbo.Art A ON A.co_art=Rf.co_art
				INNER JOIN Profit_RG.dbo.Grupo_ComisiON GC ON GC.id_gcomi=A.grado_al
				INNER JOIN CTE_Comi ON fact_cob=Rf.num_doc AND Rf.tipo_doc=''F''
				WHERE F.anulada=0 
				GROUP BY F.co_ven, F.co_cli, Rf.num_doc, F.fORma_pag, F.co_tran, GC.id_gcomi, GC.AliAS, GC.factOR
			) T
			INNER JOIN CTE_Comi ON CTE_Comi.fact_cob=T.fact_num
			INNER JOIN CTE_FecCobro ON CTE_FecCobro.doc_num=CTE_Comi.fact_cob
			INNER JOIN '+rtrim(@Empresa)+'.dbo.cONdicio Co ON Co.co_cONd=T.fORma_pag
			INNER JOIN Profit_Rg.dbo.FORma_pago Fp ON Fp.id_fp=CONVERT(int,Co.campo2) AND Fp.grupo=''Demo''
			GROUP BY 
				co_ven, co_cli, fact_num, fORma_pag, co_tran, fec_emis, MONtoFactura, CTE_Comi.Ult_cobro,
				Ult_fecha, FechaAdcCobro, Frecep, CTE_Comi.campo8, id_gcomi, T.Grupo, factOR, Fp.id_fp
			HAVING SUM(bASe)>0
		),'

	SET @Xsql3 =
		'CTE_NCR AS (
			SELECT fact_ORig,SUM(mONto_bru) mONto_bru
			FROM (
				SELECT 
					CASE WHEN ISNUMERIC(campo2)=1 
						THEN CONVERT(int,campo2) 
					ELSE 
						nro_ORig 
					END Fact_ORig,
					mONto_bru
				FROM '+rtrim(@Empresa)+'.dbo.docum_cc 
				INNER JOIN CTE_Comi ON (fact_cob=nro_ORig AND doc_ORig=''FACT'')
				OR (CASE WHEN ISNUMERIC(campo2)=1 THEN CONVERT(int,campo2) ELSE 0 END = fact_cob)
			WHERE anulado=0 AND tipo_doc=''N/CR'' --AND doc_ORig<>''DEVO''
			) T
			GROUP BY Fact_ORig
		),
		CTE_MetaVenta AS (
			SELECT * FROM [Profit_RG].[dbo].[func_MetASVentASSG] (@V,@D,@H)
		),
		CTE_Mx AS (
			SELECT * FROM [Profit_RG].[dbo].[func_MixVentASSG] (@V,@D,@H)
		)'

	SET @Xsql4 =
		'SELECT
			C.co_ven,V.ven_des,C.co_cli, left(Cli_des,60) Cli_des, C.fact_num,
			C.MONtoFactura,	C.Grupo,C.factOR,
			CASE 
				WHEN Tcl.campo1=''S'' 
					THEN GC.factOR_CE 
				ELSE C.factOR 
			END FactORApl,C.BASe,
			C.co_tran,T.des_tran,T.campo2 Flete,
			CASE
				WHEN T.campo2=''S'' 
					THEN 0.00 
				ELSE 3.00 
			END FactOR_flete,
			ISNULL(CTE_NCR.mONto_bru,0.00) NCR,
			ISNULL(CONVERT(decimal(18,6),ROUND(CTE_NCR.mONto_bru/C.MONtoFactura,6)),0.000000) Pdesc,
			C.Ult_cobro, C.fec_emis, C.Frecep, C.Ult_fecha, C.FechaAdcCobro, C.campo8 DatoFR,
			CASE
				WHEN isdate(ltrim(rtrim(C.campo8)))=0 
					THEN ''ERROR''
				ELSE ''OK''
			END ST_FechaRecep,
			DATEDIFF(d,Frecep,Ult_fecha) DC, Mv.Venta, Mv.Meta, Mv.FactOR_MV,
			CASE
				WHEN MV.Venta>MV.Meta AND C.fec_emis>=''01/01/2017'' 
					THEN MV.FactOR_MV 
				ELSE 0.00 
			END FactOR_MVApl,
			Mx.VentaGrupo, Mx.pONderaciON, Mx.FactOR_imix,
			CASE
				WHEN C.fec_emis>=''01/01/2017'' 
					THEN Mx.FactOR_imixApl 
				ELSE 0.00 
			END FactOR_imixApl,
			Co.cONd_des, Pc.descripciON Penal_des,
			Pc.id_pc, Pc.grupo, Pc.desde, Pc.hASta, Pc.inicio, Pc.fin,
			CASE
				WHEN Tcl.campo1=''S'' 
					THEN 0.00 
				ELSE ISNULL(Pc.penalizaciON,0.00)
			END PenalizaciON,
			(
				C.BASe
				-
				(C.BASe*(CASE WHEN T.campo1=''S'' THEN 0.00 ELSE 3.00 END)/100)
				-
				(C.BASe*(ISNULL(CONVERT(decimal(18,6),ROUND(CTE_NCR.mONto_bru/C.MONtoFactura,6)),0.000000))) 
			) BASeDef,
			((
				CASE 
					WHEN Tcl.campo1=''S'' 
						THEN GC.factOR_CE 
					ELSE C.factOR 
				END
				+
				(CASE 
					WHEN MV.Venta>MV.Meta AND C.fec_emis>=''01/01/2017'' 
						THEN MV.FactOR_MV 
					ELSE 
						0.00
				END)
				+
				(CASE
					WHEN C.fec_emis>''01/01/2017'' 
						THEN Mx.FactOR_imixApl 
					ELSE 
						0.00 
				END)
			))
			-
			((
				(CASE 
					WHEN Tcl.campo1=''S'' 
						THEN 0 
					ELSE
						C.factOR*ISNULL(Pc.penalizaciON/100,0.00) 
				END)
			)) FactORComiDef,
			(
				CONVERT(decimal(18,2),(
					BASe
					-
					(BASe*(
						CASE
							WHEN T.campo1=''S'' 
								THEN 0.00 
							ELSE 
								3.00
						END
					)/100)
					-
					(BASe*(
						ISNULL(CONVERT(decimal(18,6),
							ROUND(CTE_NCR.mONto_bru/C.MONtoFactura,6)),0.000000
						)
					))
				))
				*
				((
					(
						(CASE 
							WHEN Tcl.campo1=''S'' 
								THEN GC.factOR_CE 
							ELSE C.factOR 
						END
						+
						(CASE
							WHEN MV.Venta>MV.Meta AND C.fec_emis>=''01/01/2017'' 
								THEN MV.FactOR_MV 
							ELSE 0.00 
						END)
						+
						(CASE
							WHEN C.fec_emis>''01/01/2017'' 
								THEN Mx.FactOR_imixApl 
							ELSE 
								0.00 
						END))
					)
					-
					(CASE 
						WHEN Tcl.campo1=''S'' 
							THEN 0 
						ELSE 
							C.factOR*ISNULL(Pc.penalizaciON/100,0.00) 
						END)
				))/100
			) ComisiON
			FROM CTE_Fact C
			INNER JOIN '+rtrim(@Empresa)+'.dbo.vENDedOR V ON V.co_ven=C.co_ven
			INNER JOIN '+rtrim(@Empresa)+'.dbo.clientes Cl ON Cl.co_cli=C.co_cli
			INNER JOIN '+rtrim(@Empresa)+'.dbo.Tipo_cli Tcl ON Tcl.tip_cli=Cl.tipo
			INNER JOIN '+rtrim(@Empresa)+'.dbo.cONdicio Co ON Co.co_cONd=C.fORma_pag
			INNER JOIN '+rtrim(@Empresa)+'.dbo.transpOR T ON T.co_tran=C.co_tran
			INNER JOIN Profit_RG.dbo.Grupo_ComisiON GC ON Gc.id_gcomi=C.id_gcomi
			INNER JOIN CTE_MetaVenta MV ON MV.co_ven=C.co_ven
			INNER JOIN CTE_Mx Mx ON Mx.id_gcomi=C.id_gcomi
			LEFT JOIN CTE_NCR ON C.fact_num=CTE_NCR.Fact_ORig
			LEFT JOIN Profit_RG.dbo.Penal_comi Pc ON Pc.id_pc=C.Id_pc
			WHERE Ult_fecha<=@H
			ORDER BY C.fact_num;'

	SET @Xsql = @Xsql1 + @Xsql2 + @Xsql3 + @Xsql4
	RETURN @Xsql
END