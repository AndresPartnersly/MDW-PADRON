--EXPRESION REGULAR LIMPIEZA ARCHIVOS
1. Remover filas de cabecera de la 1 a la 7
2. Incluir separador de columnas con expresion regular en Node++
		Buscar: (^.{192}) ==> 192: Posicion columna
		Reemplazar: \1; => Agrega el punto y coma.
3. A las lineas de contribuyentes exentos agregar alicuota 0.0 aplicando replace en Node++
4. Guardar archivo en codificacion UTFC y aplicar expresion regular para remover caracteres invalidos: [^a-zA-Z0-9,;.\s]

--CREACION TABLA TEMPORAL
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
copy tabla1 (col1, col2, col3, col4, col5, col6, col7) FROM 'C:/Users/Public/Documents/2025_04_TUCUMAN_ACREDITAN.txt' DELIMITER ';' ENCODING 'UTF8';


--INSECION DE TABLA TEMPORAL
INSERT INTO alicuota (id_tipo, cuit, razon_social, alicuota_percepcion, alicuota_retencion, periodo_desde, periodo_hasta)
SELECT 
	6 as id_tipo, 
	TRIM(col1) as cuit,
	SUBSTRING(TRIM(col6),1,100) as razon_social,
    REPLACE(TRIM(col7), ',', '.')::numeric percepcion,
    REPLACE(TRIM(col7), ',', '.')::numeric retencion,
	to_date((SUBSTRING(TRIM(col4), 1, 4)||'-'||SUBSTRING(TRIM(col4), 5, 2)||'-'||SUBSTRING(TRIM(col4), 7, 2)),'yyyy-mm-dd') periodo_desde,
	to_date((SUBSTRING(TRIM(col5), 1, 4)||'-'||SUBSTRING(TRIM(col5), 5, 2)||'-'||SUBSTRING(TRIM(col5), 7, 2)),'yyyy-mm-dd') periodo_hasta
FROM tabla1;


--TABLA TEMPORAL COEFICIENTES
CREATE TEMP TABLE tabla2 (
    col1 text,
    col2 text,
    col3 text,
    col4 text,
	col5 text,
	col6 text
	);

	copy tabla2 (col1, col2, col3, col4, col5, col6) FROM 'C:/Users/Public/Documents/2025_04_TUCUMAN_archivocoefrg116.txt' DELIMITER ';' ENCODING 'UTF8';


--TABLA TEMPORAL ANEXOS
CREATE TEMP TABLE tabla3 (
    col1 text,
    col2 text,
	col3 text
	);

	copy tabla3 (col1, col2, col3) FROM 'C:/Users/Public/Documents/2025_04_TUCUMAN_padron_anexo_x_rg_23-02.txt' DELIMITER ';' ENCODING 'UTF8';

select tabla1.col1 as cuit, tabla1.col4 as desde, tabla1.col5 as hasta, tabla1.col6 as razon_social, tabla1.col7 as alicuota, tabla2.col6 as coeficiente, tabla3.col1 as anexo from tabla1 left join tabla2 on tabla1.col1 = tabla2.col1 left join tabla3 on tabla1.col1 = tabla3.col1 where tabla3.col1 is not null
	