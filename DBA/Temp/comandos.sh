startup;			-- Iniciar BD
startup mount;		-- Iniciar BD
startup nomount;	-- Iniciar BD

-- Comando para ejecutar Script de creación del usuario en el Servidor DE LA AGENCIA
osql -U SA -P -n -i C:\script.sql -o C:\Result_OSQL.txt

-- Comando para ejecutar Script de creación del usuario en el Servidor BODAPPS20
REM osql -S BODAPPS20 -U ADMTSM -P admtsm -n -i C:\script.sql -o C:\Result_OSQL.txt

show sga
show parameters size
show parameters pga_aggregate_target
--
--
$sqlplus /nolog
SQL> CONNECT / AS SYSDBA | connect sys/internal as sysdba
SQL> SHUTDOWN IMMEDIATE
SQL> STARTUP MOUNT pfile=C:\database10\initOCON.ORA
SQL> ALTER SYSTEM ENABLE RESTRICTED SESSION;
SQL> ALTER SYSTEM SET JOB_QUEUE_PROCESSES=0 SCOPE = MEMORY;
SQL> ALTER SYSTEM SET AQ_TM_PROCESSES=0 SCOPE = MEMORY;
SQL> ALTER DATABASE OPEN;
SQL> ALTER DATABASE NATIONAL CHARACTER SET UTF8;
SQL> SHUTDOWN IMMEDIATE
SQL> STARTUP pfile=C:\database10\initOCON.ORA
--
sqlplus sys as sydba
SQL> shutdown immediate;
SQL> startup restrict pfile=C:\database10\initOCON.ORA
SQL> ALTER DATABASE CHARACTER SET INTERNAL_USE WE8MSWIN1252 ;
SQL> shutdown immediate;
SQL> startup pfile=C:\database10\initOCON.ORA
--