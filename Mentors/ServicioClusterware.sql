-- Chequeo de servicios del clusterware
crsctl check cluster [-all | [-n server_name [...]]
crsctl check crs

-- chequea estatus de los nodos
crsctl status server

-- para iniciar el cluster en dos pasos
crsctl start has
crsctl start cluster [-all | -n server_name [...]]

-- para iniciar el cluster en un solo pasos
crsctl start crs

-- para detener el cluster
crsctl stop cluster [-all | -n server_name [...]] [-f]
crsctl stop has

-- para detener el cluster en un solo paso
crsctl start crs

-- chequear recursos del Cluster
crsctl stat res -t -init
crsctl stat res -t
./crs_stat -t

-- identificar los servicios offline

-- Iniciar un recurso abajo
./crs_start "ora.bankbu.db"

-- para iniciar recursos
crsctl start resource "ora.bankbu.db" -n bd-bank02

-- para iniciar el demonio del cluster ready service
crsctl start res ora.crsd -init

-- para listar los demonios 
crsctl stat res -t -init

crsctl status resource "ora.bankbu.db" 

-- para detener recursos
crsctl stop resource "ora.bankbu.db" -n bd-bank02