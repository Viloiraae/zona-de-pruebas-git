#!/bin/bash
#Configuración de conexión silenciosa (sin encabezados ni bordes de tabla)
PSQL="psql -X --username=postgres --dbname=my_database --no-align --tuples-only -c"
#capturamos las dos primeras entradas de terminal en sus variables correspondientes
echo -e "\nIntroduzca el nombre del producto a restablecer y a continuacion la cantidad a reponer"
read -p "Nombre del producto: " PRODUCT_NAME
read -p "Cantidad a reponer: " RESTOCK_AMOUNT
#comprobar si el producto existe en la base de datos
EXISTING_PRODUCT=$($PSQL "SELECT name FROM products where name = '$PRODUCT_NAME';")
while [[ -z "$EXISTING_PRODUCT" ]]
do
#mensaje de error si el producto no existe
echo -e "\nIntroduzca un nombre correcto para el producto a restablecer"
read -p "Nombre del producto: " PRODUCT_NAME
#volvemos a comprobar si el producto existe en la base de datos
EXISTING_PRODUCT=$($PSQL "SELECT name FROM products where name = '$PRODUCT_NAME';")
done
#comprobamos si se ha introducido una cantidad válida (mayor que 0)
while [[ ! "$RESTOCK_AMOUNT" =~ ^[1-9][0-9]*$ ]]
do
#mensaje de error si el campo no es un número entero mayor que 0
echo -e "\nIntroduzca una cantidad válida (número entero mayor que 0)"
read -p "Cantidad a reponer: " RESTOCK_AMOUNT
done
$PSQL "UPDATE products SET stock = stock + $RESTOCK_AMOUNT WHERE name = '$PRODUCT_NAME';" > /dev/null
echo -e "\nSe ha repuesto $RESTOCK_AMOUNT unidades del producto '$PRODUCT_NAME'."
#mensaje de confirmación con el stock actualizado
UPDATED_STOCK=$($PSQL "SELECT stock FROM products WHERE name = '$PRODUCT_NAME';")
echo -e "\nStock actualizado: $UPDATED_STOCK unidades."