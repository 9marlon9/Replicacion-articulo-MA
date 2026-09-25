# Replicación de Eden y Gaggl (2018)

Replicación del resultado cuantitativo principal de Maya Eden y Paul Gaggl,
["On the welfare implications of automation"](https://doi.org/10.1016/j.red.2017.12.003),
*Review of Economic Dynamics* 29 (2018), 15–43.

Se replica la **Tabla 4** (comparación de estados estacionarios), la **Figura 7**
(trayectorias de transición) y la **Figura 8** (bienestar por cohorte). Es de
esa tabla de donde sale la afirmación central del artículo: que el
abaratamiento del capital en TIC explica aproximadamente la mitad de la caída
de la participación del trabajo en el ingreso entre 1950 y 2013.

## Resultado

| | Replicación | Original |
|---|---|---|
| Participación del trabajo, EE inicial (%) | 63,15 | 63,14 |
| Participación del trabajo, EE final (%) | 59,70 | 59,68 |
| Rutina, EE inicial → final (%) | 35,60 → 19,96 | 35,58 → 19,98 |
| No rutina, EE inicial → final (%) | 27,55 → 39,74 | 27,55 → 39,71 |
| Capital TIC, EE inicial → final (%) | 1,80 → 5,25 | 1,81 → 5,27 |
| **Δ participación del trabajo (pp)** | **−3,45** | **−3,46** |
| 100 × Δ log capital TIC | 277,28 | 276,66 |

Ninguna celda de la Tabla 4 se aparta del original en más de 0,03 puntos
porcentuales. Las diferencias son atribuibles al redondeo de los parámetros
publicados.

## Ejecución

Requiere Matlab o GNU Octave. No usa ninguna toolbox ni paquete externo: el
Newton denso, el Newton de banda y la bisección están implementados en `src/`.

Desde la raíz del repositorio:

```matlab
run_all
```

Unos 15 segundos. Escribe todo en `out/`.

Verificado en **GNU Octave 8.4.0** (Linux) y ejecutado en **Matlab R2026a**
(macOS). Los resultados de `out/` en este repositorio provienen de Octave 8.4.0.

## Estructura

```
run_all.m                  script maestro: calibra, resuelve y escribe resultados
src/set_parameters.m       calibración (Tablas 2A y 3)
src/production.m           tecnología CES anidada y productos marginales
src/user_cost.m            costo de uso de largo plazo por tipo de capital
src/labor_alloc.m          asignación intratemporal del trabajo, MPLr = MPLnr
src/steady_state.m         estado estacionario
src/calibrate_tfp.m        nivel de PTF que fija la escala
src/path_allocation.m      asignación y consumo sobre una trayectoria
src/transition_path.m      transición con previsión perfecta, tiempo apilado
src/newton_banded.m        Newton con jacobiano de banda y coloreo CPR
src/newton_solve.m         Newton denso para los sistemas pequeños
src/welfare_gain.m         lambda, ecuación (9)
src/write_table4.m         Tabla 4
src/make_figures.m         Figuras 7 y 8
src/write_diagnostics.m    pruebas de validación
src/ict_series.m           series exógenas del capital TIC
data/                      series del BEA; ver data/README.md
out/                       resultados congelados, para comparar
doc/                       documento de la replicación, en LaTeX y PDF
```

## Método

El equilibrio con previsión perfecta se resuelve por tiempo apilado: las
2(T−1) ecuaciones de Euler del horizonte se escriben como un único sistema no
lineal en las sendas de capital y se resuelven con Newton. El consumo no es
incógnita, se recupera de la restricción de recursos. El jacobiano es de banda
—el residuo de Euler en t solo involucra capital en t, t+1 y t+2— y se
construye con coloreo de Curtis, Powell y Reid, lo que lo reduce de 636 a 26
evaluaciones del residuo.

La transición base converge en 5 iteraciones con residuo de Euler de 3,1e−13.

## Validación

`out/diagnostics.txt` reporta cuatro controles, tres con contraparte teórica
conocida de antemano:

1. Residuos de los sistemas de Euler y de estado estacionario.
2. Si no varía nada exógeno, la transición debe quedarse en el estado
   estacionario inicial. Desvío máximo: 1,7e−10.
3. Las cuatro participaciones deben sumar uno en cada período. Desvío máximo:
   4,4e−16.
4. El último período simulado debe coincidir con el estado estacionario final
   calculado por separado. Diferencia: 1,1e−06.

## Datos

Ver [`data/README.md`](data/README.md) para el formato, la construcción desde
las cuentas detalladas de activos fijos del BEA y el registro de procedencia.

Sin ese archivo el código corre igual, con una aproximación de las dos series
exógenas anclada en los rangos publicados, y lo advierte en consola. La
Tabla 4 no se ve afectada; λ sí.

## Diferencias conocidas respecto al original

- **λ de bienestar.** Con las series aproximadas, λ evaluada en 1980 da 4,75%
  contra el "aproximadamente 4%" del artículo. λ depende de la trayectoria
  anual completa del precio del capital TIC, no solo de sus extremos, porque
  el descuento hace que importe cuándo ocurre la caída. Se cierra al agregar
  las series del BEA.
- **γ y η.** Se recuperan de las constantes de regresión de la Tabla 2A
  (−5,201 y 0,138) y no de los valores impresos 0,005 y 0,535, cuyo redondeo
  desplaza las participaciones unas tres décimas de punto.
- **El contrafactual de la Tabla 4** congela el precio del capital TIC y deja
  correr la depreciación, no ambos. Es lo que dice la nota de la tabla
  original y lo único compatible con sus cifras.
- **Fuera de alcance.** Las columnas de rutina y no rutina de la Tabla 1 del
  artículo requieren microdatos del Current Population Survey vía IPUMS, y la
  calibración de su Tabla 2 requiere además las cuentas del BEA. Aquí esos
  parámetros se toman como dados.

## Licencia y atribución

El código está bajo licencia MIT; ver [`LICENSE`](LICENSE).

El trabajo original es de Maya Eden y Paul Gaggl. Este repositorio es una
replicación independiente con fines académicos y no contiene el artículo ni el
paquete de replicación de los autores. Existe una versión libre del artículo
como Policy Research Working Paper 7487 del Banco Mundial.

Trabajo realizado para el curso de Macroeconomía Avanzada de la maestría PEG,
Universidad de los Andes.
