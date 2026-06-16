const express = require('express');
const { Pool } = require('pg');
const dotenv = require('dotenv');
const postgres = require('postgres');
const axios = require('axios');

// Cargar variables de entorno desde el archivo .env
dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

const sql = postgres({
    host: process.env.DB_HOST,            // Postgres ip address[s] or domain name[s]
    port: process.env.DB_PORT,          // Postgres server port[s]
    database: process.env.DB_NAME,            // Name of database to connect to
    username: process.env.DB_USER,            // Username of database user
    password: process.env.DB_PASSWORD,
    idle_timeout: 60 * 1000,
    connect_timeout: 1200
});

// Middleware para parsear JSON
app.use(express.json());

// Endpoint para realizar una consulta básica con parámetros dinámicos
app.get('/search', async (req, res) => {

    const cuit = req[`query`][`cuit`];
    const periodo_desde = req[`query`][`desde`];
    const periodo_hasta = req[`query`][`hasta`];
    const tipo = parseInt(req[`query`][`tipo`]);
    console.log(`33. CUIT: ${cuit} - DESDE: ${periodo_desde} - HASTA: ${periodo_hasta} - TIPO PADRON: ${tipo} \n`);
    if (!cuit) {
        return res.status(400).json({ error: `Falta parametro "cuit"` });
    }

    if (!periodo_desde) {
        return res.status(400).json({ error: `Falta parametro "desde"` });
    }

    if (!periodo_hasta) {
        return res.status(400).json({ error: `Falta parametro "hasta"` });
    }

    if (!tipo) {
        return res.status(400).json({ error: `Falta parametro "tipo"` });
    }
    console.log(`49. CUIT: ${cuit} - DESDE: ${periodo_desde} - HASTA: ${periodo_hasta} - TIPO PADRON: ${tipo} \n`);
    try {
        const query = `select alicuota.id as id_bbdd, alicuota.id_tipo as id_tipo_padron, alicuota.cuit, alicuota.razon_social, alicuota.alicuota_percepcion, alicuota.alicuota_retencion, alicuota.periodo_desde, alicuota.periodo_hasta from alicuota where alicuota.cuit = ${cuit.toString()} and alicuota.periodo_desde <= TO_DATE(${periodo_desde.toString()},'yyyy-mm-dd') and alicuota.periodo_hasta >= TO_DATE(${periodo_hasta},'yyyy-mm-dd') and alicuota.id_tipo = ${tipo}`
        console.log(`52. query: ${query} \n`);
        const result = await sql`select alicuota.id as id_bbdd, alicuota.id_tipo as id_tipo_padron, alicuota.cuit, alicuota.razon_social, alicuota.alicuota_percepcion, alicuota.alicuota_retencion, alicuota.periodo_desde, alicuota.periodo_hasta from alicuota where alicuota.cuit = ${cuit.toString()} and alicuota.periodo_desde <= TO_DATE(${periodo_desde.toString()},'yyyy-mm-dd') and alicuota.periodo_hasta >= TO_DATE(${periodo_hasta},'yyyy-mm-dd') and alicuota.id_tipo = ${tipo}`
        res.json(result);
    }
    catch (error) {
        console.error(`Error en servicio - details: `, error);
        res.status(500).json({
            error: true,
            details: `Error en servicio - details: ${error}`
        });
    }
});

// Endpoint para obtener el documento html de una pagina web creado principalmente para servicio de actualizacion de tipo de cambio (Localizaciones ARG)
app.get('/get_html_data_from_url', async (req, res) => {

    let response = { error: true, message: null, response: null };
    let message = ``;

    try {

        const requestParameters = req.query;
        console.log(`74. Request Params: ${JSON.stringify(requestParameters)}`);
        const baseUrl = requestParameters.base_url;
        console.log(`76. Request Base URL To Get: ${baseUrl}`);

        if (!isEmpty(baseUrl)) {

            let htmlData = await axios.get(baseUrl);

            if (!isEmpty(htmlData)) {

                console.log(`84. Request Response Code: ${htmlData.status}`);

                let docHtml = htmlData.data;
                console.log(`87. HTML Body: ${docHtml}`);

                if (!isEmpty(docHtml)) {
                    response.response = docHtml;
                    response.error = false;
                    response.message = `Solicitud realizada con exito.`;
                    res.status(200).json(response);
                }
                else {
                    response.error = true;
                    response.message = `Error: no se pudo obtener html de la web indicada.`;
                    res.status(500).json(response);
                }
            }
            else {
                response.error = true;
                response.message = `Error: parametro "base_url" está vacío o incorrectamente cargado.`;
                res.status(500).json(response);
            }
        }
    }
    catch (e) {
        message = `Error: ${e.message}`;
        response.message = message;
        res.status(500).json(response);
    }
    return response;
});

// Iniciar el servidor
app.listen(port, () => {
    console.log(`118. Servidor corriendo en el puerto ${port}`);
});

let isEmpty = (value) => {

    if (value === ``)
        return true;

    if (value === null)
        return true;

    if (value === undefined)
        return true;

    if (value === `undefined`)
        return true;

    if (value === `null`)
        return true;

    return false;
}