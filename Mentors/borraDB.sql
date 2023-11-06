para poder ejecutar un “drop database” debemos tener en cuenta lo siguiente:

- La base de datos debe estar cerrada y montada 
- La base de datos debe estar montada en modo ‘exclusivo’
- La base de datos debe estar montada en forma ‘restricted’

Para eso, realizamos lo siguiente:

1. Bajamos la base de datos
SQL> shutdown immediate;

2. Montamos la base en modo exclusivo y ‘restricted’
SQL> startup mount exclusive restrict;

3. Por último procedemos a eliminar la base
SQL> drop database;