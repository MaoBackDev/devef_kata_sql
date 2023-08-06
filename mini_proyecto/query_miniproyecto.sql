-- ***************************** CREACIÓN DE TABLAS ***************************************************

CREATE TABLE IF NOT EXISTS products
(
    product_id serial NOT NULL PRIMARY KEY,
    sku character varying(30) NOT NULL UNIQUE,
    name character varying(50) NOT NULL,
    description character varying(150) NOT NULL,
    price numeric(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS customers
(
    customer_id serial NOT NULL PRIMARY KEY,
    document character varying(20) NOT NULL UNIQUE,
    first_name character varying(80) NOT NULL,
    last_name character varying(80) NOT NULL,
    email character varying(150) NOT NULL UNIQUE,
    phone character varying(20) NOT NULL,
    address character varying(100) NOT NULL,
    postal_code character varying(10) NOT NULL,
    colony character varying(50)
);

CREATE TABLE IF NOT EXISTS sales
(
    sale_id serial NOT NULL PRIMARY KEY,
    product_id integer NOT NULL,
	customer_id integer NOT NULL,
	amount integer NOT NULL,
	CONSTRAINT fk_product_sale FOREIGN KEY (product_id)
    REFERENCES products (product_id),
	CONSTRAINT fk_customer_invoice FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id)
);


-- ********************************** INSERCIÓN DE DATOS *******************************

INSERT INTO products 
VALUES
(DEFAULT, '10001', 'Celular Vivo', 'Teléfono inteligente multifuncional', 1000000),
(DEFAULT, '10002', 'Teclado gamer', 'Teclado luminoso', 700000),
(DEFAULT, '10003', 'Diadema inhalámbrico', 'Diadema de sonido transparente', 400000),
(DEFAULT, '10004', 'Monitor hd', 'Monitor samsumg 4k', 2500000),
(DEFAULT, '10005', 'Cargador celular', 'Cargador genérico multifuncional', 40000);

INSERT INTO customers
VALUES 
(default, '123456789', 'Hugo', 'Parra', 'hugo@correo.com', '3572980', 'cr 10 # 11 - 01', '11001', 'Apartado'),
(default, '123456788', 'Daniel', 'Mora', 'dani@correo.com', '3572981', 'cr 12 # 11 - 01', '11001', 'Cali'),
(default, '123456787', 'Ana', 'Rojas', 'ana@correo.com', '3572982', 'cr 15 # 01 - 01', '11001', 'Buga'),
(default, '123456786', 'Luz', 'Miranda', 'luz@correo.com', '3572983', 'cr 10 # 56 - 10', '11001', 'Bogota'),
(default, '123456785', 'Lucia', 'Parra', 'lucia@correo.com', '3572984', 'cr 120 # 11 - 01', '11001', 'Bogota'),
(default, '123456784', 'Ramon', 'Vera', 'ramon@correo.com', '3572930', 'cr 100 # 11 - 01', '11001', 'Bogota');

INSERT INTO sales
VALUES
(default, 1, 1, 2),
(default, 2, 1, 1),
(default, 5, 2, 8),
(default, 3, 3, 8),
(default, 5, 4, 20),
(default, 1, 1, 20),
(default, 2, 1, 12),
(default, 3, 1, 2),
(default, 4, 1, 10),
(default, 5, 1, 12),
(default, 1, 4, 25);

	
-- ************************************** CONSULTAS ***************************************

-- ID de los clientes de la Ciudad de Bogotá
SELECT customer_id FROM customers WHERE LOWER(colony ) = 'bogota';

-- ID y descripción de los productos que cuesten menos de 100.000 pesos
SELECT product_id, description
FROM products
WHERE price < 100000;

-- ID y nombre de los clientes, cantidad vendida, y descripción del producto, 
-- en las ventas en las cuales se vendieron más de 10 unidades.
SELECT c.customer_id, 
		c.first_name || ' ' || 
		c.last_name as full_name, s.amount, p.description
FROM sales as s
NATURAL JOIN products as p
NATURAL JOIN customers as c
WHERE s.amount > 10


--ID y nombre de los clientes que no aparecen en la tabla de ventas (Clientes que no han comprado productos)
SELECT c.customer_id, first_name || ' ' || last_name full_name
FROM  customers c
NATURAL LEFT JOIN sales s
where s.sale_id IS NULL;

-- OPCIÓN DOS
SELECT customer_id, first_name || ' ' || last_name full_name
FROM customers  
WHERE customer_id NOT IN (SELECT customer_id FROM sales);


-- ID y nombre de los clientes que han comprado todos los productos de la empresa.
SELECT customer_id, first_name || ' ' || last_name full_name
FROM customers c  
WHERE (SELECT COUNT(DISTINCT s.product_id) 
	   FROM sales s 
	   WHERE c.customer_id = s.customer_id) = (SELECT COUNT(*) FROM products);


-- ID y nombre de cada cliente y la suma total (suma de cantidad) de los productos que ha comprado. 
SELECT customer_id, first_name || ' ' || last_name full_name, SUM(s.amount) AS total
FROM customers
NATURAL JOIN sales s
GROUP BY customer_id


-- ID de los productos que no han sido comprados por clientes de buga.
SELECT Product_id
FROM products  
WHERE Product_id NOT IN (
	SELECT Product_id FROM customers
	NATURAL JOIN sales
	WHERE LOWER(colony) = 'buga'
);


-- ID de los productos que se han vendido a clientes de apartado y que también se han vendido a clientes de bogota.
SELECT DISTINCT Product_id  
FROM customers 
NATURAL JOIN sales 
WHERE LOWER(colony) = 'apartado'             
AND Product_id 
IN (SELECT Product_id                                               
		FROM customers 
	NATURAL JOIN sales                                                
	WHERE LOWER(colony) = 'bogota'
   );


-- Nombre de las ciudades en las que se han vendido todos los productos.
SELECT colony 
FROM customers 
NATURAL JOIN sales 
GROUP BY colony 
HAVING COUNT(DISTINCT Product_id) = (SELECT COUNT(*) FROM products); 