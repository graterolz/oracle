BEGIN
	pr_banseg.gcc_importar (
		'0024',
		'DIRECTORIO_BANCASEG_IN/1BENEFICACSEL08082013.TXT',
		NULL,
		NULL);
	COMMIT;
END;