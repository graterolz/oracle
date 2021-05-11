SELECT * FROM (
    SELECT  AA.RAMO RAMO,
            AA.POLIZA POLIZA,
            AA.NUMREC NUMREC,
            SUM (AA.Prima) PrimaMigcobase,
            SUM (BB.pricap) PrimaEqCoberturas,
            SUM (AA.Prima) - SUM (BB.pricap) Diferencia
    FROM MIGCOBASE AA, EQ_COBERTURAS_IND BB
    WHERE AA.RAMO = BB.RAMO
    AND AA.POLIZA = BB.POLIZA
    AND AA.NUMREC = BB.NUMREC
    AND AA.NUMCER = BB.NUMCER
    AND AA.CUADRE = 'S'
    AND BB.INDTIPO = 2
    GROUP BY AA.RAMO, AA.POLIZA, AA.NUMREC
);