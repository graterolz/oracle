-- Abrir el catalogo. Es necesario realizarlo cada vez que se reinicia la instancia
ALTER SYSTEM SET ENCRYPTION WALLET OPEN IDENTIFIED BY "password";

-- Cerrar el catalogo. To disable access to all encrypted columns in the database
ALTER SYSTEM SET ENCRYPTION WALLET CLOSE;