SELECT COUNT (*) FROM TERCERO_MIG_PRUEBA
UNION ALL
SELECT COUNT (*) FROM CLIENTE_MIG_PRUEBA
UNION ALL
SELECT COUNT (*) FROM TERCERO_ROL_MIG_PRUEBA
UNION ALL
SELECT COUNT (*) FROM ERR_MIG_CLIENTE;
--
SELECT COUNT (*) FROM EQ_MIG_MENORES
UNION ALL
SELECT COUNT (*) FROM ERR_MIG_CLIENTE_SIN_EQ;
--
SELECT 'EQ_HJPF01', COUNT (*) FROM EQ_HJPF01
UNION ALL
SELECT 'EQ_HJPF205', COUNT (*) FROM EQ_HJPF205
UNION ALL
SELECT 'EQ_FNPF01', COUNT (*) FROM EQ_FNPF01
UNION ALL
SELECT 'EQ_ORDENE', COUNT (*) FROM EQ_ORDENE
UNION ALL
SELECT 'EQ_ORPF06', COUNT (*) FROM EQ_ORPF06
UNION ALL
SELECT 'EQ_CLPF07', COUNT (*) FROM EQ_CLPF07
UNION ALL
SELECT 'EQ_HJPF06', COUNT (*) FROM EQ_HJPF06
UNION ALL
SELECT 'EQ_HJPF71', COUNT (*) FROM EQ_HJPF71
UNION ALL
SELECT 'EQ_CLPF05_FAM', COUNT (*) FROM EQ_CLPF05_FAM;