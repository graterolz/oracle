DELETE FROM ACSMIGRE.VIG_POLIZA@DESA;
DELETE FROM ACSMIGRE.VIG_RECIBO@DESA;
DELETE FROM ACSMIGRE.VIG_CERTIFICADO@DESA;
DELETE FROM ACSMIGRE.VIG_COBERT_CERT@DESA;
DELETE FROM ACSMIGRE.VIG_COBERT_CERT_REC@DESA;
DELETE FROM ACSMIGRE.VIG_ASEGURADO@DESA;
DELETE FROM ACSMIGRE.VIG_ASEGURADO_REC@DESA;
DELETE FROM ACSMIGRE.VIG_COBERT_ASEG@DESA;
DELETE FROM ACSMIGRE.VIG_COBERT_ASEG_REC@DESA;
DELETE FROM ACSMIGRE.VIG_BIEN_CERT@DESA;
DELETE FROM ACSMIGRE.VIG_COBERT_BIEN@DESA;
DELETE FROM ACSMIGRE.VIG_COBERT_BIEN_REC@DESA;
DELETE FROM ACSMIGRE.VIG_GEN_REA@DESA;
DELETE FROM ACSMIGRE.VIG_DIST_REA@DESA;
DELETE FROM ACSMIGRE.VIG_DIST_FACULT@DESA;
DELETE FROM ACSMIGRE.VIG_DIAS_GAR_PAGO@DESA;
DELETE FROM ACSMIGRE.VIG_CERT_VEH@DESA;
DELETE FROM ACSMIGRE.VIG_COND_VEH@DESA;
DELETE FROM ACSMIGRE.VIG_DIREC_COBROPOLIZA@DESA;
COMMIT;
--
BEGIN
	pr_poliza.renovar (nidepol, ' ');
	pr_poliza.activar (nidepolren, 'T');
	pr_poliza.activar (nidepolren, 'D');
	--
	pr_obligacion.asig_num;
	pr_obligacion.incluir (nnumoblig);
	pr_obligacion.activar (nnumoblig);
	--
	pr_certificado.cambio_plan (
		nidepolren,
		1,
		cr.codramocert,
		b.codplan,
		b.revplan,
		dfecini,
		ccodplano,
		crevplano
	);
	--
	pr_mod_cobert.facturacion (
		nidepol,
		ctipofact,
		dfecultfact
	);
	--
	pr_deposito.ing_aut (nnumreling, ccodofiemi);
	pr_comprobante.abrir_comp ('001', SYSDATE);
	pr_factura.cobrar (
		nidefact,
		nnumreling,
		0,
		0,
		cncompr,
		0,
		ccodofi
	);
	--
	pr_det_oblig.generar (
		nnumoblig,
		b.mtodocinglocal,
		b.mtodocinglocal,
		'BS',
		'DEVOLU',
		'DEVOLU'
	);
	--
	pr_orden_pago.inserta_orden (nnumoblig);
	pr_rel_egre.incluir (nnumrelegre);
	pr_doc_egre.incluir (nnumrelegre, ccodofiemi);
	pr_doc_egre.act_rel_egre (nnumrelegre, 'BS');
END;