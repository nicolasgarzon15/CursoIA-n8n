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
   PROCESO: Error desconocido al intentar recuperar la información de accesorios del vehículo asociado a la póliza XXXXXXXX - ORA-20025: ORA-06512: at "OPS$PUMA.SIM_PCK_AUTOS_CLTVAS_RGOSRENOV", line 1190
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
