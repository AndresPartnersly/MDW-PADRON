--EXPRESION REGULAR LIMPIEZA ARCHIVOS
1. Remover filas de cabecera de la 1 a la 7
2. Incluir separador de columnas con expresion regular en Node++
		Buscar: (^.{11}) ==> 11: Posicion columna--11,17,22,31,42,192
		Reemplazar: \1; => Agrega el punto y coma.
3. A las lineas de contribuyentes exentos agregar alicuota 0.0 aplicando replace en Node++--Reemplazar "-----" por "0    "
4. Guardar archivo en codificacion UTF8 y aplicar expresion regular para remover caracteres invalidos: [^a-zA-Z0-9,;.\s]


--CREACION TABLA TEMPORAL
drop table tabla1
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
copy tabla1 (col1, col2, col3, col4, col5, col6, col7) FROM 'C:/Users/Public/Documents/03-TUCUMAN/12-2025/ACREDITAN.TXT' DELIMITER ';' ENCODING 'UTF8';


--INSECION DE TABLA TEMPORAL
INSERT INTO alicuota (id_tipo, cuit, razon_social, alicuota_percepcion, alicuota_retencion, periodo_desde, periodo_hasta)
SELECT 
	4 as id_tipo, 
	TRIM(tabla1.col1) as cuit,
	TRIM(tabla1.col6) as razon_social,
    REPLACE(TRIM(tabla1.col7), ',', '.')::numeric percepcion,
    REPLACE(TRIM(tabla1.col7), ',', '.')::numeric retencion,
	to_date((SUBSTRING(TRIM('20251201'), 1, 4)||'-'||SUBSTRING(TRIM('20251201'), 5, 2)||'-'||SUBSTRING(TRIM('20251201'), 7, 2)),'yyyy-mm-dd') periodo_desde,
	to_date((SUBSTRING(TRIM('20251231'), 1, 4)||'-'||SUBSTRING(TRIM('20251231'), 5, 2)||'-'||SUBSTRING(TRIM('20251231'), 7, 2)),'yyyy-mm-dd') periodo_hasta
FROM tabla1

--COEFICIENTES
1. Remover filas de cabecera de la 1 a la 7
2. Incluir separador de columnas con expresion regular en Node++
		Buscar: (^.{11}) ==> 11: Posicion columna--11,17,24, 27, 34, 37, 190
		Reemplazar: \1; => Agrega el punto y coma.
3. A las lineas de contribuyentes exentos agregar alicuota 0.0 aplicando replace en Node++--Reemplazar "-.----" por "0.0000"
3. A las lineas de contribuyentes exentos agregar alicuota 0.0 aplicando replace en Node++--Reemplazar "-----" por "0    "
4. Guardar archivo en codificacion UTFC y aplicar expresion regular para remover caracteres invalidos: [^a-zA-Z0-9,;.\s]

--TABLA TEMPORAL COEFICIENTES
drop table tabla2;
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

	copy tabla2 (col1, col2, col3, col4, col5, col6, col7, col8) FROM 'C:/Users/Public/Documents/03-TUCUMAN/12-2025/archivocoefrg116.TXT' DELIMITER ';' ENCODING 'UTF8';

INSERT INTO alicuota (id_tipo, cuit, razon_social, alicuota_percepcion, alicuota_retencion, periodo_desde, periodo_hasta, coeficiente)
SELECT 
	7 as id_tipo, 
	TRIM(tabla2.col1) as cuit,
	TRIM(tabla2.col7) as razon_social,
    REPLACE(TRIM(tabla2.col8), ',', '.')::numeric percepcion,
    REPLACE(TRIM(tabla2.col8), ',', '.')::numeric retencion,
	to_date((SUBSTRING(TRIM('20251201'), 1, 4)||'-'||SUBSTRING(TRIM('20251201'), 5, 2)||'-'||SUBSTRING(TRIM('20251201'), 7, 2)),'yyyy-mm-dd') periodo_desde,
	to_date((SUBSTRING(TRIM('20251231'), 1, 4)||'-'||SUBSTRING(TRIM('20251231'), 5, 2)||'-'||SUBSTRING(TRIM('20251231'), 7, 2)),'yyyy-mm-dd') periodo_hasta,
	REPLACE(TRIM(tabla2.col3), ',', '.')::numeric coeficiente
FROM tabla2











/*

--TABLA TEMPORAL ANEXOS
CREATE TEMP TABLE tabla3 (
    col1 text,
    col2 text,
	col3 text
	);

	copy tabla3 (col1, col2, col3) FROM 'C:/Users/Public/Documents/2025_04_TUCUMAN_padron_anexo_x_rg_23-02.txt' DELIMITER ';' ENCODING 'UTF8';

--SELECT A TABLA TEMPORAL
select tabla1.col1 as cuit, tabla1.col4 as desde, tabla1.col5 as hasta, tabla1.col6 as razon_social, tabla1.col7 as alicuota, tabla2.col6 as coeficiente, tabla3.col1 as anexo from tabla1 left join tabla2 on tabla1.col1 = tabla2.col1 left join tabla3 on tabla1.col1 = tabla3.col1 where tabla3.col1 is not null

--Usada el 06/05/2025
--select tabla1.col1 as cuit, tabla1.col4 as desde, tabla1.col5 as hasta, tabla1.col6 as razon_social, tabla1.col7 as alicuota, tabla2.col6 as coeficiente from tabla1 left join tabla2 on tabla1.col1 = tabla2.col1


--SELECT A TABLA ALICUOTA CRUZADA CON TABLATIPO
SELECT alicuota.id, alicuota.id_tipo, tipo.nombre as padron, alicuota.cuit, alicuota.razon_social, alicuota.alicuota_percepcion, alicuota.alicuota_retencion, alicuota.periodo_desde, alicuota.periodo_hasta
	FROM public.alicuota inner join tipo on tipo.id = alicuota.id_tipo where cuit='30500035788';	*/