-- Bajar Base de datos Single

-- Baja la base de datos SQLplus
Shutdown Immediate

-- Baja el listener
lsnrctl stop

--
--
--

-- Bajar Producción (RAC)

-- Bajar base de datos:
	- srvctl stop database -d bankbu

-- Bajar el CRS con el usuario grid:
	- su grid
	- sudo crsctl stop crs -f

-- Subir el CRS con usuario grid:
	- su grid
	- sudo crsctl start crs

-- Subir la base de Datos:
	- srvctl start database -d bankbu

-- Abrir el wallet:
	- alter system set encryption wallet open identified by "produBankbuAS01";

-- Validar los drivers:
	$GRID_HOME/bin/acfsdriverstate -orahome $ORACLE_HOME installed
	- $GRID_HOME/bin/acfsdriverstate -orahome $ORACLE_HOME loaded

-- Cargar los drivers
	- cd $GRID_HOME/bin/ 
	- Sudo acfsload start –s