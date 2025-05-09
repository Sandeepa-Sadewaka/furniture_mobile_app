const pool = require('../config/db');

module.exports = {
  saveLocation: async (req, res, next) => {
    try {
      const { userId, latitude, longitude, address } = req.body;
      
      if (!userId || !latitude || !longitude) {
        return res.status(400).json({ error: 'Required fields missing' });
      }

      const [result] = await pool.query(
        'INSERT INTO locations (user_id, latitude, longitude, address) VALUES (?, ?, ?, ?)',
        [userId, latitude, longitude, address]
      );
      
      res.status(201).json({ 
        id: result.insertId,
        latitude,
        longitude,
        address
      });
    } catch (error) {
      next(error);
    }
  },

  getLocations: async (req, res, next) => {
    try {
      const { userId } = req.query;
      
      if (!userId) {
        return res.status(400).json({ error: 'User ID is required' });
      }

      const [locations] = await pool.query(
        'SELECT * FROM locations WHERE user_id = ? ORDER BY created_at DESC',
        [userId]
      );
      
      res.status(200).json(locations);
    } catch (error) {
      next(error);
    }
  }
};