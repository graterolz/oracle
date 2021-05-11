SELECT
	s.inst_id,
	s.sid,
	s.serial#,
	p.spid,
	s.username,
	s.schemaname,
	s.program,
	s.terminal,
	s.osuser,
	s.SQL_ID
FROM gv$session s
JOIN gv$process p ON s.paddr = p.addr AND s.inst_id = p.inst_id
WHERE s.type != 'BACKGROUND'
AND s.status = 'ACTIVE';