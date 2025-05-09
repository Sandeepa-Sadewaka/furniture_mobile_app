class User {
    constructor(email, userName, password) {
      this.email = email;
      this.userName = userName;
      this.password = password;
    }
  
    static async create(userData) {
      const [result] = await pool.query(
        'INSERT INTO users (email, userName, password) VALUES (?, ?, ?)',
        [userData.email, userData.userName, userData.password]
      );
      return { id: result.insertId, ...userData };
    }
  
    static async findByEmail(email) {
      const [users] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);
      return users[0];
    }
  }
  
  module.exports = User;