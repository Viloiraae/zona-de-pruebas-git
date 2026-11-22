#!/bin/bash
#script para reabastecer productos desde la base de datos
#Configuración de conexión silenciosa (sin encabezados ni bordes de tabla)
PSQL="psql -X --username=postgres --dbname=my_database --no-align --tuples-only -c"
#capturamos el nombre del producto
echo -e "\nIntroduzca el nombre del producto a restablecer:"
read -p "Nombre del producto: " PRODUCT_NAME
#comprobar si el producto existe en la base de datos
EXISTING_PRODUCT=$($PSQL "SELECT name FROM products WHERE name ILIKE '$PRODUCT_NAME';" | tr -d '\r')
if [[ -z "$EXISTING_PRODUCT" ]]
    then
        #comprobamos si hay un producto similar en la base de datos
        EXISTING_PRODUCT=$($PSQL "SELECT name FROM products WHERE name ILIKE '%$PRODUCT_NAME%';" | tr -d '\r')
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
                    #Si hay mas de un producto similar, se muestran los productos similares y se solicita al usuario que seleccione uno de ellos
                    mapfile -t PRODUCTS < <(echo "$EXISTING_PRODUCT")
                    echo -e "\nSe han encontrado varios productos similares:"
                    for i in "${!PRODUCTS[@]}"
                        do
                        echo "$((i+1)). ${PRODUCTS[$i]}"
                    done
                    echo "0) Cancelar"
                    #Solicitamos al usuario que seleccione un producto de la lista
                    while true
                        do
                        read -rp "Seleccione una opción: " CHOICE
                        #comprobar: si la opción es 0), se cancela el proceso de venta
                            if [[ $CHOICE == 0 ]]
                                then
                                echo -e "\nEl proceso de reposición ha sido cancelado."
                                exit 1
                            fi
                        #comprobar si la opcion es un numero entero, valido y dentro del rango de opciones
                        if [[ $CHOICE =~ ^[0-9]+$ ]] && (( CHOICE >= 1 && CHOICE <= COUNT ))
                            then
                                PRODUCT_NAME="${PRODUCTS[$((CHOICE-1))]}"
                                break
                            else
                            echo -e "\nOpción inválida, por favor seleccione una opción válida."
                        fi
                    done
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