SELECT * 
FROM dba_constraints 
WHERE owner = 'OPENCARD'
AND status <> 'ENABLED';