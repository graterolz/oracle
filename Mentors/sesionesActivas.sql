-- Identificar sesiones

SELECT 
SQL_TEXT, --Sentencia SQL
USERNAME, --Nombre usuario
SCHEMANAME, --Nombre Eschema
S.SID,  -- Id de la sesion
S.SERIAL#, 
OSUSER, --Usuario del SO
LOGON_TIME, --Hora de Login de esta sesión
STATUS, --INACTIVE o ACTIVE
MACHINE, --La maquina en la que se abre la sesión
PROGRAM --Programa usado, SQLTools.exe, TOAD.exe
FROM
SYS.V_$SESSION S, SYS.V_$SQLAREA A WHERE A.HASH_VALUE=S.SQL_HASH_VALUE
ORDER BY LOGON_TIME DESC;

-- Vista que muestra las conexiones actuales a Oracle:

select osuser, username, machine, program 
from v$session 
order by osuser

-- Vista que muestra el número de conexiones actuales a Oracle agrupado por aplicación que realiza la conexión

select program Aplicacion, count(program) Numero_Sesiones
from v$session
group by program 
order by Numero_Sesiones desc

-- Vista que muestra los usuarios de Oracle conectados y el número de sesiones por usuario

select username Usuario_Oracle, count(username) Numero_Sesiones
from v$session
group by username
order by Numero_Sesiones desc