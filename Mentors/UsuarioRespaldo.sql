-- Se crea un usuario con permiso de SYSDAB y SYSOPER

CREATE USER BKUSERBD PROFILE DEFAULT IDENTIFIED BY sysadmin01 DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP ACCOUNT UNLOCK;
GRANT SYSDBA TO BKUSERBD WITH ADMIN OPTION;
GRANT SYSOPER TO BKUSERBD WITH ADMIN OPTION;
GRANT CONNECT TO BKUSERBD;
ALTER USER BKUSERBD PROFILE MGMT_ADMIN_USER_PROFILE;