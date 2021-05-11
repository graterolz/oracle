SELECT POLIZA, SUBSTR (POLIZA, 1, 6), CD_OFIEMI FROM af_polizas;
--
ALTER TABLE tfauto.af_polizas ADD(CD_OFIEMI VARCHAR2(6));
COMMENT ON COLUMN TFAUTO.AF_POLIZAS.CD_SUCURSAL IS 'OFICINA SUSCRIPTORA';
COMMENT ON COLUMN TFAUTO.AF_POLIZAS.CD_OFIEMI IS 'OFICINA EMISORA';
-- 
UPDATE TFAUTO.AF_POLIZAS SET CD_OFIEMI = SUBSTR (POLIZA, 1, 6);
ALTER TABLE tfauto.af_recibos ADD(CD_OFIEMI VARCHAR2(6));   
COMMENT ON COLUMN TFAUTO.af_recibos.CD_SUCURSAL IS 'OFICINA SUSCRIPTORA';
COMMENT ON COLUMN TFAUTO.af_recibos.CD_OFIEMI IS 'OFICINA EMISORA POLIZA';
--
UPDATE TFAUTO.AF_RECIBOS SET CD_OFIEMI = SUBSTR (POLIZA, 1, 6);
ALTER TABLE TFAUTO.AF_RIESGOS_CUBIERTOS ADD(CD_OFIEMI VARCHAR2(6));  
COMMENT ON COLUMN TFAUTO.AF_RIESGOS_CUBIERTOS.CD_SUCURSAL IS 'OFICINA SUSCRIPTORA';
COMMENT ON COLUMN TFAUTO.AF_RIESGOS_CUBIERTOS.CD_OFIEMI IS 'OFICINA EMISORA POLIZA';    
--
UPDATE TFAUTO.AF_RECIBOS SET CD_OFIEMI = SUBSTR (POLIZA, 1, 6);
--
DECLARE
    CURSOR cur
    IS
    SELECT DISTINCT IDEPOL, IDEOP, INDPOLTRANSF
    FROM POLIZAS_A_TRANSF_TOTALFAST
    WHERE IDEPOL IN(
        181159,207177,238782,238423,218471,218473,188366,203947,230572,230130,229858,
        218562,230614,237097,237055,218622,230129,233766,234208,234582,230128,219235,
        228814,234816,218485,235273,204084,231574,231280,236090,237338,236296,228766,
        235374,237040,204031,236914,237782,218679,218379,218773,232752,232988,232076,
        203509,232079,232080,232085,182418,182415,185982,186115,186472,202443,202507,
        202600,202725,202902,202979,203036,203070,203101,203133,203234,205485,205526,
        205524,205600,205927,238357,233708,205637,205953,218462,218505,218678,193695,
        218634,218738,218868,218869,228505,228526,221676,228552,221707,228576,230127,
        192735,229535,237538,236328,236369,183513,185843,193365,182537,185817,185936,
        185972,186100,186184,186458,187893,188875,181159,202548,202590,202733,202817,
        202836,202849,202901,203295,230654,203308,203598,203692,203771,235653,203903,
        233077,203946,205107,235936,230207,220910,235383,231815,231883,231958,234499,
        235042,236161,235629,236961,235947,236297,236344,233272,236589,231110,234442,
        238136,233205
    )
    AND tipoproceso = 1;
BEGIN
    FOR i IN cur
    LOOP
        BEGIN
            UPDATE af_polizas
            SET poliza = (
                SELECT CODOFIEMI || CODPROD || LPAD (NUMPOL, 10, '0') FROM poliza
                WHERE idepol = i.idepol
            )
            WHERE nu_poliza = (
                SELECT NUMPOL FROM poliza WHERE idepol = i.idepol
            )
            AND cd_sucursal = (
                SELECT codofisusc FROM poliza 
                WHERE idepol = i.idepol
            )
            AND fecdespol = (
                SELECT fecinivig FROM poliza
                WHERE idepol = i.idepol
            )
            AND fechaspol = (
                SELECT fecfinvig FROM poliza
                WHERE idepol = i.idepol
            );
            --
            UPDATE af_recibos
            SET poliza = (
                SELECT CODOFIEMI || CODPROD || LPAD (NUMPOL, 10, '0')
                FROM poliza
                WHERE idepol = i.idepol
            )
            WHERE nu_poliza = (
                SELECT NUMPOL FROM poliza WHERE idepol = i.idepol
            )
            AND cd_sucursal = (
                SELECT codofisusc FROM poliza WHERE idepol = i.idepol
            )
            AND recibo = (
                SELECT DISTINCT numrec FROM recibo WHERE idepol = i.idepol AND ideop = i.ideop
            )
            AND fecdesrec = (
                SELECT DISTINCT fecinivig
                FROM recibo
                WHERE idepol = i.idepol AND ideop = i.ideop
            )
            AND fechasrec = (
                SELECT DISTINCT fecfinvig
                FROM recibo
                WHERE idepol = i.idepol AND ideop = i.ideop
            );
            --
            UPDATE af_riesgos_cubiertos
            SET poliza = (
                SELECT CODOFIEMI || CODPROD || LPAD (NUMPOL, 10, '0')
                FROM poliza
                WHERE idepol = i.idepol
            )
            WHERE nu_poliza = (
                SELECT NUMPOL FROM poliza WHERE idepol = i.idepol
            )
            AND cd_sucursal = (
                SELECT codofisusc FROM poliza
                WHERE idepol = i.idepol
            )
            AND recibo = (
                SELECT DISTINCT numrec FROM recibo
                WHERE idepol = i.idepol AND ideop = i.ideop
            )
            AND fe_efectiva = (
                SELECT DISTINCT fecfinvig
                FROM recibo
                WHERE idepol = i.idepol AND ideop = i.ideop
            );
            ROLLBACK;
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(i.idepol||'-'||i.ideop);
        END;
    END LOOP;
END;