const express = require('express');
const router = express.Router();
const orderController = require('../controllers/orderController');

// POST /api/orders/checkout
router.post('/checkout', orderController.checkout);

// GET /api/orders?userId=:id
router.get('/', orderController.getOrderHistory);

module.exports = router;