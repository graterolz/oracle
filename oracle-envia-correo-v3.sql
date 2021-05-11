DECLARE
	msg_from VARCHAR2(100) := 'administracionBD@demo.com';
	msg_to VARCHAR2(100) := 'ejgraterol@demo.com';
	msg_subject VARCHAR2(100) := 'Test..';
	msg_text varchar2(100) := 'Email message..';
	v_output1 varchar2(100) := 'This is the text of the attachment file.';
	---
	c utl_tcp.connection;
	rc integer;
	crlf VARCHAR2(2):= CHR(13)||CHR(10);
	mesg VARCHAR2(32767);
	---
	CURSOR curContabilidad
	IS
	SELECT PROCESS_DATE
		|| ';'
		|| CURRENCY
		|| ';'
		|| CARD_NUMBER
		|| ';' 
		|| ACCOUNTANT_DEFAULT_AGE
		|| ';' 
		|| ACCOUNT_CODE
		|| ';' 
		|| DEBIT_AMOUNT
		|| ';' 
		|| CREDIT_AMOUNT
		|| ';' 
		|| ORIGIN
		|| ';' 
		|| INTERNAL_TRANSACTION
		|| ';' 
		|| ACCOUNTANT_IDENTIFIER
		|| ';' 
		|| ACCOUNTANT_CONCEPT
		|| ';' 
		|| BIN
		|| ';' 
		|| CREDIT_MODALITY
		|| ';' 
		|| MERCHANT
		|| ';' Registro
	FROM OPENCARD.AC_ACCOUNTANT_BALANCE_FLOW
	WHERE Process_date BETWEEN TO_CHAR (SYSDATE-1, 'DD/MM/YY') and TO_CHAR (SYSDATE-1, 'DD/MM/YY');
	--AND ROWNUM <= 10;	
BEGIN
	c := utl_tcp.open_connection('10.0.8.240', 25); ----- OPEN SMTP PORT CONNECTION
	rc := utl_tcp.write_line(c, 'HELO 10.0.8.240'); ----- PERFORMS HANDSHAKING WITH SMTP SERVER
	dbms_output.put_line(utl_tcp.get_line(c, TRUE));
	rc := utl_tcp.write_line(c, 'EHLO 10.0.8.240'); ----- PERFORMS HANDSHAKING, INCLUDING EXTRA INFORMATION
	dbms_output.put_line(utl_tcp.get_line(c, TRUE));
	rc := utl_tcp.write_line(c, 'MAIL FROM: '||msg_from); ----- MAIL BOX SENDING THE EMAIL
	dbms_output.put_line(utl_tcp.get_line(c, TRUE));
	rc := utl_tcp.write_line(c, 'RCPT TO: '||msg_to); ----- MAIL BOX RECIEVING THE EMAIL
	dbms_output.put_line(utl_tcp.get_line(c, TRUE));
	rc := utl_tcp.write_line(c, 'DATA'); ----- EMAIL MESSAGE BODY START
	dbms_output.put_line(utl_tcp.get_line(c, TRUE));
	rc := utl_tcp.write_line(c, 'Date: '||TO_CHAR(SYSDATE, 'dd Mon yy hh24:mi:ss'));
	rc := utl_tcp.write_line(c, 'From: '||msg_from||' <'||msg_from||'>');
	rc := utl_tcp.write_line(c, 'MIME-Version: 1.0');
	rc := utl_tcp.write_line(c, 'To: '||msg_to||' <'||msg_to||'>');
	rc := utl_tcp.write_line(c, 'Subject: '||msg_subject);
	rc := utl_tcp.write_line(c, 'Content-Type: multipart/mixed;'); ----- INDICATES THAT THE BODY CONSISTS OF MORE THAN ONE PART
	rc := utl_tcp.write_line(c, ' boundary="-----SECBOUND"'); ----- SEPERATOR USED TO SEPERATE THE BODY PARTS
	rc := utl_tcp.write_line(c ); ----- DO NOT REMOVE THIS BLANK LINE - PART OF MIME STANDARD
	rc := utl_tcp.write_line(c, '-------SECBOUND');
	rc := utl_tcp.write_line(c, 'Content-Type: text/plain'); ----- 1ST BODY PART. EMAIL TEXT MESSAGE
	rc := utl_tcp.write_line(c, 'Content-Transfer-Encoding: 7bit');
	rc := utl_tcp.write_line(c );
	rc := utl_tcp.write_line(c, msg_text); ----- TEXT OF EMAIL MESSAGE
	rc := utl_tcp.write_line(c );
	rc := utl_tcp.write_line(c, '-------SECBOUND');
	rc := utl_tcp.write_line(c, 'Content-Type: text/plain;'); ----- 2ND BODY PART.
	rc := utl_tcp.write_line(c, ' name="Test.txt"');
	rc := utl_tcp.write_line(c, 'Content-Transfer_Encoding: 8bit');
	rc := utl_tcp.write_line(c, 'Content-Disposition: attachment;'); ----- INDICATES THAT THIS IS AN ATTACHMENT
	rc := utl_tcp.write_line(c, ' filename="Test.csv"'); ----- SUGGESTED FILE NAME FOR ATTACHMENT
	rc := utl_tcp.write_line(c );
	FOR I IN curContabilidad
	LOOP
		v_output1:= i.Registro;
		rc := utl_tcp.write_line(c, v_output1);
	END LOOP;
	rc := utl_tcp.write_line(c, '-------SECBOUND--');
	rc := utl_tcp.write_line(c );
	rc := utl_tcp.write_line(c, '.'); ----- EMAIL MESSAGE BODY END
	dbms_output.put_line(utl_tcp.get_line(c, TRUE));
	rc := utl_tcp.write_line(c, 'QUIT'); ----- ENDS EMAIL TRANSACTION
	dbms_output.put_line(utl_tcp.get_line(c, TRUE));
	utl_tcp.close_connection(c); ----- CLOSE SMTP PORT CONNECTION
END;