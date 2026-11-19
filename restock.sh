#!/bin/bash
#Configuración de conexión silenciosa (sin encabezados ni bordes de tabla)
PSQL="psql -X --username=postgres --dbname=my_database --no-align --tuples-only -c"
#capturamos el nombre del producto
echo -e "\nIntroduzca el nombre del producto a restablecer:"
read -p "Nombre del producto: " PRODUCT_NAME
#comprobar si el producto existe en la base de datos
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
                    #El script termina el proceso de reposicion si el producto no existe
                    echo -e "\nEl producto '$PRODUCT_NAME' no se encuentra registrado, el proceso de reposicion no puede continuar."
                    exit 1
                fi
            else
            echo -e "\nSe han encontrado varios productos similares a '$PRODUCT_NAME':"
            echo "$EXISTING_PRODUCT"
            echo -e "\nElija una opcion y vuelva al proceso de reposicion"
            exit 1
        fi 
        else
        #El script termina el proceso de reposicion si el producto no existe
        echo -e "\nEl producto '$PRODUCT_NAME' no se encuentra registrado, el proceso de reposicion no puede continuar."
        exit 1
    fi
    else
    #Si el producto existe, se asigna el nombre correcto a la variable PRODUCT_NAME
    PRODUCT_NAME="$EXISTING_PRODUCT"   
fi
#capturamos la cantidad a reponer 
echo -e "\nIntroduzca la cantidad a reponer:"
read -p "Cantidad a reponer: " RESTOCK_AMOUNT
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