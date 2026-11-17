#!/bin/bash
#Configuración de conexión silenciosa (sin encabezados ni bordes de tabla)
PSQL="psql -X --username=postgres --dbname=my_database --no-align --tuples-only -c"
#capturamos las dos primeras entradas de terminal en sus variables correspondientes
PRODUCT_NAME=$1
RESTOCK_AMOUNT=$2
EXISTING_PRODUCT=$($PSQL "SELECT product_id FROM products where name = '$PRODUCT_NAME';")
#comprobar si el producto existe en la base de datos
while [[ -z "$EXISTING_PRODUCT" ]]
do
echo -e "\nIntroduzca el nombre del producto a restablecerr y a continuacion la cantidad a reponer"
read -p "Nombre del producto: " PRODUCT_NAME
read -p "Cantidad a reponer: " RESTOCK_AMOUNT
#volvemos a comprobar si el producto existe en la base de datos
EXISTING_PRODUCT=$($PSQL "SELECT product_id FROM products where name = '$PRODUCT_NAME';")
done
