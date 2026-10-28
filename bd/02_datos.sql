-- =====================================================================
-- Datos de prueba. Correr después de 01_ddl.sql.
-- =====================================================================
SET client_encoding = 'UTF8';  -- evita problemas con tildes al correrlo desde psql en Windows
SET search_path TO demo_pdi;

INSERT INTO productos (codigo_producto, nombre, categoria, precio_lista) VALUES
('P001', 'Yerba mate 1 kg',            'Almacén',   245.00),
('P002', 'Arroz 1 kg',                 'Almacén',    68.00),
('P003', 'Fideos tallarín 500 g',      'Almacén',    52.00),
('P004', 'Aceite de girasol 900 ml',   'Almacén',   119.00),
('P005', 'Dulce de leche 1 kg',        'Almacén',   189.00),
('P006', 'Leche entera 1 L',           'Lácteos',    42.00),
('P007', 'Queso colonia 500 g',        'Lácteos',   330.00),
('P008', 'Manteca 200 g',              'Lácteos',    98.00),
('P009', 'Agua mineral 2 L',           'Bebidas',    75.00),
('P010', 'Refresco cola 2,25 L',       'Bebidas',   135.00),
('P011', 'Cerveza 1 L',                'Bebidas',   149.00),
('P012', 'Vino tannat 750 ml',         'Bebidas',   390.00),
('P013', 'Detergente 750 ml',          'Limpieza',   89.00),
('P014', 'Jabón en polvo 800 g',       'Limpieza',  210.00),
('P015', 'Papel higiénico x4',         'Limpieza',  115.00);

INSERT INTO sucursales (codigo_sucursal, nombre, departamento) VALUES
('S01', 'Centro',        'Montevideo'),
('S02', 'Pocitos',       'Montevideo'),
('S03', 'Ciudad Vieja',  'Montevideo'),
('S04', 'Ciudad de la Costa', 'Canelones'),
('S05', 'Maldonado',     'Maldonado');

-- 500.000 ventas generadas, para que demo_pdi.ktr
-- tarde unos segundos y se vean subir los contadores en Step Metrics.
INSERT INTO ventas (fecha, nro_ticket, codigo_producto, cantidad, precio_unitario, codigo_sucursal)
SELECT
    date '2026-10-01' + ((g / 3) % 21),
    100000 + g / 3,
    'P' || lpad((1 + g % 15)::text, 3, '0'),
    1 + (g * 7) % 6,
    p.precio_lista,
    'S0' || (1 + (g * 3) % 5)
FROM generate_series(1, 500000) g
JOIN productos p ON p.codigo_producto = 'P' || lpad((1 + g % 15)::text, 3, '0');

ANALYZE productos;
ANALYZE ventas;
