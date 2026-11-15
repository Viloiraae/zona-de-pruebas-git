#!/bin/bash
#variable de conexion PSQL para ejecutar comandos SQL
PSQL="psql -U postgres -d my_database -t --no-align -c"
#limpiar tablas anterriores si existen
echo $($PSQL "DROP TABLE IF EXISTS products, categories;")
#crear tbla categorias
echo $($PSQL "CREATE TABLE categories(category_id SERIAL PRIMARY KEY, name VARCHAR(50) UNIQUE NOT NULL);")
#crear tabla productos
echo $($PSQL "CREATE TABLE products(product_id SERIAL PRIMARY KEY, name VARCHAR(100) NOT NULL, price NUMERIC(10,2) NOT NULL, stock INT NOT NULL, category_id INT NOT NULL REFERENCES categories(category_id));")
