-- Crear DbLink

CREATE DATABASE LINK
CREATE PUBLIC DATABASE LINK

-- Se debe especificar el usuario remoto, password y nombre del servicio TNS
create public database link 
  mylink
connect to 
  remote_username
identified by 
  mypassword 
using 'tns_service_name';

-- A partir de 11g 2 se permite se puede remplazar el servicio TNS por el 
-- nombre del servidor, número de puerto y ORACLE_SID.

create public database link 
  mylink
connect to 
  remote_username
identified by 
  mypassword 
using 'myserver:1521/MYSID';