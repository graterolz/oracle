-- Consultar los usuarios 
select * from DBA_USERS where USERNAME='name_user';

-- Desbloquear un usuario 
ALTER USER name_user ACCOUNT UNLOCK;

-- Cambiar el password de un usuario
ALTER USER name_user IDENTIFIED BY password;

-- Listar los permisos de sistema de un usuario
SELECT PRIVILEGE
FROM sys.dba_sys_privs
WHERE grantee = <theUser>
UNION
SELECT PRIVILEGE 
FROM dba_role_privs rp JOIN role_sys_privs rsp ON (rp.granted_role = rsp.role)
WHERE rp.grantee = <theUser>
ORDER BY 1;