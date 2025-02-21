// setup express, enable cors and json parsing
const express = require('express');
const mysql = require('mysql2/promise');
const cores = require('cors');
const dotenv = require('dotenv');

const app = express();
app.use(cores());
app.use(express.json());


//mysql connection
dotenv.config();
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT
});

// start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
})

//test API
app.get('/', (req, res) => {
    res.send('API is working');
})

//database connection
async function checkDatabaseConnection() {
    try {
        const connection = await pool.getConnection();
        await connection.ping(); // Check if connection is alive
        console.log('Database connected successfully');
        connection.release(); // Release the connection back to the pool
    } catch (err) {
        console.error('Database connection failed:', err.message);
    }
}

// Call the function to check connection
checkDatabaseConnection();


//register user
app.post('/api/registerusers', async (req, res) => {
    const { email, userName, password } = req.body;

   
    if (!email || !password|| !userName) {
        return res.status(400).json({
            error: 'Email, Uer name and password are required'
        });
    }

    try {
        const [result] = await pool.query(
            'INSERT INTO users (email,userName, password) VALUES (?, ?, ?)', [email ,userName ,password]
        );

        res.status(200).json({ id: result.insertId, email,userName,password }); 
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

