#!/bin/bash

# ==============================================================================
# Script: queries.sh
# Descripción: Genera el reporte ejecutivo de métricas del inventario desde PostgreSQL.
# ==============================================================================

# Configuración de conexión silenciosa (sin encabezados ni bordes de tabla)
PSQL="psql -X --username=postgres --dbname=my_database --no-align --tuples-only -c"
echo -e "\n=== REPORTE EJECUTIVO DE INVENTARIO ==="
# 1. Conteo global de SKUs activos en el catálogo
echo -e "\n1. Total de productos en catálogo:"
echo "$($PSQL "SELECT COUNT(*) FROM products;")"
# 2. Valoración financiera total (precio unitario * unidades físicas disponibles)
echo -e "\n2. Valor total del inventario: ($)"
echo "$($PSQL "SELECT SUM(price * stock) FROM products;")"
# 3. Distribución de stock por categoría (ordenada de mayor a menor volumen)
echo -e "\n3. Unidades totales en stock por categoría:"
echo "$($PSQL "SELECT c.name, SUM(p.stock) FROM products p INNER JOIN categories c ON p.category_id = c.category_id GROUP BY c.name ORDER BY SUM(p.stock) DESC;")"
# 4. Alerta de reposición: productos por debajo del umbral mínimo (menos de 10 unidades)
# Pista: Muestra nombre del producto, nombre de su categoría y stock actual, ordenado por stock ascendente.
echo -e "\n4. productos con bajo stock (<10 unidades):"
echo "$($PSQL "SELECT p.name, c.name, p.stock FROM products p INNER JOIN categories c ON p.category_id = c.category_id WHERE p.stock < 10 ORDER BY p.stock ASC;")"
echo -e "\n=========================================="