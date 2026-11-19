--
-- PostgreSQL database dump
--

\restrict PwYf4VLJ4lyCaeX7EJqT5Sji4BWT4SBcFvwfROllgjl6YEOg5qyc1B6Xmghektn

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE my_database;
--
-- Name: my_database; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE my_database WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Spain.1252';


ALTER DATABASE my_database OWNER TO postgres;

\unrestrict PwYf4VLJ4lyCaeX7EJqT5Sji4BWT4SBcFvwfROllgjl6YEOg5qyc1B6Xmghektn
\connect my_database
\restrict PwYf4VLJ4lyCaeX7EJqT5Sji4BWT4SBcFvwfROllgjl6YEOg5qyc1B6Xmghektn

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    category_id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_category_id_seq OWNER TO postgres;

--
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    name character varying(100) NOT NULL,
    price numeric(10,2) NOT NULL,
    stock integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_product_id_seq OWNER TO postgres;

--
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.categories VALUES (1, 'Perifericos');
INSERT INTO public.categories VALUES (2, 'Pantallas');
INSERT INTO public.categories VALUES (3, 'Audio');
INSERT INTO public.categories VALUES (4, 'Accesorios');
INSERT INTO public.categories VALUES (5, 'Video');
INSERT INTO public.categories VALUES (6, 'Conectividad');
INSERT INTO public.categories VALUES (7, 'Almacenamiento');
INSERT INTO public.categories VALUES (8, 'Cables');
INSERT INTO public.categories VALUES (9, 'Iluminacion');


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.products VALUES (6, 'Webcam Full HD 1080p', 42.00, 18, 5);
INSERT INTO public.products VALUES (7, 'Microfono Condensador USB', 65.50, 10, 3);
INSERT INTO public.products VALUES (8, 'Hub USB-C 7 en 1', 29.99, 22, 6);
INSERT INTO public.products VALUES (9, 'Disco SSD Externo 1TB', 89.00, 12, 7);
INSERT INTO public.products VALUES (10, 'Memoria USB 128GB', 16.50, 50, 7);
INSERT INTO public.products VALUES (12, 'Altavoces Estereo PC', 32.00, 16, 3);
INSERT INTO public.products VALUES (13, 'Cable HDMI 2.1 2m', 11.99, 60, 8);
INSERT INTO public.products VALUES (14, 'Adaptador Bluetooth 5.3', 9.95, 35, 6);
INSERT INTO public.products VALUES (15, 'Base Refrigeradora Portatil', 27.50, 14, 4);
INSERT INTO public.products VALUES (17, 'Teclado Inalambrico Compacto', 38.00, 20, 1);
INSERT INTO public.products VALUES (18, 'Raton Ergonomico Vertical', 29.50, 17, 1);
INSERT INTO public.products VALUES (19, 'Tarjeta Memoria MicroSD 256GB', 24.00, 30, 7);
INSERT INTO public.products VALUES (16, 'Monitor Curvo 32 pulgadas', 279.00, 15, 2);
INSERT INTO public.products VALUES (3, 'Monitor 27 pulgadas IPS', 189.00, 20, 2);
INSERT INTO public.products VALUES (20, 'Lampara Barra LED Monitor', 31.99, 16, 9);
INSERT INTO public.products VALUES (4, 'Auriculares Inalambricos', 75.00, 30, 3);
INSERT INTO public.products VALUES (1, 'Teclado Mecanico RGB', 59.99, 13, 1);
INSERT INTO public.products VALUES (2, 'Raton Gaming Optico', 34.50, 24, 1);
INSERT INTO public.products VALUES (11, 'Soporte Elevador Monitor', 24.90, 18, 4);
INSERT INTO public.products VALUES (5, 'Alfombrilla XL', 14.95, 41, 4);


--
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 9, true);


--
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 20, true);


--
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


--
-- PostgreSQL database dump complete
--

\unrestrict PwYf4VLJ4lyCaeX7EJqT5Sji4BWT4SBcFvwfROllgjl6YEOg5qyc1B6Xmghektn

