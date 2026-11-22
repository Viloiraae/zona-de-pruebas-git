#!/bin/bash
#Menu script for interaction with inquiry, restocking, and sales functions
while true
do
    echo -e "\nSeleccione una opción:"
    echo "1. Consultar productos"
    echo "2. Reabastecer productos"
    echo "3. Vender productos"
    echo "4. Salir"
    read -r OPTION
    case "$OPTION" in
        1)
        ./queries.sh
        sleep 5
        ;;
        2)
        ./restock.sh
        sleep 2.5
        ;;
        3)
        ./sell.sh
        sleep 2.5
        ;;
        4)
        echo -e "\nSaliendo del programa..."
        exit 0
        ;;
        *)
        echo -e "\nOpción inválida, por favor seleccione una opción válida."
        ;;
    esac
done

