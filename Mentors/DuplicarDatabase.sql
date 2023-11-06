----------------------------------------------------------------
-- Configurar listener de los ambiente a duplicar
----------------------------------------------------------------
-- Se agrega TNS en TNS Names File
----------------------------------------------------------------
-- Se copia el archivo de password.
-- $ORACLE_HOME/dbs = /export/home/oracle/app/oracle/product/11.2.0/dbhome_1/dbs (DESA)
-- $ORACLE_HOME 	= /dbs/u01/app/oracle/product/11.2.0/db_1/dbs (PROD)

-- #> scp -r oracle@BD-BANK01:/u01/app/oracle/product/11.2.0/db_1/dbs/orapw<Inst_Fuente> ./orapw<Inst_Destino>

#> scp -r oracle@BD-BANK01:/u01/app/oracle/product/11.2.0/db_1/dbs/orapwBANKBU1 ./orapwBankbuM -- Cambiar nombre destino

----------------------------------------------------------------
-- Se Crea un PFile para montar el nuevo ambiente a clonar

*.archive_lag_target=0
*.audit_trail='NONE'
*.compatible='11.2.0.0.0'
*.cursor_sharing='EXACT'
*.db_block_size=8192
*.control_files='+DATA01'
*.db_domain=''
*.db_flashback_retention_target=2880
*.db_name='BANKBU'
*.db_unique_name='BankbuM'
*.instance_name='BankbuM'
*.db_recovery_file_dest='+FRA01'
*.db_recovery_file_dest_size=1100585369600
*.dg_broker_start=TRUE
*.diagnostic_dest='/export/home/oracle/'
*.fast_start_mttr_target=600
*.job_queue_processes=1000
*.log_archive_max_processes=30
*.log_archive_min_succeed_dest=1
*.log_archive_trace=0
*.open_cursors=1000
*.pga_aggregate_target=500M
*.processes=2000
*.remote_dependencies_mode='SIGNATURE'
*.remote_login_passwordfile='exclusive'
*.sessions=2300
*.sga_max_size=2G# internally adjusted
*.sga_target=3G
*.standby_file_management='AUTO'
*.statistics_level='ALL'
*.thread=1
*.transactions=2530
*.undo_retention=18000
*.undo_tablespace='UNDOTBS1'
DB_CREATE_FILE_DEST='+DATA01'
LOG_ARCHIVE_DEST='location=USE_DB_RECOVERY_FILE_DEST, valid_for=(ALL_LOGFILES, ALL_ROLES)'
DB_RECOVERY_FILE_DEST='+FRA01'
*.utl_file_dir='/InOut/BANKBU/BOD/In','/InOut/BANKBU/BOD/Logs','/InOut/BANKBU/BOD/Out'

----------------------------------------------------------------
-- Se inicia el nuevo ambiente desde sqlplus con el pfile

sql> startup nomount pfile='/export/home/oracle/InitBankbu_PROD_20160218.ora';


----------------------------------------------------------------
--Se ejecuta el script que realizara el duplicate.
 # nohup rman target sys/AvBtkWaX2D@BANKBU01-PROD auxiliary  sys/AvBtkWaX2D@BANKBU-DESA cmdfile=duplicate.rcm &

----- Fin ---
----------------------------------------------------------------
-- Contenido del script 
run {
    allocate channel prmy1 device type disk;
    allocate auxiliary channel aux01 type disk; 
    duplicate target database TO 'BANKBU' from active database ;
}

----------------------------------------------------------------
-- En caso de error de incarnación
reset database to incarnation 1;
recover datafile 1;