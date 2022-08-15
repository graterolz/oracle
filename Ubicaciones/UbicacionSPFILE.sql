-- LOCALIZAR UBICACIÓN Y NOMBRE DEL FICHERO SPFILE
-- Como el fichero de parámetros puede haberse cambiado de lugar, se puede localizar de la siguiente manera
SELECT value 
  FROM v$system_parameter 
 WHERE name = 'spfile';