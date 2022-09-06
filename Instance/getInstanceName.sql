-- Instance Name
-- SID

SELECT sys_context('userenv','instance_name') FROM dual;

show parameter instance_name;