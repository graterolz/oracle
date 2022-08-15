-- IDENTIFICA TABLESPACES Y PROPIETARIOS DE LOS MISMOS. SI TIENE DEMASIADOS EXTENT
-- EL TAMAÑO DE LOS EXTENT PUEDE NO SER OPTIMO
SELECT owner,
       DECODE (partition_name,
               NULL, segment_name,
               segment_name || ':' || partition_name) name,
       segment_type,
       tablespace_name,
       bytes,
       initial_extent,
       next_extent,
       PCT_INCREASE,
       extents,
       max_extents
  FROM dba_segments
 WHERE extents > 1
 ORDER BY 9 DESC, 3;