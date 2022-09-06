drop user osiris_con;
drop user exportador;
drop user importador;

create user osiris_con identified by "osiris_con";
create user exportador identified by "elespo98";
create user importador identified by "elimpo98";

grant dba to osiris_con;
grant dba to exportador;
grant dba to importador;