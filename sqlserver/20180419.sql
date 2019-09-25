USE SDI
--
ALTER TABLE Documento ADD Firmado bit
UPDATE Documento SET Firmado = 0
--
/****** Object:  StoredProcedure [dbo].[PRC_LEERDOCUMENTO]    Script Date: 4/19/2018 12:33:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[PRC_LEERDOCUMENTO]
	@Niddoc int, @GMT as varchar(6), @minwidth smallint, @Nidsit smallint, @Movil bit = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ret int = 0;
	
	BEGIN TRY
		Select Top 1 D.Niddoc, D.Ctitdetdoc, dbo.FNC_TEXTOMETA(D.Ctitdetdoc) as Ctitdetdocmeta, 
			CAST(SWITCHOFFSET(D.Dfecregdoc,@GMT) as SmallDateTime) as Dfecregdoc,
			CAST(SWITCHOFFSET(D.Dfecmoddoc,@GMT) as SmallDateTime) as Dfecmoddoc,
			ISNULL(ISNULL(DS.Clugdocsit,D.Clugdoc),S.Clugsit) As Clugdoc, ISNULL(ISNULL(DS.Cfuedocsit,D.Cfuedoc),S.Cfuesit) As Cfuedoc,
			dbo.FNC_TEXTOMETA(Cres1doc) as Cres1docmeta, Cres1doc, Cres2doc, Ccladoc, Ckeydoc, Csubdetdoc, Cdetdoc,
			dbo.FNC_MULTIMEDIATIPO(D.Niddoc,@minwidth) as MultimediaTipo, Directorio, Ctemdoc,
			Ctitpordoc, Ctittitdoc, Ctitarcdoc, Ctitdoc, O.Carcobj, O.Cdesobj, O.Chtmobj,
			CASE WHEN DSO.Niddoc IS NOT NULL THEN ZO.Ctexamizon
				WHEN DS.Niddoc IS NOT NULL THEN Z.Ctexamizon ELSE NULL END ZonaAmistoso,
			CASE WHEN DSO.Niddoc IS NOT NULL THEN ZO.UrlAmistoso
				WHEN DS.Niddoc IS NOT NULL THEN Z.UrlAmistoso ELSE NULL END ZonaUrlAmistoso, 
				D.TituloAmistoso, CASE WHEN DSO.Niddoc IS NOT NULL THEN DSO.Nidzon ELSE DS.Nidzon END As Nidzon, 
			CASE WHEN DSO.Niddoc IS NOT NULL THEN DSO.Nidpla ELSE DS.Nidpla END As Nidpla, D.Cestdoc,
			CASE WHEN DSO.Niddoc IS NOT NULL THEN SO.Curlsit + '/' + ZO.Ctexamizon 
				 WHEN DS.Niddoc IS NOT NULL THEN S.Curlsit + '/' + Z.Ctexamizon ELSE NULL END As UrlAmistoso,
			ISNULL(DS.Breddocsit,CAST(0 As bit)) As Redirect, S.Curlsit + '/' + Z.Ctexamizon As UrlAmistosoRedirect,
			DS.Nidpla As PlantillaRedirect, Z.nidzon, Z.Nidparzon, Z.Nidprizon, D.Bamp, D.Cautdoc,
			D.SitioIDCanonical, D.UrlCanonical, D.UrlAmp, D.Firmado
		From Documentos D 
			Left Outer Join Objeto As O On D.Niddoc = O.Niddoc And O.Ctipobj = 'I' And O.Cubiobj = 'P' And O.Npriobj = 1
			Left Outer Join DocumentoSitio As DS On D.Niddoc = DS.Niddoc And DS.Nidsit = @Nidsit
			Left Outer Join DocumentoSitio DSO On D.Niddoc = DSO.Niddoc And ISNULL(DSO.Bpubdocsit, CAST(0 As bit)) = CAST(1 As Bit)
			Left Outer Join Sitio As S On DS.Nidsit = S.Nidsit
			Left Outer Join Sitio SO On DSO.Nidsit = SO.Nidsit
			Left Outer Join Zona As Z On DS.Nidzon = Z.Nidzon
			Left Outer Join Zona ZO On DSO.Nidzon = ZO.Nidzon
		Where D.Niddoc = @Niddoc And ISNULL(D.Bmovdoc,0) = CASE WHEN ISNULL(@Movil,0) = 0 Then ISNULL(D.Bmovdoc,0) ELSE @Movil END;

		EXEC SDI.dbo.sp_lectura_documento_ingresar @Niddoc, @Nidsit;
	END TRY
	BEGIN CATCH
		Set @ret = -1;
	END CATCH

	RETURN @ret;
	
END
--
/****** Object:  StoredProcedure [dbo].[PRC_INGRESARDOCUMENTO]    Script Date: 4/16/2018 7:00:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[PRC_INGRESARDOCUMENTO]
	@Niddoc int output, @Dfecregdoc datetimeoffset output, @Ctipdoc char(1), @Nidcat int,
	@Ctitdoc varchar(200), @Ctitpordoc varchar(200), @Ctittitdoc varchar(200), @Ctitarcdoc varchar(200), @Ctitdetdoc varchar(200),
	@Ctemdoc varchar(50), @Curldoc varchar(300), @Curltardoc varchar(10), @Ccladoc varchar(300), @Ckeydoc varchar(8000),
	@Cres1doc varchar(5000), @Cres2doc varchar(5000), @Csubdetdoc text, @Cdetdoc text, @Clugdoc varchar(100), @Cfuedoc varchar(50),
	@Nidusu smallint, @Bmovdoc bit, @Modificacion bit = 0, @amp bit = 0, @Cautor varchar(50) = '', @firma bit = 0
AS
BEGIN
	SET NOCOUNT ON;

	SET @Ccladoc = ' ' + LTRIM(RTRIM(ISNULL(@Ccladoc,''))) + ' ';

	IF @Clugdoc = ''
		SET @Clugdoc = NULL;
	IF @Cfuedoc = ''
		SET @Cfuedoc = NULL;

	IF @Niddoc = 0
	BEGIN
		SET @Dfecregdoc = GETUTCDATE();
		INSERT INTO Documento(Dfecregdoc,Ctipdoc,Cestdoc,Nidcat,Ctitdoc,Ctitpordoc,Ctittitdoc,Ctitarcdoc,Ctitdetdoc,Ctemdoc,Curldoc,Curltardoc,Ccladoc,Ckeydoc,Cres1doc,Cres2doc,Csubdetdoc,Cdetdoc,Clugdoc,Cfuedoc,Bmovdoc,Bamp,Cautdoc,Firmado)
		Values(@Dfecregdoc,@Ctipdoc,'R',@Nidcat,@Ctitdoc,@Ctitpordoc,@Ctittitdoc,@Ctitarcdoc,@Ctitdetdoc,@Ctemdoc,@Curldoc,@Curltardoc,@Ccladoc,@Ckeydoc,@Cres1doc,@Cres2doc,@Csubdetdoc,@Cdetdoc,@Clugdoc,@Cfuedoc,@Bmovdoc,@amp,@Cautor,@firma);
		IF @@ERROR <> 0
			RETURN 1;
		Set @Niddoc = @@IDENTITY;
		IF NOT @Clugdoc IS NULL OR NOT @Cfuedoc IS NULL
			EXEC PRC_INGRESARDOCUMENTOSITIO @Niddoc, NULL;
		EXEC PRC_DOCUMENTOCONTROL @Niddoc, @Nidusu, 'I';
	END
	ELSE
	BEGIN
		-- Si cambia lugar o fuente de un valor vacio o nulo a un valor no vacio ni nulo
		IF EXISTS(Select Niddoc From Documento 
				  Where Niddoc = @Niddoc
					And (
						 (ISNULL(Clugdoc,'') = '' And ISNULL(@Clugdoc,'') <> '')
						 Or (ISNULL(Cfuedoc,'') = '' And ISNULL(@Clugdoc,'') <> '')
						 )
				 )
			EXEC PRC_INGRESARDOCUMENTOSITIO @Niddoc, NULL;
	
		UPDATE Documento Set Ctipdoc=@Ctipdoc,Nidcat=@Nidcat,Ctitdoc=@Ctitdoc,Ctitpordoc=@Ctitpordoc,Ctittitdoc=@Ctittitdoc,
			Ctitarcdoc=@Ctitarcdoc,Ctitdetdoc=@Ctitdetdoc,Ctemdoc=@Ctemdoc,Curldoc=@Curldoc,Curltardoc=@Curltardoc,
			Ccladoc=@Ccladoc,Ckeydoc=@Ckeydoc,Cres1doc=@Cres1doc,Cres2doc=@Cres2doc,Csubdetdoc=@Csubdetdoc,Cdetdoc=@Cdetdoc,Clugdoc=@Clugdoc,
			Cfuedoc=@Cfuedoc,Bmovdoc=@Bmovdoc,Bamp=@amp, Cautdoc = @Cautor, Firmado = @firma 
		WHERE Niddoc = @Niddoc;
		IF @@ERROR <> 0
			RETURN 1;
		IF @Modificacion = 1
		BEGIN
			UPDATE Documento Set Dfecmoddoc = GETUTCDATE() Where Niddoc = @Niddoc;
			IF @@ERROR <> 0
				RETURN 1;
		END
		IF NOT @Clugdoc IS NULL OR NOT @Cfuedoc IS NULL
		EXEC PRC_DOCUMENTOCONTROL @Niddoc, @Nidusu, 'A';
	END
	RETURN 0;
END