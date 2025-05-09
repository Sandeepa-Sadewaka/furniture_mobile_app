const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');

// Get all products
router.get('/', productController.getAllProducts);

// Get products by category
router.get('/category', productController.getProductsByCategory);

// Search products
router.get('/search', productController.searchProducts);

// Get offers
router.get('/offers', productController.getOffers);

module.exports = router;