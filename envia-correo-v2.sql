DECLARE
	v_From VARCHAR2(80) := 'administracionBD@demo.com';
	v_Recipient VARCHAR2(80) := 'ejgraterol@demo.com';
	v_Subject VARCHAR2(80) := 'test subject';
	v_Mail_Host VARCHAR2(30) := '10.0.8.240';
	v_Mail_Conn utl_smtp.Connection;
	crlf VARCHAR2(2) := chr(13)||chr(10);
BEGIN
	v_Mail_Conn := utl_smtp.Open_Connection(v_Mail_Host, 25);
	utl_smtp.Helo(v_Mail_Conn, v_Mail_Host);
	utl_smtp.Mail(v_Mail_Conn, v_From);
	utl_smtp.Rcpt(v_Mail_Conn, v_Recipient);
	utl_smtp.Data(v_Mail_Conn,
		'Date: ' || to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') || crlf ||
		'From: ' || v_From || crlf ||
		'Subject: ' || v_Subject || crlf ||
		'To: ' || v_Recipient || crlf ||
		'MIME-Version: 1.0'|| crlf ||	-- Use MIME mail standard
		'Content-Type: multipart/mixed;'|| crlf ||
		' boundary="-----SECBOUND"'|| crlf ||
		crlf ||
		'-------SECBOUND'|| crlf ||
		'Content-Type: text/plain;'|| crlf ||
		'Content-Transfer_Encoding: 7bit'|| crlf ||
		crlf ||
		'some message text'|| crlf ||	-- Message body
		'more message text'|| crlf ||
		crlf ||
		'-------SECBOUND'|| crlf ||
		'Content-Type: text/plain;'|| crlf ||
		' name="excel.csv"'|| crlf ||
		'Content-Transfer_Encoding: 8bit'|| crlf ||
		'Content-Disposition: attachment;'|| crlf ||
		' filename="excel.csv"'|| crlf ||
		crlf ||
		'CSV;file;attachement'|| crlf ||	-- Content of attachment
		crlf ||
		'-------SECBOUND--'	-- End MIME mail
	);
	utl_smtp.Quit(v_mail_conn);
EXCEPTION
	WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error then
		raise_application_error(-20000, 'Unable to send mail', TRUE);
END;