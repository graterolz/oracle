DECLARE
    SUBTYPE st_codprod IS ACSEL.plan_prod.codprod@cert%TYPE;
    SUBTYPE st_codplan IS ACSEL.plan_prod.codplan@cert%TYPE;
    SUBTYPE st_revplan IS ACSEL.plan_prod.revplan@cert%TYPE;

    CURSOR act_idepol_polizas_avi
    IS
    SELECT /*+ FIRST_ROWS */ ramo, poliza, idepol
    FROM EQ_COBERTURAS_IND
    WHERE ramo = 37;

    CURSOR valida_prod
    IS
    SELECT ROWID,ramo, poliza,numcer,codprod,idepol
    FROM eq_coberturas_ind;

    CURSOR valida_plan_prod
    IS
    SELECT ROWID, ramo, poliza,numcer,
        codprod, codplana,revplan,idepol
    FROM eq_coberturas_ind
    WHERE migra <> 'N';

    CURSOR busca_plan_prod (
        p_codprod    st_codprod,
        p_codplan    st_codplan,
        p_revplan    st_revplan
    )
    IS
    SELECT * FROM acsel.plan_prod@cert
    WHERE codprod = p_codprod
    AND codplan = p_codplan
    AND revplan = p_revplan;

    CURSOR busca_prod (
        p_codprod st_codprod
    )
    IS
    SELECT DISTINCT codprod
    FROM acsel.plan_prod@cert
    WHERE codprod = p_codprod;

    v_plan              VARCHAR2 (6);
    rt_busca_prod       busca_prod%ROWTYPE;
    rt_busca_plan_prod  busca_plan_prod%ROWTYPE;
BEGIN
    DBMS_OUTPUT.put_line ('Termina update 1');
    --
    UPDATE EQ_COBERTURAS_IND aa
    SET IdePol = (
        SELECT bb.IdePol
        FROM EQ_COBERTURAS_IND bb
        WHERE aa.Poliza = bb.Poliza AND Ramo = 33
        GROUP BY bb.IdePol
    )
    WHERE EXISTS(
        SELECT 1
        FROM EQ_COBERTURAS_IND bb
        WHERE aa.Poliza = bb.Poliza AND Ramo = 33
    )
    AND aa.Ramo IN (32, 34, 35);
    COMMIT;
    --
    DBMS_OUTPUT.put_line ('Termina update 2');
    --
    FOR C IN act_idepol_polizas_avi
    LOOP
        UPDATE EQ_COBERTURAS_IND AA
        SET Idepol = C.IdePol
        WHERE aa.Ramo IN (36, 38) 
        AND aa.Poliza = C.Poliza;
        COMMIT;
    END LOOP;
    --
    DBMS_OUTPUT.put_line ('Termina update 3');
    --
    FOR C IN valida_prod
    LOOP
        v_plan := PM.BUSCAR_PLAN (C.Ramo, C.Poliza, C.NumCer);
        UPDATE eq_coberturas_ind
        SET CODPROD = PM.buscar_producto (C.Ramo, C.Poliza),
            CodPlanA = SUBSTR (v_plan, 1, 3),
            RevPlan = SUBSTR (v_plan, 4, 6)
        WHERE ROWID = C.ROWID;
        COMMIT;
        DBMS_OUTPUT.put_line ('Incluye producto y plan');
    END LOOP;
    --
    FOR C IN valida_prod
    LOOP
        OPEN busca_prod (C.CodProd);
        FETCH busca_prod INTO rt_busca_prod;

        IF busca_prod%NOTFOUND THEN
            PM.GENERA_ERROR_CARTERA(
                cTipoError      => 'ERR-TAB-BASICAS',
                cCodError       => '002',
                cNomProceso     => 'PM_GF02.INSERTAR_DAT_EQ_COBERTURAS_IND',
                cNomTabla       => 'EQ_COBERTURAS_IND',
                cCodProd        => C.codprod,
                cMigraProducto  => 'N',
                nIdepol         => C.IdePol
            );
            COMMIT;
        END IF;
        CLOSE busca_prod;
    END LOOP;
    COMMIT;
    --
    DBMS_OUTPUT.put_line (' valida_prod producto');
    --
    FOR C IN valida_plan_prod
    LOOP
        OPEN busca_plan_prod (C.codprod, C.codplana, C.revplan);
        FETCH busca_plan_prod INTO rt_busca_plan_prod;

        IF busca_plan_prod%NOTFOUND THEN
            PM.GENERA_ERROR_CARTERA (
                cTipoError      => 'ERR-TAB-BASICAS',
                cCodError       => '003',
                cNomProceso     => 'PM_GF02.INSERTAR_DAT_EQ_COBERTURAS_IND',
                cNomTabla       => 'EQ_COBERTURAS_IND',
                cCodProd        => C.CodProd,
                cCodPlan        => C.CodPlanA,
                cRevPlan        => C.RevPlan,
                cMigraPlan      => 'N',
                nIdepol         => C.IdePol
            );
            COMMIT;
        END IF;

        CLOSE busca_plan_prod;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.put_line ('Valida plan ');
END;