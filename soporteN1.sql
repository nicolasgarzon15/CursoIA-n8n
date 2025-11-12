-- Agregar soluciones a Incidentes y Service Request recurrentes, y la estructura de las tablas involucradas a la solucion..

	..
	/* ============================================================
	   PROCESO: Validación y rehabilitación de accesorios dados de baja
	   USO: Agentes Nivel 1 desde n8n
	   OBJETIVO: Identificar accesorios con estado de baja incorrecto
	   ============================================================ */
	/* ------------------------------------------------------------
	   PASO 1. CONSULTA PARA VALIDAR ACCESORIOS ASOCIADOS A UNA PÓLIZA
	   El agente debe reemplazar &num_pol1 por el número de póliza 
	   reportado en el ticket (13 dígitos).
	   ------------------------------------------------------------ */
	Select b.num_end,
		   b.cod_acces,
		   b.mca_baja,
		   a.num_pol1,
		   a.cod_cia,
		   a.cod_ramo
	from a2000030 a
	inner join a2040200 b on b.num_secu_pol = a.num_secu_pol
	where a.num_pol1 = &num_pol1
	  and a.cod_cia = 3            -- Compañía 3: Seguros Bolívar
	  and a.cod_ramo = 250         -- Producto 250: Automóviles
	  and a.cod_secc = 1;          -- Sección 1
	/* ------------------------------------------------------------
	   PASO 2. INTERPRETACIÓN DE RESULTADOS
	   Reglas:
		 1. Cada accesorio se identifica por cod_acces.
		 2. El accesorio debe aparecer solo en un endoso.
		 3. mca_baja = 'N'  → Accesorio activo.
		 4. mca_baja = 'S'  → Accesorio dado de baja.
	   Acción:
		 Si aparece un accesorio en un solo endoso y tiene mca_baja = 'S',
		 debe ser rehabilitado.
	   ------------------------------------------------------------ */
	/* EJEMPLO DE SALIDA ESPERADA
	NUM_END | COD_ACCES | MCA_BAJA | NUM_POL1     | COD_CIA | COD_RAMO
	--------+-----------+----------+---------------+---------+----------
	0       | 0         | N        | 1234567890123 |    3    |   250
	1       | 1         | N        | 1234567890123 |    3    |   250
	2       | 2         | S        | 1234567890123 |    3    |   250
	3       | 3         | N        | 1234567890123 |    3    |   250
	*/
	/* ------------------------------------------------------------
	   PASO 3. ACCIONES SEGÚN EL RESULTADO
	   - Si un accesorio aparece en un único endoso y tiene mca_baja = 'S':
		   Escalar para ejecutar script de rehabilitación.
	   - Si varios endosos contienen el accesorio y al menos uno tiene 'N':
		   No realizar acción. Registrar y cerrar.
	   ------------------------------------------------------------ */
	..
	..
	/* ============================================================
	   PROCESO: Error desconocido al intentar recuperar la información de accesorios del vehículo asociado a la póliza XXXXXXXX - ORA-20025: ORA-06512: at "OPS$PUMA.SIM_PCK_AUTOS_CLTVAS_RGOSRENOV", line 1190 , jira referencia MDSB-846470
	   USO: Agentes Nivel 1 desde n8n
	   OBJETIVO: Identificar accesorios con cod_acces inválido
	   ============================================================ */
	/* ------------------------------------------------------------
	   PASO 1. CONSULTA PARA VALIDAR ACCESORIOS CON COD_ACCES INVÁLIDO
	   El agente debe reemplazar &num_pol1 por el número de póliza 
	   reportado en el ticket (13 dígitos).
	   ------------------------------------------------------------ */

	SELECT  DISTINCT a.num_secu_pol,
		   a.cod_ries,
		   a.cod_acces,
		   a.desc_acces
	  FROM a2040200 a
	 WHERE a.num_secu_pol = (       SELECT DISTINCT NUM_SECU_POL FROM A2000030 WHERE NUM_POL1=&num_pol1)
	   AND NOT EXISTS (
			 SELECT 1
			   FROM a1041100 m
			  WHERE m.cod_cia   = 3  
				AND m.cod_acces = a.cod_acces
		   );


	/* ------------------------------------------------------------
	   PASO 2. INTERPRETACIÓN DE RESULTADOS
	   Reglas:
		 1. En caso de devolver algún registro es porque los datos en el campo DESC_ACCES refieren a que no existe el accesorio
	   ------------------------------------------------------------ */
	/* EJEMPLO DE SALIDA ESPERADA
	NUM_SECU_POL | COD_RIES | COD_ACCES | DESC_ACCES     |
	--------+-----------+----------+---------------+---------+----------
	29810750539  | 194      | 0         | UNDEFINED      |
	*/
	/* ------------------------------------------------------------
	   PASO 3. ACCIONES SEGÚN EL RESULTADO
	   -   El alcance para solucionar este error, es informar al usuario el riesgo que debe ser excluido de la renovación fallida, este riesgo se encuentra en el excel que el 
		  usuario está cargando en Simon Web
	   ------------------------------------------------------------ */
	..
	..
	..
	..
	/* ============================================================
	   PROCESO: Error póliza de autos tiene la fecha de vigencia incorrecta, JIRA REFERENCIA MDSB-633504
	   USO: Agentes Nivel 1 desde n8n
	   OBJETIVO: Identificar inconsistencias en la fehca de vigencia de la póliza, esta fecha debe ser la misma sin importar de haber creado un nuevo endoso, debe ser la misma desde la emisión.
	   ============================================================ */
	/* ------------------------------------------------------------
	   PASO 1. se debe consultar desde qué endoso se hizo el cambio de fecha de vigencia y que el campo cod_end sea 730.
	   ------------------------------------------------------------ */

		SELECT * FROM a2000030 a 
		WHERE a.cod_cia=3
		AND a.COD_SECC =1
		AND a.cod_end=730
		AND a.num_pol1 IS NOT NULL
		AND a.fecha_emi_end >= sysdate-360
		AND EXISTS (SELECT '' FROM a2000030 b WHERE b.NUM_SECU_POL=a.NUM_SECU_POL AND b.num_end = a.num_end-1 
		AND b.fecha_vig_pol != a.fecha_vig_pol);


	/* ------------------------------------------------------------
	   PASO 2. INTERPRETACIÓN DE RESULTADOS
	   Reglas:
		 1. Si la consulta anterior trae registros, tomar el número de póliza y consultar en la tabla A2000030 y a2000163 y validar cuáles son los endosos que tienen el campo FECHA_VIG_POL erróneo.
	   ------------------------------------------------------------ */

		SELECT a.FECHA_VIG_POL, a.* FROM a2000030 a
		WHERE  a.num_pol1 IN (&num_pol1);----num_Pol1

		SELECT a.FECHA_VIG_POL, a.* FROM a2000163 a
		WHERE  a.num_secu_pol IN (&num_secu_pol);----num_secu_pol

	/* ------------------------------------------------------------
	   PASO 3. ACCIONES PARA SOLUCIONAR EJECUTAR EL SIGUIENTE SCRIPT
	   -   
	   ------------------------------------------------------------ */


			SET SERVEROUTPUT ON SIZE 1000000
			SET LINESIZE 2300
			SET PAGESIZE 10000
			SET HEADING ON
			SET NUMWIDTH 17
			SET FEEDBACK ON
			SET trimspool ON
			SET TRIM ON
			SET COLSEP ';' 
			DEFINE Ruta=&1;
			SPOOL &ruta;
			DECLARE
				l_cant_reg_seg   NUMBER := 11; -- definir aqui la cantidad maxima de registros que se espera modificar
				reporegistros    NUMBER := 0;
			BEGIN
				dbms_output.enable(NULL);
				dbms_output.put_line('INICIA PROCESO ' || to_char(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));

				UPDATE a2000030
				SET fecha_vig_pol =  TO_DATE('31072024','DDMMYYYY') 
				WHERE NUM_SECU_POL =29808157160 AND num_end>=3;
				reporegistros := reporegistros + SQL%ROWCOUNT;--5

				UPDATE a2000163
				SET FECHA_VIG_POL = TO_DATE('31072024','DDMMYYYY') 
				WHERE NUM_SECU_POL =29808157160 AND NUM_FACTURA >=3;
				reporegistros := reporegistros + SQL%ROWCOUNT;--6


				IF reporegistros = l_cant_reg_seg THEN
					dbms_output.put_line(reporegistros || ' REGISTROS ACTUALIZADOS CON EXITO.');
					COMMIT;
				ELSE
					dbms_output.put_line('<<<<<<<<<<< ERROR AL ACTUALIZAR ' || reporegistros || ' REGISTROS.');
					ROLLBACK;
				END IF;
				dbms_output.put_line('TERMINA PROCESO ' || to_char(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
			EXCEPTION
				WHEN OTHERS THEN
					dbms_output.put_line('<<<<<<<<<<< HA OCURRIDO UN ERROR: ' || SQLERRM);
					dbms_output.put_line('TERMINA PROCESO ' || to_char(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
					ROLLBACK;
			END;
			/
			SPOOL OFF
			PAUSE Presione una tecla para terminar ejecucion
			EXIT



	..

/* ============================================================
   PROCESO: Validación de error 299GCI997 - "VALORES ERRÓNEOS AL LLAMAR MOTOR DE TARIFA"
   USO: Agentes Nivel 1 (Ejecución desde n8n o SQL Developer)
   OBJETIVO: Identificar registros en SB_ERROR_LOG asociados al error ORA-20000 
             y la regla 299GCI997, para validar inconsistencias en el proceso 
             de liquidación o formalización de pólizas.
   ============================================================ */
/* ------------------------------------------------------------
   PASO 1. CONSULTA DE VALIDACIÓN DE ERROR EN MOTOR DE TARIFA
   El agente debe modificar los valores del bloque "parametros":
     - FECHA_ERROR: Fecha desde la cual se desea revisar errores.
     - NUMERO_SECUENCIA_POLIZA: Secuencia de póliza asociada al error.
   No modificar la hora si no es estrictamente necesario.
   ------------------------------------------------------------ */

WITH parametros AS (
  -- VALORES POR MODIFICAR
  SELECT 
    TO_TIMESTAMP('2025-07-30 00:00:00', 'YYYY-MM-DD HH24:MI:SS') AS FECHA_ERROR,  -- Fecha desde la cual se presenta el error
    '39745355300' AS NUMERO_SECUENCIA_POLIZA                                          -- Número de secuencia de póliza
  FROM dual
)
SELECT l.* 
FROM SB_ERROR_LOG l, parametros p
WHERE l.time_stamp BETWEEN p.FECHA_ERROR AND SYSDATE
  AND l.id_mensaje = '1973'
  AND l.description LIKE '%299GCI997%' || p.NUMERO_SECUENCIA_POLIZA || '%';

/* ------------------------------------------------------------
   PASO 2. INTERPRETACIÓN DE RESULTADOS
   Reglas:
     1. Los registros encontrados pertenecen al log de errores del motor de tarifa.
     2. Si se visualizan filas con el código de regla 299GCI997 y secuencia de póliza,
        el error está activo o fue registrado.
     3. El campo ID_MENSAJE = '1973' corresponde a errores del tipo ORA-20000.
   Acción:
     - Validar con los especialistas de Nivel 1 si el error se repite o es masivo.
     - Si hay múltiples ocurrencias recientes, escalar a desarrollo para análisis
       del servicio de cotización / formalización.
   ------------------------------------------------------------ */
/* EJEMPLO DE SALIDA ESPERADA
TIME_STAMP           | ID_MENSAJE | DESCRIPTION
---------------------+------------+----------------------------------------------
2025-07-30 01:35:21  | 1973       | 299GCI997> VALORES ERRONEOS AL LLAMAR MOTOR DE TARIFA 39745355300
2025-07-30 01:37:15  | 1973       | 299GCI997> VALORES ERRONEOS AL LLAMAR MOTOR DE TARIFA 39745355300
*/

/* ------------------------------------------------------------
   PASO 3. ACCIONES SEGÚN RESULTADO
   - Si existen registros:
       Validar consistencia en el proceso de cotización o formalización.
       Escalar al área de desarrollo si el error persiste.
   - Si no existen registros:
       Confirmar cierre del incidente.
   ------------------------------------------------------------ */
/* ------------------------------------------------------------
   REFERENCIAS Y DOCUMENTACIÓN
   - JIRA: MDSB-856535
     https://jirasegurosbolivar.atlassian.net/browse/MDSB-856535
   - RUNBOOK CONFLUENCE:
     https://jirasegurosbolivar.atlassian.net/wiki/spaces/BDCT/pages/755302410/
       299GCI997+Error+regla+VALORES+ERRONEOS+AL+LLAMAR+MOTOR+DE+TARIFA
   - PROPIETARIO: Mario Alejandro Simus
   - BASE DE DATOS: Tronador
   - ESQUEMA: OPS$PUMA
   - AMBIENTE: Producción
   ============================================================ */	

	..

/* ============================================================
   PROCESO: Monitoreo y Validación de Transmisiones RUNT – SOAT
   USO: Agentes Nivel 1 (GDI / PROCEDATOS / OPERACIONES)
   OBJETIVO: Identificar movimientos de pólizas con fallas en la 
             transmisión al RUNT, errores en respuesta o pendientes
             por confirmación.
   ============================================================ */
/* ------------------------------------------------------------
   PASO 1. MONITOR 001 – PÓLIZAS NO TRANSMITIDAS O CON ERRORES 
   Consulta para identificar pólizas con estado "RECHAZADO" 
   en la tabla SOAT_RESPUESTA_RUNT_DETALLE y con más de 10 
   registros fallidos en las últimas 24 horas.
   ------------------------------------------------------------ */

SELECT 
    D.FECHA_ENVIO,
    D.NRO_ENVIO,
    A.PLACA,
    A.ENDOSO,
    A.ESTADO,
    B.VIN,
    B.MARCA_ENVIO_RUNT,
    C.TDOC_PROPIETARIO AS TIPO_DE_DOCUMENTO,
    C.ID_PROPIETARIO   AS NUMERO_DOCUMENTO
FROM 
    ops$puma.SOAT_RESPUESTA_RUNT_DETALLE A
INNER JOIN 
    SIM_DATOSSOAT B 
    ON B.NRO_SOAT = A.POLIZA 
    AND B.NUM_END = A.ENDOSO
LEFT JOIN 
    SIM_INFORMACION_RUNT C 
    ON C.IG_PAT_VEH = A.PLACA
INNER JOIN 
    SIM_RUNT D 
    ON D.NUM_POL1 = A.POLIZA 
    AND D.NUM_END = A.ENDOSO
WHERE 
    A.FILE_id IN (
        SELECT file_id
        FROM ops$puma.SOAT_RESUMEN_CARGUE_RUNT
        WHERE Registros_fallidos >= 10
          AND fecha_creacion >= TRUNC(SYSDATE - 1)
    )
  AND A.ESTADO = 'RECHAZADO';

/* ------------------------------------------------------------
   PASO 2. MONITOR 002 – MOVIMIENTOS PENDIENTES O CON ERROR
   Consulta de verificación para identificar transmisiones 
   con más del 20% de movimientos con marca 'S' (enviados)
   y al menos 10 pendientes ('P') en las últimas 24 horas.
   ------------------------------------------------------------ */

SELECT 
    a.NRO_ENVIO            AS nro_envio_p, 
    a.FECHA_ENVIO          AS fecha_envio_p,
    a.usuario,
    COUNT(*)               AS total_registros,
    SUM(CASE WHEN b.MARCA_ENVIO_RUNT = 'P' THEN 1 ELSE 0 END) AS total_P,
    SUM(CASE WHEN b.MARCA_ENVIO_RUNT = 'S' THEN 1 ELSE 0 END) AS total_S,
    ROUND(
        100.0 * SUM(CASE WHEN b.MARCA_ENVIO_RUNT = 'S' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS porcentaje_N
FROM 
    sim_runt a
JOIN 
    sim_datossoat b 
    ON b.num_secu_pol = a.num_secu_pol 
    AND b.num_end = a.num_end
WHERE 
    a.FECHA_ENVIO >= TRUNC(SYSDATE - 1)
    AND a.nro_envio != 99
GROUP BY 
    a.NRO_ENVIO, 
    a.FECHA_ENVIO,
    a.usuario
HAVING 
    ROUND(
        100.0 * SUM(CASE WHEN b.MARCA_ENVIO_RUNT = 'S' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) > 20 
    AND SUM(CASE WHEN b.MARCA_ENVIO_RUNT = 'P' THEN 1 ELSE 0 END) >= 10;

/* ------------------------------------------------------------
   PASO 3. CONSULTA DETALLE DE PLACAS CON MOVIMIENTOS PENDIENTES
   A partir de los resultados del paso anterior, obtener las 
   placas y documentos asociados a los envíos pendientes.
   ------------------------------------------------------------ */

WITH parametros AS (
  -- VALORES POR MODIFICAR (puede filtrarse por fecha/envío si se requiere)
  SELECT 
    a.NRO_ENVIO     AS nro_envio_p, 
    a.FECHA_ENVIO   AS fecha_envio_p,
    a.usuario,
    COUNT(*) AS total_registros,
    SUM(CASE WHEN b.MARCA_ENVIO_RUNT = 'P' THEN 1 ELSE 0 END) AS total_P,
    SUM(CASE WHEN b.MARCA_ENVIO_RUNT = 'S' THEN 1 ELSE 0 END) AS total_S,
    ROUND(
        100.0 * SUM(CASE WHEN b.MARCA_ENVIO_RUNT = 'S' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS porcentaje_N
  FROM 
    sim_runt a
  JOIN 
    sim_datossoat b 
    ON b.num_secu_pol = a.num_secu_pol 
    AND b.num_end = a.num_end
  WHERE 
    a.FECHA_ENVIO >= TRUNC(SYSDATE - 1)
    AND a.nro_envio != 99
  GROUP BY 
    a.NRO_ENVIO, 
    a.FECHA_ENVIO,
    a.usuario
  HAVING 
    ROUND(
        100.0 * SUM(CASE WHEN b.MARCA_ENVIO_RUNT = 'S' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) > 20 
    AND SUM(CASE WHEN b.MARCA_ENVIO_RUNT = 'P' THEN 1 ELSE 0 END) >= 10
)
SELECT 
    s.num_pol1,
    s.num_end,
    s.PAT_VEH     AS placa,
    s.NRO_DOCUMTO,
    s.NOM_TERCERO,
    d.MARCA_ENVIO_RUNT,
    d.VIN,
    s.FECHA_ENVIO,
    s.nro_envio 
FROM 
    sim_runt s
INNER JOIN 
    sim_datossoat d 
    ON d.nro_soat = s.num_pol1  
    AND d.num_end = s.num_end 
    AND d.marca_envio_runt = 'P' -- PENDIENTES
INNER JOIN 
    parametros p  
    ON p.FECHA_ENVIO_P = s.FECHA_ENVIO
    AND p.NRO_ENVIO_P = s.NRO_ENVIO;

/* ------------------------------------------------------------
   INTERPRETACIÓN DE RESULTADOS
   ------------------------------------------------------------
   MONITOR 001 → Pólizas RECHAZADAS
       - Validar si el archivo fue cargado correctamente.
       - Si el error persiste en varios registros, escalar a PROCEDATOS.
   MONITOR 002 → Movimientos Pendientes
       - Confirmar con el equipo RUNT si el movimiento fue recibido.
       - Si se reprocesó y continúa fallando, escalar a OPERACIONES.
   DETALLE (Paso 3)
       - Permite identificar placas y pólizas con estado 'P'.
       - Revisar integridad de la información y reintentar transmisión.
   ------------------------------------------------------------
   REFERENCIAS Y DOCUMENTACIÓN
   - JIRA: MDSB-823237
     https://jirasegurosbolivar.atlassian.net/browse/MDSB-823237
   - RUNBOOK CONFLUENCE:
     https://jirasegurosbolivar.atlassian.net/wiki/spaces/BDCT/pages/366608385
   - DASHBOARD GRAFANA:
     https://grafana.segurosbolivar.com:3000/d/1b85204d-ff61-43e6-9cee-5405f2f5e574/estado-transmision-al-runt
   - PROPIETARIO: Mario Alejandro Simus Barrios
   - BASE DE DATOS: Tronador
   - ESQUEMA: OPS$PUMA
   - AMBIENTE: Producción
   ============================================================ */
  ..
