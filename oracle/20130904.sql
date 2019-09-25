CREATE INDEX DEVCASLO.ID_banca_seguro_cob_dev_010
ON DEVCASLO.banca_seguro_anu (codprod, codofiemi, numpol);
--
CREATE INDEX DEVCASLO.ID_banca_seguro_hist_010
ON DEVCASLO.banca_seguro_hist (codprov,archivo,codproc);