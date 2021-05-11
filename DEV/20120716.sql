DECLARE
    SUBTYPE st_codprod IS ACSEL.plan_prod.codprod@cert%TYPE;
    SUBTYPE st_codplan IS ACSEL.plan_prod.codplan@cert%TYPE;
    SUBTYPE st_revplan IS ACSEL.plan_prod.revplan@cert%TYPE;

    CURSOR valida_prod
    IS
    SELECT ROWID, RAMO, POLIZA, NUMCER, codprod, idepol
    FROM EQ_COBERTURAS_IND
    WHERE ramo = 41;

    CURSOR valida_plan_prod
    IS
    SELECT ROWID, RAMO, POLIZA, NUMCER, codprod, 
        codplana, revplan, idepol
    FROM EQ_COBERTURAS_IND
    WHERE ramo = 41;

    CURSOR busca_prod (p_codprod st_codprod)
    IS
    SELECT DISTINCT codprod
    FROM ACSEL.plan_prod@CERT
    WHERE CODPROD = p_codprod;

    CURSOR busca_plan_prod (
        p_codprod   st_codprod,
        p_codplan   st_codplan,
        p_revplan   st_revplan
    )
    IS
    SELECT * FROM ACSEL.plan_prod@CERT
    WHERE CODPROD = p_codprod
    AND CODPLAN = p_codplan
    AND REVPLAN = p_revplan;

    RT_busca_prod       busca_prod%ROWTYPE;
    RT_busca_plan_prod  busca_plan_prod%ROWTYPE;
    x                   NUMBER := 0;
    y                   NUMBER := 0;
BEGIN
    FOR i IN valida_prod
    LOOP
        OPEN busca_prod (I.codprod);
        FETCH busca_prod INTO RT_busca_prod;

        IF busca_prod%NOTFOUND THEN
            PM.GENERA_ERROR_CARTERA (
                cTipoError  => 'ERR-TAB-BASICAS',
                cCodError   => '002',
                cNomProceso => 'PM_GF02.INSERTAR_DAT_EQ_COBERTURAS_IND',
                cNomTabla   => 'EQ_COBERTURAS_IND',
                nCodProd    => I.codprod,
                cCodprod    => 'N',
                nIdepol     => I.idepol
            );
            COMMIT;
            y := y + 1;
        END IF;

        CLOSE busca_prod;
    END LOOP;

    FOR i IN valida_plan_prod
    LOOP
        OPEN busca_plan_prod (I.codprod, I.codplana, I.revplan);
        FETCH busca_plan_prod INTO RT_busca_plan_prod;

        IF busca_plan_prod%NOTFOUND THEN
            PM.GENERA_ERROR_CARTERA (
                cTipoError  => 'ERR-TAB-BASICAS',
                cCodError   => '003',
                cNomProceso => 'PM_GF02.INSERTAR_DAT_EQ_COBERTURAS_IND',
                cNomTabla   => 'EQ_COBERTURAS_IND',
                nCodProd    => I.codprod,
                nPlan       => (i.codplana || i.revplan),
                cPlan       => 'N',
                nIdepol     => I.idepol
            );
            COMMIT;
            x := x + 1;
        END IF;

        CLOSE busca_plan_prod;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE ('Productos: ' || y);
    DBMS_OUTPUT.PUT_LINE ('Planes:    ' || x);
END;