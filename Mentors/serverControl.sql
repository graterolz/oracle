-- Consultar estado de la base de datos
srvctl status database -d BANKBU

-- Consultar Listener
srvctl status listener -l Listener

-- Consultar una instancia en RAC, también aplica para single instance
srvctl status instance -d BANKBU -i BANKBU1

-- Detener una instancia 
srvctl stop Instance -d BANKBU -i BANKBU2

-- Iniciar una instancia
srvctl start instance -d BANKBU -i BANKBU2

-- detener una base de datos
srvctl stop database -d BANKBU

-- Iniciar la base de datos 
srvctl start database -d BANKBU

-- para re ubicar los scan y los scan_listener en otro nodo del cluster, se especifica el nodo destino -n 
srvctl relocate scan -i 1 -n bd-bank01
srvctl relocate scan_listener -i 1 -n bd-bank01

-- detenet instancia ASM de manera forzada
srvctl stop asm -n bd-bank01 -f

-- para iniciar la instancia ASM
srvctl start asm -n bd-bank01