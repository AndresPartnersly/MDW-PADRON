--ALTA TABLA TEMPORAL
CREATE TEMP TABLE temp_csv_upload (
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

--CARGA DE ARCHIVO PADRON AGIP EN TABLA TEMPORAL
copy temp_csv_upload (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12) FROM 'C:/Users/Public/Documents/ARDJU008052024.txt' DELIMITER ';' ENCODING 'UTF8';

--CADENA DE CONEXION DDBB RENDER
postgres://padron_xot0_user:MtuEnTA6ZoWWaCKLEAcJf9dRvnoXVLAK@dpg-cplg748cmk4c739o4ok0-a.oregon-postgres.render.com/padron_xot0

select alicuota.cuit, alicuota.alicuota_p, alicuota.alicuota_r, alicuota.id_tipo, tipo.nombre from alicuota inner join tipo on alicuota.id_tipo = tipo.id  where alicuota.cuit = '20040106236' order by alicuota.id desc

select version()

--AGREGADO 24/06/2024

--CREACION DE PARTICION PADRON AGIP MAYO 2024
CREATE TABLE alicuota2_2024_m5 PARTITION OF alicuota2
    FOR VALUES FROM ('2024-05-01') TO ('2024-05-31');

--CRACION DE INDICE
CREATE INDEX idx_alicuota2_2024_m5 ON alicuota2_2024_m5 (periodo_inicio, cuit);

--CREACION DE PARTICION PADRON AGIP JUNIO 2024
CREATE TABLE alicuota2_2024_m6 PARTITION OF alicuota2
    FOR VALUES FROM ('2024-06-01') TO ('2024-06-30');

--CRACION DE INDICE
CREATE INDEX idx_alicuota2_2024_m6 ON alicuota2_2024_m6 (periodo_inicio, cuit);

--delete from alicuota2

--CREACION DE TABLA TEMPORAL
CREATE TEMP TABLE temp_csv_upload (
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

--delete from temp_csv_upload

--COPIADO DE ARCHIVO A TABLA TEMPORAL
copy temp_csv_upload (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12) FROM 'C:/Users/Public/Documents/ARDJU008052024.txt' DELIMITER ';' ENCODING 'UTF8';

--INSERCION DE DATA TEMPORAL EN TABLA DEFINITIVA
INSERT INTO alicuota (id_tipo, periodo_inicio, periodo_fin, alicuota_percepcion, alicuota_retencion, cuit, razon_social)
SELECT 
	1 as id_tipo, 
	to_date((SUBSTRING(TRIM(col2), 5, 4)||'-'||SUBSTRING(TRIM(col2), 3, 2)||'-'||SUBSTRING(TRIM(col2), 1, 2)),'yyyy-mm-dd') periodo_desde,
	to_date((SUBSTRING(TRIM(col3), 5, 4)||'-'||SUBSTRING(TRIM(col3), 3, 2)||'-'||SUBSTRING(TRIM(col3), 1, 2)),'yyyy-mm-dd') periodo_hasta,
    REPLACE(TRIM(col8), ',', '.')::numeric percepcion,
    REPLACE(TRIM(col9), ',', '.')::numeric retencion,
	TRIM(col4) as cuit,
    TRIM(col12) as razon_social
FROM temp_csv_upload;

--CONSULTA EN TABLA SIN PARTICIONES NI INDICE EN PARTICIONES
SELECT * FROM alicuota2 WHERE cuit = '20000163989' AND periodo_inicio <= '2024-06-01' AND periodo_fin >= '2024-06-30'

--CONSULTA EN TABLA CON PARTICIONES E INDICE EN PARTICIONES
SELECT * FROM alicuota WHERE cuit = '20000163989' AND periodo_inicio <= '2024-06-01' AND periodo_fin >= '2024-06-30'

REINDEX TABLE ventas_2023;

VACUUM ANALYZE ventas_2023;



--AABG: 22/12/2024
--CREACION TABLA TEMPORAL
CREATE TEMP TABLE temp_csv_upload (
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

--INSECION DE TABLA TEMPORAL
INSERT INTO alicuota (id_tipo, cuit, razon_social, alicuota_percepcion, alicuota_retencion, periodo_desde, periodo_hasta)
SELECT 
	1 as id_tipo, 
	TRIM(col4) as cuit,
	TRIM(col12) as razon_social,
    REPLACE(TRIM(col8), ',', '.')::numeric percepcion,
    REPLACE(TRIM(col9), ',', '.')::numeric retencion,
	to_date((SUBSTRING(TRIM(col2), 5, 4)||'-'||SUBSTRING(TRIM(col2), 3, 2)||'-'||SUBSTRING(TRIM(col2), 1, 2)),'yyyy-mm-dd') periodo_desde,
	to_date((SUBSTRING(TRIM(col3), 5, 4)||'-'||SUBSTRING(TRIM(col3), 3, 2)||'-'||SUBSTRING(TRIM(col3), 1, 2)),'yyyy-mm-dd') periodo_hasta
FROM temp_csv_upload;

--CARGA DE DATA EN TABLA TEMPORAL
copy temp_csv_upload (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12) FROM 'C:/Users/Public/Documents/2025-02_AGIP_ARDJU008022025.txt' DELIMITER ';' ENCODING 'UTF8';


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
where alicuota.cuit = '20000163989' 
and alicuota.periodo_desde <= TO_DATE('2024-06-01','yyyy-mm-dd')
and alicuota.periodo_hasta >= TO_DATE('2024-06-01','yyyy-mm-dd')
and alicuota.id_tipo = 1