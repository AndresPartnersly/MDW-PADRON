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
    password             : process.env.DB_PASSWORD,            // Password of database user
    idle_timeout: 60 * 1000,
    connect_timeout: 1200
  });

// Middleware para parsear JSON
app.use(express.json());

// Endpoint para realizar una consulta básica con parámetros dinámicos
app.get('/search', async (req, res) => {

    const cuit = req[`query`][`cuit`].toString();
    const dia = parseInt(req[`query`][`dia`]);
    const mes = parseInt(req[`query`][`mes`]);
    const ano = parseInt(req[`query`][`ano`]);

    console.log(`CUIT: ${cuit} - DIA: ${dia} - MES: ${mes} - AñO: ${ano} \n`);
  
    if (!cuit) {
        return res.status(400).json({ error: `Falta parametro "cuit"` });
    }

    if (!dia) {
        return res.status(400).json({ error: `Falta parametro "dia"` });
    }

    if (!mes) {
        return res.status(400).json({ error: `Falta parametro "mes"` });
    }

    if (!ano) {
        return res.status(400).json({ error: `Falta parametro "año"` });
    }

    try
    {
        const result = await sql`select alicuota.razon_social, alicuota.cuit, alicuota.alicuota_percepcion, alicuota.alicuota_retencion from alicuota where alicuota.cuit = ${cuit} and alicuota.periodo_inicio_dia <= ${dia} and alicuota.periodo_inicio_mes = ${mes} and alicuota.periodo_inicio_ano = ${ano} and alicuota.periodo_fin_dia >= ${dia}`;
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
