#!/bin/bash
#variable de conexion PSQL para ejecutar comandos SQL
PSQL="psql -U postgres -d my_database -t --no-align -c"
#limpiar tablas anterriores si existen
echo $($PSQL "DROP TABLE IF EXISTS products, categories;")
#crear tbla categorias
echo $($PSQL "CREATE TABLE categories(category_id SERIAL PRIMARY KEY, name VARCHAR(50) UNIQUE NOT NULL);")
#crear tabla productos
echo $($PSQL "CREATE TABLE products(product_id SERIAL PRIMARY KEY, name VARCHAR(100) NOT NULL, price NUMERIC(10,2) NOT NULL, stock INT NOT NULL, category_id INT NOT NULL REFERENCES categories(category_id));")
cat products.csv | while IFS=',' read NAME CATEGORY PRICE STOCK
# Saltar la fila de encabezados
do
    if [[ $NAME != "name" ]]
     then
        # buscar category_id en la tabla categories
        CATEGORY_ID=$($PSQL "SELECT category_id FROM categories WHERE name='$CATEGORY';")
        # 2. Si no existe (-z verifica si la variable está vacía), insertarla y volver a buscar su ID
        if [[ -z $CATEGORY_ID ]]
         then
            # insertar categoria
            INSERT_CATEGORY_RESULT=$($PSQL "INSERT INTO categories(name) VALUES('$CATEGORY');")
            # buscar category_id nuevamente
            CATEGORY_ID=$($PSQL "SELECT category_id FROM categories WHERE name='$CATEGORY';")
        fi
        # insertar producto con el category_id correspondiente
        INSERT_PRODUCT_RESULT=$($PSQL "INSERT INTO products(name, price, stock, category_id) VALUES('$NAME', $PRICE, $STOCK, $CATEGORY_ID);")
    fi
done    