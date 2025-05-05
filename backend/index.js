// setup express, enable cors and json parsing
const express = require('express');
const mysql = require('mysql2/promise');
const cores = require('cors');
const dotenv = require('dotenv');
const router = express.Router();  

module.exports = router;

const app = express();
app.use(cores());
app.use(express.json());


//mysql connection
dotenv.config();
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT
});

// start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
})

//test API
app.get('/', (req, res) => {
    res.send('API is working');
})

//database connection
async function checkDatabaseConnection() {
    try {
        const connection = await pool.getConnection();
        await connection.ping(); // Check if connection is alive
        console.log('Database connected successfully');
        connection.release(); // Release the connection back to the pool
    } catch (err) {
        console.error('Database connection failed:', err.message);
    }
}

// Call the function to check connection
checkDatabaseConnection();


//register user
app.post('/api/registerusers', async (req, res) => {
    const { email, userName, password } = req.body;


    if (!email || !password || !userName) {
        return res.status(400).json({
            error: 'Email, Uer name and password are required'
        });
    }

    try {
        const [result] = await pool.query(
            'INSERT INTO users (email,userName, password) VALUES (?, ?, ?)', [email, userName, password]
        );

        res.status(200).json({ id: result.insertId, email, userName, password });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ error: 'Email and password are required' });
    }

    try {
        // Fetch user details from the database
        const [users] = await pool.query('SELECT email, password FROM users WHERE email = ?', [email]);

        if (users.length === 0) {
            return res.status(401).json({ error: 'Invalid email or password' });
        }

        const user = users[0];
        
        if (user.password !== password) {
            return res.status(401).json({ error: 'Invalid email or password' });
        }

        res.status(200).json({ password: user.password, email: user.email });
    } catch (error) {
        console.error("Login Error:", error);
        res.status(500).json({ error: 'Internal Server Error' });
    }


});


// get  all items
app.get('/api/products', async (req, res) => {
    try {
        console.log('Fetching all items');
        const [items] = await pool.query('SELECT * FROM products');
        res.status(200).json(items);
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

app.post('/api/addtocart', async (req, res) => {
    const {userID, productId, quantity } = req.body;
    console.log('user_id:', userID);
    console.log('product_id:', productId);
    console.log('quantity:',quantity );
    
    if (!userID || !productId || !quantity) {
        return res.status(400).json({ error: 'User ID, Product ID and quantity are required' });
    }
    try {
        console.log('Adding item to cart');
        const [result] = await pool.query(
            'INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)', 
            [userID, productId, quantity]
        );
        
        res.status(200).json({ MessageEvent: 'Item added to cart'});
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

// get cart items

app.get('/api/cart', async (req, res) => {
    try {
        console.log('Fetching cart items');
        const user_id = req.query.user_id; // Get userID from query parameters
        console.log('Received userID:', user_id);

        if (!user_id) {
            return res.status(400).json({ error: "userID is required" });
        }

        // Fetch cart items from the database
        const [cartItems] = await pool.query(
            `SELECT cart.*, products.name, products.description, products.price, products.image_url
             FROM cart 
             JOIN products ON cart.product_id = products.id 
             WHERE cart.user_id = ?`, 
            [user_id]
        );
        console.log('Cart items:', cartItems);
        res.status(200).json(cartItems);
    } catch (error) {
        console.error('Error fetching cart:', error);
        res.status(500).json({ error: error.message });
    }
});


app.delete('/api/deletecart', async (req, res) => {
    try {
        const { cart_id } = req.query; // Get cart_id from query parameters
        console.log('Cart ID to delete:', cart_id);

        if (!cart_id) {
            return res.status(400).json({ error: 'cart_id is required' });
        }

        console.log('Deleting item from cart...');
        const [result] = await pool.query(
            'DELETE FROM cart WHERE id = ?', 
            [cart_id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Cart item not found' });
        }

        res.status(200).json({ message: 'Item deleted from cart' });
    } catch (error) {
        console.error('Error deleting cart item:', error);
        res.status(500).json({ error: error.message });
    }
});

// Checkout Item

app.post('/api/checkout', async (req, res) => {
    const { user_id, product_id, quantity, price, name, address, phoneNo, city, zipCode } = req.body;

    try {
        // Insert the order item
        const [result] = await pool.query(
            'INSERT INTO order_items (user_id, product_id, quantity, price, name, address, phoneNo, city, zipCode) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', 
            [user_id, product_id, quantity, price, name, address, phoneNo, city, zipCode]
        );

        if (result.affectedRows === 0) {
            return res.status(400).json({ message: 'Failed to checkout item' });
        }

        // Delete item from cart after checkout
        const [cartResult] = await pool.query(
            'SELECT * FROM cart WHERE user_id = ? AND product_id = ?', 
            [user_id, product_id]
        );

        if (cartResult.length > 0) {
            await pool.query('DELETE FROM cart WHERE user_id = ? AND product_id = ?', [user_id, product_id]);
        }

        res.status(200).json({ message: 'Item checked out successfully' });

    } catch (error) {
        console.error('Error checking out item:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});


//get one category
app.get('/api/category', async (req, res) => {

    const category = req.query.category;
    console.log('Category:', category);
    try {
        const [items] = await pool.query('SELECT * FROM products WHERE category_id = ?', [category]);
        res.status(200).json(items);
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

//get Order Items
app.get('/api/orders', async (req, res) => {
    const { user_id } = req.query;

    try {
        if (!user_id) {
            return res.status(400).json({ error: 'User ID is required' });
        }

        const [items] = await pool.query(
            'SELECT order_items.*, products.name, products.price, products.image_url FROM order_items ' + 
            'JOIN products ON order_items.product_id = products.id ' + 
            'WHERE order_items.user_id = ?', 
            [user_id]
        );

        if (items.length === 0) {
            return res.status(404).json({ error: 'No order items found' });
        }

        res.status(200).json(items);
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

// search products
app.get('/api/search', async (req, res) => {
    const { nameItem } = req.query;
    console.log('Search:', nameItem);
    try {
        const [items] = await pool.query('SELECT * FROM products WHERE name LIKE ?', [`%${nameItem}%`]);
        res.status(200).json(items);
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});


app.get('/api/offers', async (req, res) => {
    try {
        const [items] = await pool.query(`
            SELECT products.*, offers.*
            FROM products
            JOIN offers ON products.id = offers.product_id
        `);
        res.json(items);
    } catch (error) {
        console.error('Error fetching offers:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});
