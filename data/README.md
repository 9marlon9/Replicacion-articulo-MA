# Datos

El modelo se alimenta de dos series exógenas, 1950–2013: el precio relativo
del capital TIC y su tasa de depreciación. Todo lo demás son parámetros fijos
tomados de las Tablas 2A y 3 del artículo.

## Formato esperado

Un archivo `ict_series.csv` en esta carpeta, con encabezado y una fila por año:

```
year,pc,dc
1950,1.7270,0.1370
1951,...,...
```

| Columna | Definición |
|---|---|
| `year` | Año |
| `pc` | Deflactor implícito del capital TIC dividido por el deflactor del PIB |
| `dc` | Tasa de depreciación del capital TIC |

`src/ict_series.m` detecta el archivo y lo usa. Si no existe, construye una
aproximación logística anclada en los rangos de la Tabla 3 del artículo y
avisa de ello en consola. La Tabla 4 es invariante a esta elección porque solo
usa los valores inicial y final; λ no lo es, porque depende de la trayectoria
completa vía el descuento.

## Construcción desde el BEA

Fuente: *Detailed Data for Fixed Assets and Consumer Durable Goods*, Bureau of
Economic Analysis.

Se clasifican los activos en TIC y no TIC según las Tablas A.7 y A.8 del
artículo. Dentro de los activos no residenciales, son TIC los códigos que
empiezan por `EP`, `EN`, `RD2` o `RD4`. Dentro de bienes durables de consumo,
son TIC `1RGPC`, `1RGCS`, `1RGCA` y `1OD50`.

Con esa partición:

- `pc` sale de agregar los índices de precios encadenados de los activos TIC
  con la fórmula ideal de Fisher y dividir por el deflactor del PIB.
- `dc` sale de la definición de la nota al pie 6 del artículo,
  `delta = Dep / (NetStock + Dep)`, con ambos en valores nominales de fin de
  año, de modo que los precios se cancelan.

## Procedencia

El BEA revisa estas cuentas cada año, así que una serie sin fecha de descarga
no es replicable. Al agregar `ict_series.csv`, registrar aquí:

Tabla del BEA:
Fecha de publicación de la versión utilizada:
Fecha de descarga:
Script de construcción:

## Alternativa

El paquete de replicación de los autores incluye estas series ya construidas.
Está disponible en el archivo de código y datos de *Review of Economic
Dynamics*, referencia 16-380. No se redistribuye aquí.
