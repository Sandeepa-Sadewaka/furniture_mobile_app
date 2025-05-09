const pool = require('../config/db');

module.exports = {
  checkout: async (req, res, next) => {
    try {
      const { userId, items, address, phone, city, zipCode } = req.body;
      
      // Validate input
      if (!userId || !items || !Array.isArray(items) || items.length === 0) {
        return res.status(400).json({ error: 'Invalid order data' });
      }

      // Start transaction
      const conn = await pool.getConnection();
      await conn.beginTransaction();

      try {
        // Create order
        const [orderResult] = await conn.query(
          'INSERT INTO orders (user_id, address, phone, city, zip_code) VALUES (?, ?, ?, ?, ?)',
          [userId, address, phone, city, zipCode]
        );
        const orderId = orderResult.insertId;

        // Add order items
        for (const item of items) {
          await conn.query(
            'INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)',
            [orderId, item.productId, item.quantity, item.price]
          );
        }

        // Clear cart
        await conn.query('DELETE FROM cart WHERE user_id = ?', [userId]);

        await conn.commit();
        res.status(201).json({ 
          message: 'Order placed successfully',
          orderId 
        });
      } catch (err) {
        await conn.rollback();
        throw err;
      } finally {
        conn.release();
      }
    } catch (error) {
      next(error);
    }
  },

  getOrderHistory: async (req, res, next) => {
    try {
      const { userId } = req.query;
      
      if (!userId) {
        return res.status(400).json({ error: 'User ID is required' });
      }

      const [orders] = await pool.query(`
        SELECT o.*, 
          JSON_ARRAYAGG(
            JSON_OBJECT(
              'productId', oi.product_id,
              'name', p.name,
              'quantity', oi.quantity,
              'price', oi.price,
              'imageUrl', p.image_url
            )
          ) as items
        FROM orders o
        JOIN order_items oi ON o.id = oi.order_id
        JOIN products p ON oi.product_id = p.id
        WHERE o.user_id = ?
        GROUP BY o.id
        ORDER BY o.created_at DESC
      `, [userId]);
      
      res.status(200).json(orders);
    } catch (error) {
      next(error);
    }
  }
};