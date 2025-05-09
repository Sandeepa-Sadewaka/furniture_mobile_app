const express = require('express');
const router = express.Router();
const cartController = require('../controllers/cartController');

// POST /api/cart
router.post('/', cartController.addToCart);

// GET /api/cart?userId=:id
router.get('/', cartController.getCartItems);

// DELETE /api/cart/:cartId
router.delete('/:cartId', cartController.removeFromCart);

module.exports = router;