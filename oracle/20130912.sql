DECLARE
	nIdePolBase		POLIZA.IdePol%TYPE;
	cCodProd		POLIZA.codpol%TYPE;
	nNumPol 		POLIZA.NumPol%TYPE;
	nNumPolMig		POLIZA.NumPolMig%TYPE;
	nIdePolElim		POLIZA.IdePol%TYPE;
	nEliminadas		NUMBER := 0;
	nFallidas		NUMBER := 0;

	CURSOR POLIZAS
	IS
	SELECT CODPROD,NUMPOL,NUMPOLMIG, IdePol IdePolBase,NumRen, stspol
	FROM POLIZA P
	WHERE codprod='VMPP';

	CURSOR POLIZAS_ELIM
	IS
	SELECT IdePol, ROWID Fila
	FROM POLIZA
	WHERE IdePol = nIdePolBase;

	CURSOR OPERACIONES
	IS
	SELECT DISTINCT NumOper
	FROM OPER_POL
	WHERE IdePol = nIdePolElim;
BEGIN
	FOR POL IN POLIZAS
	LOOP
		nIdePolBase := POL.IdePolBase;
		cCodProd := POL.CodProd;
		nNumPol := POL.NumPol;
		nNumPolMig := POL.NumPolMig;

		FOR PE IN POLIZAS_ELIM
		LOOP
			nIdePolElim := PE.IdePol;
			--
			BEGIN
				BEGIN
					DELETE RECIBO CASCADE WHERE IdePol = nIdePolElim;
					DELETE GEN_REA CASCADE WHERE IdePol = nIdePolElim;

					DELETE DIST_FACULT CASCADE
					WHERE IdeGenRea IN (
						SELECT IdeGenRea
						FROM DIST_REA CASCADE
						WHERE IdePol = nIdePolElim
					);

					DELETE DIST_REA CASCADE
					WHERE IdePol = nIdePolElim;

					DELETE DIST_COA CASCADE
					WHERE IdePol = nIdePolElim;

					DELETE OPER_POL CASCADE
					WHERE IdePol = nIdePolElim;
				EXCEPTION WHEN OTHERS THEN
					DBMS_OUTPUT.put_line ('POLIZA ' || POL.NumPolMig || ' ' || SQLERRM);
				END;

				DELETE ORDEN_PAGO
				WHERE NumOblig IN (
					SELECT NumOblig FROM APROB_SIN
					WHERE IdeSin IN (
						SELECT IdeSin FROM SINIESTRO
						WHERE IdePol = nIdePolElim
					)
				);

				DELETE ORDEN_PAGO
				WHERE NumOblig IN (
					SELECT NumOblig FROM OBLIGACION
					WHERE IdeSin IN (
						SELECT IdeSin FROM SINIESTRO
						WHERE IdePol = nIdePolElim
					)
				);

				DELETE ORDEN_PAGO
				WHERE NumOblig IN (
					SELECT NumOblig FROM obligacion
					WHERE numreling IN (
						SELECT numreling
						FROM REL_ING CASCADE
						WHERE NumRelIng IN (
							SELECT f.NumReling
							FROM factura f, acreencia a, recibo r
							WHERE f.IdeFact = a.IdeFact
							AND a.NumAcre = r.NumAcre
							AND r.IdePol = nIdePolElim
						)
					)
				);
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR (
					-20100,
					'Error ORDEN_PAGO 1 Tablas IdePol = ' || 
					nIdePolElim ||
					' Mensaje ' ||
					SQLERRM
				);
			END;
			--
			BEGIN
				DELETE OBLIGACION
				WHERE NumOblig IN (
					SELECT NumOblig FROM APROB_SIN
					WHERE IdeSin IN (
						SELECT IdeSin FROM SINIESTRO
						WHERE IdePol = nIdePolElim
					)
				);

				DELETE OBLIGACION
				WHERE IdeSin IN (
					SELECT IdeSin FROM APROB_SIN
					WHERE IdeSin IN (
						SELECT IdeSin FROM SINIESTRO
						WHERE IdePol = nIdePolElim
					)
				);

				DELETE OBLIGACION
				WHERE IdeSin IN (
					SELECT IdeSin FROM SINIESTRO
					WHERE IdePol = nIdePolElim
				);

				DELETE obligacion
				WHERE numreling IN (
					SELECT numreling FROM REL_ING CASCADE
					WHERE NumRelIng IN (
						SELECT f.NumReling
						FROM factura f, acreencia a, recibo r
						WHERE f.IdeFact = a.IdeFact
						AND a.NumAcre = r.NumAcre
						AND r.IdePol = nIdePolElim
					)
				);
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR (
					-20100,
					'Error Obligaciones 2 IdePol = ' ||
					nIdePolElim ||
					' Mensaje ' || 
					SQLERRM
				);
			END;
			--
			BEGIN
				DELETE LIQ_PRE_ADMIN_SALUD
				WHERE IdePreAdmin IN (
					SELECT IdePreAdmin FROM PRE_ADMIN_SALUD
					WHERE IdePol = nIdePolElim
				);
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR (
					-20100,
					'Error LIQ_PRE_ADMIN_SALUD IdePol = ' || 
					nIdePolElim ||
					' Mensaje ' ||
					SQLERRM
				);
			END;
			--
			BEGIN
				DELETE PRE_ADMIN_SALUD
				WHERE IdePol = nIdePolElim;
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR (
					-20100,
					'Error Primeras 4 Tablas IdePol = ' || 
					nIdePolElim ||
					' Mensaje ' || 
					SQLERRM
				);
			END;
			--
			BEGIN
				DELETE FACTURA CASCADE
				WHERE IdeFact IN (
					SELECT a.IdeFact FROM acreencia a, recibo r
					WHERE a.NumAcre = r.NumAcre
					AND r.IdePol = nIdePolElim
				);
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR (
					-20100,
					'Error Factura IdePol = ' ||
					nIdePolElim ||
					' Mensaje ' ||
					SQLERRM
				);
			END;
			--
			BEGIN
				DELETE REL_ING CASCADE
				WHERE NumRelIng IN (
					SELECT f.NumReling
					FROM factura f, acreencia a, recibo r
					WHERE f.IdeFact = a.IdeFact
					AND a.NumAcre = r.NumAcre
					AND r.IdePol = nIdePolElim
				);
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR (
					-20100,
					'Error 0 Tablas IdePol = ' || 
					nIdePolElim ||
					' Mensaje ' || 
					SQLERRM
				);
			END;
			--
			BEGIN
				DELETE REQ_SIN_ASEG
				WHERE IdeAseg IN (
					SELECT IdeAseg FROM ASEGURADO
					WHERE IdePol = nIdePolElim
				);
				--
				DELETE PLAZO_ESPERA_ASEG
				WHERE IdeAseg IN (
					SELECT IdeAseg FROM ASEGURADO
					WHERE IdePol = nIdePolElim
				);
				--
				DELETE ENFE_ASEG
				WHERE IdeAseg IN (
					SELECT IdeAseg FROM ASEGURADO
					WHERE IdePol = nIdePolElim
				);
				--
				DELETE DET_DEMANDA
				WHERE IdeSin IN (
					SELECT IdeSin FROM SINIESTRO
					WHERE IdePol = nIdePolElim
				);
				--
				DELETE APROB_SIN
				WHERE IdeSin IN (
					SELECT IdeSin FROM SINIESTRO
					WHERE IdePol = nIdePolElim
				);
				--
				DELETE DATOS_PARTICULARES_FIANZAS
				WHERE IDEPOL = nIdePolElim;
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR (
					-20100,
					'Error  3 Tablas IdePol = ' || 
					nIdePolElim ||
					' Mensaje ' || 
					SQLERRM
				);
			END;
			--
			BEGIN
				DELETE INSPECCION
				WHERE IdeSin IN (
					SELECT IdeSin
					FROM SINIESTRO
					WHERE IdePol = nIdePolElim
				);
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR (
					-20100,
					'Error Inspeccion IdePol = ' || 
					nIdePolElim ||
					' Mensaje ' || 
					SQLERRM
				);
			END;
			--
			BEGIN
				DELETE SINIESTRO
				WHERE IdePol = nIdePolElim;
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR (
					-20100,
					'Error  SINIESTRO IdePol = ' || 
					nIdePolElim ||
					' Mensaje ' || 
					SQLERRM
				);
			END;
			--
			BEGIN
				DELETE ASEGURADO
				WHERE IdeAseg IN (
					SELECT IdeAseg
					FROM ASEGURADO
					WHERE IdePol = nIdePolElim
				);
			EXCEPTION WHEN OTHERS THEN
				RAISE_APPLICATION_ERROR (
					-20100,
					'Error  9 Tablas IdePol = ' || 
					nIdePolElim ||
					' Mensaje ' || 
					SQLERRM
				);
			END;
			--
			BEGIN
				DELETE RECIBO CASCADE
				WHERE IdePol = nIdePolElim;
				--
				DELETE DIST_FACULT CASCADE
				WHERE IdeGenRea IN (
					SELECT IdeGenRea FROM DIST_REA CASCADE
					WHERE IdePol = nIdePolElim
				);
				--
				DELETE DIST_REA CASCADE
				WHERE IdePol = nIdePolElim;
				--
				DELETE DIST_COA CASCADE
				WHERE IdePol = nIdePolElim;
				--
				DELETE OPER_POL CASCADE
				WHERE IdePol = nIdePolElim;
			EXCEPTION WHEN OTHERS THEN
				DBMS_OUTPUT.put_line ('POLIZA ' || POL.NumPolMig || ' ' || SQLERRM);
			END;
			--
			DELETE OPER_POL CASCADE
			WHERE IdePol = nIdePolElim;
			--
			DELETE POLIZA CASCADE
			WHERE IdePol = nIdePolElim;
			--
			DELETE FROM MOD_ASEG
			WHERE idepol = nIdePolElim;
			--
			DELETE operacion
			WHERE idobjetoop = TO_CHAR (nIdePolElim)
			AND tipoobjetoop = 'POLIZA';		
		END LOOP;

		COMMIT;
	END LOOP;
ROLLBACK;
END;