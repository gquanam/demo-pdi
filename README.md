# Demo PDI: carga diaria de ventas

Ejemplo de la charla **Introducción a Pentaho Data Integration** (Quanam, octubre de 2026).

El caso: un proveedor deja todos los días un CSV de ventas. Un **job** espera el archivo, lo baja, ejecuta una **transformación** que lo carga en la base y lo mueve a `procesados/`. Si algo falla, manda un mail.

Todos los datos son inventados.

## Qué hay en el repositorio

| Archivo | Qué es |
|---|---|
| `job_carga_ventas.kjb` | El job: espera el archivo, lo baja, llama a la transformación, lo mueve o avisa por mail |
| `trf_carga_ventas.ktr` | La transformación: lee el CSV, filtra filas inválidas, cruza con productos y carga |
| `demo_pdi.ktr` | La transformación del video de Step Metrics: 500.000 ventas desde la base, con lookup cacheado |
| `bd/01_ddl.sql` | Crea el esquema `demo_pdi` y sus tablas |
| `bd/02_datos.sql` | Carga productos, sucursales y 500.000 ventas generadas |
| `entrada/ventas_2026-10-22.csv` | El archivo del proveedor: 20 filas, 3 inválidas a propósito |
| `entrada/generar_ventas_grande.py` | Genera un CSV de 500.000 filas para probar con volumen |
| `procesados/` | Adonde el job mueve el archivo cuando la carga sale bien |

## Requisitos

- Pentaho Data Integration (Spoon) 9.x o 10.x
- PostgreSQL 12 o superior
- Opcional: [smtp4dev](https://github.com/rnwood/smtp4dev), para ver el mail de error sin un servidor de correo real
- Opcional: Python 3, para generar el CSV grande

## Cómo correrlo

### 1. Crear la base

```bash
createdb -U postgres demo_pdi
psql -U postgres -d demo_pdi -f bd/01_ddl.sql
psql -U postgres -d demo_pdi -f bd/02_datos.sql
```

### 2. Configurar la contraseña de la base

La conexión `demo_local` apunta a `localhost:5432/demo_pdi` con el usuario `postgres`. La contraseña no está en los archivos: se toma de la variable `DB_PASSWORD`.

Agregala en `kettle.properties`, que está en la carpeta `.kettle` de tu usuario:

```properties
DB_PASSWORD=tu_contraseña
```

Reiniciá Spoon para que la tome.

### 3. Ejecutar el job

1. Abrí `job_carga_ventas.kjb` en Spoon.
2. Ejecutalo con **Run**.
3. Mirá el resultado en la tabla `demo_pdi.ventas_enriquecidas`. Las filas inválidas no llegan.

> **El paso "Bajar por SFTP" es ilustrativo.** Apunta a `sftp.proveedor.com`, que no existe. Para correr el camino completo, apuntalo a un servidor SFTP propio o deshabilitá ese paso.

### 4. Ver el camino de error

1. Levantá smtp4dev. Escucha el SMTP en el puerto 25 y muestra los mails en http://localhost:5000.
2. Cambiale el nombre a `entrada/ventas_2026-10-22.csv`.
3. Ejecutá el job: "Esperar archivo" falla y el job sigue por la flecha roja hasta "Avisar por mail".
4. En smtp4dev aparece el mail "Falló la carga de ventas".

Después de probar, devolvele al archivo su nombre original.

### 5. Probar con volumen

```bash
cd entrada
python generar_ventas_grande.py
```

Genera `ventas_grande.csv` con 500.000 filas, de las cuales alrededor de 1 cada 1.000 viene sin código de producto. No se versiona: está en `.gitignore`.

Para ver los steps trabajando a la vez, abrí `demo_pdi.ktr`, ejecutala y mirá la pestaña **Step Metrics**.
