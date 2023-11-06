-- 1. Respaldo del esquema opencard en desarrollo si existe
expdp opencard/Bod12345@BankbuP schemas=OPENCARD directory=BACKUP dumpfile=expdp_data_schema_OPENCARD_20151022.dmp logfile=expdp_data_schema_OPENCARD_20151022.log
	
-- 2. Respaldo del catálogo de recuperación de RMAN
expdp rman/RespaldoRMAN01@rcatbod directory=BACKUP_BD SCHEMAS=RMAN dumpfile=rman_20151022.dmp logfile=rman_20151022.log
	
-- 3. Si existe la instancia se debe borrar la Base de dato 
	
-- 4. Configurar variable ORACLE_SID en el host destino.
export ORACLE_SID=BankbuT
	
-- 5. Iniciar RMAN y conectarse al catálogo de recuperación.
rman target / catalog bk_rmand/BodRMAN01@rcatbod