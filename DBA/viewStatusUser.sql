SELECT
	username,
	account_status, 
	created,
	lock_date, 
	expiry_date
FROM dba_users 
WHERE username = 'OPENCARD'
ORDER BY 1;