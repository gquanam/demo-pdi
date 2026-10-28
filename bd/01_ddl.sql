-- =====================================================================
-- BD de prueba para la charla "Introducción a PDI"
-- Datos inventados. PostgreSQL 12 o superior.
--
-- Caso: un proveedor deja todos los días un CSV de ventas.
-- PDI lo lee, descarta filas inválidas, cruza con el maestro de
-- productos, calcula el total y carga el resultado.
-- =====================================================================

DROP SCHEMA IF EXISTS demo_pdi CASCADE;
CREATE SCHEMA demo_pdi;
SET search_path TO demo_pdi;

-- Maestro de productos: la tabla contra la que se hace el Database lookup
CREATE TABLE productos (
    codigo_producto  varchar(10)   PRIMARY KEY,
    nombre           varchar(100)  NOT NULL,
    categoria        varchar(50)   NOT NULL,
    precio_lista     numeric(10,2) NOT NULL
);

-- Sucursales (para darle realismo al CSV)
CREATE TABLE sucursales (
    codigo_sucursal  varchar(5)    PRIMARY KEY,
    nombre           varchar(100)  NOT NULL,
    departamento     varchar(50)   NOT NULL
);

-- Ventas ya cargadas en la base: origen del Table input de demo_pdi.ktr
CREATE TABLE ventas (
    id               serial        PRIMARY KEY,
    fecha            date          NOT NULL,
    nro_ticket       integer       NOT NULL,
    codigo_producto  varchar(10)   NOT NULL,
    cantidad         integer       NOT NULL,
    precio_unitario  numeric(10,2) NOT NULL,
    codigo_sucursal  varchar(5)    NOT NULL
);

-- Destino de la carga (Table output de demo_pdi.ktr y de trf_carga_ventas.ktr)
CREATE TABLE ventas_enriquecidas (
    fecha            date,
    nro_ticket       integer,
    codigo_producto  varchar(10),
    nombre_producto  varchar(100),
    categoria        varchar(50),
    cantidad         integer,
    precio_unitario  numeric(10,2),
    total            numeric(12,2),
    codigo_sucursal  varchar(5),
    fecha_carga      timestamp     DEFAULT now()
);

-- Filas descartadas (para probar el manejo de errores por step)
CREATE TABLE ventas_rechazadas (
    fecha            varchar(20),
    nro_ticket       varchar(20),
    codigo_producto  varchar(10),
    cantidad         varchar(20),
    precio_unitario  varchar(20),
    codigo_sucursal  varchar(5),
    motivo           varchar(200),
    fecha_carga      timestamp     DEFAULT now()
);

-- Nota: para mostrar logging a tabla no hace falta crear nada acá.
-- En Spoon: Transformation properties > Logging > botón SQL, y PDI
-- genera la tabla de log con la estructura que necesita.
