--EXPRESION REGULAR LIMPIEZA ARCHIVOS
/*1. Remover filas de cabecera de la 1 a la 7
2. Incluir separador de columnas con expresion regular en Node++
		Buscar: (^.{11}) ==> 11: Posicion columna--11,17,22,31,42,192
		Reemplazar: \1; => Agrega el punto y coma.
3. A las lineas de contribuyentes exentos agregar alicuota 0.0 aplicando replace en Node++--Reemplazar "-----" por "0    "
4. Guardar archivo en codificacion UTF8 y aplicar expresion regular para remover caracteres invalidos: [^a-zA-Z0-9,;.\s]
*/

--CREACION TABLA TEMPORAL
--drop table tabla1
CREATE TEMP TABLE tabla1 (
    col1 text,
    col2 text,
    col3 text,
    col4 text,
	col5 text,
	col6 text,
	col7 text
	);

--CARGA DE DATA EN TABLA TEMPORAL
copy tabla1 (col1, col2, col3, col4, col5, col6, col7) FROM '/tmp/PADRONES/TUCUMAN/2026-07/ACREDITAN.TXT' DELIMITER ';' ENCODING 'UTF8';


--INSECION DE TABLA TEMPORAL
INSERT INTO alicuota (id_tipo, cuit, razon_social, alicuota_percepcion, alicuota_retencion, periodo_desde, periodo_hasta)
SELECT 
	4 as id_tipo, 
	TRIM(tabla1.col1) as cuit,
	TRIM(tabla1.col6) as razon_social,
    REPLACE(TRIM(tabla1.col7), ',', '.')::numeric percepcion,
    REPLACE(TRIM(tabla1.col7), ',', '.')::numeric retencion,
	to_date((SUBSTRING(TRIM('20260701'), 1, 4)||'-'||SUBSTRING(TRIM('20260701'), 5, 2)||'-'||SUBSTRING(TRIM('20260701'), 7, 2)),'yyyy-mm-dd') periodo_desde,
	to_date((SUBSTRING(TRIM('20260731'), 1, 4)||'-'||SUBSTRING(TRIM('20260731'), 5, 2)||'-'||SUBSTRING(TRIM('20260731'), 7, 2)),'yyyy-mm-dd') periodo_hasta
FROM tabla1

--COEFICIENTES
/*1. Remover filas de cabecera de la 1 a la 7
2. Incluir separador de columnas con expresion regular en Node++
		Buscar: (^.{11}) ==> 11: Posicion columna--11,17,24, 27, 34, 37, 190
		Reemplazar: \1; => Agrega el punto y coma.
3. A las lineas de contribuyentes exentos agregar alicuota 0.0 aplicando replace en Node++--Reemplazar "-.----" por "0.0000"
3. A las lineas de contribuyentes exentos agregar alicuota 0.0 aplicando replace en Node++--Reemplazar "-----" por "0    "
4. Guardar archivo en codificacion UTFC y aplicar expresion regular para remover caracteres invalidos: [^a-zA-Z0-9,;.\s]
*/
--TABLA TEMPORAL COEFICIENTES
--drop table tabla2;
CREATE TEMP TABLE tabla2 (
    col1 text,
    col2 text,
    col3 text,
    col4 text,
	col5 text,
	col6 text,
	col7 text,
	col8 text
	);

	copy tabla2 (col1, col2, col3, col4, col5, col6, col7, col8) FROM '/tmp/PADRONES/TUCUMAN/2026-07/archivocoefrg116.TXT' DELIMITER ';' ENCODING 'UTF8';

INSERT INTO alicuota (id_tipo, cuit, razon_social, alicuota_percepcion, alicuota_retencion, periodo_desde, periodo_hasta, coeficiente)
SELECT 
	5 as id_tipo, 
	TRIM(tabla2.col1) as cuit,
	TRIM(tabla2.col7) as razon_social,
    REPLACE(TRIM(tabla2.col8), ',', '.')::numeric percepcion,
    REPLACE(TRIM(tabla2.col8), ',', '.')::numeric retencion,
	to_date((SUBSTRING(TRIM('20260701'), 1, 4)||'-'||SUBSTRING(TRIM('20260701'), 5, 2)||'-'||SUBSTRING(TRIM('20260701'), 7, 2)),'yyyy-mm-dd') periodo_desde,
	to_date((SUBSTRING(TRIM('20260731'), 1, 4)||'-'||SUBSTRING(TRIM('20260731'), 5, 2)||'-'||SUBSTRING(TRIM('20260731'), 7, 2)),'yyyy-mm-dd') periodo_hasta,
	REPLACE(TRIM(tabla2.col3), ',', '.')::numeric coeficiente
FROM tabla2

