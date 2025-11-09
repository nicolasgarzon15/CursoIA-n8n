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

..
