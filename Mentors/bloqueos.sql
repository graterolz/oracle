-- Lista de Bloqueos
SELECT /*+ FULL(s) PARALLEL(l, 5) */
       decode(L.TYPE,'TM','TABLE','TX','Record(s)') TYPE_LOCK,
       decode(L.REQUEST,0,'NO','YES') WAIT,
       S.OSUSER OSUSER_LOCKER,
       S.PROCESS PROCESS_LOCKER,
       S.USERNAME DBUSER_LOCKER,
       S.SID SID,
       s.SERIAL# SERIAL,
       O.OBJECT_NAME OBJECT_NAME,
       O.OBJECT_TYPE OBJECT_TYPE,
       concat(' ',s.PROGRAM) PROGRAM,
       O.OWNER OWNER
FROM v$lock l,dba_objects o,v$session s
WHERE l.ID1 = o.OBJECT_ID
AND s.SID =l.SID
AND l.TYPE in ('TM','TX');

-- Consulta de Usuario que realiza un bloqueo.
select oracle_username || ' (' || s.osuser || ')' username,
       s.sid || ',' || s.serial# sess_id,
       owner || '.' || object_name object,
       object_type,
       decode(l.block, 0, 'Not Blocking', 1, 'Blocking', 2, 'Global') status,
       decode(v.locked_mode, 0, 'None', 1,'Null',2,'Row-S (SS)',3,'Row-X (SX)',
              4,'Share',
              5,'S/Row-X (SSX)',
              6,'Exclusive',TO_CHAR(lmode)) mode_held
from v$locked_object v, dba_objects d, v$lock l, v$session s
where v.object_id = d.object_id
and v.object_id = l.id1
and v.session_id = s.sid
order by oracle_username, session_id;

-- Elimino el proceso.
ALTER SYSTEM KILL SESSION 'SID,SERIAL#';