CREATE OR REPLACE PACKAGE DEVCASLO.PR_BANSEG
IS
	PROCEDURE CREAR_TERCERO;
	PROCEDURE CREAR_CLIENTE;
	PROCEDURE CREAR_DIRECCION_COBRO_CLIENTE;
	PROCEDURE CREAR_POLIZA(NCODPROV NUMBER,CARCHIVO VARCHAR2);
	PROCEDURE ANULAR_POLIZA(NCODPROV NUMBER,CARCHIVO VARCHAR2);
	PROCEDURE COBRAR_DEVOLUCION_POLIZA(NCODPROV NUMBER,CARCHIVO VARCHAR2);
	PROCEDURE CIERRE_CAJA(CCODCIA VARCHAR2,CCODOFICIERRE VARCHAR2,DFECULTCIERRE DATE);
	--
	PROCEDURE GRABA_ERRORES(
		CTABLA VARCHAR2,
		CCOD_ERROR VARCHAR2,
		CMENSAJE_SQL VARCHAR2,
		NPROCESO VARCHAR2,
		CREFERENCIA VARCHAR2,
		DFECHAPROCESO DATE,
		CCODPROD VARCHAR2,
		CCOPROVEEDOR NUMBER,
		CARCHIVO VARCHAR2
	);
	--
	FUNCTION BUSCAR_OFICINA(CCODOFI_S VARCHAR2) RETURN VARCHAR2;
	--
	PROCEDURE PULL_PUSH_FILE(
		CCODIGO VARCHAR2,
		CDIRECARC VARCHAR2,
		CCAMPOS VARCHAR2,
		CDATOS VARCHAR2
	);
	FUNCTION IMPORTAR(
		ccodigo VARCHAR2,
		cdirecarc VARCHAR2,
		ccampos VARCHAR2,
		cdatos VARCHAR2
	) RETURN BOOLEAN;
	--
	FUNCTION EXPORTAR(CCODIGO VARCHAR2) RETURN BOOLEAN;
	PROCEDURE MODIFICAR_DATA(NCODPROV NUMBER,CARCHIVO VARCHAR2);
	PROCEDURE CREAR_BENEFI(NCODPROV NUMBER,CARCHIVO VARCHAR2)
	PROCEDURE CREAR_DP_INCE(NCODPROV NUMBER,CARCHIVO VARCHAR2);
	PROCEDURE CREAR_DP_ROBO(NCODPROV NUMBER,CARCHIVO VARCHAR2);
	PROCEDURE CREAR_DP_TERRE(NCODPROV NUMBER,CARCHIVO VARCHAR2);
	PROCEDURE BORRAR_EGRESO(NNUMRELEGRE NUMBER);
	PROCEDURE BORRAR_OBLIGACION(NNUMOBLIG NUMBER);
	PROCEDURE CREAR_TERCERO_BEN;
	PROCEDURE ABRIR_CIERRE_CAJA(CCODCIA VARCHAR2,CCODOFICIERRE VARCHAR2,DFECULTCIERRE DATE);
	FUNCTION VALIDA_FECHA(IN_DATE VARCHAR2) RETURN VARCHAR2;
	PROCEDURE RECHAZO_TXT(
		CCODPROV IN VARCHAR2,
		CCODPROC IN VARCHAR2,
		CARCHIVO IN VARCHAR2,
		STR_REG IN VARCHAR2,
		LONG_REG IN NUMBER,
		MSG_ERR IN VARCHAR2,
		NUM_REG IN NUMBER,
		POS_REG IN NUMBER,
		NOM_CAMPO IN VARCHAR2
	);
	FUNCTION SRT_FMT_MSG(
		STR_REG IN VARCHAR2,
		LONG_REG IN NUMBER,
		MSG_ERR IN VARCHAR2,
		NUM_REG IN NUMBER,
		POS_REG IN NUMBER,
		NOM_CAMPO IN VARCHAR2
	) RETURN VARCHAR2;
	--
	FUNCTION FIND_POSICION(
		CCODIGO IN VARCHAR2,
		CNOMTABELA IN VARCHAR2,
		CCAMPO IN VARCHAR2
	) RETURN NUMBER;
	--
	PROCEDURE READ_FILE_IN(FILE_NAME VARCHAR2);
	PROCEDURE READ_FILE_OUT(FILE_NAME VARCHAR2);
	PROCEDURE UPDATE_RECORD(SENTENCIA_SQL IN VARCHAR2);
	PROCEDURE LOAD_FILE(DFEC_PROCESO VARCHAR2);
	PROCEDURE ENVIAR_CORREO(NCODPROV NUMBER);
	PROCEDURE DIR_UNIX_IN;PROCEDURE DIR_UNIX_OUT;
END;
--
CREATE OR REPLACE PACKAGE BODY DEVCASLO.PR_BANSEG
AS
	PROCEDURE CREAR_TERCERO 
	IS
		nexiste 		VARCHAR2(1);
		ctabla 			VARCHAR2(100) := NULL;
		ccoderror 		VARCHAR2(20) := NULL;
		cmensaje_sql 	VARCHAR2(4000) := NULL;
		creferencia 	VARCHAR2(100) := NULL;
		cdummy 			VARCHAR2(2);
		cindtipopro 	VARCHAR2(100);
		dfechaproceso 	DATE;
		exec_coase 		EXCEPTION;
		exec_error 		EXCEPTION;
		cdirec 			banca_seguro.direc%TYPE;
		--
		CURSOR ter
		IS
		SELECT
			tipoid,numid,apeter,nomter,codprod,fecemi,direc,codpais,codestado,codciudad,codmunicipio,
			codparroquia,codsector,codtelofi,telofi,codtelhab,telhab,codtelfax,telfax,codtelcel,telcel,
			tipzona,desczona,tipvia,descvia,tiphab,deschab,nrotorre,piso,nroapto,codproveedor,archivo
		FROM banca_seguro
		WHERE NVL(indicador,'N') = 'N';
	BEGIN
		FOR b IN ter
		LOOP
			BEGIN
				SELECT 1 INTO nexiste
				FROM tercero
				WHERE tipoid = b.tipoid
				AND numid = b.numid
				AND dvid = 0;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				nexiste := 0;
			WHEN TOO_MANY_ROWS THEN
				nexiste := 1;
			END;
			--
			IF nexiste = 0 THEN
				IF b.direc IS NULL THEN
					cdirec := 'S/Informacion';
				ELSE
					cdirec := b.direc;
				END IF;
				--
				BEGIN
					INSERT INTO tercero(tipoid,numid,dvid,apeter,nomter,indnacional,fecsts,direc,codpais,codestado,codciudad,codmunicipio,telef1,telef2,telef3,fax,telex,zip,stster,codparroquia,codsector,codtelofi,telofi,codtelhab,telhab,codtelfax,telfax,codtelcel,telcel,tipzona,desczona,tipvia,descvia,tiphab,deschab,nrotorre,piso,nroapto
					)
					VALUES(b.tipoid,b.numid,0,b.apeter,b.nomter,'N',b.fecemi,b.direc,b.codpais,b.codestado,b.codciudad,b.codmunicipio,b.codtelofi || b.telofi,b.codtelhab || b.telhab,NULL,b.codtelfax || b.telfax,NULL,NULL,'ACT',b.codparroquia,b.codsector,b.codtelofi,b.telofi,b.codtelhab,b.telhab,b.codtelfax,b.telfax,b.codtelcel,b.telcel,b.tipzona,b.desczona,b.tipvia,b.descvia,b.tiphab,b.deschab,b.nrotorre,b.piso,b.nroapto
					);
				EXCEPTION WHEN OTHERS THEN
					cmensaje_sql := SQLERRM;
					creferencia := 'La cedula/Rif' || ':' || b.tipoid || '-' || b.numid || ' ' || 'Fallo en el insert';
					dfechaproceso := SYSDATE;
					--
					pr_banseg.graba_errores(
						'TERCERO','CARGA-T',cmensaje_sql,'CREAR_TERCERO',creferencia,
						dfechaproceso,b.codprod,b.codproveedor,b.archivo
					);
				END;
			END IF;
		END LOOP;
	END CREAR_TERCERO;
	--
	PROCEDURE CREAR_CLIENTE
	IS
		ctipoid 		cliente.tipoid%TYPE;
		nnumid 			cliente.numid%TYPE;
		ndvid 			cliente.dvid%TYPE := 0;
		ccodcli 		cliente.codcli%TYPE;
		cclasecli		cliente.clasecli%TYPE;
		ctipocli		cliente.tipocli%TYPE;
		csexo			cliente.sexo%TYPE;
		cedocivil		cliente.edocivil%TYPE;
		ccodact			cliente.codact%TYPE;
		ccodinganual	cliente.codinganual%TYPE;
		ccodocupacion	cliente.codocupacion%TYPE;
		cnumctaauxi		cliente.numctaauxi%TYPE;
		nmtoinganual 	NUMBER(14,2) := 0.00;
		dfecnac			DATE;
		dfecvinc		DATE;
		dfechaproceso 	DATE;
		nexiste 		NUMBER(1);
		ctabla 			VARCHAR2(100) := NULL;
		ccoderror 		VARCHAR2(20) := NULL;
		cmensaje_sql 	VARCHAR2(4000) := NULL;
		creferencia 	VARCHAR2(100) := NULL;
		cdummy			VARCHAR2(2);
		cindtipopro		VARCHAR2(100);
		exec_error		EXCEPTION;
		exec_coase		EXCEPTION;
		--
		CURSOR cli
		IS
		SELECT
			tipoid,numid,clasecli,sexo,fecnac,edocivil,codact,fecvinc,
			codinganual,codocupacion,codprod,codproveedor,archivo
		FROM banca_seguro
		WHERE NVL(indicador,'N') = 'N';
	BEGIN
		FOR a IN cli
		LOOP
			ctipoid := a.tipoid;
			nnumid := a.numid;
			ndvid := 0;
			cclasecli := '001';
			ctipocli := 'P';
			csexo := a.sexo;
			dfecnac := a.fecnac;
			cedocivil := a.edocivil;
			ccodact := a.codact;
			nmtoinganual := NULL;
			ccodinganual := a.codinganual;
			ccodocupacion := a.codocupacion;
			dfecvinc := a.fecvinc;
			--
			BEGIN
				IF ctipoid = 'M' THEN
					ccodcli := '2' || LPAD(RTRIM(LTRIM(TO_CHAR(nnumid || ndvid),' '),' '),13,'0');
				ELSIF ctipoid = 'J' THEN
					ccodcli := '3' || LPAD(RTRIM(LTRIM(TO_CHAR(nnumid),' '),' '),13,'0');
				ELSIF ctipoid = 'E' THEN
					ccodcli := '4' || LPAD(RTRIM(LTRIM(TO_CHAR(nnumid || ndvid),' '),' '),13,'0');
				ELSIF ctipoid = 'V' THEN
					ccodcli := LPAD(RTRIM(LTRIM(TO_CHAR(nnumid),' '),' '),14,'0');
				END IF;
			END;
			--
			cnumctaauxi := ccodcli;
			--
			BEGIN
				BEGIN
					SELECT 1 INTO nexiste
					FROM cliente
					WHERE tipoid = ctipoid
					AND numid = nnumid
					AND dvid = ndvid
					AND codcli = ccodcli;
				EXCEPTION WHEN NO_DATA_FOUND THEN
					nexiste := 0;
				WHEN TOO_MANY_ROWS THEN
					nexiste := 1;
				END;
				--
				IF nexiste = 0 THEN
					BEGIN
						INSERT INTO cliente(
							tipoid,numid,dvid,codcli,clasecli,tipocli,sexo,fecnac,edocivil,
							codact,fecvinc,mtoinganual,codinganual,codocupacion,numctaauxi
						)
						VALUES(
							ctipoid,nnumid,ndvid,ccodcli,cclasecli,ctipocli,csexo,dfecnac,cedocivil,
							ccodact,dfecvinc,nmtoinganual,ccodinganual,ccodocupacion,cnumctaauxi
						);
					EXCEPTION WHEN OTHERS THEN
						RAISE_APPLICATION_ERROR(-20100,'Error al Insertar Cliente:'||SqlErrm);
						cmensaje_sql := SQLERRM;
						creferencia := 'El cliente con el codigo:'|| ccodcli|| 'y la cedula/rif:'|| ctipoid|| '-'|| nnumid|| ' '|| 'Fallo en el insert';
						dfechaproceso := SYSDATE;
						pr_banseg.graba_errores(
							'CLIENTE','CARGA-C',cmensaje_sql,'CREAR_CLIENTE',creferencia,
							dfechaproceso,a.codprod,a.codproveedor,a.archivo
						);
					END;
					--
				END IF;
			END;
		END LOOP;
	END CREAR_CLIENTE;
	--
	PROCEDURE CREAR_DIRECCION_COBRO_CLIENTE
	IS
		ctipoid 		cliente.tipoid%TYPE;
		nnumid 			cliente.numid%TYPE;
		ndvid 			cliente.dvid%TYPE := 0;
		ccodcli 		cliente.codcli%TYPE;
		cclasecli 		cliente.clasecli%TYPE;
		ctipocli 		cliente.tipocli%TYPE;
		csexo 			cliente.sexo%TYPE;
		cedocivil 		cliente.edocivil%TYPE;
		ccodact 		cliente.codact%TYPE;
		ccodinganual 	cliente.codinganual%TYPE;
		ccodocupacion 	cliente.codocupacion%TYPE;
		cnumctaauxi 	cliente.numctaauxi%TYPE;
		dfecnac			DATE;
		dfecvinc		DATE;
		dfechaproceso 	DATE;
		nmtoinganual	NUMBER(14,2) := 0.00;
		nexiste 		NUMBER(1);
		nexiste_cobro 	NUMBER(1);
		ctabla 			VARCHAR2(100) := NULL;
		ccoderror 		VARCHAR2(20) := NULL;
		cmensaje_sql 	VARCHAR2(4000) := NULL;
		creferencia 	VARCHAR2(100) := NULL;
		cdummy 			VARCHAR2(2);
		cindtipopro 	VARCHAR2(100);
		exec_error 		EXCEPTION;
		exec_coase		EXCEPTION;
		--
		CURSOR cli
		IS
		SELECT
			tipoid,numid,clasecli,sexo,fecnac,edocivil,codact,fecvinc,
			codinganual,codocupacion,codprod,codproveedor,archivo
		FROM banca_seguro
		WHERE NVL(indicador,'N') = 'N';
	BEGIN
		FOR a IN cli
		LOOP
			ctipoid := a.tipoid;
			nnumid := a.numid;
			ndvid := 0;
			cclasecli := '001';
			ctipocli := 'P';
			csexo := a.sexo;
			dfecnac := a.fecnac;
			cedocivil := a.edocivil;
			ccodact := a.codact;
			nmtoinganual := NULL;
			ccodinganual := a.codinganual;
			ccodocupacion := a.codocupacion;
			dfecvinc := a.fecvinc;
			--
			BEGIN
				BEGIN
					SELECT 1,codcli INTO nexiste,ccodcli
					FROM cliente
					WHERE tipoid = ctipoid
					AND numid = nnumid
					AND dvid = ndvid;
				EXCEPTION WHEN NO_DATA_FOUND THEN
					nexiste := 0;
				WHEN TOO_MANY_ROWS THEN
					nexiste := 1;
				END;
				--
				IF nexiste = 1 THEN
					BEGIN
						SELECT 1 INTO nexiste_cobro
						FROM direc_cobrocliente
						WHERE codcli = ccodcli;
					EXCEPTION WHEN NO_DATA_FOUND THEN
						nexiste_cobro := 0;
					WHEN TOO_MANY_ROWS THEN
						nexiste_cobro := 1;
					END;
					--
					IF nexiste_cobro = 0 THEN
						BEGIN
							INSERT INTO direc_cobrocliente (
							SELECT
								codcli,zip,NULL,codpais,codestado,codciudad,codmunicipio,direc,telef1,
								telef2,telef3,fax,telex,SYSDATE,NULL,codtelofi,telofi,codtelhab,telhab,
								codtelfax,telfax,codtelcel,telcel,tipzona,desczona,tipvia,descvia,tiphab,
								deschab,nrotorre,piso,nroapto 
							FROM cliente cli,tercero ter
							WHERE codcli = ccodcli
							AND ter.tipoid = cli.tipoid
							AND ter.numid = cli.numid
							AND ter.dvid = cli.dvid
							);
						EXCEPTION WHEN OTHERS THEN
							RAISE_APPLICATION_ERROR(-20100,'Error al Insertar Direccion Cobro Cliente:'||SqlErrm);
							cmensaje_sql := SQLERRM;
							creferencia :=
								'El cliente con el codigo:'||ccodcli||'y la cedula/rif:'||
								ctipoid ||'-' ||nnumid ||' '||'Fallo en el insert';
							dfechaproceso := SYSDATE;
							pr_banseg.graba_errores(
								'DIREC_COBROCLIENTE','CARGA-C',cmensaje_sql,'CREAR_CLIENTE',creferencia,
								dfechaproceso,a.codprod,a.codproveedor,a.archivo
							);
						END;
					END IF;
				END IF;
			END;
		END LOOP;
	END CREAR_DIRECCION_COBRO_CLIENTE;
	--
	PROCEDURE crear_poliza(ncodprov NUMBER,carchivo VARCHAR2)
	IS
		ctipoid 		cliente.tipoid%TYPE;
		nnumid 		cliente.numid%TYPE;
		ndvid 			cliente.dvid%TYPE := 0;
		ccodramoplan 	ramo_plan_prod.codramoplan%TYPE;
		ccodplan 		ramo_plan_prod.codplan%TYPE;
		crevplan 		ramo_plan_prod.revplan%TYPE;
		cindben 		ramo_plan_prod.indben%TYPE;
		cindbenaseg 	ramo_plan_prod.indbenaseg%TYPE;
		nidepol_dp 		poliza.idepol%TYPE;
		ccodpol 		poliza.codpol%TYPE;
		nnumpol 		poliza.numpol%TYPE;
		nidepol 		poliza.idepol%TYPE;
		ccodprod 		poliza.codprod%TYPE;
		ccodcli 		poliza.codcli%TYPE;
		dfecinivig 		poliza.fecinivig%TYPE;
		dfecfinvig 		poliza.fecfinvig%TYPE;
		ccodofiemi 		poliza.codofiemi%TYPE;
		ccodofisusc 	poliza.codofisusc%TYPE;
		ccodmoneda 		poliza.codmoneda%TYPE;
		ccodformpago 	poliza.codformpago%TYPE;
		dfecemi			poliza.fecemi%TYPE;
		nidepol_ase 	poliza.idepol%TYPE;
		ccodcli_ase 	poliza.codcli%TYPE;
		nidepol_ben 	poliza.idepol%TYPE;
		ccodcli_ben 	poliza.codcli%TYPE;
		ccodcli_t 		poliza.codcli%TYPE;
		ccodinter 		intermediario.codinter%TYPE;
		ncodcobert 		cobert_plan_prod.codcobert%TYPE;
		cnomcontratante	contratante_adicional.nomcontratante%TYPE;
		nideaseg		asegurado.ideaseg%TYPE;
		nidebien		bien_cert.idebien%TYPE;
		dfechaproceso 	DATE;
		nexiste 		NUMBER(1);
		nnumben 		NUMBER(2);
		nmonto 			NUMBER(14,2);
		ncount 			NUMBER(5) := 0;
		ncountr 		NUMBER(5) := 0;
		activar1 		VARCHAR2(1000);
		activar2 		VARCHAR2(1000);
		ctabla 			VARCHAR2(100) := NULL;
		ccoderror 		VARCHAR2(20) := NULL;
		cmensaje_sql 	VARCHAR2(4000) := NULL;
		creferencia 	VARCHAR2(300) := NULL;
		cdummy 			VARCHAR2(2);
		cindtipopro 	VARCHAR2(100);
		ccodproc 		VARCHAR2(3);
		exec_error 		EXCEPTION;
		exec_coase		EXCEPTION;
		--
		CURSOR pol
		IS
		SELECT 
			tipoid,numid,codprod,codofiemi,numpol,fecemi,fecinivig,fecfinvig,codformpago,codmoneda,codinter,codplan,revplan,codparent,
			monto,estatura,peso,direc,codpais,codestado,codciudad,codmunicipio,codparroquia,codsector,codtelofi,telofi,codtelhab,telhab,
			codtelfax,telfax,codtelcel,telcel,tipzona,desczona,tipvia,descvia,tiphab,deschab,nrotorre,piso,nroapto,codproveedor,archivo
		FROM banca_seguro
		WHERE NVL(indicador,'N') = 'N'
		AND clasecli = 'ASE'
		AND codproveedor = NVL(ncodprov,codproveedor)
		AND archivo = NVL(carchivo,archivo);
		--
		CURSOR tom
		IS
		SELECT
			tipoid,numid,codprod,codofiemi,numpol,fecemi,fecinivig,fecfinvig,codformpago,codmoneda,codinter,codplan,revplan,codparent,
			monto,estatura,peso,direc,codpais,codestado,codciudad,codmunicipio,codparroquia,codsector,codtelofi,telofi,codtelhab,telhab,
			codtelfax,telfax,codtelcel,telcel,tipzona,desczona,tipvia,descvia,tiphab,deschab,nrotorre,piso,nroapto,codproveedor,archivo
		FROM banca_seguro
		WHERE NVL(indicador,'N') = 'N'
		AND clasecli = 'TOM'
		AND codproveedor = NVL(ncodprov,codproveedor)
		AND archivo = NVL(carchivo,archivo);
		--
		CURSOR beneficiario
		IS
		SELECT
			codprod,codofiemi,numpol,tipoid,numid,fecnac,codparent,nomter,apeter,fecing,porcpart,tipoter,codpais,codestado,codciudad,
			codmunicipio,codparroquia,codsector,direc,rif,nit,website,codtelofi,telofi,codtelhab,telhab,codtelfax,telfax,codtelcel,
			telcel,tipzona,desczona,tipvia,descvia,tiphab,deschab,nrotorre,piso,nroapto,codproveedor,archivo,numreg
		FROM banca_seguro_ben
		WHERE NVL(indicador,'N') = 'N'
		AND codproveedor = NVL(ncodprov,codproveedor)
		AND archivo = NVL(carchivo,archivo);
		AND codprod = ccodprod
		AND codofiemi = ccodofiemi
		AND numpol = nnumpol;
		--
		CURSOR ramo_plan_pro
		IS
		SELECT codramoplan,indcobert
		FROM ramo_plan_prod
		WHERE codprod = ccodprod;
		--
		CURSOR ramo_plan_pro
		IS
		SELECT DISTINCT CodRamoPlan,NomFormaDatos,ParamProgTarificador,IndCobert
		FROM RAMO_PLAN_PROD P
		WHERE P.CodProd = cCodprod
		AND P.CodPlan = cCodPlan
		AND P.RevPlan = cRevPlan
		AND P.IndRamoOblig = 'S'
		AND NOT EXISTS (
			SELECT 1 FROM CERT_RAMO C
			WHERE C.Idepol = nIdePol
			AND C.NumCert = 1
			AND C.CodPlan = P.CodPlan
			AND C.RevPlan = P.RevPlan
			AND C.CodRamoCert = P.CodRamoPlan
		);
		--
		CURSOR cobert_plan_pro
		IS
		SELECT codramoplan,codcobert,sumaasegmax,tasamax
		FROM cobert_plan_prod
		WHERE codprod = ccodprod
		AND codplan = ccodplan
		AND revplan = crevplan
		AND codramoplan = ccodramoplan;
		--
		CURSOR bienes
		IS
		SELECT DISTINCT clasebien,codbien
		FROM bien_ramo_plan_prod
		WHERE codprod = ccodprod
		AND codramoplan = ccodramoplan
		AND codplan = ccodplan
		AND revplan = crevplan;
		--
		CURSOR ince
		IS
		SELECT
			codprod,codofiemi,numpol,tiporiesgo,articulo,subnivel1,subnivel2,subnivel3,subnivel4,grupo,
			estruct,techo,pared,codclasries,norte,sur,este,oeste,monto,codproveedor,archivo
		FROM banca_seguro_dp_ince
		WHERE NVL(indicador,'N') = 'N'
		AND codproveedor = NVL(ncodprov,codproveedor)
		AND archivo = NVL(carchivo,archivo);
		--
		CURSOR terre
		IS
		SELECT
			codprod,codofiemi,numpol,tipoedif,nropisos,vistavert,cortehorz,tipofach,monto,codproveedor,archivo
		FROM banca_seguro_dp_terre
		WHERE NVL(indicador,'N') = 'N'
		AND codproveedor = NVL(ncodprov,codproveedor)
		AND archivo = NVL(carchivo,archivo);
		--
		CURSOR robo
		IS
		SELECT
			codprod,codofiemi,numpol,codindole,clase,norte,sur,este,oeste,numlocales,mercpredom,techo,
			paredext,puertext,vitrivent,porcdctovigi,porcdctoalar,monto,codproveedor,archivo
		FROM banca_seguro_dp_robo
		WHERE NVL(indicador,'N') = 'N'
		AND codproveedor = NVL(ncodprov,codproveedor)
		AND archivo = NVL(carchivo,archivo);
		--
		CURSOR cert_ramo_bs
		IS
		SELECT codramocert
		FROM cert_ramo
		WHERE idepol = nidepol
		AND numcert = 1;
		--
	BEGIN
		pr_banseg.crear_tercero;
		pr_banseg.crear_cliente;
		pr_banseg.CREAR_DIRECCION_COBRO_CLIENTE;
		--
		FOR p IN pol
		LOOP
			ctipoid := p.tipoid;
			nnumid := p.numid;
			ndvid := 0;
			ccodinter := p.codinter;
			ccodplan := p.codplan;
			crevplan := p.revplan;
			nnumpol := p.numpol;
			ccodofiemi := P.codofiemi;
			ccodprod := p.codprod;
			dfecinivig := p.fecinivig;
			dfecfinvig := p.fecfinvig;
			ccodofiemi := p.codofiemi;
			ccodmoneda := p.codmoneda;
			dfecemi := p.fecemi;
			ccodformpago := p.codformpago;
			nmonto := p.monto;
			--
			BEGIN
				SELECT codcli INTO ccodcli
				FROM cliente
				WHERE tipoid = ctipoid
				AND numid = nnumid
				AND dvid = ndvid;
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR(-20100,'Error :'||SqlErrm);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'El cliente con la cedula/rif:' || ctipoid ||
					'-' || nnumid || ' ' || 'NO posee codigo de cliente';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'CLIENTE','CARGA-P',cmensaje_sql,'CREAR_POLIZA',creferencia,
					dfechaproceso,p.codprod,p.codproveedor,p.archivo
				);
			END;
			--
			BEGIN
				SELECT sq_poldef.NEXTVAL INTO nidepol FROM DUAL;
			END;
			--
			BEGIN
				ccodofiemi := pr_banseg.buscar_oficina(p.codofiemi);
				--
				IF ccodofiemi = 'INVALI' OR ccodofiemi <> p.codofiemi THEN
					cmensaje_sql := NULL;
					creferencia := 'La Oficina no esta configurada:' || ' ' || p.codofiemi;
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'BANCA_SEGURO_OFICINA','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
						creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
					);
				END IF;
				--
				DBMS_OUTPUT.put_line('@@@ 1 --INSERTA POLIZA');
				--
				INSERT INTO poliza(
					tipocotpol,codpol,numpol,numren,idepol,indnumpol,codprod,stspol,codcli,fecren,fecinivig,
					fecfinvig,tipovig,tipopdcion,tipofact,indcoa,codformfcion,codofiemi,codofisusc,codmoneda,
					indmultiinter,indpoladhesion,indrenauto,tiposusc,codformpago,tipoanul,fecultfact,codcondcobro,
					respcob,codgrp,fecemi,indfactauto,indpoledo,indinterpub,indapsin,fecreco,indrecajus,inddevsin,inddevprima
				)
				VALUES(
					'P',ccodprod,nnumpol,0,nidepol,'N',ccodprod,'VAL',ccodcli,p.fecfinvig,p.fecinivig,p.fecfinvig,'A',
					'P','P','N','P',ccodofiemi,ccodofiemi,ccodmoneda,'N','N','S','I',ccodformpago,NULL,p.fecinivig,
					'000000','INT',NULL,dfecemi,'S','N','N','N',p.fecinivig,'N','N','S'
				);
			EXCEPTION WHEN OTHERS THEN
				DBMS_OUTPUT.put_line('@@@ 1.1 EXC --INSERTA POLIZA');
				RAISE_APPLICATION_ERROR(-20100,'Error Insert Poliza:'||SqlErrm);
				--
				cmensaje_sql := SQLERRM;
				creferencia := 
					'La Poliza con el Numero:' ||
					ccodprod || '-' || ccodofiemi ||
					'-' || nnumpol || ' ' || 'Fallo en el insert';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'POLIZA','CARGA-P',cmensaje_sql,'CREAR_POLIZA',creferencia,
					dfechaproceso,p.codprod,p.codproveedor,p.archivo
				);
			END;
			--
			BEGIN
				DBMS_OUTPUT.put_line('@@@ 2 --INSERTA PART_INTER_POL');
				--
				INSERT INTO part_inter_pol(idepol,codinter,indlider,porcpart,numoperinter,extorno)
				VALUES(nidepol,ccodinter,'S','100',NULL,NULL);
			EXCEPTION WHEN OTHERS THEN
				DBMS_OUTPUT.put_line('@@@ 2.1 --INSERTA PART_INTER_POL');
				RAISE_APPLICATION_ERROR(-20100,'Error Inser PART_INTER_POL :'||SqlErrm);
				--
				cmensaje_sql := SQLERRM;
				creferencia := 
					'La Poliza con el Numero:' || ccodprod ||
					'-' || ccodofiemi || '-' || nnumpol ||
					' '|| 'Fallo en el insert del intermediario';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'PART_INTER_POL','CARGA-P',cmensaje_sql,'CREAR_POLIZA',creferencia,
					dfechaproceso,p.codprod,p.codproveedor,p.archivo
				);
			END;
			--
			BEGIN
				DBMS_OUTPUT.put_line('@@@ 3 --DIREC_COBROPOLIZA');
				--
				INSERT INTO direc_cobropoliza (
					SELECT
						nidepol,direc,telef1,fax,telef2,telex,telef3,codpais,codestado,codciudad,codmunicipio,
						zonapostal,zonacobro,fecsts,codtelofi,telofi,codtelhab,telhab,codtelfax,telfax,codtelcel,
						telcel,tipzona,desczona,tipvia,descvia,tiphab,deschab,nrotorre,piso,nroapto
					FROM direc_cobrocliente
					WHERE codcli = ccodcli
				);
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla DIREC_COBROPOLIZA'||SQLERRM);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || ccodprod ||
					'-' || ccodofiemi || '-' || nnumpol ||
					' ' || 'Fallo en el insert';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'DIREC_COBROPOLIZA','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
					creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
				);
			END;
			--
			BEGIN
				DBMS_OUTPUT.put_line('@@@ 4 --VALIDA CLIENTE');
				--
				SELECT LTRIM(apeter) || ' ' || LTRIM(nomter) INTO cnomcontratante
				FROM tercero t,cliente c
				WHERE c.codcli = ccodcli
				AND t.tipoid = c.tipoid
				AND t.numid = c.numid
				AND t.dvid = c.dvid;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				cnomcontratante := 'INVALIDO';
			END;
			--
			BEGIN
				DBMS_OUTPUT.put_line('@@@ 5 --INSERTA CONTRATANTE ADICIONAL');
				--
				INSERT INTO contratante_adicional
				VALUES(nidepol,cnomcontratante);
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla CONTRATANTE_ADICIONAL'||SQLERRM);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || ccodprod ||
					'-' || ccodofiemi || '-' || nnumpol ||
					' ' || 'Fallo en el insert';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'CONTRATANTE_ADICIONAL','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
					creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
				);
			END;
			--
			BEGIN
				DBMS_OUTPUT.put_line('@@@ 6 --INSERTA CERTIFICADO');
				--
				INSERT INTO certificado(
					idepol,numcert,stscert,desccert,fecing,codcli,codclifact,codofisusc,codofiemi,codpais,
					codestado,codciudad,codmunicipio,direc,catasparr,catasurba,catasmanz,catasparc,catasnumr,
					catascons,zonapostal,codigo,descriesgo,observacion,claseriesgo,codexterno,fecemp,fecantcert
				)
				VALUES(
					nidepol,1,'VAL',cnomcontratante,dfecinivig,ccodcli,ccodcli,ccodofiemi,ccodofiemi,p.codpais,
					p.codestado,p.codciudad,p.codmunicipio,p.direc,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
					NULL,NULL,'01',NULL,dfecinivig,dfecinivig
				);
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla Certificado'||SQLERRM);
				--
				cmensaje_sql := SQLERRM;
				creferencia :=
				'La Poliza con el Numero:' || ccodprod ||
				'-' || ccodofiemi || '-' || nnumpol ||
				' ' || 'Fallo en el insert';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'CERTIFICADO','CARGA-P',cmensaje_sql,'CREAR_POLIZA',creferencia,
					dfechaproceso,p.codprod,p.codproveedor,p.archivo
				);
			END;
			--
			BEGIN
				DBMS_OUTPUT.put_line('@@@ 7 --INSERTA POLIZA');
				--
				INSERT INTO contratante_adicional_cert
				VALUES(nidepol,1,cnomcontratante);
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla CONTRATANTE ADICIONAL'||SQLERRM);
				--
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || ccodprod ||
					'-' || ccodofiemi || '-' || nnumpol ||
					' ' || 'Fallo en el insert';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'CONTRATANTE_ADICIONAL_CERT','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
					creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
				);
			END;
			--
			FOR cpp IN ramo_plan_pro
			LOOP
				ccodramoplan := cpp.codramoplan;
				--
				DBMS_OUTPUT.put_line('Se esta procesANDo cursor ramo_plan-prod,ramo:' || ccodramoplan);
				--
				BEGIN
					DBMS_OUTPUT.put_line('@@@ 8 --INSERTA CERT_RAMO');
					--
					INSERT INTO cert_ramo(
						stscertramo,fecinivalid,fecfinvalid,codcumulo,codplan,revplan,idepol,numcert,codramocert
					)
					VALUES('VAL',dfecinivig,dfecfinvig,'000000000000001',ccodplan,crevplan,nidepol,1,ccodramoplan);
				EXCEPTION WHEN OTHERS THEN
					DBMS_OUTPUT.put_line('@@@ 8.1 --ERROR INSERTA CERT_RAMO');
					RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla CERT_RAMO'||SQLERRM);
					--
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza con el Numero:' || ccodprod ||
						'-' || ccodofiemi || '-' || nnumpol ||
						' ' || 'Fallo en el insert,ramo:' || ccodramoplan;
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'CERT_RAMO','CARGA-P',cmensaje_sql,'CREAR_POLIZA',creferencia,
						dfechaproceso,p.codprod,p.codproveedor,p.archivo
					);
				END;
				--
				BEGIN
					DBMS_OUTPUT.put_line('@@@ 9 --GENERA REQUISITOS OBLIGATORIOS');
					--
					pr_cert_ramo.generar_requisito_oblig(
						nidepol,1,ccodramoplan,ccodprod,ccodplan,crevplan,dfecinivig,TO_DATE(dfecfinvig,'DD/MM/RRRR')
					);
					--
					UPDATE req_emi_gen
					SET stsreq = 'ENT',
						fecrecepreq = p.fecinivig
					WHERE idepol = nidepol;
				EXCEPTION WHEN OTHERS THEN
					RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla CERT_RAMO'||SQLERRM);
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza con el Numero:' || ccodprod || '-' ||
						ccodofiemi || '-' || nnumpol || ' ' ||
						'Fallo en el programa de incluir requisitos obligatorios,ramo:' || ccodramoplan;
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'REQ_EMI_GEN','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
						creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
					);
				END;
				--
				IF ccodprod = 'VMPP' THEN
					BEGIN
						DBMS_OUTPUT.put_line('@@@ 10 --PR_ASEG.INCLUIR TITULAR RAMO:' || ccodramoplan);
						pr_asegurado.incluir_titular(nidepol,1,ccodramoplan,ccodcli,ccodplan,crevplan);
					EXCEPTION WHEN OTHERS THEN
						DBMS_OUTPUT.put_line('@@@ 10.1 -- EXEC PR_ASEG.INCLUIR TITULAR RAMO:'|| ccodramoplan);
						--
						cmensaje_sql := SQLERRM;
						creferencia := 
							'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi ||
							'-' || nnumpol || ' ' || 'Fallo el proceso de Inclusion del Asegurado';
						dfechaproceso := SYSDATE;
						pr_banseg.graba_errores(
							'ASEGURADO','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
							creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
						);
					END;
					--
					BEGIN
						DBMS_OUTPUT.put_line('@@@ 11 --BUSCA ASEGURADO');
						--
						SELECT ideaseg INTO nideaseg
						FROM asegurado
						WHERE idepol = nidepol
						AND indasegtitular = 'S'
						AND codramocert = cpp.codramoplan;
					EXCEPTION WHEN NO_DATA_FOUND THEN
						DBMS_OUTPUT.put_line('@@@ 11.1 -- EXC BUSCA ASEGURADO');
						RAISE_APPLICATION_ERROR(-20100,'NO existe el Asegurado'||SQLERRM);
						--
						cmensaje_sql := SQLERRM;
						creferencia :=
							'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi ||
							'-' || nnumpol || ' ' || 'NO existe el Asegurado' ||
							'Idepol:' || nidepol || 'Ideaseg:' || nideaseg;
						dfechaproceso := SYSDATE;
						pr_banseg.graba_errores(
							'ASEGURADO','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
							creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
						);
					END;
					--
					BEGIN
						DBMS_OUTPUT.put_line( '@@@ 11.Y -- Busca Ideaseg en datos particulares: ' || nideaseg);
						--
						SELECT 1 INTO nexiste
						FROM datos_particulares_vida
						WHERE ideaseg = nideaseg;
					EXCEPTION WHEN NO_DATA_FOUND THEN
						nexiste := 0;
					WHEN OTHERS THEN
						DBMS_OUTPUT.put_line('@@@ 11.X -- error ya Existe Ideaseg en Datos_particulares_vida');
						--
						nexiste := 1;
						cmensaje_sql := SQLERRM;
						creferencia :=
							'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi ||
							'-' || nnumpol || ' ' || 'ya existen datos particulares vida' ||
							'Idepol:' || nidepol || 'Ideaseg:' || nideaseg;
						dfechaproceso := SYSDATE;
						pr_banseg.graba_errores(
							'Datos_particulares_vida','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
							creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
						);
					END;
					--
					BEGIN
						DBMS_OUTPUT.put_line('@@@ 12 --INSERTA DATOS PARTICULARES VIDA');
						--
						INSERT INTO datos_particulares_vida(
							ideaseg,idepol,numcert,codramocert,codplan,revplan,estatura,peso,cavidadtoraxicaminima,cavidadtoraxicamaxima,
							capacidadabdominal,tensionarterialminima,tensionarterialmaxima,pulso,mortalidad,valorasegurado,extraprimado,
							plazopagoprima,durapoliza,orientacion,tasainteres,observ,segsaldado,segprorrogado,fecanul,codmotvanul,stssol,
							textmotvanul,montoinversion,idesin,codcli,claseriesgo,indhabtab,indpracdep,inddepriesgoso,indfumador,duracben,
							porccrec,pagdotal,perpagpri,tipoase,edadcontra,interesdesgravamen,sumaasegant,idepolant,feciniant,fecfinant,
							indmadre,idepolmadre,frecapital,porcsaseg,porcaho,interesaho,montonomi
						)
						VALUES(
							nideaseg,nidepol,1,cpp.codramoplan,ccodplan,crevplan,p.estatura,p.peso,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'S',NULL,1,NULL,NULL,NULL,NULL
						);
					EXCEPTION WHEN OTHERS THEN
						DBMS_OUTPUT.put_line('@@@ 12.1 -- EXC INSERTA DATOS PARTICULARES VIDA');
						RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla DATOS PARTICULARES DE VIDA'||SQLERRM);
						--
						cmensaje_sql := SQLERRM;
						creferencia :=
							'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi ||
							'-' || nnumpol || ' ' || 'Fallo en el Insert' || 'Idepol:' || nidepol || 'Ideaseg:' || nideaseg;
						dfechaproceso := SYSDATE;
						pr_banseg.graba_errores(
							'DATOS_PARTICULARES_VIDA','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
							creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
						);
					END;
					--
					pr_banseg.crear_tercero_ben;
					DBMS_OUTPUT.put_line('@@@ 13 -- PROCESA CURSOR BENEFICIARIO');
					--
					FOR ben IN beneficiario
					LOOP
						nnumben := 0;
						DBMS_OUTPUT.put_line('@@@ 13.0 INSIDE CURSOR BENEFICIARIO');
						--
						BEGIN
							SELECT idepol INTO nidepol_ben
							FROM poliza
							WHERE codprod = ben.codprod
							AND codofiemi = ben.codofiemi
							AND numpol = ben.numpol
							AND idepol = nidepol;
						EXCEPTION WHEN NO_DATA_FOUND THEN
							DBMS_OUTPUT.put_line(
								'@@@ 13.1 ---Exc no existe la poliza ' || ben.codprod ||
								'-' || ben.codofiemi || '-' || ben.numpol);
							RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla Certificado'||SQLERRM);
							cmensaje_sql := SQLERRM;
							creferencia :=
								'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi || 
								'-' || nnumpol || ' ' || 'NO exisnten beneficiarios en tabla temporal';
							dfechaproceso := SYSDATE;
							pr_banseg.graba_errores(
								'BENEFICIARIO','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
								creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
							);
						END;
						--
						DBMS_OUTPUT.put_line('@@@@ compara idepol: ' || nidepol || ' con nidepol_ben' || nidepol_ben);
						--
						IF nidepol = nidepol_ben THEN
							DBMS_OUTPUT.put_line('PROCESA CURSOR CERT_RAMO_BS');
							--
							FOR cp IN cert_ramo_bs
							LOOP
								DBMS_OUTPUT.put_line( '@@@ 14 -- DENTRO LOOP CERT_RAMO_BS ' || cp.codramocert);
								--
								BEGIN
									SELECT codplan,revplan INTO ccodplan,crevplan
									FROM cert_ramo
									WHERE idepol = nidepol_ben
									AND codramocert = cp.codramocert;
								END;
								--
								BEGIN
									SELECT numben INTO nnumben
									FROM benef_cert
									WHERE idepol = nidepol_ben
									AND codramocert = cp.codramocert
									UNION
									SELECT numben FROM beneficiario
									WHERE idepol = nidepol_ben
									AND codramocert = cp.codramocert
									AND ideaseg = nideaseg;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									nnumben := 0;
								WHEN OTHERS THEN
									DBMS_OUTPUT.PUT_LINE('NUMID := '|| cp.numid);
								END;
								--
								BEGIN
									SELECT NVL(indben,'S'),NVL(indbenaseg,'S') INTO cindben,cindbenaseg
									FROM ramo_plan_prod
									WHERE codprod = ben.codprod
									AND codramoplan = cp.codramocert
									AND codplan = ccodplan
									AND revplan = crevplan;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									cindben := 'N';
									cindbenaseg := 'N';
								END;
								--
								DBMS_OUTPUT.put_line('VALORES CINDBEN-CINDBENASEG:' || cindben || '-' || cindbenaseg);
								--
								IF cindben = 'S' OR cindbenaseg = 'S' THEN
									nnumben := nnumben + 1;
									IF cindben = 'S' THEN
										BEGIN
											DBMS_OUTPUT.put_line('@@@ 15 --INSERTA BENF_CERT');
											--
											INSERT INTO benef_cert(
												idepol,numcert,codramocert,tipoid,numid,dvid,
												numben,stsben,codparent,porcpart,fecnac,fecing
											)
											VALUES(
												nidepol_ben,1,cp.codramocert,ben.tipoid,ben.numid,0,nnumben,
												'ACT',ben.codparent,ben.porcpart,ben.fecnac,ben.fecing
											);
										EXCEPTION WHEN OTHERS THEN
											RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla BENEF_CERT'||SQLERRM);
											cmensaje_sql := SQLERRM;
											creferencia :=
												'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi ||
												'-' || nnumpol || ' ' || 'Fallo en el Insert,' || 'Idepol:' ||
												nidepol || ',Ideaseg:' || nideaseg;
											dfechaproceso := SYSDATE;
											pr_banseg.graba_errores(
												'BENEF_CERT','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
												creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
											);
										END;
									ELSE
										BEGIN
											DBMS_OUTPUT.put_line('@@@ 16 --INSERTA BENEFICIARIO');
											--
											INSERT INTO beneficiario(
												idepol,numcert,codramocert,tipoid,numid,dvid,numben,
												ideaseg,tipoben,stsben,codparent,porcpart,fecnac,fecing
											)
											VALUES(
												nidepol_ben,1,cp.codramocert,ben.tipoid,ben.numid,0,nnumben,
												nideaseg,'B','ACT',ben.codparent,ben.porcpart,ben.fecnac,ben.fecing
											);
										EXCEPTION WHEN OTHERS THEN
											RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla BENEFICIARIO'||SQLERRM);
											cmensaje_sql := SQLERRM;
											creferencia := 
											'La Póliza con el Número:' || ccodprod || '-' || ccodofiemi ||
											'-' || nnumpol || ' ' || 'Fallo en el Insert,' || 'Idepol:' ||
											nidepol || ',Ideaseg:' || nideaseg;
											dfechaproceso := SYSDATE;
											pr_banseg.graba_errores(
												'BENEFICIARIO','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
												creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
											);
										END;
									END IF;
								END IF;
							END LOOP;
						END IF;
						--
						DBMS_OUTPUT.put_line('@@@ 17 --ACTUALIZA BANCA SEGURO BEN');
						--
						UPDATE banca_seguro_ben
						SET indicador = 'S',
							fecproceso = SYSDATE
						WHERE codprod = ben.codprod
						AND codofiemi = ben.codofiemi
						AND numpol = ben.numpol
						AND numreg = ben.numreg
						AND indicador = 'N';
						--
					END LOOP;
				ELSIF ccodprod = 'PRHO' THEN
					IF cpp.indcobert IN('G','B') THEN
						FOR bb IN bienes
						LOOP
							BEGIN
								SELECT sq_bien_cert.NEXTVAL INTO nidebien FROM sys.DUAL;
							END;
							--
							BEGIN
							INSERT INTO bien_cert(
								numcert,codramocert,idebien,idepol,codmoneda,clasebien,codbien,stsbien,mtovalbien,
								mtovalbienmoneda,fecinivalid,fecfinvalid,marca,modelo,serial,indmod,porcriesgo
							)
							VALUES(
								1,cpp.codramoplan,nidebien,nidepol,ccodmoneda,bb.clasebien,bb.codbien,
								'VAL',nmonto,nmonto,dfecinivig,dfecfinvig,NULL,NULL,NULL,NULL,NULL
							);
							EXCEPTION WHEN OTHERS THEN
								RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla Bien_CERT'||SQLERRM);
								--
								cmensaje_sql := SQLERRM;
								creferencia := 
									'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi ||
									'-' || nnumpol || ' ' || 'Fallo en el Insert,' || 'Idepol:' ||
									nidepol || ',IdeBien:' || nidebien || ',Ramo:' || ccodramoplan;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'BIEN_CERT','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
									creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
								);
							END;
							--
							BEGIN
								pr_bien_cert.generar_cobertura_oblig(
									nidepol,1,nidebien,cpp.codramoplan,ccodprod,ccodplan,crevplan
								);
							EXCEPTION WHEN OTHERS THEN
								RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla Bien_CERT'||SQLERRM);
								cmensaje_sql := SQLERRM;
								creferencia :=
									'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi ||
									'-' || nnumpol || ' ' || 'Fallo en el Insert,' || 'Idepol:'	 ||
									nidepol || ',IdeBien:' || nidebien || ',Ramo:' || ccodramoplan;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'COBERT_BIEN','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
									creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
								);
							END;
						END LOOP;
					ELSIF cpp.indcobert IN('C') THEN
						FOR cc IN cobert_plan_pro
						LOOP
							BEGIN
								pr_cobert_cert.generar_cobertura(nidepol,1,cpp.codramoplan,cc.codcobert);
							EXCEPTION WHEN OTHERS THEN
								RAISE_APPLICATION_ERROR(-20100,'Error:'||SqlErrm);
								cmensaje_sql := SQLERRM;
								creferencia :=
									'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi ||
									'-' || nnumpol || ' ' || 'Fallo el llamado al proceso GENERAR_COBERTURA,Idepol:' ||
									nidepol || ',Cobertura:' || cc.codcobert || ',Ramo:' || ccodramoplan;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'COBERT_CERT','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
									creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
								);
							END;
						END LOOP;
					END IF;
					--
					IF cpp.codramoplan = '0040' THEN
						FOR i IN ince
						LOOP
							BEGIN
								SELECT idepol INTO nidepol_dp
								FROM poliza
								WHERE codprod = i.codprod
								AND codofiemi = i.codofiemi
								AND numpol = i.numpol
								AND idepol = nidepol;
							EXCEPTION WHEN NO_DATA_FOUND THEN
								nidepol_dp := 0;
							END;
							--
							IF nidepol_dp <> 0 THEN
								BEGIN
									INSERT INTO datos_part_incendio(
										idepol,numcert,codplan,revplan,codramocert,tiporiesgo,articulo,subnivel1,
										subnivel2,subnivel3,subnivel4,grupo,estruct,techo,pared,desccovenin,codclasries,
										nroficio,fechoficio,codgrpusr,codusr,norte,sur,este,oeste,tipoprriesgo,tasabasica,
										indmegariesgo,mtovalbienmoneda,porcriesgo,tipo1eriesgo,porcperind,codinspec,
										tipomercancia,tasabienrefr,percaren,perindem,tasaindem,porccoaseg,utilbruta,numdias
									)
									VALUES(
										nidepol_dp,1,ccodplan,crevplan,cpp.codramoplan,i.tiporiesgo,i.articulo,
										i.subnivel1,i.subnivel2,i.subnivel3,i.subnivel4,i.grupo,i.estruct,i.techo,
										i.pared,'N',i.codclasries,NULL,NULL,NULL,NULL,i.norte,i.sur,i.este,i.oeste,
										'1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
									);
									--
									UPDATE banca_seguro_dp_ince
									SET indicador = 'S',
										fecproceso = SYSDATE
									WHERE codprod = i.codprod
									AND codofiemi = i.codofiemi
									AND numpol = i.numpol;
								EXCEPTION WHEN OTHERS THEN
									RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla DATOS PARTICULARES INCENDIO'||SQLERRM);
									cmensaje_sql := SQLERRM;
									creferencia :=
										'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi || '-' ||
										nnumpol || ' ' || 'Fallo el insert,Idepol:' || nidepol || ',Ramo:' || ccodramoplan;
									dfechaproceso := SYSDATE;
									pr_banseg.graba_errores(
										'DATOS_PART_INCENDIO','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
										creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
									);
								END;
							END IF;
						END LOOP;
					ELSIF cpp.codramoplan = '0041' THEN
						FOR t IN terre
						LOOP
							BEGIN
								SELECT idepol INTO nidepol_dp
								FROM poliza
								WHERE codprod = t.codprod
								AND codofiemi = t.codofiemi
								AND numpol = t.numpol
								AND idepol = nidepol;
							EXCEPTION WHEN NO_DATA_FOUND THEN
								nidepol_dp := 0;
							END;
							--
							IF nidepol_dp <> 0 THEN
								BEGIN
									INSERT INTO datos_part_terremoto(
										idepol,numcert,codplan,revplan,codramocert,tipoedif,nropisos,vistavert,
										cortehorz,tipofach,mtovalbienmoneda,porcriesgo,tipo1eriesgo,porcperind
									)
									VALUES(
										nidepol_dp,1,ccodplan,crevplan,cpp.codramoplan,t.tipoedif,t.nropisos,
										t.vistavert,t.cortehorz,t.tipofach,NULL,NULL,NULL,NULL
									);
									--
									UPDATE banca_seguro_dp_terre
									SET indicador = 'S',
										fecproceso = SYSDATE
									WHERE codprod = t.codprod
									AND codofiemi = t.codofiemi
									AND numpol = t.numpol;
								EXCEPTION WHEN OTHERS THEN
									RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla DATOS PARTICULARES TERREMOTO'||SQLERRM);
									cmensaje_sql := SQLERRM;
									creferencia := 'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi ||
									'-' || nnumpol || ' ' || 'Fallo el insert,Idepol:' || nidepol || ',Ramo:' || ccodramoplan;
									dfechaproceso := SYSDATE;
									pr_banseg.graba_errores(
										'DATOS_PART_TERREMOTO','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
										creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
									);
								END;
							END IF;
						END LOOP;
					ELSIF cpp.codramoplan = '0045' THEN
						FOR r IN robo
						LOOP
							BEGIN
								SELECT idepol INTO nidepol_dp
								FROM poliza
								WHERE codprod = r.codprod
								AND codofiemi = r.codofiemi
								AND numpol = r.numpol
								AND idepol = nidepol;
							EXCEPTION WHEN NO_DATA_FOUND THEN
								nidepol_dp := 0;
							END;
							--
							IF nidepol_dp <> 0 THEN
								BEGIN
									INSERT INTO datos_part_robo(
										idepol,numcert,codplan,revplan,codramocert,codindole,clase,norte,sur,este,oeste,numlocales,
										mercpredom,techo,paredext,puertext,vitrivent,indrec,indcolin,porcdctovigi,porcdctoalar
									)
									VALUES(
										nidepol_dp,1,ccodplan,crevplan,cpp.codramoplan,r.codindole,r.clase,r.norte,r.sur,r.este,r.oeste,
										r.numlocales,r.mercpredom,r.techo,r.paredext,r.puertext,r.vitrivent,'S',NULL,NULL,NULL
									);
									--
									UPDATE banca_seguro_dp_robo
									SET indicador = 'S',
										fecproceso = SYSDATE
									WHERE codprod = r.codprod
									AND codofiemi = r.codofiemi
									AND numpol = r.numpol;
								EXCEPTION WHEN OTHERS THEN
									RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla DATOS PARTICULARES ROBO'||SQLERRM);
									cmensaje_sql := SQLERRM;
									creferencia :=
										'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi || '-' ||
										nnumpol || ' ' || 'Fallo el insert,Idepol:' || nidepol || ',Ramo:' || ccodramoplan;
									dfechaproceso := SYSDATE;
									pr_banseg.graba_errores(
										'DATOS_PART_ROBO','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
										creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
									);
								END;
							END IF;
						END LOOP;
					END IF;
				END IF;
			END LOOP;
			--
			FOR tm IN tom
			LOOP
				BEGIN
					SELECT codcli INTO ccodcli_t
					FROM cliente
					WHERE tipoid = tm.tipoid
					AND numid = tm.numid
					AND dvid = 0;
				END;
				--
				UPDATE poliza
				SET codcli = ccodcli_t
				WHERE idepol = nidepol
				AND codprod = tm.codprod
				AND codofiemi = tm.codofiemi
				AND numpol = tm.numpol;
			END LOOP;
			--
			BEGIN
				SELECT codcli INTO ccodcli_t
				FROM poliza
				WHERE codprod = ccodprod
				AND codofiemi = ccodofiemi
				AND numpol = nnumpol
				AND idepol = nidepol;
			EXCEPTION WHEN OTHERS THEN
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi || '-' ||
					nnumpol || ' ' || 'Fallo Busqueda de Cliente en la Poliza,Idepol:' || nidepol;
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'POLIZA','Select-Cliente',cmensaje_sql,'CLIENTE_POLIZA',
					creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
				);
			END;
			--
			UPDATE certificado
			SET codclifact = ccodcli_t
			WHERE idepol = nidepol;
			--
			BEGIN
				DBMS_OUTPUT.put_line('@@@ 18 --PR_POLIZA INCLUIR');
				pr_poliza.incluir(nidepol);
			EXCEPTION WHEN OTHERS THEN
				DBMS_OUTPUT.put_line('@@@ 18.1 --EXC PR_POLIZA INCLUIR');
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi || '-' ||
					nnumpol || ' ' || 'Fallo el proceso de Incluir poliza,Idepol:' || nidepol;
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'POLIZA','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
					creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
				);
			END;
			--
			BEGIN
				DBMS_OUTPUT.put_line('@@@ 19 --PR_POLIZA ACTIVAR T ' || nidepol);
				activar1 := pr_poliza.activar(nidepol,'T');
			EXCEPTION WHEN OTHERS THEN
				DBMS_OUTPUT.put_line('@@@ 19.1 -- EXC PR_POLIZA ACTIVAR T');
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi || '-' ||
					nnumpol || ' ' || 'Fallo el proceso de activar1(T) poliza,Idepol:' || nidepol;
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'POLIZA','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
					creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
				);
			END;
			--
			BEGIN
				DBMS_OUTPUT.put_line('@@@ 20 --PR_POLIZA ACTIVAR D ' || nidepol);
				activar2 := pr_poliza.activar(nidepol,'D');
				ncount := ncount + 1;
				--
				DBMS_OUTPUT.put_line('@@@ 20.0 --PR_POLIZA ACTIVAR D FIN ' || nidepol);
			EXCEPTION WHEN OTHERS THEN
				DBMS_OUTPUT.put_line('@@@ 20.1 EXC --PR_POLIZA ACTIVAR D ' || nidepol);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || ccodprod || '-' || ccodofiemi || '-' ||
					nnumpol || ' ' || 'Fallo el proceso de activar2(D) poliza,Idepol:' || nidepol;
				dfechaproceso := SYSDATE;
				ncountr := ncountr + 1;
				pr_banseg.graba_errores(
					'POLIZA','CARGA-P',cmensaje_sql,'CREAR_POLIZA',
					creferencia,dfechaproceso,p.codprod,p.codproveedor,p.archivo
				);
			END;
			--
			DBMS_OUTPUT.put_line('ACTUALIZA ARCHIVO DE CONTROL Y HISTORICO');
			ccodproc := 'CAP';
			--
			UPDATE banca_seguro
			SET indicador = 'S',
				fecproceso = SYSDATE
			WHERE codprod = p.codprod
			AND codofiemi = p.codofiemi
			AND numpol = p.numpol;
			--
			UPDATE banca_seguro_hist
			SET reg_proce = ncount,
				reg_recha = ncountr
			WHERE codprov = p.codproveedor
			AND archivo = p.archivo
			AND codproc = ccodproc;
			--
		END LOOP;
	END crear_poliza;
	--
	PROCEDURE anular_poliza(ncodprov NUMBER,carchivo VARCHAR2)
	IS
		nidepol 		poliza.idepol%TYPE;
		ccodofiemi		poliza.codofiemi%TYPE;
		cstsrec			recibo.stsrec%TYPE;
		nideop 			recibo.ideop%TYPE;
		dfechaproceso 	DATE;
		activart1		VARCHAR2(1000);
		activart2		VARCHAR2(1000);
		cmensaje_sql 	VARCHAR2(4000) := NULL;
		creferencia 	VARCHAR2(100) := NULL;
		cdummy			VARCHAR2(2);
		activar1 		VARCHAR2(1000);
		activar2 		VARCHAR2(1000);
		ccodproc 		VARCHAR2(3);
		nexiste 		NUMBER(1) := 0;
		nexiste1 		NUMBER(1) := 0;
		ncount 			NUMBER(5) := 0;
		ncountr			NUMBER(5) := 0;
		exec_error 		EXCEPTION;
		--
		CURSOR anular
		IS
		SELECT
			codprod,codofiemi,numpol,fecanul,codmotvanul,codproveedor,archivo
		FROM banca_seguro_anu
		WHERE NVL(indicador,'N') = 'N'
		AND codproveedor = NVL(ncodprov,codproveedor)
		AND archivo = NVL(carchivo,archivo);
	BEGIN
		FOR a IN anular
		LOOP
			ccodofiemi := pr_banseg.buscar_oficina(a.codofiemi);
			--
			IF ccodofiemi = 'INVALI' OR ccodofiemi <> a.codofiemi THEN
				cmensaje_sql := NULL;
				creferencia := 'La Oficina no esta configurada:' || a.codofiemi;
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'BANCA_SEGURO_OFICINA','CARGA-P',cmensaje_sql,'ANULAR_POLIZA',
					creferencia,dfechaproceso,a.codprod,a.codproveedor,a.archivo
				);
			END IF;
			--
			BEGIN
				SELECT idepol INTO nidepol
				FROM poliza
				WHERE codprod = a.codprod
				AND codofiemi = ccodofiemi
				AND numpol = a.numpol;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				RAISE_APPLICATION_ERROR(-20100,'Error: Poliza NO existe'||SqlErrm);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza para Anular Numero:' || a.codprod || '-' || 
					a.codofiemi || '-' || a.numpol || ':NO existe';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'POLIZA','CARGA-A',cmensaje_sql,'ANULAR_POLIZA',
					creferencia,dfechaproceso,a.codprod,a.codproveedor,a.archivo
				);
			END;
			--
			BEGIN
				SELECT 1 INTO nexiste
				FROM recibo
				WHERE idepol = nidepol
				AND stsrec = 'ACT'
				AND a.fecanul BETWEEN fecinivig AND fecfinvig;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				nexiste := 0;
			WHEN TOO_MANY_ROWS THEN
				nexiste := 1;
			END;
			--
			BEGIN
				SELECT 1 INTO nexiste1
				FROM recibo
				WHERE idepol = nidepol
				AND stsrec = 'COB'
				AND a.fecanul BETWEEN fecinivig AND fecfinvig;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				nexiste1 := 0;
			WHEN TOO_MANY_ROWS THEN
				nexiste1 := 1;
			END;
			--
			IF nexiste1 = 1 THEN
				BEGIN
					UPDATE /*+RULE*/ poliza
					SET fecanul = a.fecanul,
						codmotvanul = a.codmotvanul,
						tipoanul = 'P'
					WHERE idepol = nidepol;
				END;
				--
				BEGIN
					pr_poliza.excluir(nidepol,a.fecanul);
				EXCEPTION WHEN OTHERS THEN
					UPDATE /*+RULE*/ poliza
					SET fecanul = NULL,
						codmotvanul = NULL,
						tipoanul = NULL
					WHERE idepol = nidepol;
					--
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza para Anular Numero:' || a.codprod || '-' || a.codofiemi ||
						'-' || a.numpol || ' ' || 'Fallo en el proceso de Anulación';
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'POLIZA','CARGA-A',cmensaje_sql,'ANULAR_POLIZA',
						creferencia,dfechaproceso,a.codprod,a.codproveedor,a.archivo
					);
				END;
				--
				BEGIN
					activar2 := pr_poliza.activar(nidepol,'D');
					ncount := ncount + 1;
				EXCEPTION WHEN OTHERS THEN
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza con el Numero:' || a.codprod || '-' || a.codofiemi || '-' ||
						a.numpol || ' ' || 'Fallo el proceso de activar2(D) poliza,Idepol:' || nidepol;
					dfechaproceso := SYSDATE;
					ncountr := ncountr + 1;
					pr_banseg.graba_errores(
						'POLIZA','CARGA-A',cmensaje_sql,'ANULAR_POLIZA',creferencia,
						dfechaproceso,a.codprod,a.codproveedor,a.archivo
					);
				END;
			END IF;
			--
			IF nexiste = 1 THEN
				BEGIN
					UPDATE /*+RULE*/ poliza
					SET fecanul = a.fecanul,
						codmotvanul = a.codmotvanul,
						tipoanul = 'P'
					WHERE idepol = nidepol;
				END;
				--
				BEGIN
					pr_poliza.anular(nidepol,a.fecanul);
					ncount := ncount + 1;
				EXCEPTION WHEN OTHERS THEN
					UPDATE /*+RULE*/ poliza
					SET fecanul = NULL,
						codmotvanul = NULL,
						tipoanul = NULL
					WHERE idepol = nidepol;
					--
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza para Anular Numero:' || a.codprod || '-' || a.codofiemi ||
						'-' || a.numpol || ' ' || 'Fallo en el proceso de Anulación';
					dfechaproceso := SYSDATE;
					ncountr := ncountr + 1;
					pr_banseg.graba_errores(
						'POLIZA','CARGA-A',cmensaje_sql,'ANULAR_POLIZA',creferencia,
						dfechaproceso,a.codprod,a.codproveedor,a.archivo
					);
				END;
			END IF;
			--
			ccodproc := 'ANP';
			--
			UPDATE banca_seguro_hist
			SET reg_proce = ncount,
				reg_recha = ncountr
			WHERE codprov = a.codproveedor
			AND archivo = a.archivo
			AND codproc = ccodproc;
			--
			UPDATE banca_seguro_anu
			SET indicador = 'S',
				fecproceso = SYSDATE
			WHERE codprod = a.codprod
			AND codofiemi = a.codofiemi
			AND numpol = a.numpol;
		END LOOP;
	END anular_poliza;
	--
	PROCEDURE cobrar_devolucion_poliza(ncodprov NUMBER,carchivo VARCHAR2)
	IS
		nidepol			poliza.idepol%TYPE;
		ccodprod 		poliza.codprod%TYPE;
		ccodformpago 	poliza.codformpago%TYPE;
		nidepolren		poliza.idepol%TYPE;
		ccodofiemi		poliza.codofiemi%TYPE;
		ctipofact		poliza.tipofact%TYPE;
		nnumrec 		recibo.numrec%TYPE;
		niderec			recibo.iderec%TYPE;
		ccodplan 		ramo_plan_prod.codplan%TYPE;
		ccodplano		ramo_plan_prod.codplan%TYPE;
		crevplan 		ramo_plan_prod.revplan%TYPE;
		crevplano		ramo_plan_prod.revplan%TYPE;
		PCODGRPUSR		USUARIO.CODGRPUSR%TYPE;
		PCODUSR 		USUARIO.CODUSR%TYPE;
		PCODSUC 		USUARIO.CODSUC%TYPE;
		PCODCIA 		USUARIO.CODCIA%TYPE;
		nnumreling 		rel_ing.numreling%TYPE;
		nidedocing		doc_ing.idedocing%TYPE;
		nidefact		factura.idefact%TYPE;
		nmtofactlocal	factura.mtofactlocal%TYPE;
		cncompr 		mov_definitivo.ncompr%TYPE;
		ndvid 			tercero.dvid%TYPE := 0;
		nnumrelegre 	rel_egre.numrelegre%TYPE;
		nnumoblig 		obligacion.numoblig%TYPE;
		ccodcajero		usuario.codusr%TYPE;
		ccodcaja		usuario.codgrpusr%TYPE;
		dfecini 		DATE;
		dfecultfact		DATE;
		dfecfinvig		DATE;
		dfecultcierre 	DATE;
		dfechaproceso 	DATE;
		chorareling		VARCHAR2(8);
		cnomterreling	VARCHAR2(120);
		cmensaje_sql 	VARCHAR2(4000) := NULL;
		creferencia 	VARCHAR2(200) := NULL;
		cdummy			VARCHAR2(2);
		ccodproc 		VARCHAR2(3);
		chorasts 		VARCHAR2(8);
		activar1		VARCHAR2(1000);
		activar2		VARCHAR2(1000);
		ccajero			VARCHAR2(8);
		wcodsuc			VARCHAR2(6);
		wcoddpto		VARCHAR2(6);
		ccodofic 		VARCHAR2(6);
		ccodofi 		VARCHAR2(6);
		nseqrelegre		NUMBER(14);
		nexiste 		NUMBER(1);
		ncount 			NUMBER(5) := 0;
		ncountr 		NUMBER(5) := 0;
		exec_error		EXCEPTION;
		--
		CURSOR cobrar
		IS
		SELECT
			tipoid,numid,codprod,codofiemi,numpol,fecvaldocing,numrefdoc,cuenta,mtodocinglocal,tipodocing,
			fecemi,fecinivig,fecfinvig,codformpago,codentfinaning,codplan,revplan,codproveedor,archivo
		FROM banca_seguro_cob_dev
		WHERE NVL(indicador,'N') = 'N'
		AND codproveedor = NVL(ncodprov,codproveedor)
		AND archivo = NVL(carchivo,archivo);
		--
		CURSOR cur_ramo
		IS
		SELECT DISTINCT codramocert
		FROM cert_ramo
		WHERE idepol = nidepol;
	BEGIN
		BEGIN
			SELECT CODGRPUSR,CODUSR,CODSUC,CODCIA INTO PCODGRPUSR,PCODUSR,PCODSUC,PCODCIA
			FROM USUARIO
			WHERE CODUSR = USER;
		END;
		--
		DBMS_OUTPUT.put_line('Se ejecuta pr_banseg.abrir_cierre_caja');
		pr_banseg.abrir_cierre_caja(PCODCIA,PCODSUC,TRUNC(SYSDATE));
		--
		FOR b IN cobrar
		LOOP
			DBMS_OUTPUT.put_line('Se Valida Oficina ');
			ccodofiemi := pr_banseg.buscar_oficina(b.codofiemi);
			--
			IF ccodofiemi = 'INVALI' OR ccodofiemi <> b.codofiemi THEN
				cmensaje_sql := NULL;
				creferencia := 'La Oficina no esta configurada:' || b.codofiemi;
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'BANCA_SEGURO_OFICINA','CARGA-P',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
					creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
				);
			END IF;
			--
			BEGIN
				DBMS_OUTPUT.put_line('Se Busca Informacion de Poliza:' || b.codprod || ccodofiemi || b.numpol);
				--
				SELECT idepol,fecultfact,tipofact
				INTO nidepol,dfecultfact,ctipofact
				FROM poliza
				WHERE codprod = b.codprod
				AND codofiemi = ccodofiemi
				AND numpol = b.numpol
				AND stspol IN('ACT','ANU');
			EXCEPTION WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.put_line('No existe la poliza buscada');
				RAISE_APPLICATION_ERROR(-20100,'Error: Poliza NO Existe'||SqlErrm);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || 
					'-' || b.numpol || ' ' || 'No existe para ser cobrada Y/O generar devolucion';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
					creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
				);
			END;
			--
			BEGIN
				DBMS_OUTPUT.put_line('Se busca el Maximo Plan y Revision en cert_ramo');
				SELECT MAX(codplan),MAX(revplan) INTO ccodplan,crevplan
				FROM cert_ramo
				WHERE idepol = nidepol;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.put_line('No Existen Plan y Revision ');
				RAISE_APPLICATION_ERROR(-20100,'Error:'||SqlErrm);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || 
					'-' || b.numpol || ' ' || 'No tiene plan configurado,Codigo del plan/rev:' || 
					ccodplan || '/' || crevplan;
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'PLAN_PROD','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
					creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
				);
			END;
			--
			BEGIN
				DBMS_OUTPUT.put_line(
					'Se Verifica que exista un recibo en la vigencia de cobro :' || b.fecinivig || '-' || b.fecfinvig
				);
				--
				SELECT 1,numrec,iderec INTO nexiste,nnumrec,niderec
				FROM recibo
				WHERE idepol = nidepol
				AND fecinivig = b.fecinivig
				AND fecfinvig = b.fecfinvig
				AND stsrec = 'ACT';
			EXCEPTION WHEN NO_DATA_FOUND THEN
				DBMS_OUTPUT.put_line('El Recibo verificado no Esta en tabla RECIBO ');
				nexiste := 0;
			WHEN TOO_MANY_ROWS THEN
				nexiste := 1;
			END;
			--
			IF b.tipodocing = 'COB' THEN
				DBMS_OUTPUT.put_line('el tipo de documento recibo es de cobro');
				--
				IF nexiste = 0 THEN
					IF b.codformpago = 'A' THEN
						DBMS_OUTPUT.put_line('Forma de Pago Anual');
						--
						IF ccodplan = b.codplan AND crevplan = b.revplan THEN
							BEGIN
								pr_poliza.renovar(nidepol,' ');
							EXCEPTION WHEN OTHERS THEN
								DBMS_OUTPUT.put_line('Error al ejecutar pr_poliza.renovar ');
								cmensaje_sql := SQLERRM;
								creferencia := 
									'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
									b.numpol || ' ' || 'Fallo el proceso de Renovacion poliza,Idepol:' || nidepol;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
							--
							BEGIN
								SELECT idepol INTO nidepolren
								FROM poliza
								WHERE codprod = b.codprod
								AND codofiemi = ccodofiemi
								AND numpol = b.numpol
								AND stspol = 'MOD'
								AND numren > 0;
							EXCEPTION WHEN NO_DATA_FOUND THEN
								DBMS_OUTPUT.put_line('No existe informacion de Poliza en status MOD');
								RAISE_APPLICATION_ERROR(-20100,'Error: Poliza no ha sido RENOVADA'||SqlErrm);
								cmensaje_sql := SQLERRM;
								creferencia := 
									'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' || 
									b.numpol || ' ' || 'no ha sido Renovada,Idepol:' || nidepolren;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
							--
							BEGIN
								DBMS_OUTPUT.put_line('Se Ejecuta pr_poliza.activar(T)');
								activar1 := pr_poliza.activar(nidepolren,'T');
							EXCEPTION WHEN OTHERS THEN
								DBMS_OUTPUT.put_line('Error al Ejecutar pr_poliza.activar(T)');
								cmensaje_sql := SQLERRM;
								creferencia := 
									'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
									b.numpol || ' ' || 'Fallo el proceso de activar1(T) poliza,Idepol:' || nidepolren;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
							--
							BEGIN
								DBMS_OUTPUT.put_line('Se Ejecuta pr_poliza.activar(D)');
								activar2 := pr_poliza.activar(nidepolren,'D');
							EXCEPTION WHEN OTHERS THEN
								DBMS_OUTPUT.put_line('Error al Ejecutar pr_poliza.activar(D)');
								cmensaje_sql := SQLERRM;
								creferencia := 
									'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
									b.numpol || ' ' || 'Fallo el proceso de activar2(D) poliza,Idepol:' || nidepolren;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
						ELSE
							BEGIN
								DBMS_OUTPUT.put_line('Se ejecuta pr_poliza.renovar');
								pr_poliza.renovar(nidepol,' ');
							EXCEPTION WHEN OTHERS THEN
								DBMS_OUTPUT.put_line('Error al ejecutar pr_poliza.renovar');
								cmensaje_sql := SQLERRM;
								creferencia := 
									'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
									b.numpol || ' ' || 'Fallo el proceso de Renovacion poliza,Idepol:' || nidepol;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
							--
							BEGIN
								DBMS_OUTPUT.put_line('Se Busca Informacion de Poliza con Status MOD')
								SELECT idepol,fecinivig INTO nidepolren,dfecini
								FROM poliza
								WHERE codprod = b.codprod
								AND codofiemi = ccodofiemi
								AND numpol = b.numpol
								AND stspol = 'MOD'
								AND numren > 0;
							EXCEPTION WHEN NO_DATA_FOUND THEN
								DBMS_OUTPUT.put_line('No Existe Informacion de poliza con status MOD');
								RAISE_APPLICATION_ERROR(-20100,'Error: Poliza NO Existe'||SqlErrm);
								cmensaje_sql := SQLERRM;
								creferencia := 
									'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' || b.numpol ||
									' ' || 'no ha sido Renovada,Idepol:' || nidepolren;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
							--
							DBMS_OUTPUT.put_line('Cursor Cur_ramo');
							--
							FOR cr IN cur_ramo
							LOOP
								DBMS_OUTPUT.put_line('Inside Cursor Cur_ramo');
								--
								BEGIN
									DBMS_OUTPUT.put_line('Se Ejecuta pr_certificado.cambio_plan');
									pr_certificado.cambio_plan(
										nidepolren,1,cr.codramocert,b.codplan,
										b.revplan,dfecini,ccodplano,crevplano
									);
								EXCEPTION WHEN OTHERS THEN
									DBMS_OUTPUT.put_line('Erro al ejecutar pr_certificado.cambio_plan ');
									cmensaje_sql := SQLERRM;
									creferencia := 
										'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
										b.numpol || ' ' || 'Fallo el proceso de cambio de plan,Idepol:' || nidepolren;
									dfechaproceso := SYSDATE;
									pr_banseg.graba_errores(
										'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
										creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
									);
								END;
							END LOOP;
							--
							BEGIN
								DBMS_OUTPUT.put_line('Se ejecuta pr_poliza.activar(T) ');
								activar1 := pr_poliza.activar(nidepolren,'T');
							EXCEPTION WHEN OTHERS THEN
								DBMS_OUTPUT.put_line('Error al Ejecutar pr_poliza.activar(T) ');
								cmensaje_sql := SQLERRM;
								creferencia :=
									'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
									b.numpol || ' ' || 'Fallo el proceso de activar1(T) poliza,Idepol:' || nidepolren;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
							--
							BEGIN
								DBMS_OUTPUT.put_line('Se ejecuta pr_poliza.activar D)');
								activar2 := pr_poliza.activar(nidepolren,'D');
							EXCEPTION WHEN OTHERS THEN
								DBMS_OUTPUT.put_line('Error al ejecutar pr_poliza.activar (D)');
								cmensaje_sql := SQLERRM;
								creferencia := 'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
								b.numpol || ' ' || 'Fallo el proceso de activar2(D) poliza,Idepol:'|| nidepolren;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
						END IF;
					ELSE
						IF dfecfinvig = dfecultfact THEN
							BEGIN
								DBMS_OUTPUT.put_line('Se ejecuta pr_poliza.renovar ');
								pr_poliza.renovar(nidepol,' ');
							EXCEPTION WHEN OTHERS THEN
								DBMS_OUTPUT.put_line('Error al ejecutar pr_poliza.renovar ');
								cmensaje_sql := SQLERRM;
								creferencia :=
									'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' || b.numpol ||
									' ' || 'Fallo el proceso de Renovacion poliza,Idepol:' || nidepol;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
							--
							BEGIN
								DBMS_OUTPUT.put_line('Busca informacion de Poliza en status MOD');
								SELECT idepol INTO nidepolren
								FROM poliza
								WHERE codprod = b.codprod
								AND codofiemi = ccodofiemi
								AND numpol = b.numpol
								AND stspol = 'MOD'
								AND numren > 0;
							EXCEPTION WHEN NO_DATA_FOUND THEN
								DBMS_OUTPUT.put_line('Error al buscar Informacion de poliza en status MOD ');
								RAISE_APPLICATION_ERROR(-20100,'Error: Poliza NO Existe'||SqlErrm);
								cmensaje_sql := SQLERRM;
								creferencia := 'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
								b.numpol || ' ' || 'No ha sido Renovada,Idepol:' || nidepolren;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
							--
							BEGIN
								DBMS_OUTPUT.put_line('Se Ejecuta pr_poliza.activar(T) ');
								activar1 := pr_poliza.activar(nidepolren,'T');
							EXCEPTION WHEN OTHERS THEN
								DBMS_OUTPUT.put_line('Error al Ejecutar Pr_poliza.activar(T)');
								cmensaje_sql := SQLERRM;
								creferencia :=
									'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' || b.numpol ||
									' ' || 'Fallo el proceso de activar1(T) poliza,Idepol:' || nidepolren;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
							--
							BEGIN
								DBMS_OUTPUT.put_line('Se Ejecuta pr_poliza.activar(D)');
								activar2 := pr_poliza.activar(nidepolren,'D');
							EXCEPTION WHEN OTHERS THEN
								DBMS_OUTPUT.put_line('Error al ejecutar pr_poliza.activar(D) ');
								cmensaje_sql := SQLERRM;
								creferencia :=
									'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' || b.numpol ||
									' ' || 'Fallo el proceso de activar2(D) poliza,Idepol:' || nidepolren;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
						ELSE
							BEGIN
								DBMS_OUTPUT.put_line('Se Ejecuta pr_mod_cobert.facturacion ');
								pr_mod_cobert.facturacion(nidepol,ctipofact,dfecultfact);
							EXCEPTION WHEN OTHERS THEN
								DBMS_OUTPUT.put_line('Error al ejecutar pr_mod_cobert.facturacion');
								cmensaje_sql := SQLERRM;
								creferencia := 
									'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' || 
									b.numpol || ' ' || 'Fallo el proceso de Facturacion,Idepol:' || nidepol;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
							--
							BEGIN
								DBMS_OUTPUT.put_line('Se ejecuta pr_poliza.activar(T) ');
								activar1 := pr_poliza.activar(nidepol,'T');
							EXCEPTION WHEN OTHERS THEN
								DBMS_OUTPUT.put_line('Error al ejecutar pr_poliza.activar(T) ');
								cmensaje_sql := SQLERRM;
								creferencia := 
									'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
									b.numpol || ' ' || 'Fallo el proceso de activar1(T) poliza,Idepol:' || nidepol;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
							--
							BEGIN
								DBMS_OUTPUT.put_line('Se ejecuta pr_poliza.activar(D)');
								activar2 := pr_poliza.activar(nidepol,'D');
							EXCEPTION WHEN OTHERS THEN
								DBMS_OUTPUT.put_line('Error al ejecutar pr_poliza.activar(D) ');
								cmensaje_sql := SQLERRM;
								creferencia := 
									'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' || b.numpol ||
									' ' || 'Fallo el proceso de activar2(D) poliza,Idepol:' || nidepol;
								dfechaproceso := SYSDATE;
								pr_banseg.graba_errores(
									'POLIZA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
									creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
								);
							END;
						END IF;
					END IF;
				END IF;
				--
				BEGIN
					DBMS_OUTPUT.put_line('Busca Informacion del Asegurado');
					--
					SELECT apeter || ' ' || nomter INTO cnomterreling
					FROM tercero
					WHERE tipoid = b.tipoid
					AND numid = b.numid
					AND dvid = ndvid;
				EXCEPTION WHEN NO_DATA_FOUND THEN
					DBMS_OUTPUT.put_line('Error al buscar el asegurado ');
					RAISE_APPLICATION_ERROR(-20100,'Error: Tercero NO Existe'||SqlErrm);
					cmensaje_sql := SQLERRM;
					creferencia :=
						'El cliente con la cedula/rif:' || b.tipoid || '-' ||
						b.numid || ' ' || 'NO existe para realizar la cobranza';
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'TERCERO','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
						creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
					);
				END;
				--
				BEGIN
					DBMS_OUTPUT.put_line('Busca si el Asegurado tiene factura en status INC ');
					--
					SELECT mtofactlocal INTO nmtofactlocal
					FROM factura
					WHERE tipoid = b.tipoid
					AND numid = b.numid
					AND dvid = ndvid
					AND stsfact = 'INC';
				EXCEPTION WHEN NO_DATA_FOUND THEN
					DBMS_OUTPUT.put_line('El Asegurado no tiene informacion de Factura');
					nmtofactlocal := 0;
				WHEN TOO_MANY_ROWS THEN
					nmtofactlocal := 0;
				END;
				--
				IF nmtofactlocal <> b.mtodocinglocal AND nmtofactlocal > 0 THEN
					b.mtodocinglocal := nmtofactlocal;
				END IF;
				--
				BEGIN
					SELECT SQ_REL_ING.NEXTVAL INTO nNumRelIng
					FROM SYS.DUAL;
				END;
				--
				BEGIN
					BEGIN
						SELECT SUBSTR(RTRIM(USER),1,8) INTO ccajero
						FROM sys.DUAL;
					END;
					--
					BEGIN
						DBMS_OUTPUT.put_line('Busca Informacion de Usuario como Cajero');
						--
						SELECT codgrpusr,codsuc INTO ccodcaja,ccodofic
						FROM usuario
						WHERE codusr = ccajero;
					END;
					--
					DBMS_OUTPUT.put_line('Busca Maximo de Relacion de Ingreso x Oficina ');
					--
					SELECT MAX(NVL(numing,1)) INTO nnumreling
					FROM correlativo_ingreso
					WHERE codofi = ccodofic;
					--
					SELECT DISTINCT codofi INTO ccodofi
					FROM correlativo_ingreso
					WHERE codofi = ccodofic;
					--
				EXCEPTION WHEN OTHERS THEN
					DBMS_OUTPUT.put_line('Error de Excepcion general ');
					--
					BEGIN
						DBMS_OUTPUT.put_line('Busca Sequencia de Relacion de Ingreso');
						SELECT sq_rel_ing.NEXTVAL INTO nnumreling FROM sys.DUAL;
					END;
				END;
				--
				BEGIN
					DBMS_OUTPUT.put_line('Busca Secuencia de Documento de Ingreso');
					SELECT sq_docing.NEXTVAL INTO nidedocing FROM sys.DUAL;
				END;
				--
				chorareling := TO_CHAR(SYSDATE,'HH24:MI:SS');
				--
				BEGIN
					DBMS_OUTPUT.put_line('Agrega Relacion de Ingreso');
					--
					INSERT INTO rel_ing(
						numreling,stsreling,codofiing,codcaja,codcajero,fecstsreling,horareling,nomterreling,codofi
					)
					VALUES(
						nnumreling,'ACT',ccodofiemi,PCODGRPUSR,PCODUSR,b.fecemi,chorareling,cnomterreling,ccodofi
					);
				EXCEPTION WHEN OTHERS THEN
					DBMS_OUTPUT.put_line('Error al insertar la relacion de Ingreso');
					RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla RELACION INGRESO'||SQLERRM);
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
						b.numpol || ' ' || 'Fallo el insert en la cobranza,Idepol:' || nidepol;
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'REL_ING','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
						creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
					);
				END;
				--
				BEGIN
					DBMS_OUTPUT.put_line('Inser table doc_ing');
					-
					INSERT INTO doc_ing(
						numreling,idedocing,numdocing,tipodocing,codentfinaning,codtarjcred,
						fecvaldocing,mtodocinglocal,mtodocingmoneda,claveautdocing,numrefdoc,
						stsdocing,fecsts,codmoneda,numcorrdep,idedep,numrelcta,numdep,codofi
					)
					VALUES(
						nnumreling,nidedocing,1,'NDC',b.codentfinaning,NULL,b.fecemi,b.mtodocinglocal,
						b.mtodocinglocal,NULL,b.numrefdoc,'INC',b.fecemi,'BS',NULL,NULL,NULL,NULL,ccodofi
					);
				EXCEPTION WHEN OTHERS THEN
					DBMS_OUTPUT.put_line('Error al insertar record en tabla DOC_ING');
					RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la DOC_ING'||SQLERRM);
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
						b.numpol || ' ' || 'Fallo el insert en la cobranza,Idepol:' || nidepol;
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'DOC_ING','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
						creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
					);
				END;
				--
				DBMS_OUTPUT.put_line('Actualiza Correlativo de Ingreso');
				--
				UPDATE correlativo_ingreso
				SET numing = nnumreling + 1,
					feculting = SYSDATE
				WHERE codofi = ccodofic;
				--
				BEGIN
					DBMS_OUTPUT.put_line('Se ejecuta pr_deposito.ing_aut ');
					pr_deposito.ing_aut(nnumreling,ccodofiemi);
				EXCEPTION WHEN OTHERS THEN
					DBMS_OUTPUT.put_line('Error al ejecutar pr_deposito.ing_aut');
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
						b.numpol || ' ' || 'Fallo el proceso de DEPOSITO,Ingreso:' || nnumreling;
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'DEPOSITO','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
						creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
					);
				END;
				--
				BEGIN
					DBMS_OUTPUT.put_line('Busca Informacion de Factura en status INC');
					--
					SELECT idefact INTO nidefact 
					FROM factura
					WHERE tipoid = b.tipoid
					AND numid = b.numid
					AND dvid = ndvid
					AND mtofactlocal = b.mtodocinglocal
					AND stsfact = 'INC';
				EXCEPTION WHEN NO_DATA_FOUND THEN
					DBMS_OUTPUT.put_line('No existe informacion de factura en stauts INC');
					RAISE_APPLICATION_ERROR(-20100,'Error: FACTURA NO Existe'||SqlErrm);
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi ||
						'-' || b.numpol || ' ' || 'NO tiene facturas pendientes';
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'FACTURA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
						creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
					);
				END;
				--
				BEGIN
					DBMS_OUTPUT.put_line('Se Ejecuta pr_comprobante.abrir_comp');
					cncompr := pr_comprobante.abrir_comp('001',SYSDATE);
					pr_factura.cobrar(nidefact,nnumreling,0,0,cncompr,0,ccodofi);
				EXCEPTION WHEN OTHERS THEN
					DBMS_OUTPUT.put_line('Error al ejecutar pr_factura.cobrar ');
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' || 
						b.numpol || ' ' || 'Fallo el proceso de COBRO de Facturas,Ingreso:' ||
						nnumreling || ',Factura:' || nidefact;
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'FACTURA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
						creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
					);
				END;
			ELSE
				BEGIN
					DBMS_OUTPUT.put_line('Busca informacion de Obligacion Tipo PRI');
					--
					SELECT 1,numoblig INTO nexiste,nnumoblig
					FROM obligacion
					WHERE tipoid = b.tipoid
					AND numid = b.numid
					AND dvid = ndvid
					AND mtonetoobliglocal = b.mtodocinglocal
					AND stsoblig = 'ACT'
					AND tipooblig = 'PRI';
				EXCEPTION WHEN NO_DATA_FOUND THEN
					DBMS_OUTPUT.put_line('Obligacion no encontrada');
					nexiste := 0;
				END;
				--
				IF nexiste = 0 THEN
					DBMS_OUTPUT.put_line('Se ejecuta pr_obligacion.asig_num');
					nnumoblig := pr_obligacion.asig_num;
					--
					BEGIN
						BEGIN
							DBMS_OUTPUT.put_line('Busca Nombre de Usuario');
							SELECT SUBSTR(RTRIM(USER),1,8) INTO ccajero FROM sys.DUAL;
						END;
						--
						BEGIN
							DBMS_OUTPUT.put_line('Busca Informacion del Usuario');
							SELECT codsuc,coddpto INTO wcodsuc,wcoddpto
							FROM usuario
							WHERE codusr = ccajero;
						END;
						--
						DBMS_OUTPUT.put_line('Inserta registro en tabla obligacion');
						--
						INSERT INTO obligacion(
							stsoblig,fecsts,codmoneda,mtonetoobliglocal,mtonetoobligmoneda,mtobrutoobliglocal,
							mtobrutoobligmoneda,fecgtiapago,dptoemi,sldoobliglocal,sldoobligmoneda,tipoid,numid,
							dvid,numoblig,tipooblig,codinterlider,mtosinpronpago,fecemis,codusr,coddpto,sucusr
						)
						VALUES(
							'VAL',b.fecemi,'BS',b.mtodocinglocal,b.mtodocinglocal,b.mtodocinglocal,b.mtodocinglocal,
							b.fecinivig,b.codofiemi,b.mtodocinglocal,b.mtodocinglocal,b.tipoid,b.numid,ndvid,
							nnumoblig,'PRI',NULL,b.mtodocinglocal,b.fecemi,ccajero,wcoddpto,wcodsuc
						);
					EXCEPTION WHEN OTHERS THEN
						DBMS_OUTPUT.put_line('Error al Insertar Registro de Obligacion ');
						RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla OBLIGACION'||SQLERRM);
						cmensaje_sql := SQLERRM;
						creferencia :=
							'La Poliza con el Numero:'|| b.codprod || '-' || b.codofiemi || '-' ||
							b.numpol || ' ' || 'Fallo el insert de la Obligacion,Idepol:' || nidepol;
						dfechaproceso := SYSDATE;
						pr_banseg.graba_errores(
							'OBLIGACION','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
							creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
						);
					END;
					--
					BEGIN
						DBMS_OUTPUT.put_line('Se Ejecuta pr_obligacion.incluir');
						pr_obligacion.incluir(nnumoblig);
						DBMS_OUTPUT.put_line('Se ejecuta pr_det_oblig.generar');
						pr_det_oblig.generar(nnumoblig,b.mtodocinglocal,b.mtodocinglocal,'BS','DEVOLU','DEVOLU');
						DBMS_OUTPUT.put_line('Se Ejecuta pr_obligacion.activar ');
						pr_obligacion.activar(nnumoblig);
					EXCEPTION WHEN OTHERS THEN
						DBMS_OUTPUT.put_line('Error en pr_obligacion');
						cmensaje_sql := SQLERRM;
						creferencia :=
							'La Poliza con el Numero:'|| b.codprod || '-' || b.codofiemi || '-' || 
							b.numpol || ' ' || 'Fallo el proceso de Generar la Obligacion';
						dfechaproceso := SYSDATE;
						pr_banseg.graba_errores(
							'OBLIGACION','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
							creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
						);
					END;
					--
					BEGIN
						DBMS_OUTPUT.put_line('Se ejecuta pr_orden_pago.inserta_orden');
						pr_orden_pago.inserta_orden(nnumoblig);
					EXCEPTION WHEN OTHERS THEN
						DBMS_OUTPUT.put_line('Error al ejecutar pr_orden_pago.inserta_orden ');
						cmensaje_sql := SQLERRM;
						creferencia :=
							'La Poliza con el Numero:'|| b.codprod|| '-'|| b.codofiemi|| '-'|| 
							b.numpol|| ':'|| 'Fallo el proceso de Generar la Orden de Pago';
						dfechaproceso := SYSDATE;
						pr_banseg.graba_errores(
							'ORDEN_PAGO','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
							creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
						);
					END;
					--
				ELSE
					BEGIN
						DBMS_OUTPUT.put_line('Se ejecuta pr_orden_pago.inserta_orden ');
						pr_orden_pago.inserta_orden(nnumoblig);
					EXCEPTION WHEN OTHERS THEN
						DBMS_OUTPUT.put_line('Error al ejecutar pr_orden_pago.inserta_orden ');
						cmensaje_sql := SQLERRM;
						creferencia := 
							'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
							b.numpol || ' ' || 'Fallo el proceso de Generar la Orden de Pago';
						dfechaproceso := SYSDATE;
						pr_banseg.graba_errores(
							'ORDEN_PAGO','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
							creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
						);
					END;
					--
				END IF;
				--
				BEGIN
					SELECT SQ_REL_EGRE.NEXTVAL INTO nNumRelEgre
					FROM SYS.DUAL;
				END;
				--
				BEGIN
					DBMS_OUTPUT.put_line('Busca Nomre de Usuario');
					SELECT SUBSTR(RTRIM(USER),1,8) INTO ccajero FROM sys.DUAL;
				END;
				--
				BEGIN
					DBMS_OUTPUT.put_line('Busca informacion de Usuario');
					--
					SELECT codgrpusr,codsuc INTO ccodcaja,ccodofic
					FROM usuario
					WHERE codusr = ccajero;
				END;
				--
				BEGIN
					DBMS_OUTPUT.put_line('Busca nueva relacion de ingreso');
					--
					SELECT MAX(NVL(numegre,1)) + 1 INTO nnumrelegre
					FROM correlativo_ingreso
					WHERE codofi = ccodofic;
					--
					SELECT DISTINCT codofi INTO ccodofi
					FROM correlativo_ingreso
					WHERE codofi = ccodofic;
					--
					DBMS_OUTPUT.put_line('Actualiza tabla correlativo_ingreso ');
					--
					UPDATE correlativo_ingreso
					SET numegre = nnumrelegre,
						fecultegre = SYSDATE
					WHERE codofi = ccodofic;
				EXCEPTION WHEN OTHERS THEN
					DBMS_OUTPUT.put_line('Error al tratar de actualizar tabla correlativo_ingreso ');
					BEGIN
						DBMS_OUTPUT.put_line('Busca Nueva sequencia sq_rel_egre ');
						SELECT sq_rel_egre.NEXTVAL INTO nnumrelegre FROM DUAL;
					END;
				END;
				--
				BEGIN
					DBMS_OUTPUT.put_line('Busca nueva sequencia sq_relegre_lotus ');
					SELECT sq_relegre_lotus.NEXTVAL INTO nseqrelegre FROM sys.DUAL;
				END;
				--
				BEGIN
					DBMS_OUTPUT.put_line('Ejecuta pr_rel_egre.inserta_rel_egre');
					pr_rel_egre.inserta_rel_egre(nnumrelegre,nnumoblig,b.tipoid,b.numid,ndvid,ccodofi);
				EXCEPTION WHEN OTHERS THEN
					DBMS_OUTPUT.put_line('Error al ejecutar pr_rel_egre.inserta_rel_egre');
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi ||
						'-' || b.numpol || ' ' || 'Fallo el proceso de Insertar la relacion de egreso';
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'REL_EGRE','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
						creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
					);
				END;
				--
				chorasts := TO_CHAR(SYSDATE,'HH24:MI:SS');
				--
				BEGIN
					DBMS_OUTPUT.put_line('Inserta record en tabla doc_egre');
					--
					INSERT INTO doc_egre(
						numrelegre,numdocpago,codmoneda,mtodocpagolocal,mtodocpagomoneda,
						stsdocpago,fecsts,horasts,tipodocpago,codentfinan,numrelcta,
						numchequera,numdocref,numchq,codcajero,codcaja,seqrelegre,codofi
					)
					VALUES(
						nnumrelegre,'1','BS',b.mtodocinglocal,b.mtodocinglocal,'VAL',b.fecemi,chorasts,'NDD',
						b.codentfinaning,'1','1',b.numrefdoc,NULL,PCODGRPUSR,USER,nseqrelegre,ccodofi
					);
				EXCEPTION WHEN OTHERS THEN
					DBMS_OUTPUT.put_line('Error al insertar record en tabla doc_egre');
					RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla DOC_EGRE'||SQLERRM);
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
						b.numpol || ' ' || 'Fallo en el Insert' || ',EGRESO:' || nnumrelegre;
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'DOC_EGRE','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
						creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
					);
				END;
				--
				BEGIN
					pr_rel_egre.incluir(nnumrelegre);
					pr_doc_egre.incluir(nnumrelegre,ccodofiemi);
					--
					cncompr := pr_doc_egre.act_rel_egre(nnumrelegre,'BS');
					ncount := ncount + 1;
				EXCEPTION WHEN OTHERS THEN
					DBMS_OUTPUT.put_line('Error al ejecutar los packages anteriores ');
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza con el Numero:' || b.codprod || '-' || b.codofiemi || '-' ||
						b.numpol || ' ' || 'Fallo La generacion de la relacion de egreso numero:' || nnumrelegre;
					dfechaproceso := SYSDATE;
					ncountr := ncountr + 1;
					pr_banseg.graba_errores(
						'DOC_EGRE','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
						creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
					);
				END;
			END IF;
			--
			ccodproc := 'CDP';
			DBMS_OUTPUT.put_line('Se actualiza historico');
			--
			UPDATE banca_seguro_hist
			SET reg_proce = ncount,
				reg_recha = ncountr
			WHERE codprov = b.codproveedor
			AND archivo = b.archivo
			AND codproc = ccodproc;
			--
			DBMS_OUTPUT.put_line('Se Actualiza archivo de cobros y devolciones');
			--
			UPDATE banca_seguro_cob_dev
			SET indicador = 'S',
				fecproceso = SYSDATE
			WHERE codprod = b.codprod
			AND codofiemi = b.codofiemi
			AND numpol = b.numpol;
			--
		END LOOP;
		--
		BEGIN
			DBMS_OUTPUT.put_line('Busca fecha de cierre de caja ');
			--
			SELECT MAX(fecultcierre) INTO dfecultcierre
			FROM cierre_caja
			WHERE codoficierre = PCODSUC
			AND codgrpusr = PCODUSR
			AND codcajero = USER
			AND indcierre = 'S';
		EXCEPTION WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.put_line('No existe informacion en tabla cierre_caja');
			RAISE_APPLICATION_ERROR(-20100,'Error:NO existe Cierre Anterior a la fecha incicada'||SqlErrm);
			cmensaje_sql := SQLERRM;
			creferencia := 'NO existe caja Abierta para el cajero:' || USER;
			dfechaproceso := SYSDATE;
			pr_banseg.graba_errores(
				'CIERRE_CAJA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
				creferencia,dfechaproceso,NULL,NULL,NULL
			);
		WHEN TOO_MANY_ROWS THEN
			cMensaje_Sql := SqlErrm;
			creferencia := 'Existen varios dias de caja Abierta para el cajero:'||USER;
			dfechaproceso := sysdate;
			PR_BANSEG.graba_errores(
				'CIERRE_CAJA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
				creferencia,dfechaproceso,NULL
			);
		END;
		--
		BEGIN
			DBMS_OUTPUT.put_line('Se ejecuta pr_banseg.cierre_caja para sucursal 010101 ');
			pr_banseg.cierre_caja(PCODCIA,PCODSUC,dfecultcierre);
		EXCEPTION WHEN OTHERS THEN
			DBMS_OUTPUT.put_line('Error al ejecutar pr_banseg.cierre_caja para sucursal 010101 ');
			cmensaje_sql := SQLERRM;
			creferencia := 'El proceso de CIERRE_CAJA fallo para el cajero:' || USER;
			dfechaproceso := SYSDATE;
			pr_banseg.graba_errores(
				'CIERRE_CAJA','CARGA-CD',cmensaje_sql,'COBRAR_DEVOLUCION_POLIZA',
				creferencia,dfechaproceso,NULL,NULL,NULL
			);
		END;
		--
	END COBRAR_DEVOLUCION_POLIZA;
	--
	PROCEDURE modificar_data(ncodprov NUMBER,carchivo VARCHAR2)
	IS
		nidepol 		poliza.idepol%TYPE;
		ccodcli 		poliza.codcli%TYPE;
		ccodclia 		poliza.codcli%TYPE;
		ccodofiemi		poliza.codofiemi%TYPE;
		ctipoida 		cliente.tipoid%TYPE;
		nnumida 		cliente.numid%TYPE;
		ndvida			cliente.dvid%TYPE := 0;
		ctipoid 		cliente.tipoid%TYPE;
		nnumid 			cliente.numid%TYPE;
		ndvid 			cliente.dvid%TYPE := 0;
		dfechaproceso 	DATE;
		ctabla 			VARCHAR2(100) := NULL;
		ccoderror 		VARCHAR2(20) := NULL;
		cmensaje_sql 	VARCHAR2(4000) := NULL;
		creferencia 	VARCHAR2(100) := NULL;
		cdummy			VARCHAR2(2);
		cindtipopro 	VARCHAR2(100);
		ccodproc 		VARCHAR2(3);
		nexiste 		NUMBER(1);
		ncount 			NUMBER(5) := 0;
		ncountr 		NUMBER(5) := 0;
		exec_error 		EXCEPTION;
		exec_coase		EXCEPTION;
		--
		CURSOR modifi
		IS
		SELECT
			codprod,codofiemi,numpol,fecemi,codactt,telft,telcelt,emailt,direct,codpostalt,
			codacta,telfa,telcela,emaila,direca,codpostala,tipoidb,numidb,nomterb,apeterb,
			codparent,porcpart,codplan,revplan,codformpago,cuenta,codproveedor,archivo
		FROM banca_seguro_mod
		WHERE NVL(indicador,'N') = 'N'
		AND codproveedor = NVL(ncodprov,codproveedor)
		AND archivo = NVL(carchivo,archivo);
	BEGIN
		FOR m IN modifi
		LOOP
			ccodofiemi := pr_banseg.buscar_oficina(m.codofiemi);
			--
			IF ccodofiemi = 'INVALI' OR ccodofiemi <> m.codofiemi THEN
				cmensaje_sql := NULL;
				creferencia := 'La Oficina no esta configurada:' || m.codofiemi;
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'BANCA_SEGURO_OFICINA','CARGA-M',cmensaje_sql,'MODIFICAR_DATA',
					creferencia,dfechaproceso,m.codprod,m.codproveedor,m.archivo
				);
			END IF;
			--
			BEGIN
				SELECT idepol,codcli INTO nidepol,ccodcli
				FROM poliza
				WHERE codprod = m.codprod
				AND codofiemi = ccodofiemi
				AND numpol = m.numpol;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				RAISE_APPLICATION_ERROR(-20100,'No EXISTE LA POLIZA'||SQLERRM);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || m.codprod || '-' || 
					m.codofiemi || '-' || m.numpol || ':No existe';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'POLIZA','CARGA-M',cmensaje_sql,'MODIFICAR_DATA',
					creferencia,dfechaproceso,m.codprod,m.codproveedor,m.archivo
				);
			END;
			--
			BEGIN
				SELECT tipoid,numid,dvid INTO ctipoid,nnumid,ndvid
				FROM cliente
				WHERE codcli = ccodcli;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				RAISE_APPLICATION_ERROR(-20100,'No EXISTE EL CLIENTE'||SQLERRM);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Póliza con el Número:' || m.codprod || '-' || m.codofiemi || 
					'-' || m.numpol || ':No existe el CLIENTE';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'CLIENTE','CARGA-M',cmensaje_sql,'MODIFICAR_DATA',creferencia,
					dfechaproceso,m.codprod,m.codproveedor,m.archivo
				);
			END;
			--
			BEGIN
				UPDATE cliente
				SET codact = m.codactt
				WHERE codcli = ccodcli;
				--
				UPDATE tercero
				SET telef1 = m.telft,
					telcel = m.telcelt,
					email = m.emailt,
					direc = m.direct,
					zip = m.codpostalt
				WHERE tipoid = ctipoid
				AND numid = nnumid
				AND dvid = ndvid;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				RAISE_APPLICATION_ERROR(-20100,'No EXISTE EL CLIENTE/TERCERO'||SQLERRM);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || m.codprod || '-' || m.codofiemi || 
					'-' || m.numpol || ':No existe el TOMADOR.No se actualizaron sus DATOS';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'CLIENTE/TERCERO','CARGA-M',cmensaje_sql,'MODIFICAR_DATA',
					creferencia,dfechaproceso,m.codprod,m.codproveedor,m.archivo
				);
			END;
			--
			BEGIN
				SELECT codcli INTO ccodclia
				FROM certificado
				WHERE idepol = nidepol;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				RAISE_APPLICATION_ERROR(-20100,'No Existe el Asegurado EN LA POLIZA'||SQLERRM);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || m.codprod || '-' || m.codofiemi ||
					'-' || m.numpol || ' ' || ':No existe el Asegurado en la Poliza';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'CERTIFICADO','CARGA-M',cmensaje_sql,'MODIFICAR_DATA',
					creferencia,dfechaproceso,m.codprod,m.codproveedor,m.archivo
				);
			END;
			--
			BEGIN
				SELECT tipoid,numid,dvid INTO ctipoida,nnumida,ndvida
				FROM cliente
				WHERE codcli = ccodclia;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				RAISE_APPLICATION_ERROR(-20100,'No EXISTE EL ASEGURADO EN CLIENTE'||SQLERRM);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || m.codprod || '-' || m.codofiemi ||
					'-' || m.numpol || ':No existe el Asegurado en la Poliza';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'CLIENTE','CARGA-M',cmensaje_sql,'MODIFICAR_DATA',
					creferencia,dfechaproceso,m.codprod,m.codproveedor,m.archivo
				);
			END;
			--
			BEGIN
				UPDATE cliente
				SET codact = m.codacta
				WHERE codcli = ccodclia;
				--
				UPDATE tercero
				SET telef1 = SUBSTR(m.telfa,1,12),
					telcel = SUBSTR(m.telcela,1,12),
					email = m.emaila,
					direc = m.direca,
					zip = m.codpostala
				WHERE tipoid = ctipoida
				AND numid = nnumida
				AND dvid = ndvida;
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR(-20100,'ERROR AL REALIZAR LA ACTUALIZACION DEL CLIENTE/TERCERO'||SQLERRM);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || m.codprod || '-' || m.codofiemi || '-' ||
					m.numpol || ' ' || 'Fallo el Proceso de Actualizacion del Asegurado';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'CLIENTE/TRECERO','CARGA-M',cmensaje_sql,'MODIFICAR_DATA',
					creferencia,dfechaproceso,m.codprod,m.codproveedor,m.archivo
				);
			END;
			--
			BEGIN
				SELECT 1 INTO nexiste
				FROM benef_cert
				WHERE tipoid = m.tipoidb
				AND numid = m.numidb
				AND dvid = '0'
				AND idepol = nidepol;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				nexiste := 0;
				cmensaje_sql := SQLERRM;
				creferencia :=
					'El Beneficiario con la cedula/Rif:' || m.tipoidb || '-' || m.numidb ||
					',No existe en la Poliza:' || m.codprod || '-' || m.codofiemi || '-' || m.numpol;
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'BENEFICIARIO','CARGA-M',cmensaje_sql,'MODIFICAR_DATA',
					creferencia,dfechaproceso,m.codprod,m.codproveedor,m.archivo
				);
			WHEN TOO_MANY_ROWS THEN
				nexiste := 1;
			END;
			--
			IF nexiste = 1 THEN
				BEGIN
					UPDATE benef_cert
					SET codparent = m.codparent,
						porcpart = m.porcpart
					WHERE tipoid = m.tipoidb
					AND numid = m.numidb
					AND dvid = 0
					AND idepol = nidepol;
					--
					UPDATE tercero
					SET nomter = m.nomterb,
						apeter = m.apeterb
					WHERE tipoid = m.tipoidb
					AND numid = m.numidb
					AND dvid = 0;
					--
					ncount := ncount + 1;
				EXCEPTION WHEN OTHERS THEN
					RAISE_APPLICATION_ERROR(-20100,'ERROR AL REALIZAR LA ACTUALIZACION DEL BENEFICIARION EN CLIENTE/TERCERO'||SQLERRM);
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza con el Numero:' || m.codprod || '-' || m.codofiemi || '-' ||
						m.numpol || ' ' || 'Fallo el Proceso de Actualizacion del BENEFICIARIO';
					dfechaproceso := SYSDATE;
					ncountr := ncountr + 1;
					pr_banseg.graba_errores(
						'TRECERO/BENEFICIARIO','CARGA-M',cmensaje_sql,'MODIFICAR_DATA',
						creferencia,dfechaproceso,m.codprod,m.codproveedor,m.archivo
					);
				END;
			END IF;
			--
			ccodproc := 'MOP';
			--
			UPDATE banca_seguro_hist
			SET reg_proce = ncount,
				reg_recha = ncountr
			WHERE codprov = m.codproveedor
			AND archivo = m.archivo
			AND codproc = ccodproc;
			--
			UPDATE banca_seguro_mod
			SET indicador = 'S',
				fecproceso = SYSDATE
			WHERE codprod = m.codprod
			AND codofiemi = m.codofiemi
			AND numpol = m.numpol;
			--
		END LOOP;
	END modificar_data;
	--
	PROCEDURE cierre_caja(ccodcia VARCHAR2,ccodoficierre VARCHAR2,dfecultcierre DATE)
	IS
		dummy 			NUMBER(1);
		dia 			NUMBER(1);
		nexiste 		NUMBER(1);
		dfecapertura 	DATE;
		dfeccierre 		DATE;
		dfecha 			DATE;
		cnohabil 		VARCHAR2(1);
		ccodcajero 		VARCHAR2(8);
		ccodcaja 		VARCHAR2(8);
	BEGIN
		BEGIN
			SELECT SUBSTR(RTRIM(USER),1,8) INTO ccodcajero
			FROM sys.DUAL;
		END;
		--
		BEGIN
			SELECT u.codgrpusr INTO ccodcaja
			FROM usuario u,grupo_usuario gu
			WHERE u.codgrpusr = gu.codgrpusr
			AND u.codusr = USER;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			raise_application_error(-20100,'Usuario no es Cajero' || SQLERRM);
		END;
		--
		BEGIN
			SELECT fecapertura INTO dfecapertura
			FROM cierre_caja
			WHERE codcia = ccodcia
			AND codoficierre = ccodoficierre
			AND codgrpusr = ccodcaja
			AND codcajero = ccodcajero
			AND NVL(TO_CHAR(dfecultcierre,'DDMMRRRR'),'0') = '0'
			AND indcierre = 'N';
		EXCEPTION WHEN NO_DATA_FOUND THEN
			dfecapertura := SYSDATE;
		WHEN TOO_MANY_ROWS THEN
			dfecapertura := SYSDATE;
		WHEN OTHERS THEN
			dfecapertura := SYSDATE;
		END;
		--
		SELECT TO_CHAR(dfecapertura,'D') INTO dia FROM DUAL;
		--
		IF dia BETWEEN 1 AND 4 THEN
			dfecapertura := SYSDATE + 1;
		ELSIF dia = 5 THEN
			dfecapertura := dfecapertura + 3;
		ELSIF dia = 6 THEN
			dfecapertura := dfecapertura + 2;
		ELSIF dia = 7 THEN
			dfecapertura := dfecapertura + 1;
		END IF;
		--
		cnohabil := 'S';
		--
		BEGIN
			WHILE cnohabil = 'S'
			LOOP
				BEGIN
					SELECT 'S' INTO cnohabil
					FROM dias_no_habiles
					WHERE TRUNC(fecha) = TRUNC(dfecapertura);
				EXCEPTION WHEN NO_DATA_FOUND THEN
					cnohabil := 'N';
				WHEN TOO_MANY_ROWS THEN
					cnohabil := 'S';
				END;
				--
				IF cnohabil = 'S' THEN
					SELECT TO_CHAR(dfecapertura,'D') INTO dia FROM DUAL;
					--
					IF dia BETWEEN 2 AND 6 THEN
						dfecapertura := dfecapertura + 1;
					ELSIF dia = 7 THEN
						dfecapertura := dfecapertura + 2;
					ELSIF dia = 1 THEN
						dfecapertura := dfecapertura + 1;
					END IF;
				END IF;
			END LOOP;
		END;
		--
		UPDATE cierre_caja
		SET fecultcierre = SYSDATE,
			indcierre = 'S'
		WHERE codcia = ccodcia
		AND codoficierre = ccodoficierre
		AND codgrpusr = ccodcaja
		AND codcajero = ccodcajero
		AND TRUNC(fecapertura) = TRUNC(dfecapertura)
		AND fecultcierre IS NULL
		AND indcierre = 'N';
		--
		BEGIN
			INSERT INTO cierre_caja(
				codcia,codoficierre,codgrpusr,codcajero,fecultcierre,fecapertura,indcierre
			)
			VALUES(ccodcia,ccodoficierre,ccodcaja,ccodcajero,NULL,dfecapertura,'N');
		END;
	EXCEPTION WHEN OTHERS THEN
		raise_application_error(-20100,'Fallo CIERRE_CAJA' || SQLERRM);
	END cierre_caja;
	--
	PROCEDURE graba_errores(
		ctabla VARCHAR2,ccod_error VARCHAR2,cmensaje_sql VARCHAR2,
		nproceso VARCHAR2,creferencia VARCHAR2,dfechaproceso DATE,
		ccodprod VARCHAR2,ccoproveedor NUMBER,carchivo VARCHAR2
	)
	IS
		cerrorref		VARCHAR2(1000);
		cmensaje_sql1	VARCHAR2(4000);
	BEGIN
		cmensaje_sql1 := cmensaje_sql;
		--
		IF cmensaje_sql1 LIKE '%ORA-02291%' THEN
			BEGIN
				SELECT 
					'La Tabla ' || ctabla || ' con datos sin referencia en la Tabla ' || u2.table_name
				INTO cerrorref
				FROM all_constraints u2,all_constraints u1
				WHERE u2.constraint_name = u1.r_constraint_name
				AND u2.owner = 'INTERFAZ'
				AND INSTR(cmensaje_sql,u1.constraint_name || ')') > 0
				AND u1.owner = 'INTERFAZ'
				AND u1.table_name = ctabla;
				--
				cmensaje_sql1 := cmensaje_sql1 || ' ' || cerrorref;
			END;
		END IF;
		--
		INSERT INTO banca_seguro_error
		VALUES(
			ctabla,ccod_error,cmensaje_sql1,nproceso,creferencia,dfechaproceso,
			ccodprod,ccoproveedor,carchivo,NULL,NULL,NULL,NULL,NULL
		);
	END graba_errores;
	--
	FUNCTION buscar_oficina(ccodofi_s VARCHAR2)
		RETURN VARCHAR2
	IS
		ccodofi_b banca_seguro_oficina.codofi_b%TYPE := NULL;
	BEGIN
		BEGIN
			SELECT codofi INTO ccodofi_b
			FROM oficina
			WHERE codofi = ccodofi_s;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			ccodofi_b := 'INVALI';
		END;
		--
		RETURN(ccodofi_b);
	END buscar_oficina;
	--
	FUNCTION IMPORTAR(ccodigo VARCHAR2,cdirecarc VARCHAR2,ccampos VARCHAR2,cdatos VARCHAR2)
		RETURN BOOLEAN
	IS
		carq 			sys.UTL_FILE.file_type;
		n_cursor 		INTEGER;
		n_cursor1 		INTEGER;
		n_dummy 		INTEGER;
		n_dummy1 		INTEGER;
		cresultado 		VARCHAR(300);
		dummy 			NUMBER;
		nexiste 		NUMBER := 0;
		ndecimales		NUMBER(10);
		cnomtabela 		VARCHAR2(30);
		carchivo 		VARCHAR2(100);
		cdirectorio 	VARCHAR2(100);
		cformula 		VARCHAR2(200);
		ctemvar 		VARCHAR2(200);
		clinea 			VARCHAR2(5000);
		clineaWHERE 	VARCHAR2(5000);
		clineatexto 	VARCHAR2(5000);
		clineaoutcampo	VARCHAR2(5000);
		clineaoutvalor	VARCHAR2(5000);
		c_expresionint1 VARCHAR2(5000) := NULL;
		c_expresionint 	VARCHAR2(5000) := NULL;
		ncount 			NUMBER(10) := 1;
		ncounp 			NUMBER(10) := 1;
		cCODPROC 		VARCHAR2(6);
		ncodprov 		NUMBER(6);
		--
		CURSOR layout_tipo_c
		IS
		SELECT nomtabela,condicao
		FROM layout_tabela
		WHERE codigo = ccodigo;
		--
		CURSOR layout_imp_c 
		IS
		SELECT
			campo,posicion,longitud,tipo,tipocampo,decimales,
			nomtabela,valordefault,NVL(indpk,'N') indpk,formula
		FROM layout_imp
		WHERE codigo = ccodigo
		AND nomtabela = cnomtabela;
		--
	BEGIN
		cdirectorio := SUBSTR(cdirecarc,1,INSTR(cdirecarc,'/',-1) - 1);
		carchivo := SUBSTR(cdirecarc,INSTR(cdirecarc,'/',-1 ) + 1,LENGTH(cdirecarc));
		ncodprov := SUBSTR(cArchivo,1,1);
		--
		IF SUBSTR(cArchivo,2,2)= 'AS' THEN
			cCODPROC := 'CAP';
		ELSIF SUBSTR(cArchivo,2,2)= 'CA' THEN
			cCODPROC := 'ANP';
		ELSIF SUBSTR(cArchivo,2,2)= 'BE' THEN
			cCODPROC := 'CBP';
		ELSIF SUBSTR(cArchivo,2,2)= 'CO' THEN
			cCODPROC := 'CDP';
		ELSIF SUBSTR(cArchivo,2,2)= 'IN' THEN
			cCODPROC := 'ICE';
		ELSIF SUBSTR(cArchivo,2,2)= 'MO' THEN
			cCODPROC := 'MOP';
		ELSIF SUBSTR(cArchivo,2,2)= 'RO' THEN
			cCODPROC := 'ROB';
		ELSIF SUBSTR(cArchivo,2,2)= 'TE' THEN
			cCODPROC := 'TRR';
		END IF;
		--
		BEGIN
			INSERT INTO banca_seguro_hist(codprov,codproc,fecproc,archivo,reg_leido,reg_proce,reg_recha,stsproc,fecini,fecfin)
			VALUES (ncodprov,cCODPROC,trunc(sysdate),SUBSTR(cArchivo,2),null,null,null,'INI',sysdate,null);
		END;
		--
		carq := sys.UTL_FILE.Fopen(cDirectorio,cArchivo,'r');
		sys.UTL_FILE.get_line(carq,clinea);
		n_cursor := DBMS_SQL.open_cursor;
		--
		WHILE clinea IS NOT NULL
		LOOP
			FOR y IN layout_tipo_c
			LOOP
				cnomtabela := RTRIM(y.nomtabela);
				--
				FOR x IN layout_imp_c
				LOOP
					clineaoutcampo := clineaoutcampo || x.campo || ',';
					DBMS_OUTPUT.put_line(x.campo);
					--
					IF x.longitud <> 0 THEN
						clineatexto := SUBSTR(clinea,x.posicion,x.longitud);
						--
						IF x.tipocampo = 'DATE' THEN
							clineatexto :=
								'TO_DATE('|| CHR(39) || SUBSTR(clineatexto,1,2) ||
								'/' || SUBSTR(clineatexto,3,2) || '/' ||  SUBSTR(clineatexto,5,4) ||
								CHR(39) || ',' || CHR(39) || 'DD/MM/RRRR' || CHR(39) || '),';
							DBMS_OUTPUT.put_line('tipo date ' || clineatexto);
						ELSIF x.tipocampo = 'NUMBER' THEN
							ndecimales := 10 ** x.decimales;
							clineatexto :=
								'TO_NUMBER(LTRIM(' || CHR(39) || clineatexto || CHR(39) || 
								'))/' || TO_CHAR(ndecimales) || ',';
							DBMS_OUTPUT.put_line('tipo number ' || clineatexto);
						ELSE
							clineatexto := CHR(39) || RTRIM(LTRIM(clineatexto)) || CHR(39) || ',';
						END IF;
						--
						IF x.formula IS NOT NULL THEN
							DBMS_OUTPUT.put_line(x.formula);
							n_cursor1 := DBMS_SQL.open_cursor;
							ctemvar := REPLACE(RTRIM(x.formula),'',SUBSTR(clineatexto,1,LENGTH(clineatexto) - 1));
							c_expresionint1 :=('BEGIN ' || ctemvar || '; END;');
							--
							DBMS_SQL.parse(n_cursor1,c_expresionint1,DBMS_SQL.native);
							DBMS_SQL.bind_variable (n_cursor1,'cResultado',' ');
							--
							n_dummy1 := DBMS_SQL.EXECUTE(n_cursor1);
							--
							DBMS_SQL.variable_value(n_cursor1,'cResultado',cresultado);
							DBMS_SQL.close_cursor(n_cursor1);
							--
							clineatexto := CHR(39) || RTRIM(LTRIM(cresultado)) || CHR(39) || ',';
						END IF;
					ELSE
						IF x.tipo = 'S' THEN
							IF x.formula IS NOT NULL THEN
								DBMS_OUTPUT.put_line('X.Tipo ' || x.tipo || ' X.Formula ' || x.formula);
								n_cursor1 := DBMS_SQL.open_cursor;
								ctemvar := RTRIM(x.formula);
								c_expresionint1 :=('BEGIN ' || ctemvar || '; END;');
								--
								DBMS_SQL.parse(n_cursor1,c_expresionint1,DBMS_SQL.native);
								DBMS_SQL.bind_variable(n_cursor1,'cResultado',' ');
								--
								DBMS_OUTPUT.put_line(c_expresionint1);
								--
								n_dummy1 := DBMS_SQL.EXECUTE(n_cursor1);
								--
								DBMS_SQL.variable_value(n_cursor1,'cResultado',cresultado);
								DBMS_SQL.close_cursor(n_cursor1);
								--
								clineatexto := CHR(39) || RTRIM(LTRIM(cresultado)) || CHR(39) || ',';
							END IF;
						ELSE
							clineatexto := CHR(39) || RTRIM(LTRIM(x.valordefault)) || CHR(39) || ',';
						END IF;
					END IF;
					--
					clineaoutvalor := clineaoutvalor || clineatexto;
					DBMS_OUTPUT.put_line('cLineaTexto ' || clineatexto);
					--
					IF x.indpk = 'S' THEN
						clineaWHERE := 
							clineaWHERE || ' ' || x.campo || ' = ' || 
							SUBSTR(clineatexto,1,LENGTH(clineatexto) - 1 ) || ' AND ';
					END IF;
				END LOOP;
				--
				clineaWHERE := SUBSTR(clineaWHERE,1,LENGTH(clineaWHERE) - 4);
				clineaoutcampo := SUBSTR(clineaoutcampo,1,LENGTH(clineaoutcampo) - 1);
				clineaoutvalor := SUBSTR(clineaoutvalor,1,LENGTH(clineaoutvalor) - 1);
				--
				IF PR.existe(cnomtabela,clineaWHERE) <> 0 THEN
					nexiste := pr.existe(cnomtabela,clineaWHERE);
				END IF;
				--
				IF nexiste = 0 THEN
					IF ccampos IS NOT NULL AND cdatos IS NOT NULL THEN
						c_expresionint :=
							'INSERT INTO ' || cnomtabela || '(' || ccampos || ',' ||  clineaoutcampo ||
							') VALUES(' || cdatos || ',' || clineaoutvalor || ')';
					ELSE
						c_expresionint :=
							'INSERT INTO ' || cnomtabela || '(' || clineaoutcampo ||
							') VALUES(' || clineaoutvalor || ')';
					END IF;
					--
					DBMS_SQL.parse(n_cursor,c_expresionint,DBMS_SQL.native	);
					n_dummy := DBMS_SQL.EXECUTE(n_cursor);
				END IF;
				--
				clineaoutcampo := NULL;
				clineaoutvalor := NULL;
				clineaWHERE := NULL;
				--
				IF cnomtabela = 'BANCA_SEGURO' THEN
					UPDATE BANCA_SEGURO
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_BEN' THEN
					UPDATE BANCA_SEGURO_BEN
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_ANU' THEN
					UPDATE BANCA_SEGURO_ANU
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_COB_DEV' THEN
					UPDATE BANCA_SEGURO_COB_DEV
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_MOD' THEN
					UPDATE BANCA_SEGURO_MOD
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_DP_INCE' THEN
					UPDATE BANCA_SEGURO_DP_INCE
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_DP_ROBO' THEN
					UPDATE BANCA_SEGURO_DP_ROBO
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_DP_TERRE' THEN
					UPDATE BANCA_SEGURO_DP_TERRE
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				END IF;
				--
				ncounp := ncounp+1;
			END LOOP;
			--
			BEGIN
				UTL_FILE.get_line(carq,clinea);
			EXCEPTION WHEN NO_DATA_FOUND THEN
				EXIT;
			END;
			--
			ncount := ncount + 1;
			COMMIT;
			DBMS_OUTPUT.put_line('Value of nCount = nCount ' || ncount);
			--
			UPDATE banca_seguro_hist
			SET REG_LEIDO = ncount
			WHERE CODPROV = ncodprov
			AND ARCHIVO = SUBSTR(cArchivo,2)
			AND CODPROC = cCODPROC;
		END LOOP;
		--
		DBMS_OUTPUT.put_line('Value of 66'||'Fecha:'||sysdate);
		DBMS_SQL.close_cursor(n_cursor);
		sys.UTL_FILE.fclose(carq);
		--
		UPDATE banca_seguro_hist
		SET STSPROC = 'FIN',
			fecfin = sysdate
		WHERE CODPROV = ncodprov
		AND ARCHIVO = SUBSTR(cArchivo,2)
		AND CODPROC = cCODPROC;
		--
		RETURN(TRUE);
	EXCEPTION WHEN sys.UTL_FILE.invalid_filehANDle THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,pr.mensaje('ABD',20264,'1.-INVALID_FILEHANDLE' || ' LINE NUMBER ==> ' || ncount,NULL,NULL));
	WHEN sys.UTL_FILE.read_error THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,pr.mensaje('ABD',20264,'2.-READ_ERROR'|| ' LINE NUMBER ==> '|| ncount,NULL,NULL));
	WHEN sys.UTL_FILE.invalid_operation THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,pr.mensaje('ABD',20264,'3.-INVALID_OPERATION'|| ' LINE NUMBER ==> '|| ncount,NULL,NULL));
	WHEN sys.UTL_FILE.invalid_path THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,pr.mensaje('ABD',20264,'4.-INVALID_PATH'|| ' LINE NUMBER ==> '|| ncount,NULL,NULL));
	WHEN sys.UTL_FILE.invalid_mode THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,pr.mensaje('ABD',20264,'5.-INVALID_MODE'|| ' LINE NUMBER ==> '|| ncount,NULL,NULL));
	WHEN sys.UTL_FILE.internal_error THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,pr.mensaje('ABD',20264,'6.-INTERNAL_ERROR'|| ' LINE NUMBER ==> '|| ncount,NULL,NULL));
	WHEN OTHERS THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,pr.mensaje('ABD',20264,'7.-'|| SQLERRM|| ' LINE NUMBER ==> '|| ncount,NULL,NULL));
	END;
	--
	PROCEDURE PULL_PUSH_FILE(ccodigo VARCHAR2,cdirecarc VARCHAR2,ccampos VARCHAR2,cdatos VARCHAR2)
	IS
		carq 			SYS.UTL_FILE.file_type;
		n_cursor 		INTEGER;
		n_cursor1		INTEGER;
		n_dummy 		INTEGER;
		n_dummy1 		INTEGER;
		cresultado 		VARCHAR(300);
		dummy 			NUMBER;
		nexiste 		NUMBER := 0;
		ndecimales 		NUMBER(10);
		cnomtabela 		VARCHAR2(30);
		carchivo 		VARCHAR2(100);
		cdirectorio 	VARCHAR2(100);
		cformula		VARCHAR2(200);
		ctemvar 		VARCHAR2(200);
		clinea 			VARCHAR2(5000);
		clineaWHERE		VARCHAR2(5000);
		clineatexto 	VARCHAR2(5000);
		clineaoutcampo	VARCHAR2(5000);
		clineaoutvalor	VARCHAR2(5000);
		c_expresionint1 VARCHAR2(5000) := NULL;
		c_expresionint 	VARCHAR2(5000) := NULL;
		ncount 			NUMBER(10) := 1;
		ncounp 			NUMBER(10) := 1;
		ccodproc 		VARCHAR2(6);
		ncodprov 		NUMBER(6);
		--
		cchg_fmt		VARCHAR2(1) := 'Y';
		cval_fecha 		VARCHAR2(1) := 'Y';
		v_outfile		UTL_FILE.file_type;
		nm_directory	VARCHAR2(50);
		v_str_file		VARCHAR2(5100);
		nlongreg		NUMBER(6);
		c_msg_rechazo	VARCHAR2(60);
		ncounr 			NUMBER(10) := 0;
		nposicion		NUMBER(4) := 0;
		ccampo 			VARCHAR2(30);
		--
		sentencia_sql 		VARCHAR2(4000);
		c_error_registro	NUMBER(1) := 0;
		nexiste_t 			NUMBER(1) := 0;
		clval				VARCHAR2(400);
		cstsreg				VARCHAR2(3);
		--
		CURSOR layout_tipo_c
		IS
		SELECT nomtabela,condicao
		FROM layout_tabela
		WHERE codigo = ccodigo;
		--
		CURSOR layout_imp_c
		IS
		SELECT
			campo,posicion,longitud,tipo,tipocampo,decimales,nomtabela,valordefault,NVL(indpk,'N') indpk,formula
		FROM layout_imp
		WHERE codigo = ccodigo
		AND nomtabela = cnomtabela;
		--
	BEGIN	 
		cdirectorio := SUBSTR(cdirecarc,1,INSTR(cdirecarc,'/',-1) - 1);
		carchivo := SUBSTR(cdirecarc,INSTR(cdirecarc,'/',-1) + 1,LENGTH(cdirecarc));
		ncodprov := SUBSTR(carchivo,1,1);
		carchivo := SUBSTR(cArchivo,2);
		--
		IF SUBSTR(carchivo,2,2) = 'AS' THEN
			ccodproc := 'CAP';
		ELSIF SUBSTR(carchivo,2,2) = 'CA' THEN
			ccodproc := 'ANP';
		ELSIF SUBSTR(carchivo,2,2) = 'BE' THEN
			ccodproc := 'CBP';
		ELSIF SUBSTR(carchivo,2,2) = 'CO' THEN
			ccodproc := 'CDP';
		ELSIF SUBSTR(carchivo,2,2) = 'IN' THEN
			ccodproc := 'ICE';
		ELSIF SUBSTR(carchivo,2,2) = 'MO' THEN
			ccodproc := 'MOP';
		ELSIF SUBSTR(carchivo,2,2) = 'RO' THEN
			ccodproc := 'ROB';
		ELSIF SUBSTR(carchivo,2,2) = 'TE' THEN
			ccodproc := 'TRR';
		END IF;
		--
		BEGIN
			INSERT INTO banca_seguro_hist(
				codprov,codproc,fecproc,archivo,reg_leido,reg_proce,reg_recha,stsproc,fecini,fecfin
			)
			VALUES(ncodprov,ccodproc,TRUNC(SYSDATE),SUBSTR(carchivo,2),NULL,NULL,NULL,'INI',SYSDATE,NULL);
		END;
		--
		BEGIN
			UTL_FILE.fclose_all;
			BEGIN
				SELECT rutasal INTO nm_directory
				FROM banca_seguro_prov
				WHERE codprov = ncodprov
				AND codproc = ccodproc;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				nm_directory := 'DIRECTORIO_BANCASEG_OUT';
			WHEN OTHERS THEN
				nm_directory := 'DIRECTORIO_BANCASEG_OUT';
			END;
			--
			v_outfile := sys.UTL_FILE.fopen(nm_directory,carchivo,'w',32767);
		END;
		--
		carq := sys.UTL_FILE.fopen(cdirectorio,carchivo,'r');
		sys.UTL_FILE.get_line(carq,clinea);
		n_cursor := DBMS_SQL.open_cursor;
		--
		WHILE TRIM(clinea) IS NOT NULL
		LOOP
			FOR y IN layout_tipo_c
			LOOP
				cnomtabela := RTRIM(y.nomtabela);
				BEGIN
					SELECT MAX(posicion + longitud) INTO nlongreg
					FROM layout_imp
					WHERE codigo = ccodigo
					AND nomtabela = cnomtabela;
				EXCEPTION WHEN NO_DATA_FOUND THEN
					nlongreg := 1;
				WHEN OTHERS THEN
					nlongreg := 1;
				END;
				--
				FOR x IN layout_imp_c
				LOOP
					clineaoutcampo := clineaoutcampo || x.campo || ',';
					--
					IF x.longitud <> 0 THEN
						clineatexto := SUBSTR(clinea,x.posicion,x.longitud);
						--
						IF x.tipocampo = 'DATE' AND cval_fecha != 'N' THEN
							cval_fecha := pr_banseg.valida_fecha(clineatexto);
							nposicion := x.posicion;
							ccampo := x.campo;
							cchg_fmt := 'Y';
							--
							IF clineatexto = '00000000' THEN
								clineatexto := NULL;
								cchg_fmt := 'N';
								clineatexto := CHR(39) || RTRIM(LTRIM(clineatexto)) || CHR(39) || ',';cval_fecha := 'Y';
							END IF;
							--
							IF cchg_fmt = 'Y' THEN
								clineatexto := 
									'TO_DATE(' || CHR(39) || SUBSTR(clineatexto,1,2) || '/' || 
									SUBSTR(clineatexto,3,2) || '/' || SUBSTR(clineatexto,5,4) ||
									CHR(39) || ',' || CHR(39) || 'DD/MM/RRRR' || CHR(39) || '),';
							END IF;
						ELSIF x.tipocampo = 'NUMBER' THEN
							ndecimales := 10 * x.decimales;
							clineatexto := 'TO_NUMBER(LTRIM('|| CHR(39)|| clineatexto|| CHR(39)|| '))/'|| TO_CHAR(ndecimales)|| ',';
						ELSE
							clineatexto := CHR(39) || RTRIM(LTRIM((REPLACE(clineatexto,CHR(39),' ')))) || CHR(39) || ',';
						END IF;
						--
						IF x.formula IS NOT NULL THEN
							n_cursor1 := DBMS_SQL.open_cursor;
							ctemvar :=REPLACE( RTRIM(x.formula),'',SUBSTR(clineatexto,1,LENGTH(clineatexto) - 1));
							c_expresionint1 :=('BEGIN ' || ctemvar || '; END;');
							DBMS_SQL.parse(n_cursor1,c_expresionint1,DBMS_SQL.native);
							DBMS_SQL.bind_variable(n_cursor1,'cResultado',' ');
							--
							n_dummy1 := DBMS_SQL.execute(n_cursor1);
							DBMS_SQL.variable_value(n_cursor1,'cResultado',cresultado);
							DBMS_SQL.close_cursor(n_cursor1);
							--
							clineatexto := CHR(39)|| RTRIM(LTRIM(cresultado))|| CHR(39)|| ',';
						END IF;
					ELSE
						IF x.tipo = 'S' THE
							IF x.formula IS NOT NULL THEN
								DBMS_OUTPUT.put_line('X.Tipo ' || x.tipo || ' X.Formula ' || x.formula);
								n_cursor1 := DBMS_SQL.open_cursor;
								cTemVar := ':cResultado := '||RTRIM(X.Formula);ctemvar := RTRIM(x.formula);
								c_expresionint1 :=('BEGIN ' || ctemvar || '; END;');
								DBMS_SQL.parse(n_cursor1,c_expresionint1,DBMS_SQL.native);
								DBMS_SQL.bind_variable( n_cursor1,'cResultado',' ');
								DBMS_OUTPUT.put_line(c_expresionint1);
								n_dummy1 := DBMS_SQL.execute(n_cursor1);
								DBMS_SQL.variable_value(n_cursor1,'cResultado',cresultado);
								DBMS_SQL.close_cursor(n_cursor1);
								clineatexto := CHR(39) || RTRIM(LTRIM(cresultado)) || CHR(39) || ',';
							END IF;
						ELSE
							clineatexto := CHR(39)|| RTRIM(LTRIM(x.valordefault))|| CHR(39)|| ',';
						END IF;
					END IF;
					--
					clineaoutvalor := clineaoutvalor || clineatexto;
					--
					IF x.indpk = 'S' THEN
						clineaWHERE :=
							clineaWHERE || ' ' || x.campo || ' = ' ||
							SUBSTR(clineatexto,1,LENGTH(clineatexto) - 1) || ' AND ';
					END IF;
				END LOOP;
				--
				IF y.condicao IS NOT NULL THEN
					clineaWHERE := clineaWHERE || y.condicao || ' AND ';
				END IF;
				--
				clineaWHERE := SUBSTR(clineaWHERE,1,LENGTH(clineaWHERE) - 4);
				clineaoutcampo := SUBSTR(clineaoutcampo,1,LENGTH(clineaoutcampo) - 1);
				clineaoutvalor := SUBSTR(clineaoutvalor,1,LENGTH(clineaoutvalor) - 1);
				--
				IF pr.existe(cnomtabela,clineaWHERE) <> 0 THEN
					nexiste := pr.existe(cnomtabela,clineaWHERE);
				END IF;
				--
				IF cval_fecha = 'N' THEN
					c_msg_rechazo := 'Fecha Invalida';
					v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
					sys.UTL_FILE.put_line(v_outfile,v_str_file);
					COMMIT;
					--
					ncounr := ncounr + 1;
				END IF;
				--
				IF nexiste = 0 AND cval_fecha = 'Y' THEN
					IF ccampos IS NOT NULL AND cdatos IS NOT NULL THEN
						c_expresionint :=
							'INSERT INTO ' || cnomtabela || '(' || ccampos || ',' || 
							clineaoutcampo || ') VALUES(' || cdatos || ',' || clineaoutvalor || ')';
					ELSE
						c_expresionint :=
							'INSERT INTO ' || cnomtabela || '(' || clineaoutcampo || ') VALUES(' || clineaoutvalor || ')';
					END IF;
					--
					DBMS_SQL.parse(n_cursor,c_expresionint,DBMS_SQL.native);
					n_dummy := DBMS_SQL.execute(n_cursor);
					COMMIT;
					--
					BEGIN
						c_error_registro := 0;
						--
						IF cnomtabela = 'BANCA_SEGURO' THEN
							FOR val IN (
								SELECT * FROM banca_seguro bb
								WHERE bb.numreg IS NULL
								AND bb.codproveedor IS NULL
								AND bb.fecproceso IS NULL
								AND NVL(bb.indicador,'N') = 'N'
								AND NVL(bb.stsreg,'INC') = 'INC'
							)
							LOOP
								BEGIN
									DBMS_OUTPUT.put_line('Valida Producto');
									SELECT 1 INTO nexiste_t
									FROM producto p
									WHERE p.codprod = val.codprod;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									DBMS_OUTPUT.put_line('Error al Validar el Producto:' || val.codprod);
									c_error_registro := 1;
									c_msg_rechazo := 'No existe el producto ';
									ccampo := 'CODPROD';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Oficina Emisora:' || val.codofiemi);
									SELECT 1 INTO nexiste_t
									FROM oficina oc
									WHERE oc.codofi = val.codofiemi;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									c_error_registro := 1;
									c_msg_rechazo := 'oficina Emisora no EXISTE ';
									ccampo := 'CODOFIEMI';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Forma de Pago:' || val.codformpago);
									clval := pr.busca_lval('FORMPAGO',val.codformpago);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Error en la Forma de Pago';
										ccampo := 'CODFORMPAGO';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Clase de Cliente /CLASECLI' || val.clasecli);
									IF val.clasecli NOT IN('ASE','TOM') THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Error en la Clase de Cliente(ASE/TOM)';
										ccampo := 'CLASECLI';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Sexo' || val.sexo);
									--
									IF val.sexo NOT IN('F','M') THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Error en el Sexo(F/M)';
										ccampo := 'SEXO';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Estado Civil:' || val.edocivil);
									clval := pr.busca_lval('EDOCIVIL',val.edocivil);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Error en el Estado Civil';
										ccampo := 'EDOCIVIL';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Codigo de La Profesion o Actividad Realizada:'	 || val.codact);
									clval := pr.busca_lval('CODACT',val.codact);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Error en el Codigo de Actividad';
										ccampo := 'CODACT';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Ocupacion:' || val.codocupacion);
									--
									SELECT 1 INTO nexiste_t
									FROM tarifa_ocupacion_ap oc
									WHERE oc.codocupacion = val.codocupacion;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									c_error_registro := 1;
									c_msg_rechazo := 'Error Ocupacion Invalida ';
									ccampo := 'CODOCUPACION';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida TipoId:' || val.tipoid);
									clval := pr.busca_lval('TIPOID',val.tipoid);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Tipo de Identificacion Invalida';
										ccampo := 'TIPOID';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Pais:' || val.codpais);
									SELECT 1 INTO nexiste_t
									FROM pais
									WHERE codpais = val.codpais;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									nexiste_t := 0;
								WHEN TOO_MANY_ROWS THEN
									nexiste_t := 1;
								END;
								--
								IF nexiste_t = 0 THEN
									c_error_registro := 1;
									c_msg_rechazo := 'El Codigo del Pais no Existe';
									ccampo := 'CODPAIS';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END IF;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Estado:' || val.codpais || '-' || val.codestado);
									--
									SELECT 1 INTO nexiste_t
									FROM estado
									WHERE codpais = val.codpais
									AND codestado = val.codestado;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									nexiste_t := 0;
								WHEN TOO_MANY_ROWS THEN
									nexiste_t := 1;
								END;
								--
								IF nexiste_t = 0 THEN
									c_error_registro := 1;
									c_msg_rechazo := 'El Codigo del Pais_Estado no Existe';
									ccampo := 'CODESTADO';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END IF;
								--
								BEGIN
									DBMS_OUTPUT.put_line(
										'Valida Ciudad: ' || val.codpais || '_' || val.codestado || '_' || val.codciudad
									);
									--
									SELECT 1 INTO nexiste_t
									FROM ciudad cd
									WHERE cd.codpais = val.codpais
									AND cd.codestado = val.codestado
									AND cd.codciudad = val.codciudad;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									nexiste_t := 0;
								WHEN TOO_MANY_ROWS THEN
									nexiste_t := 1;
								END;
								--
								IF nexiste_t = 0 THEN
									c_error_registro := 1;
									c_msg_rechazo := 'El Codigo del Pais_Estado_ciudad no Existe';
									ccampo := 'CODCIUDAD';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END IF;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Municipio:' || val.codmunicipio);
									SELECT 1 INTO nexiste_t
									FROM municipio m
									WHERE m.codpais = val.codpais
									AND m.codestado = val.codestado
									AND m.codciudad = val.codciudad
									AND m.codmunicipio = val.codmunicipio;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									nexiste_t := 0;
								WHEN TOO_MANY_ROWS THEN
									nexiste_t := 1;
								END;
								--
								IF nexiste_t = 0 THEN
									c_error_registro := 1;
									c_msg_rechazo := 'Pais_Estado_ciudad_Municipio no Existe';
									ccampo := 'CODMUNICIPIO';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END IF;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Parroquia:' || val.codparroquia);
									SELECT 1 INTO nexiste_t
									FROM parroquia pp
									WHERE pp.codpais = val.codpais
									AND pp.codestado = val.codestado
									AND pp.codciudad = val.codciudad
									AND pp.codmunicipio = val.codmunicipio
									AND pp.codparroquia = val.codparroquia;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									nexiste_t := 0;
								WHEN TOO_MANY_ROWS THEN
									nexiste_t := 1;
								END;
								--
								IF nexiste_t = 0 THEN
									c_error_registro := 1;
									c_msg_rechazo := 'Pais_Estado_ciudad_Municipio_parroquia Invalido';
									ccampo := 'CODPARROQUIA';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END IF;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Sector:' || val.codsector);
									SELECT 1 INTO nexiste_t
									FROM sector ss
									WHERE ss.codpais = val.codpais
									AND ss.codestado = val.codestado
									AND ss.codciudad = val.codciudad
									AND ss.codmunicipio = val.codmunicipio
									AND ss.codparroquia = val.codparroquia
									AND ss.codsector = val.codsector;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									nexiste_t := 0;
								WHEN TOO_MANY_ROWS THEN
									nexiste_t := 1;
								END;
								--
								IF nexiste_t = 0 THEN
									c_error_registro := 1;
									c_msg_rechazo := 'Pais_Estado_ciudad_Municipio_parroquia_sector Invalido';
									ccampo := 'CODSECTOR';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END IF;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Intermediario:' || val.codinter);
									SELECT 1 INTO nexiste_t
									FROM intermediario
									WHERE codinter = val.codinter;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									c_error_registro := 1;
									c_msg_rechazo := 'Intermediario Invalido';
									ccampo := 'CODINTER';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line(
										'Valida Plan y Revision:' || val.codprod || '_' || val.codplan || '_' || val.revplan
									);
									SELECT 1 INTO nexiste_t
									FROM plan_prod pp
									WHERE pp.codprod = val.codprod
									AND pp.codplan = val.codplan
									AND pp.revplan = val.revplan;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									c_error_registro := 1;
									c_msg_rechazo := 'Plan y Revision Invalido';
									ccampo := 'CODPLAN';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									IF val.numpol IS NULL OR val.numpol <= 0 THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Numero de POliza Invalido:';
										ccampo := 'NUMPOL';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida codmoneda:' || val.tipoid);
									clval := pr.busca_lval('TIPOMON',val.codmoneda);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Codigo de Moneda Invalida';
										ccampo := 'CODMONEDA';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Tipoter:' || val.tipoid);
									clval := pr.busca_lval('TIPOTER',val.tipoter);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Codigo de Tipo de Tercero Invalido';
										ccampo := 'TIPOTER';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Parentesco:' || val.codparent);
									clval := pr.busca_lval('PARENT',val.codparent);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Codigo de Parentesco Invalido';
										ccampo := 'CODPARENT';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Tipo de Zona:' || val.tipzona);
									clval := pr.busca_lval('TIPZONA',val.tipzona);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Codigo de Tipo de Zona Invalido';
										ccampo := 'TIPZONA';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Tipo de Via:' || val.tipvia);
									clval := pr.busca_lval('TIPVIA',val.tipvia);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Codigo de Tipo de Via Invalido';
										ccampo := 'TIPVIA';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Tipo de Habitacion' || val.tiphab);
									clval := pr.busca_lval('TIPHAB',val.tiphab);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Codigo de Tipo de Habitacion Invalido';
										ccampo := 'TIPHAB';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
							END LOOP;
						ELSIF cnomtabela = 'BANCA_SEGURO_BEN' THEN
							FOR val_benIN(
								SELECT * FROM banca_seguro_ben bb
								WHERE bb.numreg IS NULL
								AND bb.codproveedor IS NULL
								AND bb.fecproceso IS NULL
								AND NVL(bb.indicador,'N') = 'N'
								AND NVL(bb.stsreg,'INC') = 'INC'
							)
							LOOP
								BEGIN
									DBMS_OUTPUT.put_line('Valida Producto');
									SELECT 1 INTO nexiste_t
									FROM producto p
									WHERE p.codprod = val_ben.codprod;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									DBMS_OUTPUT.put_line('Error al Validar el Producto:' || val_ben.codprod);
									c_error_registro := 1;
									c_msg_rechazo := 'No existe el producto ';
									ccampo := 'CODPROD';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Oficina Emisora:' || val_ben.codofiemi);
									SELECT 1 INTO nexiste_t
									FROM oficina oc
									WHERE oc.codofi = val_ben.codofiemi;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									c_error_registro := 1;
									c_msg_rechazo := 'oficina Emisora no EXISTE ';
									ccampo := 'CODOFIEMI';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida TipoId:' || val_ben.tipoid);
									clval := pr.busca_lval('TIPOID',val_ben.tipoid);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Tipo de Identificacion Invalida';
										ccampo := 'TIPOID';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									IF val_ben.numpol IS NULL OR val_ben.numid <= 0 THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Numero de Identificacion Invalido:';
										ccampo := 'NUMID';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Tipoter:' || val_ben.tipoid);
									clval := pr.busca_lval('TIPOTER',val_ben.tipoter);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Codigo de Tipo de Tercero Invalido';
										ccampo := 'TIPOTER';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Parentesco:' || val_ben.codparent);
									clval := pr.busca_lval('PARENT',val_ben.codparent);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Codigo de Parentesco Invalido';
										ccampo := 'CODPARENT';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Pais:' || val_ben.codpais);
									SELECT 1 INTO nexiste_t
									FROM pais
									WHERE codpais = val_ben.codpais;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									nexiste_t := 0;
								WHEN TOO_MANY_ROWS THEN
									nexiste_t := 1;
								END;
								--
								IF nexiste_t = 0 THEN
									c_error_registro := 1;
									c_msg_rechazo := 'El Codigo del Pais no Existe';
									ccampo := 'CODPAIS';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END IF;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Estado:' || val_ben.codpais || '-' || val_ben.codestado);
									SELECT 1 INTO nexiste_t
									FROM estado
									WHERE codpais = val_ben.codpais
									AND codestado = val_ben.codestado;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									nexiste_t := 0;
								WHEN TOO_MANY_ROWS THEN
									nexiste_t := 1;
								END;
								--
								IF nexiste_t = 0 THEN
									c_error_registro := 1;
									c_msg_rechazo := 'El Codigo del Pais_Estado no Existe';
									ccampo := 'CODESTADO';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END IF;
								--
								BEGIN
									DBMS_OUTPUT.put_line(
										'Valida Ciudad: ' || val_ben.codpais || '_' || val_ben.codestado || '_' || val_ben.codciudad
									);
									SELECT 1 INTO nexiste_t
									FROM ciudad cd
									WHERE cd.codpais = val_ben.codpais
									AND cd.codestado = val_ben.codestado
									AND cd.codciudad = val_ben.codciudad;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									nexiste_t := 0;
								WHEN TOO_MANY_ROWS THEN
									nexiste_t := 1;
								END;
								--
								IF nexiste_t = 0 THEN
									c_error_registro := 1;
									c_msg_rechazo := 'El Codigo del Pais_Estado_ciudad no Existe';
									ccampo := 'CODCIUDAD';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END IF;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Municipio:' || val_ben.codmunicipio);
									--
									SELECT 1 INTO nexiste_t
									FROM municipio m
									WHERE m.codpais = val_ben.codpais
									AND m.codestado = val_ben.codestado
									AND m.codciudad = val_ben.codciudad
									AND m.codmunicipio = val_ben.codmunicipio;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									nexiste_t := 0;
								WHEN TOO_MANY_ROWS THEN
									nexiste_t := 1;
								END;
								--
								IF nexiste_t = 0 THEN
									c_error_registro := 1;
									c_msg_rechazo := 'Pais_Estado_ciudad_Municipio no Existe';
									ccampo := 'CODMUNICIPIO';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END IF;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Parroquia:' || val_ben.codparroquia);
									SELECT 1 INTO nexiste_t
									FROM parroquia pp
									WHERE pp.codpais = val_ben.codpais
									AND pp.codestado = val_ben.codestado
									AND pp.codciudad = val_ben.codciudad
									AND pp.codmunicipio = val_ben.codmunicipio
									AND pp.codparroquia = val_ben.codparroquia;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									nexiste_t := 0;
								WHEN TOO_MANY_ROWS THEN
									nexiste_t := 1;
								END;
								--
								IF nexiste_t = 0 THEN
									c_error_registro := 1;
									c_msg_rechazo := 'Pais_Estado_ciudad_Municipio_parroquia Invalido';
									ccampo := 'CODPARROQUIA';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END IF;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Sector:' || val_ben.codsector);
									SELECT 1 INTO nexiste_t
									FROM sector ss
									WHERE ss.codpais = val_ben.codpais
									AND ss.codestado = val_ben.codestado
									AND ss.codciudad = val_ben.codciudad
									AND ss.codmunicipio = val_ben.codmunicipio
									AND ss.codparroquia = val_ben.codparroquia
									AND ss.codsector = val_ben.codsector;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									nexiste_t := 0;
								WHEN TOO_MANY_ROWS THEN
									nexiste_t := 1;
								END;
								--
								IF nexiste_t = 0 THEN
									c_error_registro := 1;
									c_msg_rechazo := 'Pais_Estado_ciudad_Municipio_parroquia_sector Invalido';
									ccampo := 'CODSECTOR';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END IF;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Tipo de Zona:' || val_ben.tipzona);
									clval := pr.busca_lval('TIPZONA',val_ben.tipzona);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Codigo de Tipo de Zona Invalido';
										ccampo := 'TIPZONA';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Tipo de Via:' || val_ben.tipvia);
									clval := pr.busca_lval('TIPVIA',val_ben.tipvia);
									--									
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Codigo de Tipo de Via Invalido';
										ccampo := 'TIPVIA';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Tipo de Habitacion' || val_ben.tiphab);
									clval := pr.busca_lval('TIPHAB',val_ben.tiphab);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Codigo de Tipo de Habitacion Invalido';
										ccampo := 'TIPHAB';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
							END LOOP;
						ELSIF cnomtabela = 'BANCA_SEGURO_COB_DEV' THEN
							FOR val_cobIN(
								SELECT * FROM banca_seguro_cob_dev cc
								WHERE cc.numreg IS NULL
								AND cc.codproveedor IS NULL
								AND cc.fecproceso IS NULL
								AND NVL(cc.indicador,'N') = 'N'
								AND NVL(cc.stsreg,'INC') = 'INC'
							)
							LOOP
								BEGIN
									DBMS_OUTPUT.put_line('Valida TipoId:' || val_cob.tipoid);
									clval := pr.busca_lval('TIPOID',val_cob.tipoid);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Tipo de Identificacion Invalida';
										ccampo := 'TIPOID';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Producto');
									SELECT 1 INTO nexiste_t
									FROM producto p
									WHERE p.codprod = val_cob.codprod;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									DBMS_OUTPUT.put_line('Error al Validar el Producto:' || val_cob.codprod);
									c_error_registro := 1;
									c_msg_rechazo := 'Producto Invalido ';
									ccampo := 'CODPROD';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Oficina Emisora:' || val_cob.codofiemi);
									--
									SELECT 1 INTO nexiste_t
									FROM oficina oc
									WHERE oc.codofi = val_cob.codofiemi;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									c_error_registro := 1;
									c_msg_rechazo := 'oficina Emisora Invalida ';
									ccampo := 'CODOFIEMI';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida TIPOID y NUMID:' || val_cob.tipoid || '-' || val_cob.numid);
									SELECT 1 INTO nexiste_t
									FROM tercero tt
									WHERE tt.tipoid = val_cob.tipoid
									AND tt.numid = val_cob.numid;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									c_error_registro := 1;
									c_msg_rechazo := 'Tipo y Numero de Identificacion Invalido ';
									ccampo := 'NUMID';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Poliza');
									SELECT 1 INTO nexiste_t FROM poliza p
									WHERE p.codprod = val_cob.codprod
									AND p.codofiemi = val_cob.codofiemi
									AND p.numpol = val_cob.numpol
									UNION
									SELECT 1 FROM banca_seguro p
									WHERE p.codprod = val_cob.codprod
									AND p.codofiemi = val_cob.codofiemi
									AND p.numpol = val_cob.numpol;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									c_error_registro := 1;
									c_msg_rechazo := 'No existe la Poliza ';
									ccampo := 'NUMPOL';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Producto plan y revision ');
									SELECT 1 INTO nexiste_t
									FROM plan_prod p
									WHERE p.codprod = val_cob.codprod
									AND p.codplan = val_cob.codplan
									AND p.revplan = val_cob.revplan;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									DBMS_OUTPUT.put_line(
										'Error al Validar el Producto:' || val_cob.codprod || 
										'-' || val_cob.codplan || '-' || val_cob.revplan
									);
									c_error_registro := 1;
									c_msg_rechazo := 'Producto Plan y Revision Invalido ';
									ccampo := 'CODPLAN';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Validacion tipo de documento ingreso TIPODOCING:'	 || val_cob.tipodocing);
									IF val_cob.tipodocing NOT IN('COB','DEV') THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Tipo de Documento Ingreso Invalido:(COB/DEV) ';
										ccampo := 'TIPODOCING';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
							END LOOP;
							--
						ELSIF cnomtabela = 'BANCA_SEGURO_ANU' THEN
							FOR val_anuIN(
								SELECT * FROM banca_seguro_anu bb
								WHERE bb.numreg IS NULL
								AND bb.codproveedor IS NULL
								AND bb.fecproceso IS NULL
								AND NVL(bb.indicador,'N') = 'N'
								AND NVL(bb.stsreg,'INC') = 'INC'
							)
							LOOP
								BEGIN
									DBMS_OUTPUT.put_line('Valida Producto');
									SELECT 1 INTO nexiste_t FROM producto p
									WHERE p.codprod = val_anu.codprod;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									DBMS_OUTPUT.put_line('Error al Validar el Producto:'|| val_anu.codprod);
									c_error_registro := 1;
									c_msg_rechazo := 'No existe el producto ';
									ccampo := 'CODPROD';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Oficina Emisora:' || val_anu.codofiemi);
									SELECT 1 INTO nexiste_t
									FROM oficina oc
									WHERE oc.codofi = val_anu.codofiemi;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									c_error_registro := 1;
									c_msg_rechazo := 'oficina Emisora no EXISTE ';
									ccampo := 'CODOFIEMI';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Poliza');
									SELECT 1 INTO nexiste_t FROM poliza p
									WHERE p.codprod = val_anu.codprod
									AND p.codofiemi = val_anu.codofiemi
									AND p.numpol = val_anu.numpol;
								EXCEPTION WHEN NO_DATA_FOUND THEN
									DBMS_OUTPUT.put_line('Error al Validar la Poliza:' || val_anu.numpol);
									c_error_registro := 1;
									c_msg_rechazo := 'No existe la Poliza ';
									ccampo := 'NUMPOL';
									nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
									v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
									sys.UTL_FILE.put_line(v_outfile,v_str_file);
									COMMIT;
								END;
								--
								BEGIN
									DBMS_OUTPUT.put_line('Valida Motivo de Anulacion ' || val_anu.codmotvanul);
									clval := pr.busca_lval('MOTVANUL',val_anu.codmotvanul);
									--
									IF clval = 'INVALIDO' THEN
										c_error_registro := 1;
										c_msg_rechazo := 'Codigo de Motivo de Anulacion Invalido';
										ccampo := 'CODMOTVANUL';
										nposicion := pr_banseg.find_posicion(ccodigo,cnomtabela,ccampo);
										v_str_file := pr_banseg.srt_fmt_msg(clinea,nlongreg,c_msg_rechazo,ncount,nposicion,ccampo);
										sys.UTL_FILE.put_line(v_outfile,v_str_file);
										COMMIT;
									END IF;
								END;
							END LOOP;
						END IF;
						--
						IF c_error_registro = 1 THEN
							cstsreg := 'REC';
							ncounr := ncounr + 1;
						ELSE
							cstsreg := 'VAL';
						END IF;
						--
						DBMS_OUTPUT.put_line('actualiza record: ' || ncounp || ' de la tabla:' || cnomtabela);
						sentencia_sql :=
							'UPDATE ' || cnomtabela || ' SET codproveedor=' || ncodprov ||
							',archivo=' || CHR(39) || SUBSTR(carchivo,2) || CHR(39) ||
							',numreg=' || ncounp || ',indicador=' || CHR(39) || 'N' ||
							CHR(39) || ',stsreg=' || CHR(39) || cstsreg || CHR(39) ||
							',fecproceso=' || CHR(39) || TO_DATE(TRUNC(SYSDATE)) ||
							CHR(39) || ' WHERE codproveedor IS NULL AND' ||
							' archivo is null AND indicador is null AND fecproceso is null';
						pr_banseg.UPDATE_RECORD(sentencia_sql);
						COMMIT;
					END;
				END IF;
				--
				clineaoutcampo := NULL;
				clineaoutvalor := NULL;
				clineaWHERE := NULL;
				cval_fecha := 'Y';
				--
				IF cnomtabela = 'BANCA_SEGURO' THEN
					UPDATE BANCA_SEGURO
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_BEN' THEN
					UPDATE BANCA_SEGURO_BEN
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_ANU' THEN
					UPDATE BANCA_SEGURO_ANU
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_COB_DEV' THEN
					UPDATE BANCA_SEGURO_COB_DEV
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_MOD' THEN
					UPDATE BANCA_SEGURO_MOD
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_DP_INCE' THEN
					UPDATE BANCA_SEGURO_DP_INCE
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_DP_ROBO' THEN
					UPDATE BANCA_SEGURO_DP_ROBO
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				ELSIF cnomtabela = 'BANCA_SEGURO_DP_TERRE' THEN
					UPDATE BANCA_SEGURO_DP_TERRE
					SET CODPROVEEDOR = ncodprov,
						archivo = SUBSTR(cArchivo,2)
					WHERE CODPROVEEDOR is null
					AND archivo is null
					AND INDICADOR is null
					AND FECPROCESO is null;
				END IF;
				--
				ncounp := ncounp + 1;
			END LOOP;
			--
			BEGIN
				UTL_FILE.get_line(carq,clinea);
			EXCEPTION WHEN NO_DATA_FOUND THEN
				EXIT;
			END;
			--
			ncount := ncount + 1;
			COMMIT;
			--
			DBMS_OUTPUT.put_line('Value of nCount = nCount ' || ncount);
			--
			UPDATE banca_seguro_hist
			SET reg_leido = ncount,
				reg_recha = ncounr
			WHERE codprov = ncodprov
			AND archivo = SUBSTR(carchivo,2)
			AND codproc = ccodproc;
		END LOOP;
		--
		DBMS_SQL.close_cursor(n_cursor);
		sys.UTL_FILE.fclose(carq);
		sys.UTL_FILE.fclose(v_outfile);
		--
		UPDATE banca_seguro_hist
		SET reg_leido = ncount - 1,
			stsproc = 'FIN',
			fecfin = SYSDATE
		WHERE codprov = ncodprov
		AND archivo = SUBSTR(carchivo,2)
		AND codproc = ccodproc;
	EXCEPTION WHEN sys.UTL_FILE.invalid_filehANDle THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,
			pr.mensaje('ABD',20264,'1.-INVALID_FILEHANDLE'||' LINE NUMBER ==> '||ncount,NULL,NULL)
		);
	WHEN sys.UTL_FILE.read_error THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,pr.mensaje('ABD',20264,'2.-READ_ERROR'||' LINE NUMBER ==> '||ncount,NULL,NULL));
	WHEN sys.UTL_FILE.invalid_operation THEN
		sys.UTL_FILE.fclose(carq);
		--
		UPDATE banca_seguro_hist
		SET stsproc = 'NFF',
			fecfin = SYSDATE
		WHERE codprov = ncodprov
		AND archivo = SUBSTR(carchivo,2)
		AND codproc = ccodproc;
		--
		raise_application_error(-20264,
			pr.mensaje(
				'ABD',20264,cnomtabela||'-'|| ncount||'3.-INVALID_OPERATION'||
				' LINE NUMBER ==> '||ncount||' SQLERROR: '||SQLERRM,NULL,NULL
			)
		);
	WHEN sys.UTL_FILE.invalid_path THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,
			pr.mensaje('ABD',20264,'4.-INVALID_PATH' || ' LINE NUMBER ==> ' || ncount,NULL,NULL)
		);
	WHEN sys.UTL_FILE.invalid_mode THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,
			pr.mensaje('ABD',20264,'5.-INVALID_MODE'|| ' LINE NUMBER ==> '|| ncount,NULL,NULL)
		);
	WHEN sys.UTL_FILE.internal_error THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,
			pr.mensaje('ABD',20264,'6.-INTERNAL_ERROR'|| ' LINE NUMBER ==> '|| ncount,NULL,NULL)
		);
	WHEN UTL_FILE.charSETmismatch THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,
			pr.mensaje('ABD',-20058,'6.1-Opened With FOPEN_NCHAR But Later I/O Inconsistent'||' LINE NUMBER ==> '||ncount,NULL,NULL)
		);
	WHEN UTL_FILE.file_open THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,
			pr.mensaje('ABD',-20059,'6.2-File Already Opened'|| ' LINE NUMBER ==> '|| ncount,NULL,NULL)
		);
	WHEN UTL_FILE.invalid_maxlinesize THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,
			pr.mensaje('ABD',-20060,'6.3-Line Size Exceeds 32K '|| ' LINE NUMBER ==> '|| ncount,NULL,NULL)
		);
	WHEN UTL_FILE.invalid_filename THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,
			pr.mensaje('ABD',-20061,'6.4-Invalid File Name '|| ' LINE NUMBER ==> '|| ncount,NULL,NULL)
		);
	WHEN UTL_FILE.access_denied THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20264,
			pr.mensaje('ABD',-20061,'6.5-File Access Denied By '|| ' LINE NUMBER ==> '|| ncount,NULL,NULL)
		);
	WHEN UTL_FILE.invalid_offSET THEN
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20265,
			pr.mensaje('ABD',-20061,'6.6- FSEEK Param Less Than 0 '|| ' LINE NUMBER ==> '|| ncount,NULL,NULL)
		);
	WHEN OTHERS THEN
		sys.UTL_FILE.fclose(carq);
		--
		UPDATE banca_seguro_hist
		SET stsproc = 'FCD',
			fecfin = SYSDATE
		WHERE codprov = ncodprov
		AND archivo = SUBSTR(carchivo,2)
		AND codproc = ccodproc;
		--
		sys.UTL_FILE.fclose(carq);
		raise_application_error(-20299,
			pr.mensaje('ABD',20264,'7.-Unknown utl_file error )'||	' LINE NUMBER ==> '	|| ncount,NULL,NULL	)
		);
	END PULL_PUSH_FILE;
	--
	PROCEDURE crear_benefi(ncodprov NUMBER,carchivo VARCHAR2)
	IS
		ccodplan 		ramo_plan_prod.codplan%TYPE;
		crevplan 		ramo_plan_prod.revplan%TYPE;
		cindben 		ramo_plan_prod.indben%TYPE;
		cindbenaseg 	ramo_plan_prod.indbenaseg%TYPE;
		nidepol 		poliza.idepol%TYPE;
		nideaseg 		asegurado.ideaseg%TYPE;
		ccodproc 		VARCHAR2(3);
		ccoderror 		VARCHAR2(20) := NULL;
		cmensaje_sql 	VARCHAR2(4000) := NULL;
		creferencia 	VARCHAR2(200) := NULL;
		nnumben			NUMBER(2) := 0;
		ncount 			NUMBER(5) := 0;
		ncountr 		NUMBER(5) := 0;
		dfechaproceso 	DATE;
		--
		CURSOR beneficiario
		IS
		SELECT 
			codprod,codofiemi,numpol,tipoid,numid,fecnac,codparent,nomter,apeter,fecing,porcpart,
			tipoter,codpais,codestado,codciudad,codmunicipio,codparroquia,codsector,direc,rif,nit,
			website,codtelofi,telofi,codtelhab,telhab,codtelfax,telfax,codtelcel,telcel,tipzona,
			desczona,tipvia,descvia,tiphab,deschab,nrotorre,piso,nroapto,codproveedor,archivo
		FROM banca_seguro_ben
		WHERE NVL(indicador,'N') = 'N'
		AND codproveedor = NVL(ncodprov,codproveedor)
		AND archivo = NVL(carchivo,archivo);
		--
		CURSOR cert_ramo_bs
		IS
		SELECT codramocert
		FROM cert_ramo
		WHERE idepol = nidepol
		AND numcert = 1;
	BEGIN
		pr_banseg.crear_tercero_ben;
		--
		FOR ben IN beneficiario
		LOOP
			nnumben := 0;
			--
			BEGIN
				SELECT idepol INTO nidepol
				FROM poliza
				WHERE codprod = ben.codprod
				AND codofiemi = ben.codofiemi
				AND numpol = ben.numpol;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				RAISE_APPLICATION_ERROR(-20100,'NO SE HA CREADO LA POLIZA:'||BEN.CodProd||'-'||BEN.CodOfiEmi||'-'||BEN.Numpol);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || ben.codprod || '-' || ben.codofiemi || '-' || ben.numpol || ':No EXISTE';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'POLIZA','CARGA-B',cmensaje_sql,'CREAR_BENEFI',creferencia,
					dfechaproceso,ben.codprod,ben.codproveedor,ben.archivo
				);
			END;
			--
			FOR cpp IN cert_ramo_bs
			LOOP
				BEGIN
					SELECT codplan,revplan INTO ccodplan,crevplan
					FROM cert_ramo
					WHERE idepol = nidepol
					AND codramocert = cpp.codramocert;
				END;
				--
				BEGIN
					SELECT ideaseg INTO nideaseg
					FROM asegurado
					WHERE idepol = nidepol
					AND indasegtitular = 'S'
					AND codramocert = cpp.codramocert;
				EXCEPTION WHEN NO_DATA_FOUND THEN
					RAISE_APPLICATION_ERROR(-20100,'NO existe el Asegurado'||SQLERRM);
					cmensaje_sql := SQLERRM;
					creferencia :=
						'La Poliza con el Numero:' || ben.codprod || '-' || ben.codofiemi || '-' || ben.numpol ||
						':NO existe el Asegurado' || 'Idepol:' || nidepol || 'Ideaseg:' || nideaseg;
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'ASEGURADO','CARGA-P',cmensaje_sql,'CREAR_POLIZA',creferencia,
						dfechaproceso,ben.codprod,ben.codproveedor,ben.archivo
					);
				END;
				--
				BEGIN
					SELECT numben INTO nnumbe
					FROM benef_cert
					WHERE idepol = nidepol
					AND codramocert = cpp.codramocert
					UNION
					SELECT numben
					FROM beneficiario
					WHERE idepol = nidepol
					AND codramocert = cpp.codramocert
					AND ideaseg = nideaseg;
				EXCEPTION WHEN NO_DATA_FOUND THEN
					nnumben := 0;
				END;
				--
				BEGIN
					SELECT NVL(indben,'S'),NVL(indbenaseg,'S') INTO cindben,cindbenaseg
					FROM ramo_plan_prod
					WHERE codprod = ben.codprod
					AND codramoplan = cpp.codramocert
					AND codplan = ccodplan
					AND revplan = crevplan;
				EXCEPTION WHEN NO_DATA_FOUND THEN
					cindben := 'N';
					cindbenaseg := 'N';
				END;
				--
				IF cindben = 'S' OR cindbenaseg = 'S' THEN
					nnumben := nnumben + 1;
					--
					IF cindben = 'S' THEN
						BEGIN
							INSERT INTO benef_cert(
								idepol,numcert,codramocert,tipoid,numid,dvid,
								numben,stsben,codparent,porcpart,fecnac,fecing
							)
							VALUES(
								nidepol,1,cpp.codramocert,ben.tipoid,ben.numid,0,nnumben,
								'ACT',ben.codparent,ben.porcpart,ben.fecnac,ben.fecing
							);
							--
							ncount := ncount + 1;
						EXCEPTION WHEN OTHERS THEN
							RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla BENEF_CERT'||SQLERRM);
							cmensaje_sql := SQLERRM;
							creferencia := 
								'La Poliza con el Numero:' || ben.codprod || '-' || ben.codofiemi || '-' || ben.numpol ||
								':Fallo en el Insert,' || 'Idepol:' || nidepol || ',Ideaseg:' || nideaseg;
							dfechaproceso := SYSDATE;
							ncountr := ncountr + 1;
							pr_banseg.graba_errores(
								'BENEF_CERT','CARGA-B',cmensaje_sql,'CREAR_BENEFI',creferencia,
								dfechaproceso,ben.codprod,ben.codproveedor,ben.archivo
							);
						END;
					ELSE
						BEGIN
							INSERT INTO beneficiario(
								idepol,numcert,codramocert,ideaseg,tipoid,numid,dvid,
								numben,tipoben,stsben,codparent,porcpart,fecnac,fecing
							)
							VALUES(
								nidepol,1,cpp.codramocert,nideaseg,ben.tipoid,ben.numid,0,nnumben,
								'B','ACT',ben.codparent,ben.porcpart,ben.fecnac,ben.fecing
							);
							ncount := ncount + 1;
						EXCEPTION WHEN OTHERS THEN
							RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla BENEFICIARIO'||SQLERRM);
							cmensaje_sql := SQLERRM;
							creferencia :=
								'La Poliza con el Numero:' || ben.codprod || '-' || ben.codofiemi || '-' || ben.numpol ||
								':Fallo en el Insert,' || 'Idepol:' || nidepol || ',Ideaseg:' || nideaseg;
							dfechaproceso := SYSDATE;
							ncountr := ncountr + 1;
							pr_banseg.graba_errores(
								'BENEFICIARIO','CARGA-B',cmensaje_sql,'CREAR_BENEFI',creferencia,
								dfechaproceso,ben.codprod,ben.codproveedor,ben.archivo
							);
						END;
					END IF;
				END IF;
			END LOOP;
			--
			ccodproc := 'CBP';
			--
			UPDATE banca_seguro_hist
			SET reg_proce = ncount,
				reg_recha = ncountr
			WHERE codprov = ben.codproveedor
			AND archivo = ben.archivo
			AND codproc = ccodproc;
			--
			UPDATE banca_seguro_ben
			SET indicador = 'S',
				fecproceso = SYSDATE
			WHERE codprod = ben.codprod
			AND codofiemi = ben.codofiemi
			AND numpol = ben.numpol;
		END LOOP;
	END crear_benefi;
	--
	PROCEDURE crear_dp_ince(ncodprov NUMBER,carchivo VARCHAR2)
	IS
		nidepol 		poliza.idepol%TYPE;
		ccodplan 		ramo_plan_prod.codplan%TYPE;
		crevplan 		ramo_plan_prod.revplan%TYPE;
		dfechaproceso 	DATE;
		ccoderror 		VARCHAR2(20) := NULL;
		cmensaje_sql 	VARCHAR2(4000) := NULL;
		creferencia 	VARCHAR2(100) := NULL;
		ccodproc 		VARCHAR2(3);
		ncount 			NUMBER(5) := 0;
		ncountr 		NUMBER(5) := 0;
		--
		CURSOR ince
		IS
		SELECT 
			codprod,codofiemi,numpol,tiporiesgo,articulo,subnivel1,subnivel2,subnivel3,subnivel4,
			grupo,estruct,techo,pared,codclasries,norte,sur,este,oeste,monto,codproveedor,archivo
		FROM banca_seguro_dp_ince
		WHERE NVL(indicador,'N') = 'N'
		AND codproveedor = NVL(ncodprov,codproveedor)
		AND archivo = NVL(carchivo,archivo);
	BEGIN
		FOR i IN ince
		LOOP
			BEGIN
				SELECT idepol INTO nidepol
				FROM poliza
				WHERE codprod = i.codprod
				AND codofiemi = i.codofiemi
				AND numpol = i.numpol;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				RAISE_APPLICATION_ERROR(-20100,'NO SE HA CREADO LA POLIZA:'||BEN.CodProd||'-'||BEN.CodOfiEmi||'-'||BEN.Numpol);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || i.codprod || '-' || i.codofiemi || '-' || i.numpol || ':No EXISTE';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'POLIZA','CARGA-I',cmensaje_sql,'CREAR_DP_INCE',creferencia,
					dfechaproceso,i.codprod,i.codproveedor,i.archivo
				);
			END;
			--
			BEGIN
				SELECT codplan,revplan INTO ccodplan,crevplan
				FROM cert_ramo
				WHERE idepol = nidepol
				AND codramocert = '0040';
			EXCEPTION WHEN NO_DATA_FOUND THEN
				ccodplan := 0;
				crevplan := 0;
			END;
			--
			BEGIN
				INSERT INTO datos_part_incendio(
					idepol,numcert,codplan,revplan,codramocert,tiporiesgo,articulo,subnivel1,
					subnivel2,subnivel3,subnivel4,grupo,estruct,techo,pared,desccovenin,codclasries,
					nroficio,fechoficio,codgrpusr,codusr,norte,sur,este,oeste,tipoprriesgo,tasabasica,
					indmegariesgo,mtovalbienmoneda,porcriesgo,tipo1eriesgo,porcperind,codinspec,
					tipomercancia,tasabienrefr,percaren,perindem,tasaindem,porccoaseg,utilbruta,numdias
				)
				VALUES(
					nidepol,1,ccodplan,crevplan,'0040',i.tiporiesgo,i.articulo,i.subnivel1,i.subnivel2,
					i.subnivel3,i.subnivel4,i.grupo,i.estruct,i.techo,i.pared,'N',i.codclasries,NULL,
					NULL,NULL,NULL,i.norte,i.sur,i.este,i.oeste,'1',NULL,NULL,NULL,NULL,NULL,NULL,
					NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
				);
				--
				ncount := ncount + 1;
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla DATOS PARTICULARES INCENDIO'||SQLERRM);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || i.codprod || '-' || i.codofiemi || '-' ||
					i.numpol || ' ' || 'Fallo el insert,Idepol:' || nidepol;
				dfechaproceso := SYSDATE;
				ncountr := ncountr + 1;
				pr_banseg.graba_errores(
					'DATOS_PART_INCENDIO','CARGA-P',cmensaje_sql,'CREAR_DP_INCE',
					creferencia,dfechaproceso,i.codprod,i.codproveedor,i.archivo
				);
			END;
			--
			ccodproc := 'ICE';
			--
			UPDATE banca_seguro_hist
			SET reg_proce = ncount,
				reg_recha = ncountr
			WHERE codprov = i.codproveedor
			AND archivo = i.archivo
			AND codproc = ccodproc;
			--
			UPDATE banca_seguro_dp_ince
			SET indicador = 'S',
				fecproceso = SYSDATE
			WHERE codprod = i.codprod
			AND codofiemi = i.codofiemi
			AND numpol = i.numpol;
		END LOOP;
	END crear_dp_ince;
	--
	PROCEDURE crear_dp_robo(ncodprov NUMBER,carchivo VARCHAR2)
	IS
		nidepol 		poliza.idepol%TYPE;
		ccodplan 		ramo_plan_prod.codplan%TYPE;
		crevplan 		ramo_plan_prod.revplan%TYPE;
		ccoderror 		VARCHAR2(20) := NULL;
		cmensaje_sql 	VARCHAR2(4000) := NULL;
		creferencia 	VARCHAR2(100) := NULL;
		ccodproc		VARCHAR2(3);
		ncount			NUMBER(5) := 0;
		ncountr			NUMBER(5) := 0;
		dfechaproceso 	DATE;
		--
		CURSOR robo
		IS
		SELECT
			codprod,codofiemi,numpol,codindole,clase,norte,sur,este,oeste,numlocales,mercpredom,
			techo,paredext,puertext,vitrivent,porcdctovigi,porcdctoalar,monto,codproveedor,archivo
		FROM banca_seguro_dp_robo
		WHERE NVL(indicador,'N') = 'N'
		AND codproveedor = NVL(ncodprov,codproveedor)
		AND archivo = NVL(carchivo,archivo);
	BEGIN
		FOR r IN robo
		LOOP
			BEGIN
				SELECT idepol INTO nidepol
				FROM poliza
				WHERE codprod = r.codprod
				AND codofiemi = r.codofiemi
				AND numpol = r.numpol;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				RAISE_APPLICATION_ERROR(-20100,'NO SE HA CREADO LA POLIZA:'||BEN.CodProd||'-'||BEN.CodOfiEmi||'-'||BEN.Numpol);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || r.codprod || '-' || r.codofiemi || '-' || r.numpol || ':No EXISTE';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'POLIZA','CARGA-R',cmensaje_sql,'CREAR_DP_ROBO',creferencia,
					dfechaproceso,r.codprod,r.codproveedor,r.archivo
				);
			END;
			--
			BEGIN
				SELECT codplan,revplan INTO ccodplan,crevplan
				FROM cert_ramo
				WHERE idepol = nidepol
				AND codramocert = '0045';
			EXCEPTION WHEN NO_DATA_FOUND THEN
				ccodplan := 0;
				crevplan := 0;
			END;
			--
			BEGIN
				INSERT INTO datos_part_robo(
					idepol,numcert,codplan,revplan,codramocert,codindole,clase,norte,sur,este,oeste,numlocales,
					mercpredom,techo,paredext,puertext,vitrivent,indrec,indcolin,porcdctovigi,porcdctoalar
				)
				VALUES(
					nidepol,1,ccodplan,crevplan,'0045',r.codindole,r.clase,r.norte,r.sur,r.este,r.oeste,
					r.numlocales,r.mercpredom,r.techo,r.paredext,r.puertext,r.vitrivent,'S',NULL,NULL,NULL
				);
				--
				ncount := ncount + 1;
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla DATOS PARTICULARES ROBO'||SQLERRM);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || r.codprod || '-' || r.codofiemi || 
					'-' || r.numpol || ' ' || 'Fallo el insert,Idepol:' || nidepol;
				dfechaproceso := SYSDATE;
				ncountr := ncountr + 1;
				pr_banseg.graba_errores(
					'DATOS_PART_ROBO','CARGA-R',cmensaje_sql,'CREAR_DP_ROBO',
					creferencia,dfechaproceso,r.codprod,r.codproveedor,r.archivo
				);
			END;
			--
			ccodproc := 'ROB';
			--
			UPDATE banca_seguro_hist
			SET reg_proce = ncount,
				reg_recha = ncountr
			WHERE codprov = r.codproveedor
			AND archivo = r.archivo
			AND codproc = ccodproc;
			--
			UPDATE banca_seguro_dp_robo
			SET indicador = 'S',
				fecproceso = SYSDATE
			WHERE codprod = r.codprod
			AND codofiemi = r.codofiemi
			AND numpol = r.numpol;
		END LOOP;
	END crear_dp_robo;
	--
	PROCEDURE crear_dp_terre(ncodprov NUMBER,carchivo VARCHAR2)
	IS
		nidepol 		poliza.idepol%TYPE;
		ccodplan 		ramo_plan_prod.codplan%TYPE;
		crevplan 		ramo_plan_prod.revplan%TYPE;
		dfechaproceso 	DATE;
		ccoderror 		VARCHAR2(20) := NULL;
		cmensaje_sql 	VARCHAR2(4000) := NULL;
		creferencia 	VARCHAR2(100) := NULL;
		ccodproc 		VARCHAR2(3);
		ncount 			NUMBER(5) := 0;
		ncountr			NUMBER(5) := 0;
		--
		CURSOR terre
		IS
		SELECT
			codprod,codofiemi,numpol,tipoedif,nropisos,vistavert,
			cortehorz,tipofach,monto,codproveedor,archivo
		FROM banca_seguro_dp_terre
		WHERE NVL(indicador,'N') = 'N'
		AND codproveedor = NVL(ncodprov,codproveedor)
		AND archivo = NVL(carchivo,archivo);
	BEGIN
		FOR t IN terre
		LOOP
			BEGIN
				SELECT idepol INTO nidepol
				FROM poliza
				WHERE codprod = t.codprod
				AND codofiemi = t.codofiemi
				AND numpol = t.numpol;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				RAISE_APPLICATION_ERROR(-20100,'NO SE HA CREADO LA POLIZA:'||BEN.CodProd||'-'||BEN.CodOfiEmi||'-'||BEN.Numpol);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || t.codprod || '-' || t.codofiemi ||
					'-' || t.numpol || ':No EXISTE';
				dfechaproceso := SYSDATE;
				pr_banseg.graba_errores(
					'POLIZA','CARGA-T',cmensaje_sql,'CREAR_DP_TERRE',
					creferencia,dfechaproceso,t.codprod,t.codproveedor,t.archivo
				);
			END;
			--
			BEGIN
				SELECT codplan,revplan INTO ccodplan,crevplan
				FROM cert_ramo
				WHERE idepol = nidepol
				AND codramocert = '0041';
			EXCEPTION WHEN NO_DATA_FOUND THEN
				ccodplan := 0;
				crevplan := 0;
			END;
			--
			BEGIN
				INSERT INTO datos_part_terremoto(
					idepol,numcert,codplan,revplan,codramocert,tipoedif,nropisos,vistavert,
					cortehorz,tipofach,mtovalbienmoneda,porcriesgo,tipo1eriesgo,porcperind
				)
				VALUES(
					nidepol,1,ccodplan,crevplan,'0041',t.tipoedif,t.nropisos,
					t.vistavert,t.cortehorz,t.tipofach,NULL,NULL,NULL,NULL
				);
				--
				ncount := ncount + 1;
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR(-20100,'Fallo insert en la Tabla DATOS PARTICULARES TERREMOTO'||SQLERRM);
				cmensaje_sql := SQLERRM;
				creferencia :=
					'La Poliza con el Numero:' || t.codprod || '-' || t.codofiemi || 
					'-' || t.numpol || ' ' || 'Fallo el insert,Idepol:' || nidepol;
				dfechaproceso := SYSDATE;
				ncountr := ncountr + 1;
				pr_banseg.graba_errores(
					'DATOS_PART_TERREMOTO','CARGA-P',cmensaje_sql,'CREAR_DP_TERRE',
					creferencia,dfechaproceso,t.codprod,t.codproveedor,t.archivo
				);
			END;
			--
			ccodproc := 'TRR';
			--
			UPDATE banca_seguro_hist
			SET reg_proce = ncount,
				reg_recha = ncountr
			WHERE codprov = t.codproveedor
			AND archivo = t.archivo
			AND codproc = ccodproc;
			--
			UPDATE banca_seguro_dp_terre
			SET indicador = 'S',
				fecproceso = SYSDATE
			WHERE codprod = t.codprod
			AND codofiemi = t.codofiemi
			AND numpol = t.numpol;
		END LOOP;
	END crear_dp_terre;
	--
	PROCEDURE borrar_egreso(nnumrelegre NUMBER)
	IS
		ccajero 	VARCHAR2(10);
		chorasts 	VARCHAR2(8);
		ccodofic 	VARCHAR2(6);
		ccodofi 	VARCHAR2(6);
		ccodcajero	usuario.codusr%TYPE;
		ccodcaja	usuario.codgrpusr%TYPE;
	BEGIN
		BEGIN
			SELECT SUBSTR(RTRIM(USER),1,8) INTO ccajero FROM sys.DUAL;
		END;
		--
		BEGIN
			SELECT codgrpusr,codsuc INTO ccodcaja,ccodofic
			FROM usuario
			WHERE codusr = ccajero;
		END;
		--
		BEGIN
			SELECT DISTINCT NVL(codofi,codofirelegre) INTO ccodofi
			FROM rel_egre
			WHERE numrelegre = nnumrelegre
			AND NVL(codofi,codofirelegre) = ccodofic;
		END;
		--
		UPDATE orden_pago
		SET numrelegre = NULL,
			codofi = NULL
		WHERE numrelegre = nnumrelegre
		AND codofi = ccodofi;
		--
		DELETE doc_egre
		WHERE numrelegre = nnumrelegre
		AND codofi = ccodofi;
		--
		DELETE rel_egre
		WHERE numrelegre = nnumrelegre
		AND codofi = ccodofi;
		--
		COMMIT;
	END borrar_egreso;
	--
	PROCEDURE borrar_obligacion(nnumoblig NUMBER)
	IS
	BEGIN
		DELETE obligacion
		WHERE numoblig = nnumoblig;
		--
		DELETE det_oblig
		WHERE numoblig = nnumoblig;
		--
		DELETE orden_pago
		WHERE numoblig = nnumoblig;
		--
		COMMIT;
	END borrar_obligacion;
	--
	PROCEDURE crear_tercero_ben
	IS
		nexiste 		VARCHAR2(1);
		ctabla 			VARCHAR2(100) := NULL;
		ccoderror 		VARCHAR2(20) := NULL;
		cmensaje_sql 	VARCHAR2(4000) := NULL;
		creferencia 	VARCHAR2(100) := NULL;
		cdummy 			VARCHAR2(2);
		cindtipopro		VARCHAR2(100);
		dfechaproceso 	DATE;
		exec_error		EXCEPTION;
		exec_coase 		EXCEPTION;
		--
		CURSOR ter
		IS
		SELECT * FROM banca_seguro_ben
		WHERE NVL(indicador,'N') = 'N';
		--
	BEGIN
		FOR b IN ter
		LOOP
			BEGIN
				SELECT 1 INTO nexiste
				FROM tercero
				WHERE tipoid = b.tipoid
				AND numid = b.numid
				AND dvid = 0;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				nexiste := 0;
			WHEN TOO_MANY_ROWS THEN
				nexiste := 1;
			END;
			--
			IF nexiste = 0 THEN
				BEGIN
					INSERT INTO tercero(
						tipoid,numid,dvid,apeter,nomter,indnacional,fecsts,direc,codpais,codestado,
						codciudad,codmunicipio,telef1,telef2,telef3,fax,telex,zip,stster,codparroquia,
						codsector,codtelofi,telofi,codtelhab,telhab,codtelfax,telfax,codtelcel,telcel,
						tipzona,desczona,tipvia,descvia,tiphab,deschab,nrotorre,piso,nroapto
					)
					VALUES(
						b.tipoid,b.numid,0,b.apeter,b.nomter,'N',SYSDATE,b.direc,b.codpais,b.codestado,
						b.codciudad,b.codmunicipio,b.codtelofi || b.telofi,b.codtelhab || b.telhab,NULL,
						b.codtelfax || b.telfax,NULL,NULL,'ACT',b.codparroquia,b.codsector,b.codtelofi,
						b.telofi,b.codtelhab,b.telhab,b.codtelfax,b.telfax,b.codtelcel,b.telcel,b.tipzona,
						b.desczona,b.tipvia,b.descvia,b.tiphab,b.deschab,b.nrotorre,b.piso,b.nroapto
					);
				EXCEPTION WHEN OTHERS THEN
					cmensaje_sql := SQLERRM;
					creferencia :='La cedula/Rif' || ':' || b.tipoid || '-' || b.numid || ' ' || 'Fallo en el insert';
					dfechaproceso := SYSDATE;
					pr_banseg.graba_errores(
						'TERCERO','CARGA-T',cmensaje_sql,'CREAR_TERCERO_BEN',
						creferencia,dfechaproceso,b.codprod,b.codproveedor,b.archivo
					);
				END;
			END IF;
		END LOOP;
	END crear_tercero_ben;
	--
	PROCEDURE abrir_cierre_caja(ccodcia VARCHAR2,ccodoficierre VARCHAR2,dfecultcierre DATE)
	IS
		dummy 			NUMBER;
		dfecapertura 	DATE;
		existe 			NUMBER(1);
		cmensaje_sql 	VARCHAR2(4000) := NULL;
	BEGIN
		BEGIN
			SELECT 1 INTO existe
			FROM cierre_caja
			WHERE codcia = ccodcia
			AND codoficierre = ccodoficierre
			AND codgrpusr = 'DESARROL'
			AND codcajero = USER
			AND indcierre = 'S'
			AND TRUNC(fecapertura) = TRUNC(dfecultcierre);
		EXCEPTION WHEN NO_DATA_FOUND THEN
			dummy := (
				'No existe caja abierta para la oficina: ' || ccodoficierre || ' Grupo Usr. ' || 
				'DESARROL' || ' cajero: ' || USER || ' y fecha: ' || TRUNC(dfecultcierre)
			);
		END;
		--
		BEGIN
			SELECT MAX(fecapertura) INTO dfecapertura
			FROM cierre_caja
			WHERE codcia = ccodcia
			AND codoficierre = ccodoficierre
			AND codgrpusr = 'DESARROL'
			AND codcajero = USER
			AND indcierre = 'N';
		END;
		--
		IF dfecapertura IS NULL THEN
			dummy := (
				'No existe caja abierta para la oficina: ' || ccodoficierre || ' Grupo Usr. ' ||
				'DESARROL' || ' cajero: ' || USER
			);
		ELSIF TRUNC(dfecapertura) = TRUNC(dfecultcierre) THEN
			dummy :=('La caja esta abierta');
		ELSE
			BEGIN
				DELETE cierre_caja
				WHERE codcia = ccodcia
				AND codoficierre = ccodoficierre
				AND codgrpusr = 'DESARROL'
				AND codcajero = USER
				AND TRUNC(fecapertura) = TRUNC(dfecapertura);
			END;
			--
			BEGIN
				UPDATE cierre_caja
				SET indcierre = 'N',
					fecultcierre = NULL
				WHERE codcia = ccodcia
				AND codoficierre = ccodoficierre
				AND codgrpusr = 'DESARROL'
				AND codcajero = USER
				AND TRUNC(fecapertura) = TRUNC(dfecultcierre);
			END;
		END IF;
	EXCEPTION WHEN OTHERS THEN
		cmensaje_sql :=(SQLERRM);
	END abrir_cierre_caja;
	--
	FUNCTION valida_fecha(in_date IN VARCHAR2)
		RETURN VARCHAR2
	IS
		in_date_dmy		VARCHAR2(8);
		chg_date_ymd	VARCHAR2(8);
		h_in_date		DATE;
	BEGIN
		in_date_dmy := LPAD(in_date,8);
		chg_date_ymd := SUBSTR(in_date_dmy,5,4) || SUBSTR(in_date_dmy,3,2) || SUBSTR(in_date_dmy,1,2);
		--
		IF chg_date_ymd >= '15821015' THEN
			h_in_date := TO_DATE(REPLACE(chg_date_ymd,' ','*'),'YYYYMMDD');
			RETURN 'Y';
		ELSE
			RETURN 'N';
		END IF;
	EXCEPTION WHEN OTHERS THEN
		RETURN 'N';
	END valida_fecha;
	--
	FUNCTION exportar(ccodigo VARCHAR2)
		RETURN BOOLEAN
	IS
		n_cursor 		INTEGER;
		n_dummy 		INTEGER;
		c_expresionint 	VARCHAR2(5000) := NULL;
		cdef 			VARCHAR2(5000) := NULL;
		cnomtabela 		VARCHAR2(30);
		cdirectorio 	VARCHAR2(200) := NULL;
		cArchivo 		VARCHAR2(35) := NULL;
		cDirectorioBase VARCHAR2(30) := NULL;
		carq 			SYS.UTL_FILE.file_type;
		--
		CURSOR layout_tipo_c
		IS
		SELECT nomtabela,campo,ordem,condicao
		FROM layout_tabela
		WHERE codigo = ccodigo;
		--
		CURSOR layout_imp_c
		IS
		SELECT
			campo,posicion,longitud,tipo,tipocampo,decimales,nomtabela,valordefault,
			NVL(indpk,'N') indpk,formula,indselect,indtipo,parametro,indcopiar
		FROM layout_imp
		WHERE codigo = ccodigo
		AND nomtabela = cnomtabela
		ORDER BY orden;
	BEGIN
		cDirectorioBase := PR.BUSCA_PARAMETRO('015');
		cdirectorio := 'BANCASEG_DIRECT_OUT';
		c_expresionint := NULL;
		--
		FOR x IN layout_tipo_c
		LOOP
			DBMS_OUTPUT.put_line('Entra al Cursor LAYOUT_TIPO_C cDirectorio ' || cdirectorio);
			cnomtabela := x.nomtabela;
			carchivo := x.nomtabela || '.txt';
			c_expresionint := 'SELECT ';
			--
			FOR y IN layout_imp_c
			LOOP
				DBMS_OUTPUT.put_line('Entra al Cursor LAYOUT_IMP_C ');
				--
				IF RTRIM(y.formula) IS NOT NULL THEN
					c_expresionint := c_expresionint || REPLACE(y.formula,'',y.campo) || '||';
				ELSE
					IF y.tipocampo = 'VARCHAR2' THEN
						c_expresionint :=c_expresionint || 'RPAD(' || y.campo || ',' || y.longitud || ')||';
					ELSIF y.tipocampo = 'NUMBER' THEN
						c_expresionint :=c_expresionint || 'LPAD(' || y.campo || ',' || y.longitud || ',0' || ')||';
					ELSIF y.tipocampo = 'DATE' THEN
						c_expresionint :=c_expresionint || 'LPAD(' || y.campo || ',' || y.longitud || ')||';
					END IF;
				END IF;
			END LOOP;
			--
			c_expresionint := SUBSTR(c_expresionint,1,(INSTR(c_expresionint,'||',-1)) - 1) || ' cDef';
			c_expresionint := c_expresionint || ' FROM ' || x.nomtabela;
			--
			IF x.condicao IS NOT NULL THEN
				c_expresionint := c_expresionint || ' WHERE ' || x.condicao;
			END IF;
			--
			IF x.ordem IS NOT NULL THEN
				c_expresionint := c_expresionint || ' ORDER BY ' || x.ordem;
			END IF;
			--
			DBMS_OUTPUT.put_line('cDirectorio ' || cdirectorio || ' cArchivo ' || carchivo);
			--
			carq := sys.UTL_FILE.fopen(cdirectorio,carchivo,'w');
			n_cursor := DBMS_SQL.open_cursor;
			--
			DBMS_SQL.parse(n_cursor,c_expresionint,DBMS_SQL.native);
			DBMS_SQL.define_column(n_cursor,1,cdef,5000);
			n_dummy := DBMS_SQL.execute(n_cursor);
			--
			WHILE(DBMS_SQL.fetch_rows(n_cursor) > 0)
			LOOP
				DBMS_SQL.COLUMN_VALUE(n_cursor,1,cdef);
				DBMS_OUTPUT.put_line('Archivo:' || carchivo || '-' || 'Dir:' || cdirectorio || '-' || 'Texto' || cdef);
				sys.UTL_FILE.put_line(carq,cdef);
			END LOOP;
			--
			sys.UTL_FILE.fclose(carq);
		END LOOP;
		--
		DBMS_SQL.close_cursor(n_cursor);
		RETURN(TRUE);
	EXCEPTION WHEN OTHERS THEN
		raise_application_error(-20100,'Error :' || SQLERRM);
	END exportar;
	--
	PROCEDURE rechazo_txt(
		ccodprov IN VARCHAR2,ccodproc IN VARCHAR2,carchivo IN VARCHAR2,
		str_reg IN VARCHAR2,long_reg IN NUMBER,msg_err IN VARCHAR2,
		num_reg IN NUMBER,pos_reg IN NUMBER,nom_campo IN VARCHAR2
	)
	IS
		v_outfile		UTL_FILE.file_type;
		nm_directory 	VARCHAR2(50);
		v_str_file		VARCHAR2(5100);
	BEGIN
		BEGIN
			SELECT rutasal INTO nm_directory
			FROM banca_seguro_prov
			WHERE codprov = ccodprov
			AND codproc = ccodproc;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			nm_directory := 'DIRECTORIO_BANCASEG_OUT';
		WHEN OTHERS THEN
			nm_directory := 'DIRECTORIO_BANCASEG_OUT';
		END;
		--
		v_outfile := sys.UTL_FILE.fopen(nm_directory,carchivo,'A',32767);
		v_str_file :=
			RPAD(str_reg,long_reg,' ') || RPAD(msg_err,60,' ') || 
			LPAD(TO_CHAR(num_reg),10,'0') || LPAD(TO_CHAR(pos_reg),4,'0') || 
			RPAD(nom_campo,15,' ');
		--
		DBMS_OUTPUT.put_line('Mensaje de Error:' || msg_err);
		sys.UTL_FILE.put_line(v_outfile,v_str_file);
		COMMIT;
		--
		sys.UTL_FILE.fclose(v_outfile);
	END rechazo_txt;
	--
	FUNCTION srt_fmt_msg(
		str_reg IN VARCHAR2,long_reg IN NUMBER,msg_err IN VARCHAR2,
		num_reg IN NUMBER,pos_reg IN NUMBER,nom_campo IN VARCHAR2
	)
		RETURN VARCHAR2
	IS
		v_str_data VARCHAR2(5100);
	BEGIN
		v_str_data :=
			RPAD(str_reg,long_reg,' ') || RPAD(msg_err,60,' ') ||
			LPAD(TO_CHAR(num_reg),10,'0') || RPAD(nom_campo,15,' ') ||
			LPAD(TO_CHAR(pos_reg),4,'0');
		RETURN(v_str_data);
	END;
	--
	PROCEDURE read_file_in(file_name VARCHAR2)
	IS
		vsfile 		UTL_FILE.file_type;
		vnewline 	VARCHAR2(1500);
	BEGIN
		vsfile := UTL_FILE.fopen('DIRECTORIO_RONTARCA_IN',file_name,'r');
		DELETE tmp_seefile;
		--
		IF UTL_FILE.is_open(vsfile) THEN
			LOOP
				BEGIN
					UTL_FILE.get_line(vsfile,vnewline);
					--
					IF vnewline IS NULL THEN
						EXIT;
					END IF;
					--
					INSERT INTO tmp_seefile(file_name,record_file)
					VALUES(file_name,vnewline);
				EXCEPTION WHEN NO_DATA_FOUND THEN
					EXIT;
				END;
			END LOOP;
			COMMIT;
		END IF;
		--
		UTL_FILE.fclose(vsfile);
	EXCEPTION WHEN UTL_FILE.invalid_mode THEN
		raise_application_error(-20051,'Invalid Mode Parameter');
	WHEN UTL_FILE.invalid_path THEN
		raise_application_error(-20052,'Invalid File Location');
	WHEN UTL_FILE.invalid_filehANDle THEN
		raise_application_error(-20053,'Invalid FilehANDle');
	WHEN UTL_FILE.invalid_operation THEN
		raise_application_error(-20054,'Invalid Operation');
	WHEN UTL_FILE.read_error THEN
		raise_application_error(-20055,'Read Error');
	WHEN UTL_FILE.internal_error THEN
		raise_application_error(-20057,'Internal Error');
	WHEN UTL_FILE.charSETmismatch THEN
		raise_application_error(-20058,'Opened With FOPEN_NCHAR But Later I/O Inconsistent');
	WHEN UTL_FILE.file_open THEN
		raise_application_error(-20059,'File Already Opened');
	WHEN UTL_FILE.invalid_maxlinesize THEN
		raise_application_error(-20060,'Line Size Exceeds 32K');
	WHEN UTL_FILE.invalid_filename THEN
		raise_application_error(-20061,'Invalid File Name');
	WHEN UTL_FILE.access_denied THEN
		raise_application_error(-20062,'File Access Denied By');
	WHEN UTL_FILE.invalid_offSET THEN
		raise_application_error(-20063,'FSEEK Param Less Than 0');
	WHEN OTHERS THEN
		raise_application_error(-20099,'Unknown UTL_FILE Error');
	END read_file_in;
	--
	PROCEDURE read_file_out(file_name VARCHAR2)
	IS
		vsfile 		UTL_FILE.file_type;
		vnewline 	VARCHAR2(1500);
	BEGIN
		vsfile := UTL_FILE.fopen('DIRECTORIO_RONTARCA_OUT',file_name,'r');
		DELETE tmp_seefile;
		--
		IF UTL_FILE.is_open(vsfile) THEN
			LOOP
				BEGIN
					UTL_FILE.get_line(vsfile,vnewline);
					--
					IF vnewline IS NULL THEN
						EXIT;
					END IF;
					--
					INSERT INTO tmp_seefile(file_name,record_file)
					VALUES(file_name,vnewline);
				EXCEPTION WHEN NO_DATA_FOUND THEN
					EXIT;
				END;
			END LOOP;
			--
			COMMIT;
		END IF;
		--
		UTL_FILE.fclose(vsfile);
	EXCEPTION WHEN UTL_FILE.invalid_mode THEN
		raise_application_error(-20051,'Invalid Mode Parameter');
	WHEN UTL_FILE.invalid_path THEN
		raise_application_error(-20052,'Invalid File Location');
	WHEN UTL_FILE.invalid_filehANDle THEN
		raise_application_error(-20053,'Invalid FilehANDle');
	WHEN UTL_FILE.invalid_operation THEN
		raise_application_error(-20054,'Invalid Operation');
	WHEN UTL_FILE.read_error THEN
		raise_application_error(-20055,'Read Error');
	WHEN UTL_FILE.internal_error THEN
		raise_application_error(-20057,'Internal Error');
	WHEN UTL_FILE.charSETmismatch THEN
		raise_application_error(-20058,'Opened With FOPEN_NCHAR But Later I/O Inconsistent');
	WHEN UTL_FILE.file_open THEN
		raise_application_error(-20059,'File Already Opened');
	WHEN UTL_FILE.invalid_maxlinesize THEN
		raise_application_error(-20060,'Line Size Exceeds 32K');
	WHEN UTL_FILE.invalid_filename THEN
		raise_application_error(-20061,'Invalid File Name');
	WHEN UTL_FILE.access_denied THEN
		raise_application_error(-20062,'File Access Denied By');
	WHEN UTL_FILE.invalid_offSET THEN
		raise_application_error(-20063,'FSEEK Param Less Than 0');
	WHEN OTHERS THEN
		raise_application_error(-20099,'Unknown UTL_FILE Error');
	END read_file_out;
	--
	FUNCTION find_posicion(ccodigo IN VARCHAR2,cnomtabela IN VARCHAR2,ccampo IN VARCHAR2)
		RETURN NUMBER
	IS
		nposicion NUMBER(4);
	BEGIN
		BEGIN
			SELECT posicion INTO nposicion
			FROM layout_imp ly
			WHERE ly.codigo = ccodigo
			AND ly.nomtabela = cnomtabela
			AND ly.campo = ccampo;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			nposicion := 0;
		END;
		--
		RETURN(nposicion);
	END find_posicion;
	--
	PROCEDURE load_file(dfec_proceso VARCHAR2)
	IS
		nombre_dia	VARCHAR(15);
		dfecha_dma	VARCHAR2(8);
		cruta 		VARCHAR(300) := NULL;
		dia_habil 	NUMBER(1) := 1;
		xdia 		NUMBER(1) := 1;
		--
		CURSOR cur_proceso
		IS
		SELECT rutaent,prearchi,extarchi,codprov,codigo,numsec
		FROM banca_seguro_prov
		WHERE stspro = 'ACT'
		ORDER BY numsec;
	BEGIN
		IF dfec_proceso IS NULL THEN
			nombre_dia := pr_util.dia_letra(TRUNC(SYSDATE));
			--
			IF nombre_dia = 'lunes' THEN
				xdia := 3;
			END IF;
			--
			BEGIN
				SELECT TO_CHAR(TRUNC(SYSDATE - xdia),'DDMMYYYY')
				INTO dfecha_dma
				FROM DUAL;
			END;
		ELSE
			dfecha_dma := dfec_proceso;
		END IF;
		--
		BEGIN
			SELECT 0 INTO dia_habil
			FROM dias_no_habiles
			WHERE TO_CHAR(fecha,'DDMMYYYY') = dfecha_dma;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			dia_habil := 1;
		END;
		--
		IF dia_habil = 1 THEN
			FOR b IN cur_proceso
			LOOP
				BEGIN
					cruta :=
						UPPER(TRIM(b.rutaent)) || '/' || TRIM(b.codprov) || 
						UPPER(TRIM(b.prearchi)) || dfecha_dma || '.' || UPPER(b.extarchi);
					DBMS_OUTPUT.put_line(b.codigo || ' archivo:-->' || cruta);
					pr_banseg.PULL_PUSH_FILE(b.codigo,TRIM(cruta),NULL,NULL);
				END;
			END LOOP;
		ELSE
			DBMS_OUTPUT.put_line('dia no habil ');
		END IF;
	END load_file;
	--
	PROCEDURE UPDATE_RECORD(sentencia_sql IN VARCHAR2)
	AS
		cursor_tabla_banca INTEGER;
		registro INTEGER;
	BEGIN
		DBMS_OUTPUT.put_line(sentencia_sql);
		cursor_tabla_banca := DBMS_SQL.open_cursor;
		DBMS_SQL.parse(cursor_tabla_banca,TRIM(sentencia_sql),DBMS_SQL.native);
		registro := DBMS_SQL.execute(cursor_tabla_banca);
		DBMS_SQL.close_cursor(cursor_tabla_banca);
	EXCEPTION WHEN OTHERS THEN
		DBMS_OUTPUT.put_line('Error de Excepction en UPDATE Record tabla banca seguro ');
		--
		IF DBMS_SQL.is_open(cursor_tabla_banca) THEN
			DBMS_SQL.close_cursor(cursor_tabla_banca);
		END IF;
	END UPDATE_RECORD;
	--
	PROCEDURE enviar_correo(ncodprov NUMBER)
	IS
		crlf			VARCHAR2(2) := CHR(13) || CHR(10);
		texto 			VARCHAR2(7500);
		asunto			VARCHAR2(100);
		cemail			banca_seguro_mail.email%TYPE;
		nreg_proceso	banca_seguro_hist.reg_proce%TYPE;
		v_mensaje 		msg_acsel.mensaje%TYPE;
		--
		CURSOR cur_correo
		IS
		SELECT u.email
		FROM banca_seguro_mail u
		WHERE u.codprov = ncodprov
		AND u.status = 'ACT';
		--
		reg_correo	cur_correo%ROWTYPE;
	BEGIN
		BEGIN
			FOR envio IN(
				SELECT codprov,codproc,fecproc,reg_recha,archivo,reg_leido,t.descrip
				FROM banca_seguro_hist,lval t
				WHERE mail = 'N'
				AND codprov = ncodprov
				AND t.codlval = codprov
				AND t.tipolval = 'PROVEBS'
			)
			LOOP
				cemail := 'acsel@acsel.com';
				nreg_proceso := envio.reg_leido - envio.reg_recha;
				asunto := ' Resultado Descarga Archivos Banca Seguro. ';
				v_mensaje := ' Favor tomar nota de los Rechazos Ocurridos en el proceso de descarga. ';
				v_mensaje := SUBSTR(v_mensaje,1,LENGTH(v_mensaje));
				texto :=
					'<html><body><p><b><font face="Arial" color="#r0g50b0">' || 
					'Seguros' || '</font></b></p><p><b>' || v_mensaje || '</b></p>' ||
					'<p><b>Proveedor: </b>' || envio.codprov || '-' || envio.descrip || '.</p>' ||
					'<p><b>Archivo: </b>' || envio.archivo || '.</p>' || '<p><b>Registros Leidos: </b>' ||
					envio.reg_leido || '.</p>' || '<p><b>Registros aceptados: </b>' || nreg_proceso ||
					'.</p>' || '<p><b>Registros Rechazados: </b>' || envio.reg_recha || '.</p>' ||
					'<p><b>Fecha de Proceso: </b>' || envio.fecproc || '.</p>' || '</body></html>';
				--
				OPEN cur_correo;
				LOOP
					FETCH cur_correo INTO reg_correo;
					EXIT WHEN cur_correo%NOTFOUND;
					DBMS_OUTPUT.put_line('reg_correo.Email ' || reg_correo.email);
					pr_emails.pr_enviar_correo(cemail,reg_correo.email,asunto,crlf || texto,'text/html');
				END LOOP;
				CLOSE cur_correo;
				--
				BEGIN
					UPDATE banca_seguro_hist aa
					SET aa.mail = 'S'
					WHERE aa.mail = 'N'
					AND aa.codprov = envio.codprov
					AND aa.codproc = envio.codproc
					AND aa.archivo = envio.archivo
					AND aa.fecproc = envio.fecproc;
					COMMIT;
				END;
			END LOOP;
		END;
	END enviar_correo;
	--
	PROCEDURE DIR_UNIX_in
	IS
		c1 			SYS_REFCURSOR;
		file_name 	VARCHAR2(400);
		dir 		VARCHAR2(400);
	BEGIN
		dir := '/desarrollo/ftp/ftp_rontarca/entrada';
		sys.get_directory_files(dir,c1);
		FETCH c1 INTO file_name;
		--
		WHILE c1%FOUND
		LOOP
			DBMS_OUTPUT.put_line(file_name);
			FETCH c1 INTO file_name;
		END LOOP;
	END DIR_UNIX_in;
	--
	PROCEDURE DIR_UNIX_out
	IS
		c1 			SYS_REFCURSOR;
		file_name 	VARCHAR2(400);
		dir 		VARCHAR2(400);
	BEGIN
		dir := '/desarrollo/ftp/ftp_rontarca/salida';
		sys.get_directory_files(dir,c1);
		FETCH c1 INTO file_name;
		--
		WHILE c1%FOUND
		LOOP
			DBMS_OUTPUT.put_line(file_name);
			FETCH c1 INTO file_name;
		END LOOP;
	END DIR_UNIX_out;
	--
END PR_BANSEG;