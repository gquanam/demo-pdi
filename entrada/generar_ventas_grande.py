"""Genera ventas_grande.csv (500.000 filas) para probar con volumen (Step Metrics).

Mismo formato que ventas_2026-10-22.csv. Alrededor de 1 de cada 1.000 filas
viene sin código de producto, para que el Filter rows tenga algo que descartar.

Uso:  python generar_ventas_grande.py  [cantidad_de_filas]
"""
import csv
import random
import sys

FILAS = int(sys.argv[1]) if len(sys.argv) > 1 else 500_000

PRECIOS = {
    "P001": "245.00", "P002": "68.00", "P003": "52.00", "P004": "119.00",
    "P005": "189.00", "P006": "42.00", "P007": "330.00", "P008": "98.00",
    "P009": "75.00", "P010": "135.00", "P011": "149.00", "P012": "390.00",
    "P013": "89.00", "P014": "210.00", "P015": "115.00",
}
CODIGOS = list(PRECIOS)
SUCURSALES = ["S01", "S02", "S03", "S04", "S05"]

random.seed(42)  # siempre el mismo archivo

with open("ventas_grande.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["fecha", "nro_ticket", "codigo_producto", "cantidad",
                "precio_unitario", "codigo_sucursal"])
    for i in range(FILAS):
        codigo = random.choice(CODIGOS)
        w.writerow([
            f"2026-10-{1 + (i // 3) % 21:02d}",
            300000 + i // 3,
            "" if random.random() < 0.001 else codigo,
            random.randint(1, 6),
            PRECIOS[codigo],
            random.choice(SUCURSALES),
        ])

print(f"ventas_grande.csv generado con {FILAS:,} filas")
