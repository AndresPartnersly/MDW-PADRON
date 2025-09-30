--EXPRESION REGULAR LIMPIEZA ARCHIVOS
[^a-zA-Z0-9,;\s]

--remover primera fila de cabecera

--CREACION TABLA TEMPORAL
CREATE TEMP TABLE temp_entre_rios (
    col1 text,
    col2 text,
    col3 text,
    col4 text,
	col5 text,
	col6 text,
	col7 text,
	col8 text,
	col9 text,
	col10 text,
	col11 text,
	col12 text
	);

--CARGA DE DATA EN TABLA TEMPORAL
copy temp_entre_rios (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12) FROM 'C:/Users/Public/Documents/02-ENTRE RIOS/10-2025/PadronRetPer202510.txt' DELIMITER ';' ENCODING 'UTF8';




--INSECION DE TABLA TEMPORAL
INSERT INTO alicuota (id_tipo, cuit, razon_social, alicuota_percepcion, alicuota_retencion, periodo_desde, periodo_hasta)
SELECT 
	4 as id_tipo, 
	TRIM(col4) as cuit,
	TRIM(col12) as razon_social,
    REPLACE(TRIM(col8), ',', '.')::numeric percepcion,
    REPLACE(TRIM(col9), ',', '.')::numeric retencion,
	to_date((SUBSTRING(TRIM(col2), 5, 4)||'-'||SUBSTRING(TRIM(col2), 3, 2)||'-'||SUBSTRING(TRIM(col2), 1, 2)),'yyyy-mm-dd') periodo_desde,
	to_date((SUBSTRING(TRIM(col3), 5, 4)||'-'||SUBSTRING(TRIM(col3), 3, 2)||'-'||SUBSTRING(TRIM(col3), 1, 2)),'yyyy-mm-dd') periodo_hasta
FROM temp_entre_rios;

select alicuota.id,
	alicuota.id_tipo,
	alicuota.cuit, 
	alicuota.razon_social,
	alicuota.alicuota_percepcion,
	alicuota.alicuota_retencion,
	alicuota.periodo_desde,
	alicuota.periodo_hasta 
from
	alicuota 
where alicuota.cuit = '34684733496' 
and alicuota.id_tipo = 3