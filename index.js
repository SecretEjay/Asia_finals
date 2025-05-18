import express from 'express';
import mysql from 'mysql2';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
import rateLimit from 'express-rate-limit';

dotenv.config();

const SECRET_KEY = process.env.SECRET_KEY;

const app = express();
const port = 3000;
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Initialize server
app.listen(port, () => {
  console.log('running on port ' + port);
  console.log(`Server running on http://localhost:` + port);
});

// connect to MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'post_db'
});

db.connect(err => {
  if (err) throw err;
  console.log('Connected to MySQL!');
});

// rate limiter
const limiter = rateLimit({
  windowMs: 2 * 60 * 1000,
  max: 100,
  message: { message: "Too many requests, please try again later." }
});
app.use(limiter);

// Register
app.post('/register', async (req, res) => {
  const { username, password } = req.body;

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    db.query(
      'INSERT INTO user (username, password) VALUES (?, ?)',
      [username, hashedPassword],
      (err, result) => {
        if (err) {
          if (err.code === 'ER_DUP_ENTRY') {
            return res.status(409).json({ message: 'Username already exists' });
          }
          return res.status(500).json({ message: 'Database error', error: err });
        }

        res.status(201).json({ message: 'User registered successfully' });
      }
    );
  } catch (err) {
    res.status(500).json({ message: 'Error registering user', error: err.message });
  }
});

// Login
app.post('/login', (req, res) => {
  const { username, password } = req.body;

  db.query(
    'SELECT * FROM user WHERE username = ?',
    [username],
    async (err, results) => {
      if (err) {
        return res.status(500).json({ message: 'Database error', error: err });
      }

      if (results.length === 0) {
        return res.status(401).json({ message: 'Invalid credentials' });
      }

      const user = results[0];

      const isPasswordValid = await bcrypt.compare(password, user.password);
      if (!isPasswordValid) {
        return res.status(401).json({ message: 'Invalid credentials' });
      }

      const token = jwt.sign(
        { id: user.id, username: user.username },
        SECRET_KEY,
        { expiresIn: '1h' }
      );

      res.json({ message: 'Login successful', token });
    }
  );
});

// middleware to authenticate token
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.status(401).json({ message: 'Token required' });

  jwt.verify(token, SECRET_KEY, (err, user) => {
    if (err) return res.status(403).json({ message: 'Invalid token' });
    req.user = user;
    next();
  });
}

// Retrieve all
app.get('/posts', authenticateToken, (req, res) => {
  const sql = 'SELECT * FROM posts';

  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Database error', error: err });
    }
    res.status(200).json(results);
  });
});

// Retrieve a single post
app.get('/post/:id', authenticateToken, (req, res) => {
  const sql = 'SELECT * FROM posts WHERE id = ?';
  db.query(sql, [req.params.id], (err, results) => {
    if (err) return res.status(500).json({ message: 'Database error', error: err });
    if (results.length === 0) return res.status(404).json({ message: 'Post not found' });
    res.status(200).json(results[0]);
  });
});

// Create new post
app.post('/post', authenticateToken, (req, res) => {
  const { title, content, author } = req.body;
  const sql = 'INSERT INTO posts (title, content, author) VALUES (?, ?, ?)';
  db.query(sql, [title, content, author], (err, result) => {
    if (err) return res.status(500).json({ message: 'Database error', error: err });
    res.status(201).json({ message: 'Post created', postId: result.insertId });
  });
});

// Update post
app.put('/update/:id', authenticateToken, (req, res) => {
  const { title, content, author } = req.body;
  const sql = 'UPDATE posts SET title = ?, content = ?, author = ? WHERE id = ?';
  db.query(sql, [title, content, author, req.params.id], (err, result) => {
    if (err) return res.status(500).json({ message: 'Database error', error: err });
    if (result.affectedRows === 0) return res.status(404).json({ message: 'Post not found' });
    res.status(200).json({ message: 'Post updated' });
  });
});

// Delete post
app.delete('/delete/:id', authenticateToken, (req, res) => {
  const sql = 'DELETE FROM posts WHERE id = ?';
  db.query(sql, [req.params.id], (err, result) => {
    if (err) return res.status(500).json({ message: 'Database error', error: err });
    if (result.affectedRows === 0) return res.status(404).json({ message: 'Post not found' });
    res.status(200).json({ message: 'Post deleted' });
  });
});
