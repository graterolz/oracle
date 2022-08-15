-- TABLAS DE LAS QUE ES PROPIETARIO UN USUARIO DETERMINADO
SELECT table_owner, table_name 
FROM sys.all_synonyms 
WHERE table_owner = 'SCOTT';