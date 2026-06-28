--============================================================
-- PROYECTO:    Análisis de Desempeño Logístico
-- AUTOR:       Andrea Galicia 
-- DATOS:       Dataset simulado de empresa de transporte y logística.
--              Incluye información de conductores, clientes,
--              Rutas y envíos correspondientes al año 2024.
-- DESCRIPCIÓN: Análisis del desempeño operativo de una empresa
--              de logística en México. Identifica las rutas con
--              mayor ingreso y mayor número de retrasos, y evalúa
--              el costo de falla acumulado por conductor.
--              Objetivo: detectar áreas de mejora y apoyar
--              la toma de decisiones operativas.

-- HERRAMIENTAS:PostgreSQL 18 / pgAdmin 4 / Power BI
-- FECHA:       JUNIO 2026
-- ==========================================================

-- ============================================================
-- Creación de Tabla de Conductores
-- ============================================================

CREATE TABLE conductores (
id_conductor SERIAL PRIMARY KEY,
nombre_conductor varchar(100) NOT NULL, 
tipo_vehiculo varchar(20) NOT NULL
);

-- ============================================================
-- Creación de Tabla de clientes
-- ============================================================

CREATE TABLE clientes (
id_cliente SERIAL PRIMARY KEY,
nombre_cliente varchar(100) NOT NULL,
ciudad varchar(50) NOT NULL, 
segmento varchar(50) NOT NULL
);

-- ============================================================
-- Creación de Tabla de Rutas
-- ============================================================

CREATE TABLE rutas (
id_ruta SERIAL PRIMARY KEY, 
nombre_ruta varchar(50),
origen varchar(50),
destino varchar (50),
distancia_km integer	,
tarifa_por_kg decimal(5,2)
);

-- ============================================================
-- Creación de Tabla de Envíos
-- ============================================================
	
	CREATE TABLE envios (
	id_envio SERIAL PRIMARY KEY,
	fecha_envio date,
	id_ruta integer references rutas(id_ruta),
	id_cliente integer references clientes(id_cliente),
	id_conductor integer references conductores(id_conductor),
	peso_kg decimal(7,2),
	costo_envio_mxn decimal(12,2),
	fecha_prometida date,
	fecha_entrega_real date,
	estatus varchar(50),
	dias_retraso integer,
	costo_falla_mxn decimal(12,2)
	);

-- ============================================================
-- Reconocimiento de los datos
-- ============================================================

SELECT COUNT (*) FROM conductores;
SELECT COUNT (*) FROM rutas;
SELECT COUNT (*) FROM envios;
SELECT COUNT (*) FROM clientes;

SELECT * FROM envios;
SELECT * FROM rutas;
SELECT * FROM conductores;
-- ============================================================
-- Conteo de datos por cada tabla
-- ============================================================

SELECT 'conductores' AS tabla, COUNT(*) FROM CONDUCTORES
UNION ALL SELECT 'rutas', COUNT(*) FROM rutas
UNION ALL SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL SELECT 'envios', COUNT (*) FROM envios;

-- ============================================================
-- 1. ¿Qué ruta genera más ingreso?
-- ============================================================

SELECT nombre_ruta, SUM(costo_envio_mxn)
FROM envios e
JOIN rutas r 
ON e.id_ruta = r.id_ruta
GROUP BY r.nombre_ruta
ORDER BY SUM(e.costo_envio_mxn) DESC;

--Nota: La ruta que mayor ingreso presenta es Ciudad de México - Tijuana con $3,026,879.18,
--seguido de Ciudad de México-Culiacán con $1,170,467.84
--Y, Ciudad de México - Mérida con $1,143,170.79.
--Son rutas que muestran ser un pilar importante para la empresa, habría que revisar sus costos. 


-- ============================================================
-- 2. ¿Qué ruta tiene más envíos retrasados?
-- ============================================================

SELECT nombre_ruta, COUNT(estatus) as conteo_estatus
FROM envios e
JOIN rutas r
ON e.id_ruta = r.id_ruta
WHERE e.estatus =  'Retrasado'
GROUP BY r.nombre_ruta
ORDER BY COUNT(e.estatus) DESC;

--Algo importante de notar, es que, la ruta de Ciudad de México - Tijuana es de las que más ingreso
--genera pero al mismo tiempo es la segunda ruta que más envíos retrasados tiene, se tiene que prestar atención,
--ya que, pudiera generar más ingreso si no se tuviera tanto envio "retrasado".
--Otra de las rutas que tienen envíos con mayor retraso son:
--Ciudad de México - Querétaro (19),
--Ciudad de México - Monterrey (14).
--Es importante conocer el motivo por el que se están teniendo retrasos para poder trabajar en ello y generar
--estrategias que ayuden al mejoramiento del servicio. 

-- ============================================================
-- 3. ¿Cuál conductor tiene el mayor costo de falla acumulado?
-- ============================================================

SELECT c.nombre_conductor, SUM(e.costo_falla_mxn) as costo_falla
FROM envios e
JOIN conductores c
ON e.id_conductor = c.id_conductor
GROUP BY c.nombre_conductor
ORDER BY SUM(e.costo_falla_mxn) DESC;


--Los conductores que representan mayores gastos son:
--Jorge Mendoza ($18,155.20)
--Sergio Reyes Ibarra ($17,509.11)
--Enrique Vargas ($15,027.09)
--Es importante revisarlo para tomar las medidas necesarias, ya que representan grandes pérdidas.

-- ============================================================
-- 3. ¿Cuál conductor tiene el mayor costo de falla acumulado? en PORCENTAJE
-- ============================================================

SELECT c.nombre_conductor, 
SUM(e.costo_falla_mxn) as costo_falla,
ROUND(SUM(costo_falla_mxn)/(SELECT SUM(costo_falla_mxn)FROM envios)*100,2) as "porcentaje"
FROM envios e
JOIN conductores c
ON e.id_conductor = c.id_conductor
GROUP BY c.nombre_conductor
ORDER BY SUM(e.costo_falla_mxn) DESC;

--En términos de porcentaje Jorge Mendoza representa el 10.36%
--Sergio Reyes representa el 10%
--y, Enrique Vargas el 8.58%
--En porcentaje se refleja realmente el porcentaje que representa cada uno de los conductores
--por costo falla y a los que hay que prestarles más atención. 

-- ============================================================
-- Resumen
-- ============================================================

--1. La ruta que mayor ingreso presenta es Ciudad de México - Tijuana con $3,026,879.18,
--2.La ruta de Ciudad de México - Tijuana es de las que más ingreso
--genera pero al mismo tiempo es la segunda ruta que más envíos retrasados tiene, se tiene que prestar atención,
--ya que podría generar más ingresos si no se tuviera tanto envío "retrasado".
--3.El conductor que mayor gasto genera es Jorge Mendoza con el  10.36%

-- ============================================================
-- Fin del Análisis
-- ============================================================



