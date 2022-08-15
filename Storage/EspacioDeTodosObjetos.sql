OCUPACIÓN DE TODOS LOS OBJETOS DE LA BASE DE DATOS
Espacio ocupado por todos los objetos de la base de datos, muestra primero los objetos que más ocupan
SELECT
SEGMENT_NAME,
SUM(BYTES)/1024/1024 
FROM DBA_EXTENTS MB
GROUP BY SEGMENT_NAME
ORDER BY 2 DESC;