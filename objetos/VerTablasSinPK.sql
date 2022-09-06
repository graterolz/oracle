-- TABLAS SIN PRÍMARY KEY
SELECT TABLE_NAME 
FROM ALL_TABLES T
WHERE OWNER = 'SIEBEL'
AND NOT EXISTS (
  SELECT 1 FROM ALL_CONSTRAINTS C   
  WHERE T.OWNER  = C.OWNER
  AND CONSTRAINT_TYPE = 'P'
);