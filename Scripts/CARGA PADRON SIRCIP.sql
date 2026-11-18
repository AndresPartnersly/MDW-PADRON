--superadmin
--EXPRESION REGULAR LIMPIEZA ARCHIVOS
[^a-zA-Z0-9,;\s]

CREATE TEMP TABLE temp_csv_upload (
    col1 text,
    col2 text,
    col3 text,
    col4 text,
	col5 text,
	col6 text,
	col7 text
	);

--CARGA DE DATA EN TABLA TEMPORAL
--copy temp_csv_upload (col1, col2, col3, col4, col5, col6, col7) FROM '/tmp/PADRONES/SIRCIP/padron_agentes.txt' DELIMITER ';' ENCODING 'UTF8';
copy temp_csv_upload (col1, col2, col3, col4, col5, col6, col7) FROM 'C:/Users/Public/Documents/SIRCIP/padron_agentes - copia.txt' DELIMITER ',' ENCODING 'UTF8';



--INSECION DE TABLA TEMPORAL
INSERT INTO padron_sircip (cuit, razon_social, jurisdiccion_sede, codigo_crc, letra_alicuota, campo_siete, periodo_desde, periodo_hasta)
SELECT
	TRIM(col2) as cuit,
	TRIM(col3) as razon_social,
	TRIM(col4) as jurisdiccion_sede,
	TRIM(col5) as crc,
	TRIM(col6) as letra_alicuota,
    TRIM(col7) as campo_siete,
	to_date((SUBSTRING(TRIM('20261101'), 1, 4)||'-'||SUBSTRING(TRIM('20261101'), 5, 2)||'-'||SUBSTRING(TRIM('20261101'), 7, 2)),'yyyy-mm-dd') periodo_desde,
	to_date((SUBSTRING(TRIM('20261130'), 1, 4)||'-'||SUBSTRING(TRIM('20261130'), 5, 2)||'-'||SUBSTRING(TRIM('20261130'), 7, 2)),'yyyy-mm-dd') periodo_hasta
FROM temp_csv_upload;