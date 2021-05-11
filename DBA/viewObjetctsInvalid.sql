SELECT
	owner,
	object_type,
	COUNT(*)
FROM dba_objects 
WHERE status ='INVALID' 
AND owner = 'OPENCARD' 
GROUP BY owner, object_type;