# CI/CD Security Challenge Setup Guide

## Prerequisites
Before starting this challenge, make sure you have:
1. Docker installed on your system
2. Docker Compose installed on your system
3. A web browser to access Jenkins
4. Basic understanding of CI/CD concepts

## Installation Steps

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/devsecquest.git
cd devsecquest
```

### 2. Verify Docker Installation
```bash
# Check Docker version
docker --version

# Check Docker Compose version
docker-compose --version
```

### 3. Start the Challenge Environment
```bash
# Navigate to the project root directory
cd devsecquest

# Start the Jenkins container
docker-compose up -d challenge-env
```

### 4. Verify the Container is Running
```bash
# Check if the container is running
docker ps | findstr challenge-env
```
You should see output similar to:
```
CONTAINER ID   IMAGE                        COMMAND                  STATUS         PORTS
175505bddacf   gamify-itsec-challenge-env   "/usr/bin/tini -- /u…"   Up 5 minutes   0.0.0.0:8080->8080/tcp, 50000/tcp
```

### 5. Access Jenkins
1. Open your web browser
2. Navigate to: `http://localhost:8080`
3. Log in with the following credentials:
   - Username: `admin`
   - Password: `admin`

### 6. Verify Jenkins Setup
1. After logging in, you should see the Jenkins dashboard
2. Check that you can access:
   - Manage Jenkins
   - New Item
   - People
   - Build History

### 7. Start the Challenge
1. Read the challenge walkthrough: [WALKTHROUGH.md](WALKTHROUGH.md)
2. Follow the steps to complete the security challenges

## Troubleshooting

### Common Issues

1. **Port 8080 is already in use**
   ```bash
   # Find the process using port 8080
   netstat -ano | findstr :8080
   
   # Stop the process or change the port in docker-compose.yml
   ```

2. **Docker container won't start**
   ```bash
   # Check Docker logs
   docker logs gamify-itsec-challenge-env-1
   
   # Restart Docker service
   # Windows: Restart Docker Desktop
   # Linux: sudo systemctl restart docker
   ```

3. **Can't access Jenkins**
   - Verify the container is running
   - Check if port 8080 is accessible
   - Try accessing with different browsers
   - Clear browser cache

### Getting Help
If you encounter any issues:
1. Check the [WALKTHROUGH.md](WALKTHROUGH.md) for solutions
2. Review the Docker logs
3. Check the Jenkins system logs
4. Create an issue in the GitHub repository

## Next Steps
After completing the setup:
1. Read the challenge objectives in [README.md](README.md)
2. Follow the step-by-step guide in [WALKTHROUGH.md](WALKTHROUGH.md)
3. Start with Task 1: Finding Exposed Credentials

## Additional Resources
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/) 