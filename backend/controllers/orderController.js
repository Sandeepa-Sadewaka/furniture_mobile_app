const pool = require('../config/db');

module.exports = {
  checkout: async (req, res, next) => {
    try {
      console.log('Order controller loaded');
      const {
        user_id,
        product_id,
        quantity,
        price,
        name,
        address,
        phoneNo,
        city,
        zipCode,
        latitude,
        longitude
      } = req.body;

      // Validate input
      if (
        !user_id || !product_id || !quantity || !price ||
        !name || !address || !phoneNo || !city || !zipCode ||
        !latitude || !longitude
      ) {
        return res.status(400).json({ error: 'All fields are required' });
      }

      // Start transaction
      const conn = await pool.getConnection();
      await conn.beginTransaction();

      try {
        // First, create location entry
        const [locationResult] = await conn.query(
          `INSERT INTO locations 
           (latitude, longitude, address, timestamp) 
           VALUES (?, ?, ?, NOW())`,
          [latitude, longitude, address]
        );

        const locationId = locationResult.insertId;

        // Then create order with location_id reference
        const [orderResult] = await conn.query(
          `INSERT INTO order_items 
           (user_id, product_id, quantity, price, name, address, phoneNo, city, zipCode, location_id) 
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
          [user_id, product_id, quantity, price, name, address, phoneNo, city, zipCode, locationId]
        );

        const orderId = orderResult.insertId;

        // Clear cart for that product
        await conn.query(
          'DELETE FROM cart WHERE user_id = ? AND product_id = ?',
          [user_id, product_id]
        );

        await conn.commit();

        res.status(200).json({
          message: 'Order placed successfully',
          orderId,
          locationId
        });
      } catch (err) {
        await conn.rollback();
        console.error('Transaction error:', err);
        res.status(500).json({ error: 'Failed to place order' });
      } finally {
        conn.release();
      }
    } catch (error) {
      console.error('Checkout error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  },

  getOrderHistory: async (req, res, next) => {
    console.log('Get order history controller loaded');
    try {
      const { user_id } = req.query;

      if (!user_id) {
        return res.status(400).json({ error: 'User ID is required' });
      }

      const [orders] = await pool.query(`
        SELECT 
          oi.id as order_id,
          oi.product_id,
          p.name as product_name,
          oi.quantity,
          oi.price,
          oi.address,
          oi.phoneNo,
          oi.city,
          oi.zipCode,
          p.image_url,
          l.latitude,
          l.longitude,
          l.timestamp as delivery_timestamp
        FROM order_items oi
        JOIN products p ON oi.product_id = p.id
        LEFT JOIN locations l ON oi.location_id = l.id
        WHERE oi.user_id = ?
        ORDER BY oi.id DESC
      `, [user_id]);

      res.status(200).json(orders);
    } catch (error) {
      console.error('Error fetching order history:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
};