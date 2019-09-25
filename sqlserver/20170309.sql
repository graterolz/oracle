SELECT dbo.func_ConvertMonto(2500,'$',0)
UNION ALL
SELECT dbo.func_ConvertMonto(2500,'Bsf',1)
--
DROP TABLE [Profit_XLS].[dbo].[DailyIncome]
CREATE TABLE [Profit_XLS].[dbo].[DailyIncome](
	VendorId nvarchar(10),
	IncomeDay nvarchar(10), 
	IncomeAmount int
)
--
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('SPIKE', 'FRI', 100)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('SPIKE', 'MON', 300)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('FREDS', 'SUN', 400)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('SPIKE', 'WED', 500)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('SPIKE', 'TUE', 200)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('JOHNS', 'WED', 900)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('SPIKE', 'FRI', 100)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('JOHNS', 'MON', 300)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('SPIKE', 'SUN', 400)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('JOHNS', 'FRI', 300)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('FREDS', 'TUE', 500)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('FREDS', 'TUE', 200)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('SPIKE', 'MON', 900)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('FREDS', 'FRI', 900)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('FREDS', 'MON', 500)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('JOHNS', 'SUN', 600)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('SPIKE', 'FRI', 300)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('SPIKE', 'WED', 500)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('SPIKE', 'FRI', 300)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('JOHNS', 'THU', 800)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('JOHNS', 'SAT', 800)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('SPIKE', 'TUE', 100)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('SPIKE', 'THU', 300)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('FREDS', 'WED', 500)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('SPIKE', 'SAT', 100)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('FREDS', 'SAT', 500)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('FREDS', 'THU', 800)
INSERT INTO [Profit_XLS].[dbo].[DailyIncome] VALUES ('JOHNS', 'TUE', 600)
--
SELECT * FROM [Profit_XLS].[dbo].[DailyIncome]
--
SELECT * FROM [Profit_XLS].[dbo].[DailyIncome]
PIVOT (AVG (IncomeAmount) FOR IncomeDay IN ([MON],[TUE],[WED],[THU],[FRI],[SAT],[SUN])) AS AvgIncomePerDay
--
SELECT * FROM [Profit_XLS].[dbo].[DailyIncome]
PIVOT (MAX (IncomeAmount) FOR IncomeDay IN ([MON],[TUE],[WED],[THU],[FRI],[SAT],[SUN])) AS MaxIncomePerDay
WHERE VendorId IN ('SPIKE')
--
USE Profit_XLS EXEC sp_help 'dbo.descuentos_articulos'
USE MICHI01 EXEC sp_help 'dbo.tipo_cli'
--
SELECT TOP 1 * FROM MICHI01.dbo.descuen
WHERE rowguid = 'DDD21E47-C504-E711-8115-005056B5FD38'
--
DECLARE @vCodigo varchar(20), @vPorcentaje float,@vTipCli varchar(10);
--
DECLARE cArticulos CURSOR READ_ONLY FOR
SELECT codigo, porcentaje 
FROM Profit_XLS.dbo.descuentos_articulos
ORDER BY 1;
--
CREATE TABLE #Result(
	[co_desc] [char](30) NOT NULL,
	[tipo_cli] [char](6) NOT NULL,
	[tipo_desc] [char](1) NOT NULL,
	[hasta1] [decimal](18, 2) NOT NULL,
	[hasta2] [decimal](18, 2) NOT NULL,
	[hasta3] [decimal](18, 2) NOT NULL,
	[hasta4] [decimal](18, 2) NOT NULL,
	[hasta5] [decimal](18, 2) NOT NULL,
	[porc1] [decimal](18, 2) NOT NULL,
	[porc2] [decimal](18, 2) NOT NULL,
	[porc3] [decimal](18, 2) NOT NULL,
	[porc4] [decimal](18, 2) NOT NULL,
	[porc5] [decimal](18, 2) NOT NULL,
	[porc6] [decimal](18, 2) NOT NULL,
	[campo1] [char](30) NOT NULL,
	[campo2] [char](30) NOT NULL,
	[campo3] [char](30) NOT NULL,
	[campo4] [char](30) NOT NULL,
	[campo5] [char](30) NOT NULL,
	[campo6] [char](30) NOT NULL,
	[campo7] [char](30) NOT NULL,
	[campo8] [char](30) NOT NULL,
	[co_us_in] [char](6) NOT NULL,
	[fe_us_in] [datetime] NOT NULL,
	[co_us_mo] [char](6) NOT NULL,
	[fe_us_mo] [datetime] NOT NULL,
	[co_us_el] [char](6) NOT NULL,
	[fe_us_el] [datetime] NOT NULL,
	[revisado] [char](1) NOT NULL,
	[trasnfe] [char](1) NOT NULL,
	[co_sucu] [char](6) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[row_id] [timestamp] NOT NULL
)
--
OPEN cArticulos
FETCH NEXT FROM cArticulos INTO @vCodigo,@vPorcentaje
WHILE (@@fetch_status <> -1)
	BEGIN
		DECLARE cTipoCliente CURSOR READ_ONLY FOR 
		SELECT tip_cli FROM MICHI01.dbo.tipo_cli ORDER BY 1;

		OPEN cTipoCliente
		FETCH NEXT FROM cTipoCliente INTO @vTipCli
		WHILE (@@fetch_status <> -1)
		BEGIN
			PRINT @vTipCli + '-' + @vCodigo + '-' + convert(varchar,@vPorcentaje);
			
			INSERT INTO #Result(
				[co_desc],[tipo_cli],[tipo_desc],[hasta1],[hasta2],[hasta3],[hasta4],[hasta5],
				[porc1],[porc2],[porc3],[porc4],[porc5],[porc6],[campo1],[campo2],[campo3],
				[campo4],[campo5],[campo6],[campo7],[campo8],[co_us_in],[fe_us_in],[co_us_mo],
				[fe_us_mo],[co_us_el],[fe_us_el],[revisado],[trasnfe],[co_sucu],[rowguid])
			SELECT TOP 1 
				@vCodigo,@vTipCli,[tipo_desc],[hasta1],[hasta2],[hasta3],[hasta4],[hasta5],
				@vPorcentaje,[porc2],[porc3],[porc4],[porc5],[porc6],[campo1],[campo2],[campo3],
				[campo4],[campo5],[campo6],[campo7],[campo8],[co_us_in],[fe_us_in],[co_us_mo],
				[fe_us_mo],[co_us_el],[fe_us_el],[revisado],[trasnfe],[co_sucu],NEWID() 			
			FROM MICHI01.dbo.descuen;

			FETCH NEXT FROM cTipoCliente INTO @vTipCli
		END
		CLOSE cTipoCliente
		DEALLOCATE cTipoCliente
		
		FETCH NEXT FROM cArticulos INTO @vCodigo,@vPorcentaje
	END
CLOSE cArticulos
DEALLOCATE cArticulos
--
SELECT * FROM #Result
DROP TABLE #Result