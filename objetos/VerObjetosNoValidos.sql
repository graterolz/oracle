-- OBJETOS NO VÁLIDOS (PAQUETES, PROCEDIMIENTOS, FUNCIONES, TRIGGERS, VISTAS,…)
SELECT
  OBJECT_NAME, OBJECT_TYPE
FROM all_objects
WHERE OWNER = 'SIEBEL'
AND STATUS <> 'VALID';