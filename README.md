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

## Cómo reproducir

Sin instalar nada: **[abrir en MATLAB Online](https://matlab.mathworks.com/open/github/v1?repo=9marlon9/Replicacion-articulo-MA&file=run_all.m)**,
que carga el repositorio listo para correr. Requiere una cuenta de MathWorks.

Localmente, en cambio:

**1. Descargar el repositorio.**

```
git clone https://github.com/9marlon9/Replicacion-articulo-MA.git
```



**2. Abrir Matlab u Octave** y situarse en la **raíz** de la carpeta, no en
`src/`: `run_all` agrega esa subcarpeta a la ruta de forma relativa.

**3. Ejecutar.**

```matlab
run_all
```





Trabajo realizado para el curso de Macroeconomía Avanzada de la maestría PEG,
Universidad de los Andes.
