const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Test connection
async function checkDatabaseConnection() {
  try {
    const connection = await pool.getConnection();
    await connection.ping();
    console.log('Database connected successfully');
    connection.release();
  } catch (err) {
    console.error('Database connection failed:', err.message);
  }
}

checkDatabaseConnection();

module.exports = pool;