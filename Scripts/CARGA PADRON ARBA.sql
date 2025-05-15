--superadmin
--EXPRESION REGULAR LIMPIEZA ARCHIVOS
--Buscar ;\r?$ y reemplazar por nada

--CREACION TABLA TEMPORAL PERCEPCIONES
CREATE TEMP TABLE temp_percepciones (
    col1 text,
    col2 text,
    col3 text,
    col4 text,
	col5 text,
	col6 text,
	col7 text,
	col8 text,
	col9 text,
	col10 text
	);

copy temp_percepciones FROM 'C:/Users/Public/Documents/04-ARBA/05-2025/PadronRGSPer052025.TXT' WITH (
  FORMAT csv,
  DELIMITER ';',
  HEADER FALSE
);

--CREACION TABLA TEMPORAL RETENCIONES
CREATE TEMP TABLE temp_retenciones (
    col1 text,
    col2 text,
    col3 text,
    col4 text,
	col5 text,
	col6 text,
	col7 text,
	col8 text,
	col9 text,
	col10 text
	);

copy temp_retenciones FROM 'C:/Users/Public/Documents/04-ARBA/05-2025/PadronRGSRet052025.TXT' WITH (
  FORMAT csv,
  DELIMITER ';',
  HEADER FALSE
);


--INSECION DE TABLA TEMPORAL
INSERT INTO alicuota (id_tipo, cuit, razon_social, alicuota_percepcion, alicuota_retencion, periodo_desde, periodo_hasta)
SELECT 
	2 as id_tipo, 
	TRIM(COALESCE(temp_percepciones.col5,temp_retenciones.col5)) as cuit,
	TRIM(COALESCE(temp_percepciones.col5,temp_retenciones.col5)) as razon_social,
    REPLACE(TRIM(COALESCE(temp_percepciones.col9,'0,00')), ',', '.')::numeric percepcion,
	REPLACE(TRIM(COALESCE(temp_retenciones.col9,'0,00')), ',', '.')::numeric retencion,
	to_date((SUBSTRING(TRIM('20250501'), 1, 4)||'-'||SUBSTRING(TRIM('20250501'), 5, 2)||'-'||SUBSTRING(TRIM('20250501'), 7, 2)),'yyyy-mm-dd') periodo_desde,
	to_date((SUBSTRING(TRIM('20250531'), 1, 4)||'-'||SUBSTRING(TRIM('20250531'), 5, 2)||'-'||SUBSTRING(TRIM('20250531'), 7, 2)),'yyyy-mm-dd') periodo_hasta
FROM temp_percepciones full join temp_retenciones on temp_percepciones.col5 = temp_retenciones.col5