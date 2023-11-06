-- Ejecutar estadísticas 
Execute DBMS_STATS.gather_schema_stats(‘Esquema’);

-- Query para validar fecha de la última ejecución de estadísticas en los índices.
SELECT index_name, last_analyzed
FROM DBA_INDEXES order by 2 desc;

-- Script para construir los Analyze de los índices con blevel>3 

select 'ANALYZE INDEX '||owner||'.'||index_name||' VALIDATE STRUCTURE ONLINE;' line2
from sys.dba_indexes where owner = 'OPENCARD' AND blevel>3
order by table_name, index_name;

-- Si el índice tiene una Blevel superior a cuatro, reconstruir el índice.
SELECT
	index_name, blevel,
	DECODE(blevel,0,'OK BLEVEL',1,'OK BLEVEL',2,
	'OK BLEVEL',3,'OK BLEVEL',4,'OK BLEVEL','BLEVEL HIGH') OK
FROM dba_indexes where OWNER='OPENCARD' order by 2;

--
--
--

Ejecución de estadísticas

- Por TABLAS
Por favor ejecuta el cálculo de estadisticas para cada tabla  de los esquemas de la aplicacion.
	 
SQL> exec dbms_stats.gather_table_stats(ownname =>'DAI2',table_name =>'DAI2H008',estimate_percent => 100, degree => 4, cascade => true ) ;
	
-- Nota:
-- ownname : Es el nombre del esquema
-- table_name : Es el nombre de la tabla
-- estimate_percent: Es el grado de cálculo de la estadística ( te recomiendo que sea el 100%) 
-- degree : Numero de procesos en paralelo que le puedes colocar (Depende del nro de cpu que tengas ) 
-- cascade : Es para que le calcule la estadística a cada índice.
	 
- Por ESQUEMAS
Por favor ejecuta el cálculo de estadísticas para cada esquema de la aplicación.
	  
SQL>exec dbms_stats.gather_schema_stats('Schema_Name',options=>'GATHER',estimate_percent => 100,method_opt => 'FOR ALL COLUMNS SIZE AUTO', cascade => TRUE , degree => 4 ); 
	 
Nota: 
Schema_Name: Nombre del esquema que tengas. 
degree : Dependerá de los CPU que tenga tu maquina 