const express = require('express');
const sql = require('mssql');
const app = express();

const SERVER = "<SERVER>"
const SOURCE = "PRY***_DB"

const USERNAME = "<USERNAME>"
const PASSWORD = "<PASSWORD>"

const config = {
    user: USERNAME,
    password: PASSWORD,
    server: SERVER, 
    database: SOURCE,
    options: {
        encrypt: false,
        trustServerCertificate: true
    }
};

app.get('/data', async (req, res) => {
    try {
        let pool = await sql.connect(config);
        let result = await pool.request().query('SELECT * FROM student');
        res.json(result.recordset);
    } catch (err) {
        console.error('SQL error', err);
        res.status(500).send('Server Error');
    }
});

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});
