const pool = require('../config/db');

module.exports = {
  register: async (req, res, next) => {
    try {
      const { email, userName, password } = req.body;
      console.log('Registering user:', req.body);
      
      if (!email || !userName || !password) {
        return res.status(400).json({ error: 'All fields are required' });
      }

      const [result] = await pool.query(
        'INSERT INTO users (email, userName, password) VALUES (?, ?, ?)',
        [email, userName, password]
      );
      
      res.status(200).json({ 
        id: result.insertId, 
        email, 
        userName 
      });
    } catch (error) {
      next(error);
    }
  },

  login: async (req, res, next) => {
    try {
      const { email, password } = req.body;
      
      if (!email || !password) {
        return res.status(400).json({ error: 'Email and password are required' });
      }

      const [users] = await pool.query(
        'SELECT * FROM users WHERE email = ?', 
        [email]
      );
      if (users.length === 0 || users[0].password !== password) {
        return res.status(401).json({ error: 'Invalid credentials' });
      }

      res.status(200).json({ 
        id: users[0].id,
        email: users[0].email,
        userName: users[0].userName,
        password: users[0].password
      });
    } catch (error) {
      next(error);
    }
  }
};