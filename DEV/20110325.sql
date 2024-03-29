CREATE INDEX "MIGRA"."PK_GIPF01" ON "MIGRA"."GIPF01" ("CDCIA","NRREG");
CREATE INDEX "MIGRA"."PK_GIPF02" ON "MIGRA"."GIPF02" ("NRREG","NRGIR");
CREATE INDEX "MIGRA"."PK_GIPF03" ON "MIGRA"."GIPF03" ("CDCIA","NACION","CDDEU","NRREG");
CREATE INDEX "MIGRA"."PK_GIPF16" ON "MIGRA"."GIPF16" ("NRREG");
CREATE INDEX "MIGRA"."PK_HJPF02_FEC1" ON "MIGRA"."HJPF01" ("RAMO","POLIZA","ANODES"*10000+"MESDES"*100+"DIADES","ANOHAS"*10000+"MESHAS"*100+"DIAHAS");
CREATE INDEX "MIGRA"."PK_HJPF01" ON "MIGRA"."HJPF01" ("RAMO","POLIZA");
CREATE INDEX "MIGRA"."IDX_RAMPOLSTS" ON "MIGRA"."HJPF02" ("RAMO","POLIZA","STSSIT");
CREATE INDEX "MIGRA"."IDX_RAPODESHAS" ON "MIGRA"."HJPF02" ("RAMO","POLIZA","DIADES","MESDES","ANODES","DIAHAS","MESHAS","ANOHAS");
CREATE INDEX "MIGRA"."PK_HJPF02_FEC2" ON "MIGRA"."HJPF02" ("RAMO","POLIZA","ANODES"*10000+"MESDES"*100+"DIADES","ANOHAS"*10000+"MESHAS"*100+"DIAHAS");
CREATE INDEX "MIGRA"."PK_HJPF02_FEC3" ON "MIGRA"."HJPF02" ("RAMO","POLIZA","NUMREC","ANODES"*10000+"MESDES"*100+"DIADES","ANOHAS"*10000+"MESHAS"*100+"DIAHAS");
CREATE INDEX "MIGRA"."PK_HJPF02" ON "MIGRA"."HJPF02" ("RAMO","POLIZA");
CREATE INDEX "MIGRA"."IDX$$_069E0001" ON "MIGRA"."HJPF05" ("RAMO","POLIZA","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF05" ON "MIGRA"."HJPF05" ("RAMO","POLIZA","STSREC","NUMREC","CODCOB");
CREATE INDEX "MIGRA"."PK_HJPF06" ON "MIGRA"."HJPF06" ("RAMO","POLIZA","STSREC","NUMREC","COFAAM","CODBEN");
CREATE INDEX "MIGRA"."PK_CLPF06" ON "MIGRA"."CLPF06" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","COFAAM","BENCOL");
CREATE INDEX "MIGRA"."PK_CLPF43" ON "MIGRA"."CLPF43" ("RAMO","POLIZA","CERVEH");
CREATE INDEX "MIGRA"."INDEX_FNPF03" ON "MIGRA"."FNPF03" ("RAMO","POLIZA");
CREATE INDEX "MIGRA"."PK_CLPF02" ON "MIGRA"."CLPF02" ("TIPOPR","RAMO","POLIZA","CODPLA","COBCOL");
CREATE INDEX "MIGRA"."PK_CLPF05_2" ON "MIGRA"."CLPF05" ("RAMO","POLIZA","NUMCER");
CREATE INDEX "MIGRA"."PK_CLPF05_3" ON "MIGRA"."CLPF05" ("RAMO","POLIZA");
CREATE INDEX "MIGRA"."PK_CLPF05_4" ON "MIGRA"."CLPF05" ("RAMO","POLIZA","COFAAM");
CREATE INDEX "MIGRA"."PK_CLPF05" ON "MIGRA"."CLPF05" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","COFAAM");
CREATE INDEX "MIGRA"."PK_CLPF05_1" ON "MIGRA"."CLPF05" ("RAMO","POLIZA","NUMCER","COFAAM");
CREATE INDEX "MIGRA"."PK_CLPF07" ON "MIGRA"."CLPF07" ("RAMO","POLIZA","CERVEH");
CREATE INDEX "MIGRA"."PK_CLPF08" ON "MIGRA"."CLPF08" ("RAMO","POLIZA","CERVEH","CODCOB","ANODES","MESDES","DIADES");
CREATE INDEX "MIGRA"."IDX$$_06C60001" ON "MIGRA"."CLPF08" ("RAMO","POLIZA","CERVEH","CODCOB");
CREATE INDEX "MIGRA"."PK_CLPF08N_NUM" ON "MIGRA"."CLPF08N" ("RAMO","POLIZA","NUMREC");
CREATE INDEX "MIGRA"."PK_CLPF08N_COD_2" ON "MIGRA"."CLPF08N" ("RAMO","POLIZA","CERVEH","CODCOB");
CREATE INDEX "MIGRA"."PK_CLPF08N_COD_3" ON "MIGRA"."CLPF08N" ("RAMO","POLIZA","CERVEH");
CREATE INDEX "MIGRA"."PK_CLPF08N" ON "MIGRA"."CLPF08N" ("RAMO","POLIZA","CERVEH","CODCOB","ANODES","MESDES","DIADES");
CREATE INDEX "MIGRA"."PK_CLPF08N_CER" ON "MIGRA"."CLPF08N" ("RAMO","POLIZA","NUMREC","CERVEH");
CREATE INDEX "MIGRA"."PK_CLPF08N_COD" ON "MIGRA"."CLPF08N" ("RAMO","POLIZA","NUMREC","CERVEH","CODCOB");
CREATE INDEX "MIGRA"."PK_CLPF10" ON "MIGRA"."CLPF10" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","CODPLA","COBCOL");
CREATE INDEX "MIGRA"."PK_CLPF25" ON "MIGRA"."CLPF25" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","COFAAM");
CREATE INDEX "MIGRA"."IDX_CLPF25" ON "MIGRA"."CLPF25" ("RAMO","POLIZA","NUMCER","COFAAM");
CREATE INDEX "MIGRA"."PK_CLPF27" ON "MIGRA"."CLPF27" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","COFAAM");
CREATE INDEX "MIGRA"."PK_CLPF37" ON "MIGRA"."CLPF37" ("RAMO","POLIZA","NUMCER","CODEST");
CREATE INDEX "MIGRA"."PK_CLPF40_CER" ON "MIGRA"."CLPF40" ("RAMO","POLIZA","NUMREC","NUMCER");
CREATE INDEX "MIGRA"."PK_CLPF40" ON "MIGRA"."CLPF40" ("RAMO","POLIZA","NUMREC");
CREATE INDEX "MIGRA"."PK_CLPF44" ON "MIGRA"."CLPF44" ("RAMO","POLIZA","NUMCER");
CREATE INDEX "MIGRA"."PK_CTRALTAB" ON "MIGRA"."CTRALTAB" ("ACTIAR","ACARGU");
CREATE INDEX "MIGRA"."PK_ESPF01" ON "MIGRA"."ESPF01" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM","CODEST","CODCTO");
CREATE INDEX "MIGRA"."PK_HJPF07" ON "MIGRA"."HJPF07" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF08" ON "MIGRA"."HJPF08" ("RAMO","POLIZA","STSREC","NUMREC","CODEST");
CREATE INDEX "MIGRA"."IDX_RAMPOL_1" ON "MIGRA"."HJPF08" ("RAMO","POLIZA");
CREATE INDEX "MIGRA"."PK_HJPF10" ON "MIGRA"."HJPF10" ("CODPRD");
CREATE INDEX "MIGRA"."PK_HJPF10M" ON "MIGRA"."HJPF10M" ("CODPRD");
CREATE INDEX "MIGRA"."PK_HJPF13" ON "MIGRA"."HJPF13" ("RAMO","POLIZA","STSREC","NUMREC","CLAUS");
CREATE INDEX "MIGRA"."PK_HJPF21" ON "MIGRA"."HJPF21" ("TRIESG","SUBGRU","SUBCLA");
CREATE INDEX "MIGRA"."PK_HJPF24" ON "MIGRA"."HJPF24" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF25" ON "MIGRA"."HJPF25" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF26" ON "MIGRA"."HJPF26" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF27" ON "MIGRA"."HJPF27" ("RAMO","POLIZA");
CREATE INDEX "MIGRA"."PK_HJPF29" ON "MIGRA"."HJPF29" ("RAMO","POLIZA");
CREATE INDEX "MIGRA"."PK_HJPF30" ON "MIGRA"."HJPF30" ("RAMO","POLIZA");
CREATE INDEX "MIGRA"."PK_HJPF32" ON "MIGRA"."HJPF32" ("RAMO","CODCOB");
CREATE INDEX "MIGRA"."PK_HJPF32C" ON "MIGRA"."HJPF32C" ("RAMO","POLIZA","CODCOB");
CREATE INDEX "MIGRA"."PK_HJPF35" ON "MIGRA"."HJPF35" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF63" ON "MIGRA"."HJPF63" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."QUEST_SX_IDX9BD09E95DEED9093" ON "MIGRA"."HJPF71" ("NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF71" ON "MIGRA"."HJPF71" ("RAMO","POLIZA","STSREC","NUMREC","COFAAM");
CREATE INDEX "MIGRA"."PK_SIPF07" ON "MIGRA"."SIPF07" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM","CODBE","CODCOB");
CREATE INDEX "MIGRA"."PK_SIPF08" ON "MIGRA"."SIPF08" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM","NUMPGO");
CREATE INDEX "MIGRA"."IDX$$_06A60001" ON "MIGRA"."CLPF18" ("POLIZA","CLACOL");
CREATE INDEX "MIGRA"."IDX_RAMPOLCLA" ON "MIGRA"."CLPF18" ("RAMO","POLIZA","CLACOL");
CREATE INDEX "MIGRA"."PK_ORPF07" ON "MIGRA"."ORPF07" ("ANOOPA","NMROPA","CDGENT","CODBAN","NMRCHQ","CORCHQ");
CREATE INDEX "MIGRA"."IDX_2_ORPF08" ON "MIGRA"."ORPF08" ("NMROPA");
CREATE INDEX "MIGRA"."PK_ORPF08" ON "MIGRA"."ORPF08" ("NMRTRS");
CREATE INDEX "MIGRA"."PK_TRANSF" ON "MIGRA"."ORPF08" ("ANOOPA","NMROPA");
CREATE INDEX "MIGRA"."PK_MCPF01" ON "MIGRA"."MCPF01" ("CCLI1","CCLI2","CCLI3","CCLI4","CCLI5","CCLI6","CCLI7","CCLI8");
CREATE INDEX "MIGRA"."PK_HJPF75" ON "MIGRA"."HJPF75" ("RAMO","POLIZA","STSREC","NUMREC","BIECOB");
CREATE INDEX "MIGRA"."PK_HJPF76" ON "MIGRA"."HJPF76" ("ANOEMI","CORORD");
CREATE INDEX "MIGRA"."PKANO_HJPF76" ON "MIGRA"."HJPF76" ("ANOEMI");
CREATE INDEX "MIGRA"."PKCOR_HJPF76" ON "MIGRA"."HJPF76" ("CORORD");
CREATE INDEX "MIGRA"."PKPOL_HJPF76" ON "MIGRA"."HJPF76" ("POLIZA","NUMREC");
CREATE INDEX "MIGRA"."PKPOLIZA_HJPF76" ON "MIGRA"."HJPF76" ("POLIZA");
CREATE INDEX "MIGRA"."PKRECIBO_HJPF76" ON "MIGRA"."HJPF76" ("NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF83" ON "MIGRA"."HJPF83" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_RBPF10" ON "MIGRA"."RBPF10" ("CPLREC","ZONREC","NMRRCL","RAMO","POLIZA","CDGREC");
CREATE INDEX "MIGRA"."PK_HJPF84" ON "MIGRA"."HJPF84" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF94" ON "MIGRA"."HJPF94" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_REPF14" ON "MIGRA"."REPF14" ("RAMO","POLIZA","STSREC","NUMREC","TIPCON");
CREATE INDEX "MIGRA"."PK_HJPF95" ON "MIGRA"."HJPF95" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_HJPF98" ON "MIGRA"."HJPF98" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRA"."PK_REPF15" ON "MIGRA"."REPF15" ("RAMO","POLIZA","STSREC","NUMREC","TIPCON","NUMCES","CODRF");
CREATE INDEX "MIGRA"."PK_IMPF01" ON "MIGRA"."IMPF01" ("SUCCON","VOERIF","RIF");
CREATE INDEX "MIGRA"."IDX$$_07320001" ON "MIGRA"."IMPF02" ("CORORD","ANOEMI");
CREATE INDEX "MIGRA"."PK_IMPF02" ON "MIGRA"."IMPF02" ("VOERIF","RIF");
CREATE INDEX "MIGRA"."PK_ORDENE" ON "MIGRA"."ORDENE" ("ANOEMI","CORORD");
CREATE INDEX "MIGRA"."PK_OBLIGA" ON "MIGRA"."ORDENE" ("ANOOPA","NMROPA");
CREATE INDEX "MIGRA"."PK_ORPF06" ON "MIGRA"."ORPF06" ("ANOOPA","NMROPA","ANOEMI","CORORD");
CREATE INDEX "MIGRA"."INDEX_ORPF06" ON "MIGRA"."ORPF06" ("ANOEMI","CORORD");
CREATE INDEX "MIGRA"."PK_SIPF01" ON "MIGRA"."SIPF01" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM");