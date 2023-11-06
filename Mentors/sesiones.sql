-- Para que se ejecute como si fuera OPENCARD
alter session set current_schema=OPENCARD;

-- matar sesion
ALTER SYSTEM KILL SESSION 'sid,serial#';

-- Muestra el tiempo restante del proceso.
SELECT S.OSUSER, --Usuario de SO
    S.USERNAME, --Usuario
    A.SQL_TEXT, --Query
    SL.OPNAME, --Operación que esta realizando (Table Scan, Sort/Merge,..)
    trunc((SL.SOFAR*100)/SL.TOTALWORK,2) AS EVOL, --Evolución en %
    SL.SOFAR, --Tiempo que lleva
    SL.TOTALWORK, --Tiempo total
    To_Char(SYSDATE, 'dd/mm/yyyy HH24:MI:SS') AS T_NOW, --Ahora. Día y hora actual.
    To_Char(SYSDATE+((((1/24)/60)/60)*SL.TIME_REMAINING), 'dd/mm/yyyy HH24:MI:SS') AS T_STOP --Día y hora cuando acabará. 
FROM V$SESSION_LONGOPS SL, V$SESSION S ,V$SQLAREA A
WHERE SL.SOFAR <> SL.TOTALWORK
AND SL.SID = S.SID
AND A.HASH_VALUE=S.SQL_HASH_VALUE;

-- Visualizar la cantidad los procesos y sesiones activas
select resource_name, current_utilization, max_utilization, limit_value 
from v$resource_limit where resource_name in ('sessions', 'processes');