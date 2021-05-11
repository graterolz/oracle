SELECT
	owner,
	name,
	SUBSTR(owner,1,10)||'.'||SUBSTR(name,1,35) ObjectName,
	type,
	sharable_mem,
	loads,
	executions,
	locks,
	pins
FROM v$db_object_cache
WHERE type IN ('PACKAGE BODY','PACKAGE')
AND executions > 0
AND OWNER = 'OPENCARD'
ORDER BY executions DESC, loads DESC, sharable_mem DESC;