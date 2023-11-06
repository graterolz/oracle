SELECT sid,
  serial#,
  opname,
  target_desc,
  percent,
  sofar,
  totalwork,
  to_char(start_time,   'hh24:mi:ss') start_time,
  to_char(efin,   'hh24:mi:ss') estimate_fin,
  case when sofar <> totalwork and last_update_time < sysdate-1/10000 then '*' else null end broken
FROM
  (SELECT sid,
     serial#,
     opname,
     target_desc,
     sofar,
     totalwork,
     to_char(CASE
             WHEN totalwork = 0 THEN 1
             ELSE sofar / totalwork
             END *100,    '990') percent,
     start_time,
     last_update_time,
     start_time +((elapsed_seconds + time_remaining) / 86400) efin
   FROM Gv$session_longops
   ORDER BY  CASE
             WHEN sofar = totalwork
                THEN 1
                ELSE 0 END,
          efin DESC)
WHERE sofar <> totalwork;