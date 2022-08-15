CREATE OR REPLACE PROCEDURE EnviarCorreo (
	l_to IN VARCHAR2,
	l_subject IN VARCHAR2,
	body IN VARCHAR2
)
IS
	l_mailhost VARCHAR2(64):= '10.0.8.240';
	l_from VARCHAR2(64):= 'ics@bod.com.ve';
	delim VARCHAR2(1):= ';';
	pos INTEGER;
	l_to_aux varchar2(32765):= replace(l_to, ' ', '');
	l_to_list varchar2(32765);
	l_mail_conn UTL_SMTP.connection;
	msg VARCHAR(4000);
	crlf VARCHAR2( 2 ):= CHR( 13 ) || CHR( 10 );
BEGIN
	l_mail_conn:= UTL_SMTP.open_connection(l_mailhost, 25);
	UTL_SMTP.helo(l_mail_conn, l_mailhost);
	UTL_SMTP.mail(l_mail_conn, l_from);
	LOOP
		EXIT WHEN l_to_aux is NULL;
		pos:= INSTR(l_to_aux, delim);
		IF pos > 0 THEN
			UTL_SMTP.rcpt(l_mail_conn, substr(l_to_aux,1,pos-1));
			l_to_aux:= substr(l_to_aux,pos+1);
		ELSE
			UTL_SMTP.rcpt(l_mail_conn, l_to_aux);
			l_to_aux:= null;
		END IF;
	END LOOP;

	msg:= 
		'Date: ' || TO_CHAR( SYSTIMESTAMP, 'dd Mon yy hh24:mi:ss TZHTZM' ) || crlf ||
		'From: ' || l_from || ' <' || l_from || '>' || crlf ||
		'To: ' || l_to || crlf ||
		'Subject: ' || l_subject || crlf;
	msg:= msg || '' || crlf || body || crlf || TO_CHAR( SYSTIMESTAMP, 'dd Mon yy hh24:mi:ss TZHTZM' ) || crlf;
	UTL_SMTP.data(l_mail_conn, msg);
	UTL_SMTP.quit(l_mail_conn);
END;