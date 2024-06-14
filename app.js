const express = require('express');
const { Pool } = require('pg');
const dotenv = require('dotenv');
const postgres = require('postgres');
//import postgres from 'postgres'

// Cargar variables de entorno desde el archivo .env
dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

// Configuración de la conexión a PostgreSQL
const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT
});
//postgres://padron_xot0_user:MtuEnTA6ZoWWaCKLEAcJf9dRvnoXVLAK@dpg-cplg748cmk4c739o4ok0-a.oregon-postgres.render.com/padron_xot0
const sql = postgres({
    host                 : process.env.DB_HOST,            // Postgres ip address[s] or domain name[s]
    port                 : process.env.DB_PORT,          // Postgres server port[s]
    database             : process.env.DB_NAME,            // Name of database to connect to
    username             : process.env.DB_USER,            // Username of database user
    password             : process.env.DB_PASSWORD,            // Password of database user
    idle_timeout: 60000,  // 1 minuto
    connect_timeout: 120000  // 2 minutos
  });

// Middleware para parsear JSON
app.use(express.json());

// Endpoint para realizar una consulta básica con parámetros dinámicos
app.get('/search', async (req, res) => {
  //const { cuit } = req.query;
  console.log('req.query'+ JSON.stringify(req.query));

  const cuit = req[`query`][`cuit`];
  const dia = parseInt(req[`query`][`dia`]);
  const mes = parseInt(req[`query`][`mes`]);
  const ano = parseInt(req[`query`][`ano`]);
  console.log(`cuit: ${cuit} - dia: ${dia} - mes: ${mes} - ano: ${ano}`);
  /*if (!cuit) {
    return res.status(400).json({ error: 'Falta el parámetro de búsqueda' });
  }*/

  try {
    //const result = await pool.query(`SELECT alicuota_p::numeric from alicuota WHERE cuit = '${searchParam}'`);
    console.log('39. Conectado a la base de datos');
    //const client = await pool.connect();
    
    //const consulta = `select alicuota.razon_social, alicuota.cuit, alicuota.alicuota_percepcion, alicuota.alicuota_retencion, tipo.nombre as padron from alicuota inner join tipo on alicuota.id_tipo = tipo.id  where alicuota.cuit = '${cuit}' and alicuota.periodo_inicio_dia <= ${dia} and alicuota.periodo_inicio_mes = ${mes} and alicuota.periodo_inicio_ano = ${ano} and alicuota.periodo_fin_dia >= ${dia}`;
    console.log('41. consulta: '+consulta);
    //const result = await sql `select alicuota.razon_social, alicuota.cuit, alicuota.alicuota_percepcion, alicuota.alicuota_retencion, tipo.nombre as padron from alicuota inner join tipo on alicuota.id_tipo = tipo.id  where alicuota.cuit = '${cuit}' and alicuota.periodo_inicio_dia <= ${dia} and alicuota.periodo_inicio_mes = ${mes} and alicuota.periodo_inicio_ano = ${ano} and alicuota.periodo_fin_dia >= ${dia}`;
    //const result = await pool.query(consulta);
    const result = await sql`select alicuota.razon_social, alicuota.cuit, alicuota.alicuota_percepcion, alicuota.alicuota_retencion from alicuota where alicuota.cuit = '20000163989'`;
    
    res.json(result.rows);
  } catch (error) {
    console.error('Error al realizar la consulta', error);
    res.status(500).json({ error: 'Error al realizar la consulta' });
  }
});


// Iniciar el servidor
app.listen(port, () => {
  console.log(`Servidor corriendo en el puerto ${port}`);
});
