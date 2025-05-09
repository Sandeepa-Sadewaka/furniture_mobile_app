const pool = require('../config/db');

exports.getAllProducts = async (req, res, next) => {
  try {
    const [items] = await pool.query('SELECT * FROM products');
    res.status(200).json(items);
  } catch (error) {
    next(error);
  }
};

exports.getProductsByCategory = async (req, res, next) => {
  try {
    const category = req.query.category;
    const [items] = await pool.query('SELECT * FROM products WHERE category_id = ?', [category]);
    res.status(200).json(items);
  } catch (error) {
    next(error);
  }
};

exports.searchProducts = async (req, res, next) => {
  try {
    const { nameItem } = req.query;
    const [items] = await pool.query('SELECT * FROM products WHERE name LIKE ?', [`%${nameItem}%`]);
    res.status(200).json(items);
  } catch (error) {
    next(error);
  }
};

exports.getOffers = async (req, res, next) => {
  try {
    const [items] = await pool.query(`
      SELECT products.*, offers.*
      FROM products
      JOIN offers ON products.id = offers.product_id
    `);
    res.json(items);
  } catch (error) {
    next(error);
  }
};