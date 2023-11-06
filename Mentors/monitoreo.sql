-- Monitoreo de Procesos

alter session set nls_date_format='dd-mon-rrrr hh24:mi:ss';
col process_error format a10


select LOGICAL_OBJECT, status
	,group_code
	,sequence
	,START_DATE_TIME
	,FINIHS_DATE_TIME
	,(FINIHS_DATE_TIME-START_DATE_TIME)*1440 minutos
	,(FINIHS_DATE_TIME-START_DATE_TIME)*24 horas
	,PROCESS_DATE
	,STATUS
	,PROCESS_ERROR
from opencard.OP_PROCESS_SCHEDULE
where
--logical_object like 'BD_KM_GENARCH_AMEX%'
next_execution_date > '28--2015'
--and
--( group_code =300
--and group_code > 190 
-- )
and 
group_code > 280
--and sequence in (2,3,4,5)
--where GROUP_CODE = 290
--and sequence not in  (5,7,14)
--and (  FINIHS_DATE_TIME is null or FINIHS_DATE_TIME < START_DATE_TIME)
order by 4,START_DATE_TIME, group_code, sequence, process_date;