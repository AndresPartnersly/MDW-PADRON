const express = require('express');
const { Pool } = require('pg');
const dotenv = require('dotenv');
const postgres = require('postgres');

// Cargar variables de entorno desde el archivo .env
dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

const sql = postgres({
    host                 : process.env.DB_HOST,            // Postgres ip address[s] or domain name[s]
    port                 : process.env.DB_PORT,          // Postgres server port[s]
    database             : process.env.DB_NAME,            // Name of database to connect to
    username             : process.env.DB_USER,            // Username of database user
    password             : process.env.DB_PASSWORD,
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
    console.log(`CUIT: ${cuit} - DESDE: ${periodo_desde} - HASTA: ${periodo_hasta} - TIPO PADRON: ${tipo} \n`);
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
    console.log(`CUIT: ${cuit} - DESDE: ${periodo_desde} - HASTA: ${periodo_hasta} - TIPO PADRON: ${tipo} \n`);
    try
    {
        const query = `select alicuota.id as id_bbdd, alicuota.id_tipo as id_tipo_padron, alicuota.cuit, alicuota.razon_social, alicuota.alicuota_percepcion, alicuota.alicuota_retencion, alicuota.periodo_desde, alicuota.periodo_hasta from alicuota where alicuota.cuit = ${cuit.toString()} and alicuota.periodo_desde <= TO_DATE(${periodo_desde.toString()},'yyyy-mm-dd') and alicuota.periodo_hasta >= TO_DATE(${periodo_hasta},'yyyy-mm-dd') and alicuota.id_tipo = ${tipo}`
        console.log(`query: ${query} \n`);
        const result = await sql`select alicuota.id as id_bbdd, alicuota.id_tipo as id_tipo_padron, alicuota.cuit, alicuota.razon_social, alicuota.alicuota_percepcion, alicuota.alicuota_retencion, alicuota.periodo_desde, alicuota.periodo_hasta from alicuota where alicuota.cuit = ${cuit.toString()} and alicuota.periodo_desde <= TO_DATE(${periodo_desde.toString()},'yyyy-mm-dd') and alicuota.periodo_hasta >= TO_DATE(${periodo_hasta},'yyyy-mm-dd') and alicuota.id_tipo = ${tipo}`
        res.json(result);
    }
    catch (error)
    {
        console.error(`Error en servicio - details: `, error);
        res.status(500).json({ 
            error: true,
            details: `Error en servicio - details: ${error}`
         });
    }
});


// Iniciar el servidor
app.listen(port, () => {
    console.log(`Servidor corriendo en el puerto ${port}`);
});
