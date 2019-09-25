CREATE INDEX "MIGRAREN"."PK_CLPF02" ON "MIGRAREN"."CLPF02" ("TIPOPR","RAMO","POLIZA","CODPLA","COBCOL");
CREATE INDEX "MIGRAREN"."IDX_CLPF02" ON "MIGRAREN"."CLPF02" ("RAMO","POLIZA","CODPLA","COBCOL");
CREATE INDEX "MIGRAREN"."PK_CLPF05_1" ON "MIGRAREN"."CLPF05" ("RAMO","POLIZA","NUMCER","COFAAM");
CREATE INDEX "MIGRAREN"."IDX_CLPF05_02" ON "MIGRAREN"."CLPF05" ("RAMO","POLIZA","CODPLA");
CREATE INDEX "MIGRAREN"."PK_CLPF05_2" ON "MIGRAREN"."CLPF05" ("RAMO","POLIZA","NUMCER");
CREATE INDEX "MIGRAREN"."PK_CLPF05_3" ON "MIGRAREN"."CLPF05" ("RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."PK_CLPF05_4" ON "MIGRAREN"."CLPF05" ("RAMO","POLIZA","COFAAM");
CREATE INDEX "MIGRAREN"."PK_CLPF05" ON "MIGRAREN"."CLPF05" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","COFAAM");
CREATE INDEX "MIGRAREN"."PK_CLPF06" ON "MIGRAREN"."CLPF06" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","COFAAM","BENCOL");
CREATE INDEX "MIGRAREN"."PK_CLPF07" ON "MIGRAREN"."CLPF07" ("RAMO","POLIZA","CERVEH");
CREATE INDEX "MIGRAREN"."PK_CLPF08" ON "MIGRAREN"."CLPF08" ("RAMO","POLIZA","CERVEH","CODCOB","ANODES","MESDES","DIADES");
CREATE INDEX "MIGRAREN"."IDX$$_06C60001" ON "MIGRAREN"."CLPF08" ("RAMO","POLIZA","CERVEH","CODCOB");
CREATE INDEX "MIGRAREN"."PK_CLPF08N_NUM" ON "MIGRAREN"."CLPF08N" ("RAMO","POLIZA","NUMREC");
CREATE INDEX "MIGRAREN"."PK_CLPF08N_COD_2" ON "MIGRAREN"."CLPF08N" ("RAMO","POLIZA","CERVEH","CODCOB");
CREATE INDEX "MIGRAREN"."PK_CLPF08N_COD_3" ON "MIGRAREN"."CLPF08N" ("RAMO","POLIZA","CERVEH");
CREATE INDEX "MIGRAREN"."PK_CLPF08N" ON "MIGRAREN"."CLPF08N" ("RAMO","POLIZA","CERVEH","CODCOB","ANODES","MESDES","DIADES");
CREATE INDEX "MIGRAREN"."PK_CLPF08N_CER" ON "MIGRAREN"."CLPF08N" ("RAMO","POLIZA","NUMREC","CERVEH");
CREATE INDEX "MIGRAREN"."PK_CLPF08N_COD" ON "MIGRAREN"."CLPF08N" ("RAMO","POLIZA","NUMREC","CERVEH","CODCOB");
CREATE INDEX "MIGRAREN"."PK_CLPF10" ON "MIGRAREN"."CLPF10" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","CODPLA","COBCOL");
CREATE INDEX "MIGRAREN"."IDX$$_06A60001" ON "MIGRAREN"."CLPF18" ("POLIZA","CLACOL");
CREATE INDEX "MIGRAREN"."IDX_RAMPOLCLA" ON "MIGRAREN"."CLPF18" ("RAMO","POLIZA","CLACOL");
CREATE INDEX "MIGRAREN"."IDX$$_1CEC0002" ON "MIGRAREN"."CLPF25" ("RAMO","POLIZA","NUMCER","COFAAM","CORRE");
CREATE INDEX "MIGRAREN"."PK_CLPF25" ON "MIGRAREN"."CLPF25" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","COFAAM");
CREATE INDEX "MIGRAREN"."IDX_CLPF25" ON "MIGRAREN"."CLPF25" ("RAMO","POLIZA","NUMCER","COFAAM");
CREATE INDEX "MIGRAREN"."IDX$$_1CEC0001" ON "MIGRAREN"."CLPF25" ("NUMCER","POLIZA");
CREATE INDEX "MIGRAREN"."PK_CLPF27" ON "MIGRAREN"."CLPF27" ("TIPOPR","RAMO","POLIZA","NUMCER","CORRE","COFAAM");
CREATE INDEX "MIGRAREN"."PK_CLPF37" ON "MIGRAREN"."CLPF37" ("RAMO","POLIZA","NUMCER","CODEST");
CREATE INDEX "MIGRAREN"."IDX_RAMPOLNUM_01" ON "MIGRAREN"."CLPF37" ("RAMO","POLIZA","NUMCER");
CREATE INDEX "MIGRAREN"."IDX_RAPONUCODANO" ON "MIGRAREN"."CLPF37" ("RAMO","POLIZA","NUMCER","CODEST","CODCLA","ANO");
CREATE INDEX "MIGRAREN"."PK_CLPF40_CER" ON "MIGRAREN"."CLPF40" ("RAMO","POLIZA","NUMREC","NUMCER");
CREATE INDEX "MIGRAREN"."PK_CLPF40" ON "MIGRAREN"."CLPF40" ("RAMO","POLIZA","NUMREC");
CREATE INDEX "MIGRAREN"."PK_CLPF43" ON "MIGRAREN"."CLPF43" ("RAMO","POLIZA","CERVEH");
CREATE INDEX "MIGRAREN"."PK_CLPF44" ON "MIGRAREN"."CLPF44" ("RAMO","POLIZA","NUMCER");
CREATE INDEX "MIGRAREN"."IDX$$_132E0001" ON "MIGRAREN"."VAPF02" ("PROCES");
CREATE INDEX "MIGRAREN"."PK_CODVER" ON "MIGRAREN"."VAPF02" ("CODVER");
CREATE INDEX "MIGRAREN"."IDX_VERANO_1" ON "MIGRAREN"."VVALORES" ("VER_CIVI","ANO");
CREATE INDEX "MIGRAREN"."PK_VERANOCOD" ON "MIGRAREN"."VVALORES" ("VER_CIVI","ANO","CODVER");
CREATE INDEX "MIGRAREN"."IDX_CODVER" ON "MIGRAREN"."VVALORES" ("CODVER");
CREATE INDEX "MIGRAREN"."PK_HJPF35" ON "MIGRAREN"."HJPF35" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF63" ON "MIGRAREN"."HJPF63" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRAREN"."QUEST_SX_IDX9BD09E95DEED9093" ON "MIGRAREN"."HJPF71" ("NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF71" ON "MIGRAREN"."HJPF71" ("RAMO","POLIZA","STSREC","NUMREC","COFAAM");
CREATE INDEX "MIGRAREN"."IDX_HJPF71_01" ON "MIGRAREN"."HJPF71" ("RAMO","POLIZA","NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF75" ON "MIGRAREN"."HJPF75" ("RAMO","POLIZA","STSREC","NUMREC","BIECOB");
CREATE INDEX "MIGRAREN"."IDX$$_1E390001" ON "MIGRAREN"."HJPF75" ("POLIZA","RAMO","NUMREC","BIECOB");
CREATE INDEX "MIGRAREN"."PKANO_HJPF76" ON "MIGRAREN"."HJPF76" ("ANOEMI");
CREATE INDEX "MIGRAREN"."PKCOR_HJPF76" ON "MIGRAREN"."HJPF76" ("CORORD");
CREATE INDEX "MIGRAREN"."IDX_HJPF76" ON "MIGRAREN"."HJPF76" ("POLIZA","NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF83" ON "MIGRAREN"."HJPF83" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF84" ON "MIGRAREN"."HJPF84" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF94" ON "MIGRAREN"."HJPF94" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF95" ON "MIGRAREN"."HJPF95" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF98" ON "MIGRAREN"."HJPF98" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRAREN"."PK_IMPF01" ON "MIGRAREN"."IMPF01" ("SUCCON","VOERIF","RIF");
CREATE INDEX "MIGRAREN"."PK_IMPF01_2" ON "MIGRAREN"."IMPF01" ("TIPCON");
CREATE INDEX "MIGRAREN"."IDX$$_07320001" ON "MIGRAREN"."IMPF02" ("CORORD","ANOEMI");
CREATE INDEX "MIGRAREN"."PK_IMPF02" ON "MIGRAREN"."IMPF02" ("VOERIF","RIF");
CREATE INDEX "MIGRAREN"."PK_MCPF01" ON "MIGRAREN"."MCPF01" ("CCLI1","CCLI2");
CREATE INDEX "MIGRAREN"."IDX$$_15D50001" ON "MIGRAREN"."COPF02" ("CTAN6");
CREATE INDEX "MIGRAREN"."IDX$$_0A540001" ON "MIGRAREN"."CTRALTAB" (TRIM ("ACARGU"));
CREATE INDEX "MIGRAREN"."IDX$$_0E360001" ON "MIGRAREN"."CTRALTAB" ("ACTIAR",SUBSTR ("ACFUNC",49,2));
CREATE INDEX "MIGRAREN"."IDX_ACARGU_14_2" ON "MIGRAREN"."CTRALTAB" (SUBSTR ("ACARGU",14,2));
CREATE INDEX "MIGRAREN"."PK_CTRALTAB" ON "MIGRAREN"."CTRALTAB" ("ACTIAR","ACARGU");
CREATE INDEX "MIGRAREN"."IDX_ACTSACARG" ON "MIGRAREN"."CTRALTAB" ("ACTIAR",SUBSTR ("ACARGU",14,2));
CREATE INDEX "MIGRAREN"."IDX_CTRALTAB_01" ON "MIGRAREN"."CTRALTAB" ("ACTIAR",SUBSTR ("ACFUNC",50,1),"ACARGU");
CREATE INDEX "MIGRAREN"."PK_ESPF01" ON "MIGRAREN"."ESPF01" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM","CODEST","CODCTO");
CREATE INDEX "MIGRAREN"."INDEX_FNPF03" ON "MIGRAREN"."FNPF03" ("RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."IDX$$_19700001" ON "MIGRAREN"."FNPF05" ("RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."IDX_FNPF05" ON "MIGRAREN"."FNPF05" ("CODIAS","RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."IDX$$_19710001" ON "MIGRAREN"."FNPF06" ("NUMCON");
CREATE INDEX "MIGRAREN"."IDX_EQ_FNPF06" ON "MIGRAREN"."FNPF06" ("RAMO","POLIZA","CCLI1","CCLI2");
CREATE INDEX "MIGRAREN"."IDX_EQ_FNPF06_01" ON "MIGRAREN"."FNPF06" ("RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."IDX_FNPF06" ON "MIGRAREN"."FNPF06" ("RAMO","POLIZA","CODIAS");
CREATE INDEX "MIGRAREN"."IDX$$_19720001" ON "MIGRAREN"."FNPF08" ("POLIZA","RAMO");
CREATE INDEX "MIGRAREN"."PK_FNPF08" ON "MIGRAREN"."FNPF08" ("RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."FINANCIAMIENTO" ON "MIGRAREN"."GIPF01" ("NRREG");
CREATE INDEX "MIGRAREN"."IDX$$_11F20001" ON "MIGRAREN"."GIPF01" ("NACION","CDDEU");
CREATE INDEX "MIGRAREN"."PK_GIPF01" ON "MIGRAREN"."GIPF01" ("CDCIA","NRREG");
CREATE INDEX "MIGRAREN"."INDEX_NRREG" ON "MIGRAREN"."GIPF02" ("NRREG");
CREATE INDEX "MIGRAREN"."PK_GIPF02" ON "MIGRAREN"."GIPF02" ("NRREG","NRGIR");
CREATE INDEX "MIGRAREN"."RAMO_POLIZA_RECIBO" ON "MIGRAREN"."GIPF03" ("RAMO","POLIZA","NUMREC");
CREATE INDEX "MIGRAREN"."PK_GIPF03" ON "MIGRAREN"."GIPF03" ("CDCIA","NACION","CDDEU","NRREG");
CREATE INDEX "MIGRAREN"."IDX_GIPF03" ON "MIGRAREN"."GIPF03" ("NRREG","RAMO","POLIZA","NUMREC");
CREATE INDEX "MIGRAREN"."PK_ORDENE" ON "MIGRAREN"."ORDENE" ("ANOEMI","CORORD");
CREATE INDEX "MIGRAREN"."PK_OBLIGA" ON "MIGRAREN"."ORDENE" ("ANOOPA","NMROPA");
CREATE INDEX "MIGRAREN"."PK_ORPF06" ON "MIGRAREN"."ORPF06" ("ANOOPA","NMROPA","ANOEMI","CORORD");
CREATE INDEX "MIGRAREN"."INDEX_ORPF06" ON "MIGRAREN"."ORPF06" ("ANOEMI","CORORD");
CREATE INDEX "MIGRAREN"."PK_ORPF07" ON "MIGRAREN"."ORPF07" ("ANOOPA","NMROPA","CDGENT","CODBAN","NMRCHQ","CORCHQ");
CREATE INDEX "MIGRAREN"."IDX_2_ORPF08" ON "MIGRAREN"."ORPF08" ("NMROPA");
CREATE INDEX "MIGRAREN"."PK_ORPF08" ON "MIGRAREN"."ORPF08" ("NMRTRS");
CREATE INDEX "MIGRAREN"."PK_TRANSF" ON "MIGRAREN"."ORPF08" ("ANOOPA","NMROPA");
CREATE INDEX "MIGRAREN"."PK_RBPF10" ON "MIGRAREN"."RBPF10" ("CPLREC","ZONREC","NMRRCL","RAMO","POLIZA","CDGREC");
CREATE INDEX "MIGRAREN"."INDX_SIN" ON "MIGRAREN"."RBPF10" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM");
CREATE INDEX "MIGRAREN"."PK_REPF14" ON "MIGRAREN"."REPF14" ("RAMO","POLIZA","STSREC","NUMREC","TIPCON");
CREATE INDEX "MIGRAREN"."REPF14_INDEX_02" ON "MIGRAREN"."REPF14" ("RAMO","POLIZA","NUMREC");
CREATE INDEX "MIGRAREN"."PK_REPF15" ON "MIGRAREN"."REPF15" ("RAMO","POLIZA","STSREC","NUMREC","TIPCON","NUMCES","CODRF");
CREATE INDEX "MIGRAREN"."IDX_PLAEDA" ON "MIGRAREN"."RSPF04" ("PLANU","EDAD");
CREATE INDEX "MIGRAREN"."IDX$$_11F40002" ON "MIGRAREN"."RSPF06" ("RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."IDX$$_11F40001" ON "MIGRAREN"."RSPF06" ("POLIZA","RAMO");
CREATE INDEX "MIGRAREN"."IDX_SIPF01" ON "MIGRAREN"."SIPF01" ("RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."IDX_SIPF01_RAMO" ON "MIGRAREN"."SIPF01" ("RAMO");
CREATE INDEX "MIGRAREN"."PK_SIPF01" ON "MIGRAREN"."SIPF01" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM");
CREATE INDEX "MIGRAREN"."IDX$$_0A760001" ON "MIGRAREN"."SIPF05" ("ANOEMI","CORORD");
CREATE INDEX "MIGRAREN"."PK_SIPF05" ON "MIGRAREN"."SIPF05" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM");
CREATE INDEX "MIGRAREN"."IDX_SIPF05" ON "MIGRAREN"."SIPF05" ("RAMO","POLIZA","RECLAM","SERIE");
CREATE INDEX "MIGRAREN"."IDX_1234" ON "MIGRAREN"."SIPF05" ("ANOEMI","CORORD","TIPOPG","STSBEN");
CREATE INDEX "MIGRAREN"."PK_SIPF07" ON "MIGRAREN"."SIPF07" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM","CODBE","CODCOB");
CREATE INDEX "MIGRAREN"."IDX_SIPF07_01" ON "MIGRAREN"."SIPF07" ("RAMO","POLIZA","RECLAM","SERIE");
CREATE INDEX "MIGRAREN"."PK_SIPF08" ON "MIGRAREN"."SIPF08" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM","NUMPGO");
CREATE INDEX "MIGRAREN"."IDX_SIPF41" ON "MIGRAREN"."SIPF41" ("RAMO","POLIZA","SERIE","RECLAC","RECLAM","CODCOB");
CREATE INDEX "MIGRAREN"."IDX$$_0AB70001" ON "MIGRAREN"."SIPF41" ("RECLAM","POLIZA");
CREATE INDEX "MIGRAREN"."PK_GIPF16" ON "MIGRAREN"."GIPF16" ("NRREG");
CREATE INDEX "MIGRAREN"."IDX_GIPF55" ON "MIGRAREN"."GIPF55" ("NRREG");
CREATE INDEX "MIGRAREN"."PK_HJPF01" ON "MIGRAREN"."HJPF01" ("RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."IDX$$_18A60001" ON "MIGRAREN"."HJPF01" ("CEDREG");
CREATE INDEX "MIGRAREN"."PK_HJPF01_F2" ON "MIGRAREN"."HJPF01" ("NOMASE");
CREATE INDEX "MIGRAREN"."PK_HJPF02_FEC1" ON "MIGRAREN"."HJPF01" (
	"RAMO","POLIZA",
	"ANODES" * 10000 + "MESDES" * 100 + "DIADES",
	"ANOHAS" * 10000 + "MESHAS" * 100 + "DIAHAS"
);
CREATE INDEX "MIGRAREN"."PK_HJPF01_F1" ON "MIGRAREN"."HJPF01" ("RAMO","POLIZA","DIADES","MESDES","ANODES","DIAHAS","MESHAS","ANOHAS");
CREATE INDEX "MIGRAREN"."IDX$$_28A20001" ON "MIGRAREN"."HJPF02" ("NUMREC","POLIZA");
CREATE INDEX "MIGRAREN"."IDX_RAMPOL_03" ON "MIGRAREN"."HJPF03" ("RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."IDX_RAMO_01" ON "MIGRAREN"."HJPF03" ("RAMO");
CREATE INDEX "MIGRAREN"."IDX_RAMO_02" ON "MIGRAREN"."HJPF03" ("POLIZA");
CREATE INDEX "MIGRAREN"."IDX_HJPF03_02" ON "MIGRAREN"."HJPF03" ("GRALIC");
CREATE INDEX "MIGRAREN"."IDX_HJPF03_01" ON "MIGRAREN"."HJPF03" ("RAMO","GRALIC");
CREATE INDEX "MIGRAREN"."IDX$$_0E340001" ON "MIGRAREN"."HJPF05" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF05_2" ON "MIGRAREN"."HJPF05" ("NUMREC");
CREATE INDEX "MIGRAREN"."IDX$$_069E0001" ON "MIGRAREN"."HJPF05" ("RAMO","POLIZA","NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF05" ON "MIGRAREN"."HJPF05" ("RAMO","POLIZA","STSREC","NUMREC","CODCOB");
CREATE INDEX "MIGRAREN"."PK_HJPF06" ON "MIGRAREN"."HJPF06" ("RAMO","POLIZA","STSREC","NUMREC","COFAAM","CODBEN");
CREATE INDEX "MIGRAREN"."PK_HJPF07" ON "MIGRAREN"."HJPF07" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF08" ON "MIGRAREN"."HJPF08" ("RAMO","POLIZA","STSREC","NUMREC","CODEST");
CREATE INDEX "MIGRAREN"."IDX_RAMPOL_1" ON "MIGRAREN"."HJPF08" ("RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."IDX_RAPOCODESTE" ON "MIGRAREN"."HJPF08" ("RAMO","POLIZA","CODEST");
CREATE INDEX "MIGRAREN"."PK_HJPF08_2" ON "MIGRAREN"."HJPF08" ("POLIZA");
CREATE INDEX "MIGRAREN"."IDX_RAMPOLNUM_3" ON "MIGRAREN"."HJPF09A" ("RAMO","POLIZA","NUMREC");
CREATE INDEX "MIGRAREN"."IDX_RAPONUVER" ON "MIGRAREN"."HJPF09A" ("RAMO","POLIZA","NUMREC","VERCIH","ANOF");
CREATE INDEX "MIGRAREN"."PK_HJPF13" ON "MIGRAREN"."HJPF13" ("RAMO","POLIZA","STSREC","NUMREC","CLAUS");s
CREATE INDEX "MIGRAREN"."PK_HJPF21" ON "MIGRAREN"."HJPF21" ("TRIESG","SUBGRU","SUBCLA");
CREATE INDEX "MIGRAREN"."PK_HJPF24" ON "MIGRAREN"."HJPF24" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF25" ON "MIGRAREN"."HJPF25" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF26" ON "MIGRAREN"."HJPF26" ("RAMO","POLIZA","STSREC","NUMREC");
CREATE INDEX "MIGRAREN"."PK_HJPF27" ON "MIGRAREN"."HJPF27" ("RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."PK_HJPF29" ON "MIGRAREN"."HJPF29" ("RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."PK_HJPF30" ON "MIGRAREN"."HJPF30" ("RAMO","POLIZA");
CREATE INDEX "MIGRAREN"."PK_HJPF32C" ON "MIGRAREN"."HJPF32C" ("RAMO","POLIZA","CODCOB");