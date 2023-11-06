-- Comando para ver la variable de ambiente
$ printenv  path
$ printenv  

-- Para agregar la variable ORACLE _SID
export ORACLE_SID=BankbuC

-- Ver los SMON que se están ejecutando en el servidor
ps -ef | grep smon

-- Ver el valor se la variable ORACLE_SID
echo $ORACLE_SID

-- Entrar al sql plus
sqlplus / as sysdba

-- Comandos del Lintener
lsnrctl status
lsnrctl start
lsnrctl stop

-- Ver usuario con el que estamos conectados
show user;

-- Ver los valores de sesiones y procesos
select resource_name, current_utilization, max_utilization, limit_value 
from v$resource_limit 
where resource_name in ('sessions', 'processes');

-- Formato de Fecha
alter session set nls_date_format = 'dd-mm-yyyy HH24:MI:SS'; 

-- Archivo de salida en forma de HTML
set markup html on spool on 
Spool file_name.html
..
..
set markup html off 
Spool off 

-- Revisar el SID y el Oracle Home
set serveroutput on;
declare
 OHM varchar2(100);  
 OHS varchar2(100); 
begin
  dbms_system.get_env('ORACLE_HOME', OHM) ;  
  dbms_system.get_env('ORACLE_SID', OHS) ;  
  DBMS_OUTPUT.PUT_LINE( OHM);  
  DBMS_OUTPUT.PUT_LINE( OHS); 
end;