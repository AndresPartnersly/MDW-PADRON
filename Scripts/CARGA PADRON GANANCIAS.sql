--superadmin
--EXPRESION REGULAR LIMPIEZA ARCHIVOS
[^a-zA-Z0-9,;\s]

CREATE TEMP TABLE exclusion_ganancias_tmp (
    col1 text,
    col2 text,
    col3 text,
    col4 text,
	col5 text,
	col6 text,
	col7 text,
	col8 text
	);

--CARGA DE DATA EN TABLA TEMPORAL
--copy exclusion_ganancias_tmp (col1, col2, col3, col4, col5, col6, col7, col8) FROM '/tmp/PADRONES/GANANCIAS/RG830.txt' DELIMITER ';' ENCODING 'UTF8';
copy exclusion_ganancias_tmp (col1, col2, col3, col4, col5, col6, col7, col8) FROM '/tmp/PADRONES/GANANCIAS/RG830.txt' DELIMITER ';' ENCODING 'UTF8';

--INSECION DE TABLA TEMPORAL
INSERT INTO exclusion_ganancias (nro_certificado, cuit, razon_social, periodo_fiscal, porcentaje, resolucion, fecha_desde, fecha_hasta)
SELECT 
	TRIM(col1) as nro_certificado,
	TRIM(col2) as cuit,
	TRIM(col3) as razon_social,
	col4 ::numeric as periodo_fiscal,
	col5 ::numeric as porcentaje,
	TRIM(col6) as resolucion,
	to_date((SUBSTRING(TRIM(col7), 7, 4)||'-'||SUBSTRING(TRIM(col7), 4, 2)||'-'||SUBSTRING(TRIM(col7), 1, 2)),'yyyy-mm-dd') fecha_desde,
	to_date((SUBSTRING(TRIM(col8), 7, 4)||'-'||SUBSTRING(TRIM(col8), 4, 2)||'-'||SUBSTRING(TRIM(col8), 1, 2)),'yyyy-mm-dd') fecha_hasta
FROM exclusion_ganancias_tmp;