#!/bin/bash
# Sell script
#Configuración de conexión silenciosa (sin encabezados ni bordes de tabla)
PSQL="psql -X --username=postgres --dbname=my_database --no-align --tuples-only -c"
#Selección y validación del producto de venta
echo "Ingrese el nombre del producto que desea vender:"
read -r PRODUCT_NAME
#validacion del formato del nombre del producto
while [[ ! $PRODUCT_NAME =~ ^[a-zA-Z0-9_.-]+( [a-zA-Z0-9_.-]+)*$ ]]
do
  echo -e "\nPor favor, ingrese un nombre de producto válido"
  read -r PRODUCT_NAME
done
#comprobamos si el producto existe en la base de datos
EXISTING_PRODUCT=$($PSQL "SELECT name FROM products WHERE name = '$PRODUCT_NAME';")
#validacion de existencia del producto
if [[ -z $EXISTING_PRODUCT ]]
then
  echo -e "\nEl producto '$PRODUCT_NAME' no se encuentra registrado, el proceso de venta no puede continuar."
  #El script termina si el producto no existe
  exit 0
  fi
echo -e "\nIngrese la cantidad que desea vender:"
read SELL_AMOUNT
#validacion del formato de la cantidad a vender
while [[ ! $SELL_AMOUNT =~ ^[1-9][0-9]*$ ]]
do
  echo -e "\nPor favor, ingrese una cantidad válida"
  read -r SELL_AMOUNT
done
