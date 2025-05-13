const pool = require('../config/db');

module.exports = {
  addToCart: async (req, res, next) => {
    try {
      const { userID, productId, quantity } = req.body;
      
      if (!userID || !productId || !quantity) {
    console.log("addToCart called with body:", req.body);
        return res.status(400).json({ error: 'All fields are required' });
      }

      const [result] = await pool.query(
        'INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)',
        [userID, productId, quantity]
      );
      
      res.status(200).json({ 
        message: 'Item added to cart',
        cartId: result.insertId
      });
    } catch (error) {
      next(error);
    }
  },
  
  getCartItems: async (req, res, next) => {
    try {
      const { user_id } = req.query;
  
      if (!user_id) {
        return res.status(400).json({ error: 'User ID is required' });
      }
  
      const [cartItems] = await pool.query(
        `
        SELECT c.*, p.name AS product_name, p.price, p.image_url 
        FROM cart c
        JOIN products p ON c.product_id = p.id
        WHERE c.user_id = ?
        `,
        [user_id]
      );
      res.status(200).json(cartItems);
    } catch (error) {
      console.error("Error fetching cart items:", error);
      res.status(500).json({ error: 'Server error' });
    }
  },
  
  removeFromCart: async (req, res, next) => {
    console.log("removeFromCart called with params:", req.params);
  
    try {
      const { cartId } = req.params;
  
      if (!cartId) {
        return res.status(400).json({ error: 'Cart ID is required' });
      }
  
      const [result] = await pool.query(
        'DELETE FROM cart WHERE id = ?',
        [cartId]
      );
  
      if (result.affectedRows === 0) {
        return res.status(404).json({ error: 'Cart item not found' });
      }
  
      res.status(200).json({ message: 'Item removed from cart' });
    } catch (error) {
      console.error('Error removing item from cart:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  },
};
  