DECLARE
    SUBTYPE st_codprod IS ACSEL.plan_prod.codprod@cert%TYPE;
    SUBTYPE st_codplan IS ACSEL.plan_prod.codplan@cert%TYPE;
    SUBTYPE st_revplan IS ACSEL.plan_prod.revplan@cert%TYPE;

    CURSOR valida_prod
    IS
    SELECT  ROWID, ramo, poliza, numcer, codprod,
            codplana, revplan, idepol
    FROM eq_coberturas_ind
    WHERE CODPROD IN ('FIAN');

    CURSOR busca_plan_prod (
        p_codprod st_codprod,
        p_codplan st_codplan,
        p_revplan st_revplan
    )
    IS
    SELECT * FROM acsel.plan_prod@cert
    WHERE codprod = p_codprod
    AND codplan = p_codplan
    AND revplan = p_revplan;

    v_plan VARCHAR2(6);
    rt_busca_plan_prod busca_plan_prod%ROWTYPE;
BEGIN
    FOR C IN valida_prod
    LOOP
        v_plan := PM.BUSCAR_PLAN (C.Ramo, C.Poliza, C.NumCer);

        IF C.CODPROD = 'FIAN' THEN
            UPDATE eq_coberturas_ind
            SET CodPlanA = SUBSTR (v_plan, 1, 2),
                RevPlan = SUBSTR (v_plan, 3, 5)
            WHERE ROWID = C.ROWID;
        ELSE
            UPDATE eq_coberturas_ind
            SET CodPlanA = SUBSTR (v_plan, 1, 3),
                RevPlan = SUBSTR (v_plan, 4, 6)
            WHERE ROWID = C.ROWID;
        END IF;
        COMMIT;
    END LOOP;

    FOR C IN valida_prod
    LOOP
        OPEN busca_plan_prod (C.codprod, C.codplana, C.revplan);
        FETCH busca_plan_prod INTO rt_busca_plan_prod;

        IF busca_plan_prod%NOTFOUND THEN
            PM.GENERA_ERROR_CARTERA (
                cTipoError    => 'ERR-TAB-BASICAS',
                cCodError     => '003',
                cNomProceso   => 'PM_GF02.INSERTAR_DAT_EQ_COBERTURAS_IND',
                cNomTabla     => 'EQ_COBERTURAS_IND',
                cCodProd      => C.CodProd,
                cCodPlan      => C.CodPlanA,
                cRevPlan      => C.RevPlan,
                cMigraPlan    => 'N',
                nIdepol       => C.IdePol);
            COMMIT;
        END IF;

        CLOSE busca_plan_prod;
    END LOOP;
END;