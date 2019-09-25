CREATE INDEX "MIGRA"."MIGCOBASE_INDEX_01" ON "MIGRA"."MIGCOBASE" ("RAMO","POLIZA","NUMREC","NUMCER","COFAAM","CODCOB");
CREATE INDEX "MIGRA"."IDX$$_30480001" ON "MIGRA"."MIGCARTEI" ("POLIZA");
CREATE INDEX "MIGRA"."INDX_SIN" ON "MIGRA"."RBPF10" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM");
CREATE INDEX "MIGRA"."PK_RBPF10" ON "MIGRA"."RBPF10" ("CPLREC","ZONREC","NMRRCL","RAMO","POLIZA","CDGREC");
CREATE INDEX "MIGRA"."REPF14_INDEX_02" ON "MIGRA"."REPF14" ("RAMO,POLIZA,NUMREC");
CREATE INDEX "MIGRA"."PK_REPF14" ON "MIGRA"."REPF14" ("RAMO","POLIZA","STSREC","NUMREC","TIPCON");
CREATE INDEX "MIGRA"."PK_REPF15" ON "MIGRA"."REPF15" ("RAMO","POLIZA","STSREC","NUMREC","TIPCON","NUMCES","CODRF");
CREATE INDEX "MIGRA"."IDX_PLAEDA" ON "MIGRA"."RSPF04" ("PLANU,EDAD");
CREATE INDEX "MIGRA"."IDX$$_11F40001" ON "MIGRA"."RSPF06" ("POLIZA,RAMO");
CREATE INDEX "MIGRA"."IDX$$_11F40002" ON "MIGRA"."RSPF06" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."IDX_SIPF01_RAMO" ON "MIGRA"."SIPF01" ("RAMO");
CREATE INDEX "MIGRA"."IDX_SIPF01" ON "MIGRA"."SIPF01" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."PK_SIPF01" ON "MIGRA"."SIPF01" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM");
CREATE INDEX "MIGRA"."IDX$$_0A760001" ON "MIGRA"."SIPF05" ("ANOEMI,CORORD");
CREATE INDEX "MIGRA"."IDX_1234" ON "MIGRA"."SIPF05" ("ANOEMI","CORORD","TIPOPG","STSBEN");
CREATE INDEX "MIGRA"."IDX_SIPF05" ON "MIGRA"."SIPF05" ("RAMO","POLIZA","RECLAM","SERIE");
CREATE INDEX "MIGRA"."PK_SIPF05" ON "MIGRA"."SIPF05" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM");
CREATE INDEX "MIGRA"."IDX_SIPF07_01" ON "MIGRA"."SIPF07" ("RAMO","POLIZA","RECLAM","SERIE");
CREATE INDEX "MIGRA"."PK_SIPF07" ON "MIGRA"."SIPF07" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM","CODBE","CODCOB");
CREATE INDEX "MIGRA"."PK_SIPF08" ON "MIGRA"."SIPF08" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM","NUMPGO");
CREATE INDEX "MIGRA"."IDX_SIPF41" ON "MIGRA"."SIPF41" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM","CODCOB");
CREATE INDEX "MIGRA"."IDX$$_0AB70001" ON "MIGRA"."SIPF41" ("RECLAM,POLIZA");
CREATE INDEX "MIGRA"."PK_CODVER" ON "MIGRA"."VAPF02" ("CODVER");
CREATE INDEX "MIGRA"."IDX$$_132E0001" ON "MIGRA"."VAPF02" ("PROCES");
CREATE INDEX "MIGRA"."PK_VERANOCOD" ON "MIGRA"."VVALORES" ("VER_CIVI,ANO,CODVER");
CREATE INDEX "MIGRA"."IDX_VERANO_1" ON "MIGRA"."VVALORES" ("VER_CIVI,ANO");
CREATE INDEX "MIGRA"."IDX_CODVER" ON "MIGRA"."VVALORES" ("CODVER");
CREATE INDEX "MIGRA"."PK_HJPF32C" ON "MIGRA"."HJPF32C" ("RAMO,POLIZA,CODCOB");
CREATE INDEX "MIGRA"."PK_HJPF35" ON "MIGRA"."HJPF35" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF63" ON "MIGRA"."HJPF63" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF71_3" ON "MIGRA"."HJPF71" ("RAMO,POLIZA,COFAAM");
CREATE INDEX "MIGRA"."IDX_TEM_HJPF71_03" ON "MIGRA"."HJPF71" ("RAMO");
CREATE INDEX "MIGRA"."PK_HJPF71_2" ON "MIGRA"."HJPF71" ("RAMO,POLIZA,STSREC");
CREATE INDEX "MIGRA"."IDX_HJPF71_01" ON "MIGRA"."HJPF71" ("RAMO,POLIZA,NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF71" ON "MIGRA"."HJPF71" ("RAMO","POLIZA","STSREC","NUMREC","COFAAM");
CREATE INDEX "MIGRA"."QUEST_SX_IDX9BD09E95DEED9093" ON "MIGRA"."HJPF71" ("NUMREC");
CREATE INDEX "MIGRA"."IDX$$_1E390001" ON "MIGRA"."HJPF75" ("POLIZA","RAMO","NUMREC","BIECOB");
CREATE INDEX "MIGRA"."PK_HJPF75" ON "MIGRA"."HJPF75" ("RAMO","POLIZA","STSREC","NUMREC","BIECOB");
CREATE INDEX "MIGRA"."IDX_HJPF76" ON "MIGRA"."HJPF76" ("POLIZA,NUMREC");
CREATE INDEX "MIGRA"."PKCOR_HJPF76" ON "MIGRA"."HJPF76" ("CORORD");
CREATE INDEX "MIGRA"."PKANO_HJPF76" ON "MIGRA"."HJPF76" ("ANOEMI");
CREATE INDEX "MIGRA"."PK_HJPF83" ON "MIGRA"."HJPF83" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF84" ON "MIGRA"."HJPF84" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF94" ON "MIGRA"."HJPF94" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF95" ON "MIGRA"."HJPF95" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF98" ON "MIGRA"."HJPF98" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_IMPF01_2" ON "MIGRA"."IMPF01" ("TIPCON");
CREATE INDEX "MIGRA"."PK_IMPF01" ON "MIGRA"."IMPF01" ("SUCCON,VOERIF,RIF");
CREATE INDEX "MIGRA"."PK_IMPF02" ON "MIGRA"."IMPF02" ("VOERIF,RIF");
CREATE INDEX "MIGRA"."IDX$$_07320001" ON "MIGRA"."IMPF02" ("CORORD,ANOEMI");
CREATE INDEX "MIGRA"."PK_MCPF01" ON "MIGRA"."MCPF01" ("CCLI1,CCLI2");
CREATE INDEX "MIGRA"."PK_OBLIGA" ON "MIGRA"."ORDENE" ("ANOOPA,NMROPA");
CREATE INDEX "MIGRA"."PK_ORDENE" ON "MIGRA"."ORDENE" ("ANOEMI,CORORD");
CREATE INDEX "MIGRA"."INDEX_ORPF06" ON "MIGRA"."ORPF06" ("ANOEMI,CORORD");
CREATE INDEX "MIGRA"."PK_ORPF06" ON "MIGRA"."ORPF06" ("ANOOPA","NMROPA","ANOEMI","CORORD");
CREATE INDEX "MIGRA"."PK_ORPF07" ON "MIGRA"."ORPF07" ("ANOOPA","NMROPA","CDGENT","CODBAN","NMRCHQ","CORCHQ");
CREATE INDEX "MIGRA"."PK_TRANSF" ON "MIGRA"."ORPF08" ("ANOOPA,NMROPA");
CREATE INDEX "MIGRA"."PK_ORPF08" ON "MIGRA"."ORPF08" ("NMRTRS");
CREATE INDEX "MIGRA"."IDX_2_ORPF08" ON "MIGRA"."ORPF08" ("NMROPA");
CREATE INDEX "MIGRA"."IDX_HJPF03_01" ON "MIGRA"."HJPF03" ("RAMO,GRALIC");
CREATE INDEX "MIGRA"."IDX_HJPF03_02" ON "MIGRA"."HJPF03" ("GRALIC");
CREATE INDEX "MIGRA"."IDX_RAMO_02" ON "MIGRA"."HJPF03" ("POLIZA");
CREATE INDEX "MIGRA"."IDX_RAMO_01" ON "MIGRA"."HJPF03" ("RAMO");
CREATE INDEX "MIGRA"."IDX_RAMPOL_03" ON "MIGRA"."HJPF03" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."IDX$$_069E0001" ON "MIGRA"."HJPF05" ("RAMO,POLIZA,NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF05_2" ON "MIGRA"."HJPF05" ("NUMREC");
CREATE INDEX "MIGRA"."IDX$$_0E340001" ON "MIGRA"."HJPF05" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF05" ON "MIGRA"."HJPF05" ("RAMO","POLIZA","STSREC","NUMREC","CODCOB");
CREATE INDEX "MIGRA"."PK_HJPF06" ON "MIGRA"."HJPF06" ("RAMO","POLIZA","STSREC","NUMREC","COFAAM","CODBEN");
CREATE INDEX "MIGRA"."PK_HJPF07" ON "MIGRA"."HJPF07" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."IDX_RAMPOL_1" ON "MIGRA"."HJPF08" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."PK_HJPF08" ON "MIGRA"."HJPF08" ("RAMO","POLIZA","STSREC","NUMREC","CODEST");
CREATE INDEX "MIGRA"."PK_HJPF08_2" ON "MIGRA"."HJPF08" ("POLIZA");
CREATE INDEX "MIGRA"."IDX_RAPOCODESTE" ON "MIGRA"."HJPF08" ("RAMO,POLIZA,CODEST");
CREATE INDEX "MIGRA"."IDX_RAPONUVER" ON "MIGRA"."HJPF09A" ("RAMO,POLIZA,NUMREC,VERCIH,ANOF");
CREATE INDEX "MIGRA"."IDX_RAMPOLNUM_3" ON "MIGRA"."HJPF09A" ("RAMO,POLIZA,NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF13" ON "MIGRA"."HJPF13" ("RAMO","POLIZA","STSREC","NUMREC","CLAUS");
CREATE INDEX "MIGRA"."PK_HJPF21" ON "MIGRA"."HJPF21" ("TRIESG,SUBGRU,SUBCLA");
CREATE INDEX "MIGRA"."PK_HJPF24" ON "MIGRA"."HJPF24" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF25" ON "MIGRA"."HJPF25" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF26" ON "MIGRA"."HJPF26" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF27" ON "MIGRA"."HJPF27" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."PK_HJPF29" ON "MIGRA"."HJPF29" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."PK_HJPF30" ON "MIGRA"."HJPF30" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."IDX_FNPF05" ON "MIGRA"."FNPF05" ("CODIAS,RAMO,POLIZA");
CREATE INDEX "MIGRA"."IDX$$_19700001" ON "MIGRA"."FNPF05" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."IDX_FNPF06" ON "MIGRA"."FNPF06" ("RAMO,POLIZA,CODIAS");
CREATE INDEX "MIGRA"."IDX_EQ_FNPF06_01" ON "MIGRA"."FNPF06" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."IDX_EQ_FNPF06" ON "MIGRA"."FNPF06" ("RAMO","POLIZA","CCLI1","CCLI2");
CREATE INDEX "MIGRA"."IDX$$_19710001" ON "MIGRA"."FNPF06" ("NUMCON");
CREATE INDEX "MIGRA"."PK_FNPF08" ON "MIGRA"."FNPF08" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."IDX$$_19720001" ON "MIGRA"."FNPF08" ("POLIZA,RAMO");
CREATE INDEX "MIGRA"."PK_GIPF01" ON "MIGRA"."GIPF01" ("CDCIA,NRREG");
CREATE INDEX "MIGRA"."IDX$$_11F20001" ON "MIGRA"."GIPF01" ("NACION,CDDEU");
CREATE INDEX "MIGRA"."FINANCIAMIENTO" ON "MIGRA"."GIPF01" ("NRREG");
CREATE INDEX "MIGRA"."PK_GIPF02" ON "MIGRA"."GIPF02" ("NRREG,NRGIR");
CREATE INDEX "MIGRA"."INDEX_NRREG" ON "MIGRA"."GIPF02" ("NRREG");
CREATE INDEX "MIGRA"."IDX_GIPF03" ON "MIGRA"."GIPF03" ("NRREG","RAMO","POLIZA","NUMREC");
CREATE INDEX "MIGRA"."PK_GIPF03" ON "MIGRA"."GIPF03" ("CDCIA","NACION","CDDEU","NRREG");
CREATE INDEX "MIGRA"."RAMO_POLIZA_RECIBO" ON "MIGRA"."GIPF03" ("RAMO,POLIZA,NUMREC");
CREATE INDEX "MIGRA"."PK_GIPF16" ON "MIGRA"."GIPF16" ("NRREG");
CREATE INDEX "MIGRA"."IDX$$_23670001" ON "MIGRA"."GIPF16" ("CDDEU,NACION");
CREATE INDEX "MIGRA"."IDX_GIPF55" ON "MIGRA"."GIPF55" ("NRREG");
CREATE INDEX "MIGRA"."PK_HJPF01_F2" ON "MIGRA"."HJPF01" ("NOMASE");
CREATE INDEX "MIGRA"."IDX$$_18A60001" ON "MIGRA"."HJPF01" ("CEDREG");
CREATE INDEX "MIGRA"."PK_HJPF01" ON "MIGRA"."HJPF01" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."PK_HJPF02_FEC1" ON "MIGRA"."HJPF01" ("RAMO","POLIZA","ANODES" * 10000 + "MESDES" * 100 + "DIADES","ANOHAS" * 10000 + "MESHAS" * 100 + "DIAHAS");
CREATE INDEX "MIGRA"."PK_HJPF01_F1" ON "MIGRA"."HJPF01" ("RAMO","POLIZA","DIADES","MESDES","ANODES","DIAHAS","MESHAS","ANOHAS");
CREATE INDEX "MIGRA"."IDX_HJPF02" ON "MIGRA"."HJPF02" ("NUMREC");
CREATE INDEX "MIGRA"."IDX_HJPF02_03" ON "MIGRA"."HJPF02" ("RAMO,NUMREC");
CREATE INDEX "MIGRA"."IDX_HJPF02_01" ON "MIGRA"."HJPF02" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."IDX_POLREC_01" ON "MIGRA"."HJPF02" ("POLIZA,NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF02" ON "MIGRA"."HJPF02" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."PK_HJPF02_FEC3" ON "MIGRA"."HJPF02" ("RAMO","POLIZA","NUMREC","ANODES" * 10000 + "MESDES" * 100 + "DIADES","ANOHAS" * 10000 + "MESHAS" * 100 + "DIAHAS");
CREATE INDEX "MIGRA"."PK_HJPF02_FEC2" ON "MIGRA"."HJPF02" ("RAMO","POLIZA","ANODES" * 10000 + "MESDES" * 100 + "DIADES","ANOHAS" * 10000 + "MESHAS" * 100 + "DIAHAS");
CREATE INDEX "MIGRA"."IDX_RAPODESHAS" ON "MIGRA"."HJPF02" ("RAMO","POLIZA","DIADES","MESDES","ANODES","DIAHAS","MESHAS","ANOHAS");
CREATE INDEX "MIGRA"."IDX_RAMPOLSTS" ON "MIGRA"."HJPF02" ("RAMO,POLIZA,STSSIT");
CREATE INDEX "MIGRA"."PK_HJPF02_F1" ON "MIGRA"."HJPF02" ("RAMO","POLIZA","STSREC","NUMREC","DIADES","MESDES","ANODES","DIAHAS","MESHAS","ANOHAS");
CREATE INDEX "MIGRA"."IDX_HJPF02_02" ON "MIGRA"."HJPF02" ("RAMO,POLIZA,NUMREC");
CREATE INDEX "MIGRA"."PK_CLPF05" ON "MIGRA"."CLPF05" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","COFAAM");
CREATE INDEX "MIGRA"."PK_CLPF05_4" ON "MIGRA"."CLPF05" ("RAMO,POLIZA,COFAAM");
CREATE INDEX "MIGRA"."PK_CLPF05_3" ON "MIGRA"."CLPF05" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."PK_CLPF05_2" ON "MIGRA"."CLPF05" ("RAMO,POLIZA,NUMCER");
CREATE INDEX "MIGRA"."IDX_CLPF05_02" ON "MIGRA"."CLPF05" ("RAMO,POLIZA,CODPLA");
CREATE INDEX "MIGRA"."PK_CLPF05_1" ON "MIGRA"."CLPF05" ("RAMO","POLIZA","NUMCER","COFAAM");
CREATE INDEX "MIGRA"."PK_CLPF06" ON "MIGRA"."CLPF06" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","COFAAM","BENCOL");
CREATE INDEX "MIGRA"."PK_CLPF07" ON "MIGRA"."CLPF07" ("RAMO,POLIZA,CERVEH");
CREATE INDEX "MIGRA"."IDX$$_06C60001" ON "MIGRA"."CLPF08" ("RAMO","POLIZA","CERVEH","CODCOB");
CREATE INDEX "MIGRA"."PK_CLPF08" ON "MIGRA"."CLPF08" ("RAMO","POLIZA","CERVEH","CODCOB","ANODES","MESDES","DIADES");
CREATE INDEX "MIGRA"."PK_CLPF08N_COD" ON "MIGRA"."CLPF08N" ("RAMO,POLIZA,NUMREC,CERVEH,CODCOB");
CREATE INDEX "MIGRA"."PK_CLPF08N_CER" ON "MIGRA"."CLPF08N" ("RAMO,POLIZA,NUMREC,CERVEH");
CREATE INDEX "MIGRA"."PK_CLPF08N" ON "MIGRA"."CLPF08N" ("RAMO,POLIZA,CERVEH,CODCOB,ANODES,MESDES,DIADES");
CREATE INDEX "MIGRA"."PK_CLPF08N_COD_3" ON "MIGRA"."CLPF08N" ("RAMO,POLIZA,CERVEH");
CREATE INDEX "MIGRA"."PK_CLPF08N_COD_2" ON "MIGRA"."CLPF08N" ("RAMO,POLIZA,CERVEH,CODCOB");
CREATE INDEX "MIGRA"."PK_CLPF08N_NUM" ON "MIGRA"."CLPF08N" ("RAMO,POLIZA,NUMREC");
CREATE INDEX "MIGRA"."PK_CLPF10" ON "MIGRA"."CLPF10" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","CODPLA","COBCOL");
CREATE INDEX "MIGRA"."IDX_RAMPOLCLA" ON "MIGRA"."CLPF18" ("RAMO,POLIZA,CLACOL");
CREATE INDEX "MIGRA"."IDX$$_06A60001" ON "MIGRA"."CLPF18" ("POLIZA,CLACOL");
CREATE INDEX "MIGRA"."IDX_CLPF25" ON "MIGRA"."CLPF25" ("RAMO","POLIZA","NUMCER","COFAAM");
CREATE INDEX "MIGRA"."PK_CLPF25" ON "MIGRA"."CLPF25" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","COFAAM");
CREATE INDEX "MIGRA"."IDX$$_1CEC0002" ON "MIGRA"."CLPF25" ("RAMO","POLIZA","NUMCER","COFAAM","CORRE");
CREATE INDEX "MIGRA"."IDX$$_1CEC0001" ON "MIGRA"."CLPF25" ("NUMCER,POLIZA");
CREATE INDEX "MIGRA"."PK_CLPF27" ON "MIGRA"."CLPF27" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","COFAAM");
CREATE INDEX "MIGRA"."IDX_RAPONUCODANO" ON "MIGRA"."CLPF37" ("RAMO","POLIZA","NUMCER","CODEST","CODCLA","ANO");
CREATE INDEX "MIGRA"."IDX_RAMPOLNUM_01" ON "MIGRA"."CLPF37" ("RAMO,POLIZA,NUMCER");
CREATE INDEX "MIGRA"."PK_CLPF37" ON "MIGRA"."CLPF37" ("RAMO","POLIZA","NUMCER","CODEST");
CREATE INDEX "MIGRA"."PK_CLPF40" ON "MIGRA"."CLPF40" ("RAMO,POLIZA,NUMREC");
CREATE INDEX "MIGRA"."PK_CLPF40_CER" ON "MIGRA"."CLPF40" ("RAMO","POLIZA","NUMREC","NUMCER");
CREATE INDEX "MIGRA"."PK_CLPF43" ON "MIGRA"."CLPF43" ("RAMO,POLIZA,CERVEH");
CREATE INDEX "MIGRA"."PK_CLPF44" ON "MIGRA"."CLPF44" ("RAMO,POLIZA,NUMCER");
CREATE INDEX "MIGRA"."IDX$$_15D50001" ON "MIGRA"."COPF02" ("CTAN6");
CREATE INDEX "MIGRA"."IDX_ACARGU_14_2" ON "MIGRA"."CTRALTAB" (SUBSTR ("ACARGU", 14, 2));
CREATE INDEX "MIGRA"."IDX$$_0E360001" ON "MIGRA"."CTRALTAB" ("ACTIAR", SUBSTR ("ACFUNC", 49, 2));
CREATE INDEX "MIGRA"."IDX$$_0A540001" ON "MIGRA"."CTRALTAB" (TRIM ("ACARGU"));
CREATE INDEX "MIGRA"."PK_CTRALTAB" ON "MIGRA"."CTRALTAB" ("ACTIAR,ACARGU");
CREATE INDEX "MIGRA"."IDX_CTRALTAB_01" ON "MIGRA"."CTRALTAB" ("ACTIAR", SUBSTR ("ACFUNC", 50, 1), "ACARGU");
CREATE INDEX "MIGRA"."IDX_ACTSACARG" ON "MIGRA"."CTRALTAB" ("ACTIAR", SUBSTR ("ACARGU", 14, 2));
CREATE INDEX "MIGRA"."PK_ESPF01" ON "MIGRA"."ESPF01" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM","CODEST","CODCTO");
CREATE INDEX "MIGRA"."INDEX_FNPF03" ON "MIGRA"."FNPF03" ("RAMO,POLIZA");
CREATE INDEX "MIGRA"."IDX_CLPF02" ON "MIGRA"."CLPF02" ("RAMO","POLIZA","CODPLA","COBCOL");
CREATE INDEX "MIGRA"."PK_CLPF02" ON "MIGRA"."CLPF02" ("TIPOPR","RAMO","POLIZA","CODPLA","COBCOL");