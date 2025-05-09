const express = require('express');
const router = express.Router();
const locationController = require('../controllers/locationController');

// POST /api/locations
router.post('/', locationController.saveLocation);

// GET /api/locations?userId=:id
router.get('/', locationController.getLocations);

module.exports = router;