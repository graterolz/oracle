-- Para comprobar si hay algún job programado en la base de datos podemos hacer la siguiente consulta con el usuario sys:
select * from dba_jobs;

-- Para consultar todos los jobs:
select * from all_scheduler_jobs;

-- Consultar log de ejecución de jobs:
select * from all_scheduler_job_log order by log_date desc;

-- Consultar los jobs que están en ejecución:
select * from all_scheduler_running_jobs;

-- Detener un job:
exec dbms_scheduler.stop_job('USER.JOB');

-- Se puede forzar la parada de un job ejecutando la siguiente query como usuario system:
exec dbms_scheduler.stop_job('USER.JOB', true);

-- Deshabilitar un Job:
exec dbms_scheduler.disable('USER.JOB');

-- Se puede forzar la deshabilitación de un job ejecutando la siguiente query como system:
exec dbms_scheduler.disable('USER.JOB', true);

-- Habilitar un Job:
exec dbms_scheduler.enable('USER.JOB');

-- Arrancar un Job:
exec dbms_scheduler.run_job('USER.JOB');

--
--
--

-- Para detener el JOB del cierre se debe iniciar con el usuario de OPENCARD

- Identificar el job a detener
SELECT * FROM DBA_JOBS;
	
- Se pone en broken el JOB 
EXEC DBMS_JOB.BROKEN(num_job,TRUE);

- Se valida de nuevo el Job  
SELECT JOB, BROKEN FROM DBA_JOBS;
SELECT * FROM DBA_JOBS_RUNNING;

- Se consulta el Serial# del Job
SELECT SID, SERIAL# FROM V$SESSION WHERE SID=SID_JOB;

- Se procede a matar el Job. 
ALTER SYSTEM KILL SESSION 'SID,SERIAL#' IMMEDIATE;

- Se aplica un commit
COMMIT;
 
- Se valida y se confirma el Job
SELECT * FROM DBA_JOBS_RUNNING;
 
- Se remueve el Job y se aplica un commit
EXEC DBMS_JOB.REMOVE(32380);
COMMIT;

- Se valida si fue removido el job
SELECT * FROM DBA_JOBS;