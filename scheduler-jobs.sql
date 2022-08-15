SELECT
	owner,
	job_name,
	job_creator,
	job_action,
	TO_CHAR(start_date,'mm/dd/yyyy'),
	repeat_interval,
	enabled,
	state,
	To_char(last_start_date,'mm/dd/yyyy hh:mm:ss')
FROM DBA_SCHEDULER_JOBS
WHERE JOB_NAME = 'CARGAICSMARTES'