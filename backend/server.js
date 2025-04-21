const express = require('express');
const cors = require('cors');
const sequelize = require('./config/database');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Import routes
const challengeRoutes = require('./routes/challengeRoutes');

// Use routes
app.use('/api/challenges', challengeRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to DevSecQuest API' });
});

// Basic error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Something went wrong!' });
});

// Database connection
sequelize.authenticate()
  .then(() => {
    console.log('Database connection established successfully.');
    // Sync all models
    return sequelize.sync();
  })
  .then(() => {
    console.log('All models were synchronized successfully.');
    // Start server
    app.listen(port, '0.0.0.0', () => {
      console.log(`Server is running on port ${port}`);
    });
  })
  .catch(err => {
    console.error('Unable to connect to the database:', err);
  }); 