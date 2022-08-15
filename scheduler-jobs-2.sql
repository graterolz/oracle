SELECT
	owner,
	job_name,
	job_creator,
	job_action,
	TO_CHAR(start_date,'mm/dd/yyyy'),
	repeat_interval,
	enabled,state,
	To_char(last_start_date,'mm/dd/yyyy')
FROM DBA_SCHEDULER_JOBS
WHERE job_name LIKE 'PURGA';