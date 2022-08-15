--ESPACIO UTILIZADO POR LOS TABLESPACES
--Consulta SQL para el DBA de Oracle que muestra los tablespaces, el espacio utilizado, el espacio libre y los ficheros de datos de los mismos
SELECT t.tablespace_name                      "Tablespace",
       t.status                               "Estado",
       ROUND (MAX (d.bytes) / 1024 / 1024, 2) "MB Tamaño",
       ROUND ((MAX (d.bytes) / 1024 / 1024)
                  - (SUM (DECODE (f.bytes, NULL, 0, f.bytes)) / 1024 / 1024),
               2)                             "MB Usados",
       ROUND (SUM (DECODE (f.bytes, NULL, 0, f.bytes)
                   ) / 1024 / 1024, 2)        "MB Libres",
       t.pct_increase                         "% incremento",
       SUBSTR (d.file_name, 1, 80)            "Fichero de datos"
  FROM DBA_FREE_SPACE f, DBA_DATA_FILES d, DBA_TABLESPACES t
 WHERE t.tablespace_name = d.tablespace_name
   AND f.tablespace_name(+) = d.tablespace_name
   AND f.file_id(+) = d.file_id
 GROUP BY t.tablespace_name,
       d.file_name,
       t.pct_increase,
       t.status
 ORDER BY 1, 3 DESC;