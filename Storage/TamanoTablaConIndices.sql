--TAMAÑO OCUPADO POR UNA TABLA CONCRETA INCLUYENDO LOS ÍNDICES DE LA MISMA
SELECT SUM(bytes)/1024/1024 Table_Allocation_MB 
FROM user_segments
WHERE segment_type in ('TABLE','INDEX')
AND (
  segment_name='NOMBRETABLA' ñ OR
  segment_name IN (
    SELECT index_name 
		FROM user_indexes 
    WHERE table_name='NOMBRETABLA')
);