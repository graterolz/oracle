--MEMORIA SHARE_POOL LIBRE Y USADA
SELECT name,to_number(value) bytes 
  FROM v$parameter
 WHERE name ='shared_pool_size'
UNION ALL
SELECT name,bytes 
  FROM v$sgastat
 WHERE pool = 'shared pool'
   AND name = 'free memory';