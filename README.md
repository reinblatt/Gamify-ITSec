# DevSecQuest

An open-source, gamified learning platform for cybersecurity professionals transitioning to DevSecOps.

## Overview

DevSecQuest is designed to help cybersecurity professionals acquire DevSecOps skills through hands-on challenges and gamified learning experiences. The platform runs locally using Docker and Kubernetes, ensuring data privacy and control.

## Features

- 🎮 Gamified learning experience with points, badges, and leaderboards
- 🛡️ Hands-on cybersecurity and DevSecOps challenges
- 🐳 Local hosting using Docker and Kubernetes
- 📚 Personalized learning paths
- 🤝 Community-driven development

## System Requirements

### Hardware Requirements
- CPU: 2+ cores
- RAM: 8GB minimum (16GB recommended)
- Storage: 20GB free space
- Network: Internet connection for downloading dependencies

### Software Requirements
- Operating System:
  - Windows 10/11 (64-bit)
  - macOS 10.15+
  - Linux (Ubuntu 20.04+, CentOS 8+)
- Docker Desktop 4.0+
- Kubernetes (Minikube or Kind)
- Node.js 16+
- Python 3.8+
- Git

## Project Structure

```
devsecquest/
├── frontend/         # React-based frontend application
├── backend/          # Node.js/Python backend services
├── kubernetes/       # Kubernetes manifests and configurations
├── challenges/       # Challenge definitions and environments
│   ├── ci-cd-security/  # CI/CD Security Challenge
│   │   ├── README.md    # Challenge overview
│   │   ├── WALKTHROUGH.md # Step-by-step guide
│   │   ├── SETUP.md     # Setup instructions
│   │   ├── Dockerfile   # Challenge environment
│   │   └── jenkins.yaml # Jenkins configuration
│   └── ...           # Other challenges
└── docs/            # Documentation and guides
```

## Quick Start Guide

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/devsecquest.git
   cd devsecquest
   ```

2. **Verify Prerequisites**:
   ```bash
   # Check Docker
   docker --version
   docker-compose --version
   
   # Check Kubernetes
   kubectl version
   
   # Check Node.js
   node --version
   
   # Check Python
   python --version
   ```

3. **Start the Development Environment**:
   ```bash
   # Start Minikube
   minikube start --memory=8192 --cpus=4
   
   # Enable required addons
   minikube addons enable ingress
   minikube addons enable metrics-server
   
   # Deploy the application
   kubectl apply -f kubernetes/
   ```

4. **Access the Application**:
   ```bash
   # Get the frontend service URL
   minikube service devsecquest-frontend
   ```

## Detailed Setup Instructions

### Docker Setup
1. Install Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop)
2. Verify installation:
   ```bash
   docker run hello-world
   ```

### Kubernetes Setup
1. Install Minikube:
   ```bash
   # Windows
   choco install minikube
   
   # macOS
   brew install minikube
   
   # Linux
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
   sudo install minikube-linux-amd64 /usr/local/bin/minikube
   ```

2. Start Minikube:
   ```bash
   minikube start --driver=docker
   ```

### Development Environment
1. Install Node.js dependencies:
   ```bash
   cd frontend
   npm install
   ```

2. Install Python dependencies:
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

## Troubleshooting

### Common Issues

1. **Docker Won't Start**
   - Check if virtualization is enabled in BIOS
   - Verify Docker service is running
   - Check system requirements

2. **Minikube Won't Start**
   - Check if Docker is running
   - Verify system resources
   - Try: `minikube delete && minikube start`

3. **Application Won't Deploy**
   - Check Kubernetes logs: `kubectl logs -f <pod-name>`
   - Verify resource limits
   - Check network connectivity

4. **Challenge Environment Issues**
   - Check challenge-specific README
   - Verify Docker containers are running
   - Check port availability

### Debugging Tools

1. **Kubernetes Debugging**:
   ```bash
   # Get pod status
   kubectl get pods
   
   # View pod logs
   kubectl logs <pod-name>
   
   # Describe pod
   kubectl describe pod <pod-name>
   ```

2. **Docker Debugging**:
   ```bash
   # List containers
   docker ps -a
   
   # View container logs
   docker logs <container-id>
   
   # Check container status
   docker inspect <container-id>
   ```

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](docs/CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests
5. Submit a pull request

### Code Standards
- Follow PEP 8 for Python code
- Use ESLint for JavaScript/TypeScript
- Write clear commit messages
- Include tests for new features

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the need for practical DevSecOps training
- Built with the open-source community in mind
- Special thanks to all contributors 