const express = require('express');
const router = express.Router();
const { createCICDChallenge, validateCICDChallenge } = require('../controllers/cicdChallengeController');

// Create a new CI/CD challenge
router.post('/cicd', createCICDChallenge);

// Validate CI/CD challenge completion
router.post('/cicd/validate', validateCICDChallenge);

// Get all challenges
router.get('/', async (req, res) => {
  try {
    const challenges = await Challenge.findAll();
    res.json(challenges);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching challenges', error: error.message });
  }
});

module.exports = router; 