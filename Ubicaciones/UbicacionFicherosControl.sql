-- LOCALIZAR UBICACIÓN Y NOMBRE DE LOS FICHEROS DE CONTROL
-- Como el fichero de parámetros puede haberse cambiado de lugar, se puede localizar de la siguiente manera
-- Ubicación y número de ficheros de control:
SELECT value 
  FROM v$system_parameter 
 WHERE name = 'control_files';