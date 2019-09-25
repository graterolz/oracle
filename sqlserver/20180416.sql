USE [SDI]
GO
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
