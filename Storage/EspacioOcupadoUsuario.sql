-- ESPACIO OCUPADO POR USUARIO
SELECT
  owner,
  SUM(BYTES)/1024/1024 
FROM DBA_EXTENTS MB
GROUP BY owner;