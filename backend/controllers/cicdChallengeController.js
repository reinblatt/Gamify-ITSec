const Challenge = require('../models/Challenge');

const createCICDChallenge = async (req, res) => {
  try {
    const challenge = await Challenge.create({
      name: 'CI/CD Security Challenge',
      description: 'Secure a vulnerable Jenkins pipeline by identifying and fixing security issues.',
      points: 100,
      difficulty: 'intermediate'
    });

    res.status(201).json(challenge);
  } catch (error) {
    res.status(500).json({ message: 'Error creating challenge', error: error.message });
  }
};

const validateCICDChallenge = async (req, res) => {
  try {
    const { jenkinsConfig } = req.body;
    
    // Check for common security issues
    const issues = [];
    
    // Check for exposed credentials
    if (jenkinsConfig.includes('password') || jenkinsConfig.includes('secret')) {
      issues.push('Exposed credentials found in pipeline configuration');
    }
    
    // Check for proper security scanning
    if (!jenkinsConfig.includes('security-scan') && !jenkinsConfig.includes('vulnerability')) {
      issues.push('Missing security scanning in pipeline');
    }
    
    // Check for proper access controls
    if (!jenkinsConfig.includes('authorization') && !jenkinsConfig.includes('permissions')) {
      issues.push('Missing proper access controls');
    }

    if (issues.length === 0) {
      // Update challenge status
      await Challenge.update(
        { status: 'completed', endTime: new Date() },
        { where: { name: 'CI/CD Security Challenge' } }
      );
      
      res.json({ 
        success: true, 
        message: 'Challenge completed successfully!',
        points: 100
      });
    } else {
      res.json({
        success: false,
        message: 'Security issues found',
        issues: issues
      });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error validating challenge', error: error.message });
  }
};

module.exports = {
  createCICDChallenge,
  validateCICDChallenge
}; 