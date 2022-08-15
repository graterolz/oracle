--REGLAS DE INTEGRIDAD Y COLUMNA A LA QUE AFECTAN
SELECT
       constraint_name,
       column_name 
FROM sys.all_cons_columns;