-- Script de respaldo

run {
	allocate channel 'dev_0' type 'sbt_tape'
	parms 'ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=ICS,OB2BARLIST=BODAPPS115_ICS_DB_FULL_ORA_DIA)';
	allocate channel 'dev_1' type 'sbt_tape'
	parms 'ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=ICS,OB2BARLIST=BODAPPS115_ICS_DB_FULL_ORA_DIA)';
	allocate channel 'dev_2' type 'sbt_tape'
	parms 'ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=ICS,OB2BARLIST=BODAPPS115_ICS_DB_FULL_ORA_DIA)';
	allocate channel 'dev_3' type 'sbt_tape'
	parms 'ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=ICS,OB2BARLIST=BODAPPS115_ICS_DB_FULL_ORA_DIA)';
	allocate channel 'dev_4' type 'sbt_tape'
	parms 'ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=ICS,OB2BARLIST=BODAPPS115_ICS_DB_FULL_ORA_DIA)';
	allocate channel 'dev_5' type 'sbt_tape'
	parms 'ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=ICS,OB2BARLIST=BODAPPS115_ICS_DB_FULL_ORA_DIA)';
	sql 'alter system archive log current';
	backup format 'BODAPPS115_ICS_DB_FULL_ORA_DIA<ICS_%s:%t:%p>.dbf' archivelog all;
	DELETE NOPROMPT FORCE ARCHIVELOG UNTIL TIME 'sysdate -1';
	backup format 'BODAPPS115_ICS_DB_FULL_ORA_DIA<ICS_%s:%t:%p>.dbf' current controlfile;
}

run {
	allocate channel 'dev_0' type 'sbt_tape'
	parms 'SBT_LIBRARY=/opt/omni/lib/libob2oracle8_64bit.so,ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=BankbuBI,OB2BARLIST=BD_BI_ DB_FULL_ORA_DIA)';
	allocate channel 'dev_1' type 'sbt_tape'
	parms 'SBT_LIBRARY=/opt/omni/lib/libob2oracle8_64bit.so,ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=BankbuBI,OB2BARLIST=BD_BI_ DB_FULL_ORA_DIA)';
	allocate channel 'dev_2' type 'sbt_tape'
	parms 'SBT_LIBRARY=/opt/omni/lib/libob2oracle8_64bit.so,ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=BankbuBI,OB2BARLIST=BD_BI_ DB_FULL_ORA_DIA)';
	backup incremental level 0
	format 'BD_BI_ DB_FULL_ORA_DIA<BankbuBI_%s:%t:%p>.dbf'
	database;
	backup
	format 'BD_BI_ DB_FULL_ORA_DIA<BankbuBI_%s:%t:%p>.dbf'
	recovery area;
	DELETE NOPROMPT ARCHIVELOG UNTIL TIME 'sysdate -1';
	backup
	format 'BD_BI_ DB_FULL_ORA_DIA<BankbuBI_%s:%t:%p>.dbf'
	current controlfile;
}

nohup rman target lzambrano/Pegaso26@BankbuBi catalog rman/RespaldoRMAN01@rcatbod cmdfile=backupBI.rman > log_bankbuBI.log &

--
--
--

-- Respaldo nivel 0 de bankbu
rman target lzambrano/Pegaso26@bankbu catalog rman/RespaldoRMAN01@rcatbod 

run {
	allocate channel 'dev_0' type 'sbt_tape'
	parms 'SBT_LIBRARY=/opt/omni/lib/libob2oracle8_64bit.so,ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=BANKBU,OB2BARLIST=BD-BANK-SCAN_Bankbu_BD_FULL_ORA)';
	allocate channel 'dev_1' type 'sbt_tape'
	parms 'SBT_LIBRARY=/opt/omni/lib/libob2oracle8_64bit.so,ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=BANKBU,OB2BARLIST=BD-BANK-SCAN_Bankbu_BD_FULL_ORA)';
	allocate channel 'dev_2' type 'sbt_tape'
	parms 'SBT_LIBRARY=/opt/omni/lib/libob2oracle8_64bit.so,ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=BANKBU,OB2BARLIST=BD-BANK-SCAN_Bankbu_BD_FULL_ORA)';
	send device type 'sbt_tape' 'OB2BARHOSTNAME=bd-bank-scan.com';
	sql 'alter system archive log current';
	backup incremental level 0
	format 'BD-BANK-SCAN_Bankbu_BD_FULL_ORA<BANKBU_%s:%t:%p>.dbf'
	database;
	backup
	format 'BD-BANK-SCAN_Bankbu_BD_FULL_ORA<BANKBU_%s:%t:%p>.dbf'
	archivelog all;
	backup
	format 'BD-BANK-SCAN_Bankbu_BD_FULL_ORA<BANKBU_%s:%t:%p>.dbf'
	recovery area;
	DELETE NOPROMPT ARCHIVELOG UNTIL TIME 'sysdate -1';
	backup
	format 'BD-BANK-SCAN_Bankbu_BD_FULL_ORA<BANKBU_%s:%t:%p>.dbf'
	current controlfile;
}

nohup rman target / catalog rman/RespaldoRMAN01@rcatbod cmdfile=backupmes.rman > log_20160222.log &

-- Desarrollo
nohup rman target / catalog DESARMAN/Bod12345@rcatbod cmdfile=backupmes.rman > log_20160222.log &

--
--
--

run
{
	allocate channel 'dev_0' type 'sbt_tape' parms 'SBT_LIBRARY=/opt/omni/lib/libob2oracle8_64bit.so,ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=BANKBU,OB2BARLIST=BD-BANK-SCAN_Bankbu_BD_FULL_ORA)';
	allocate channel 'dev_1' type 'sbt_tape' parms 'SBT_LIBRARY=/opt/omni/lib/libob2oracle8_64bit.so,ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=BANKBU,OB2BARLIST=BD-BANK-SCAN_Bankbu_BD_FULL_ORA)';
	allocate channel 'dev_2' type 'sbt_tape' parms 'SBT_LIBRARY=/opt/omni/lib/libob2oracle8_64bit.so,ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=BANKBU,OB2BARLIST=BD-BANK-SCAN_Bankbu_BD_FULL_ORA)';
	RESTORE DATABASE From Tag='TAG20110610T212018'; 
	SWITCH DATAFILE ALL;  # para actualizar el control file e indicarle las nuevas rutas
	RECOVER DATABASE;
	RELEASE CHANNEL 'dev_0';
	RELEASE CHANNEL 'dev_1';
	RELEASE CHANNEL 'dev_2';
}