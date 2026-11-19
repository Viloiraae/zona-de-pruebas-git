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
EXISTING_PRODUCT=$($PSQL "SELECT name FROM products WHERE name ILIKE '$PRODUCT_NAME';")
if [[ -z "$EXISTING_PRODUCT" ]]
    then
    #comprobamos si hay un producto similar en la base de datos
    EXISTING_PRODUCT=$($PSQL "SELECT name FROM products WHERE name ILIKE '%$PRODUCT_NAME%';")
    if [[ -n "$EXISTING_PRODUCT" ]]
        then
        #Si aparecen uno o mas productos similares
        COUNT=$(echo "$EXISTING_PRODUCT" | wc -l)
        if [[ $COUNT -eq 1 ]]
            then
            echo -e "\nTe refieres a '$EXISTING_PRODUCT'? (s/n)"
            read -r RESPONSE
                if [[ $RESPONSE =~ ^[Ss]$ ]]
                    then
                    PRODUCT_NAME=$EXISTING_PRODUCT
                    else
                    #El script termina el proceso de venta si el producto no existe
                    echo -e "\nEl producto '$PRODUCT_NAME' no se encuentra registrado, el proceso de venta no puede continuar."
                    exit 1
                fi
            else
            echo -e "\nSe han encontrado varios productos similares a '$PRODUCT_NAME':"
            echo "$EXISTING_PRODUCT"
            echo -e "\nElija una opcion y vuelva al proceso de venta"
            exit 1
        fi 
        else
        #El script termina el proceso de venta si el producto no existe
        echo -e "\nEl producto '$PRODUCT_NAME' no se encuentra registrado, el proceso de venta no puede continuar."
        exit 1
    fi
    else
    #Si el producto existe, se asigna el nombre correcto a la variable PRODUCT_NAME
    PRODUCT_NAME="$EXISTING_PRODUCT"   
fi
#el proceso de venta continua si el producto existe
echo -e "\nIngrese la cantidad que desea vender:"
read -r SELL_AMOUNT
#validacion del formato de la cantidad a vender
while [[ ! $SELL_AMOUNT =~ ^[1-9][0-9]*$ ]]
do
  echo -e "\nPor favor, ingrese una cantidad válida"
  read -r SELL_AMOUNT
done
#comprobamos si hay suficiente stock para la venta
CURRENT_STOCK=$($PSQL "SELECT stock FROM products WHERE name = '$PRODUCT_NAME';")
while [[ $CURRENT_STOCK -lt $SELL_AMOUNT ]]
do
    echo -e "\nActualmente hay $CURRENT_STOCK unidades disponibles de '$PRODUCT_NAME'. ¿desea continuar con la venta?"
    echo -e "\nPulse Enter para terminar o ingrese una cantidad válida y pulse Enter para continuar"
    read -r SELL_AMOUNT
    if [[ $SELL_AMOUNT = "" ]]
        then
        echo -e "\nEl proceso de venta ha sido cancelado."
        exit 1
    fi
    #validacion del formato de la cantidad a vender
    while [[ ! $SELL_AMOUNT =~ ^[1-9][0-9]*$ ]]
    do
        echo -e "\nPor favor, ingrese una cantidad válida"
        read -r SELL_AMOUNT
    done
done
#actualizamos el stock en la base de datos
$PSQL "UPDATE products SET stock = stock - $SELL_AMOUNT WHERE name = '$PRODUCT_NAME';" > /dev/null
#Mensaje final con el resumen de la venta y el nuevo saldo disponible.
UPDATED_STOCK=$($PSQL "SELECT stock FROM products WHERE name = '$PRODUCT_NAME';")
echo -e "\nSe han vendido $SELL_AMOUNT unidades del producto '$PRODUCT_NAME' y actualmente hay $UPDATED_STOCK unidades disponibles."



