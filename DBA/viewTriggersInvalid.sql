SELECT * 
FROM dba_triggers
WHERE owner = 'OPENCARD'
AND status <> 'ENABLED';