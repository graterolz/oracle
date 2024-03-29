DROP TABLE MIGRA.TERCERO_ROL_MIG_PRUEBA CASCADE CONSTRAINTS;
--
CREATE TABLE MIGRA.TERCERO_ROL_MIG_PRUEBA (
	TIPOID	VARCHAR2 (1 BYTE),
	NUMID	NUMBER (14),
	DVID	VARCHAR2 (1 BYTE),
	TIPOTER	VARCHAR2 (2 BYTE),
	STSROL	VARCHAR2 (3 BYTE),
	FECSTS	DATE
);
--
CREATE UNIQUE INDEX MIGRA.PK_TERCERO_ROL ON MIGRA.TERCERO_ROL_MIG_PRUEBA (
	TIPOID, NUMID, DVID, TIPOTER
);
--
ALTER TABLE MIGRA.TERCERO_ROL_MIG_PRUEBA ADD (
	CONSTRAINT PK_TERCERO_ROL
	PRIMARY KEY
	(TIPOID, NUMID, DVID, TIPOTER)
	USING INDEX MIGRA.PK_TERCERO_ROL
);
--
DROP TABLE MIGRA.CLIENTE_MIG_PRUEBA CASCADE CONSTRAINTS;
CREATE TABLE MIGRA.CLIENTE_MIG_PRUEBA (
    TIPOID              VARCHAR2 (1 BYTE) NOT NULL,
    NUMID               NUMBER (14) NOT NULL,
    DVID                VARCHAR2 (1 BYTE) NOT NULL,
    CODCLI              VARCHAR2 (14 BYTE) NOT NULL,
    CLASECLI            VARCHAR2 (3 BYTE),
    TIPOCLI             VARCHAR2 (1 BYTE),
    SEXO                VARCHAR2 (1 BYTE),
    FECNAC              DATE,
    EDOCIVIL            VARCHAR2 (1 BYTE),
    CODACT              VARCHAR2 (4 BYTE),
    CODFUERZA           VARCHAR2 (3 BYTE),
    CODGRADO            VARCHAR2 (4 BYTE),
    FECVINC             DATE NOT NULL,
    FECLISTANEGRA       DATE,
    CODLISTANEGRA       VARCHAR2 (4 BYTE),
    MTOINGANUAL         NUMBER (14, 2),
    FECINGANUAL         DATE,
    NUMCTAAUXI          VARCHAR2 (14 BYTE),
    TIPOCONYUGE         VARCHAR2 (1 BYTE),
    NUMIDCONYUGE        NUMBER (14),
    NOMCONYUGE          VARCHAR2 (30 BYTE),
    APECONYUGE          VARCHAR2 (30 BYTE),
    INDCONTRAGARANTE    VARCHAR2 (1 BYTE),
    CODINGANUAL         VARCHAR2 (4 BYTE),
    NUMEXP              VARCHAR2 (6 BYTE),
    INDMIGRA            VARCHAR2 (1 BYTE) DEFAULT 'N'
);
--
CREATE INDEX MIGRA.IDX$$_0A4F0001 ON MIGRA.CLIENTE_MIG_PRUEBA (NUMID, TIPOID, DVID);
CREATE UNIQUE INDEX MIGRA.PK_CLIENTE_MIG_PRUEBA ON MIGRA.CLIENTE_MIG_PRUEBA (CODCLI);
--
ALTER TABLE MIGRA.CLIENTE_MIG_PRUEBA ADD (
    CONSTRAINT CK_CLIENTE_MIG_01
    CHECK (
        SEXO IN ('F','M','N')
    ),
    CONSTRAINT PK_CLIENTE_MIG
    PRIMARY KEY (CODCLI)
    USING INDEX MIGRA.PK_CLIENTE_MIG
);
--
ALTER TABLE MIGRA.CLIENTE_MIG_PRUEBA ADD (
    CONSTRAINT FK_CLIENTE_MIG__TERCERO
    FOREIGN KEY (TIPOID, NUMID, DVID)
    REFERENCES MIGRA.TERCERO_MIG (TIPOID,NUMID,DVID)
);
--
DROP TABLE MIGRA.TERCERO_MIG_PRUEBA CASCADE CONSTRAINTS;
CREATE TABLE MIGRA.TERCERO_MIG_PRUEBA (
	TIPOID			VARCHAR2 (1 BYTE) NOT NULL,
	NUMID			NUMBER (14) NOT NULL,
	DVID			VARCHAR2 (1 BYTE) NOT NULL,
	NOMTER			VARCHAR2 (60 BYTE) NOT NULL,
	APETER			VARCHAR2 (50 BYTE),
	CODPAIS			VARCHAR2 (3 BYTE) NOT NULL,
	CODESTADO 		VARCHAR2 (3 BYTE) NOT NULL,
	CODCIUDAD 		VARCHAR2 (3 BYTE) NOT NULL,
	CODMUNICIPIO	VARCHAR2 (3 BYTE) NOT NULL,
	DIREC			VARCHAR2 (250 BYTE) NOT NULL,
	TELEF1 			VARCHAR2 (12 BYTE),
	TELEF2			VARCHAR2 (12 BYTE),
	TELEF3			VARCHAR2 (12 BYTE),
	FAX				VARCHAR2 (12 BYTE),
	TELEX			VARCHAR2 (12 BYTE),
	ZIP				VARCHAR2 (12 BYTE),
	INDNACIONAL		VARCHAR2 (1 BYTE) NOT NULL,
	STSTER			VARCHAR2 (3 BYTE) NOT NULL,
	FECSTS			DATE NOT NULL,
	NUMCTAAUXI		VARCHAR2 (14 BYTE),
	EMAIL			VARCHAR2 (100 BYTE),
	TIPOTER			VARCHAR2 (2 BYTE),
	RIF				VARCHAR2 (20 BYTE),
	NIT 			VARCHAR2 (20 BYTE),
	CODPARROQUIA	VARCHAR2 (3 BYTE),
	CODSECTOR		VARCHAR2 (3 BYTE),
	WEBSITE 		VARCHAR2 (100 BYTE),
	RAZONSOCIAL		VARCHAR2 (110 BYTE),
	INDMIGRA		VARCHAR2 (1 BYTE) DEFAULT 'N',
	MIGRA 			VARCHAR2 (1 BYTE)
);
--
CREATE INDEX MIGRA.ID_TERCERO_01 ON MIGRA.TERCERO_MIG_PRUEBA (APETER, NOMTER);
CREATE INDEX MIGRA.ID_TERCERO_010 ON MIGRA.TERCERO_MIG_PRUEBA (MIGRA);
CREATE INDEX MIGRA.ID_TERCERO_02 ON MIGRA.TERCERO_MIG_PRUEBA (NOMTER, APETER);
CREATE INDEX MIGRA.ID_TERCERO_03 ON MIGRA.TERCERO_MIG_PRUEBA (NUMID);
CREATE INDEX MIGRA.IDX01_TERCERO ON MIGRA.TERCERO_MIG_PRUEBA (NUMID, DVID);
CREATE INDEX MIGRA.IDX03_TERCERO ON MIGRA.TERCERO_MIG_PRUEBA (NUMID, TIPOID);
CREATE INDEX MIGRA.I_TERCERO_MIG_PRUEBA ON MIGRA.TERCERO_MIG_PRUEBA (NOMTER);
CREATE UNIQUE INDEX MIGRA.PK_TERCERO ON MIGRA.TERCERO_MIG_PRUEBA (TIPOID, NUMID, DVID);
--
ALTER TABLE MIGRA.TERCERO_MIG_PRUEBA ADD (
	CONSTRAINT PK_TERCERO
	PRIMARY KEY
	(TIPOID, NUMID, DVID)
	USING INDEX MIGRA.PK_TERCERO
);