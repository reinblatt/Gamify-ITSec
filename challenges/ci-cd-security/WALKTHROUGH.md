# CI/CD Security Challenge Walkthrough
## A Beginner's Guide to Securing Jenkins Pipelines

### Prerequisites
Before starting this challenge, make sure you have:
1. Docker and Docker Compose installed on your system
2. Basic understanding of Jenkins and CI/CD concepts
3. A web browser to access Jenkins
4. Git installed for cloning the repository

### Initial Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/Gamify-ITSec.git
   cd Gamify-ITSec
   ```

2. Verify your Docker installation:
   ```bash
   # Check Docker version
   docker --version
   
   # Check Docker Compose version
   docker-compose --version
   ```

### Step 1: Starting the Challenge Environment
1. Navigate to the project directory:
   ```bash
   cd challenges/ci-cd-security
   ```

2. Start the Jenkins container:
   ```bash
   docker-compose up -d challenge-env
   ```

3. Wait for the container to start (about 1-2 minutes)

4. Verify the container is running:
   ```bash
   docker ps | findstr challenge-env
   ```
   You should see output similar to:
   ```
   CONTAINER ID   IMAGE                        COMMAND                  STATUS         PORTS
   175505bddacf   gamify-itsec-challenge-env   "/usr/bin/tini -- /u…"   Up 5 minutes   0.0.0.0:8080->8080/tcp, 50000/tcp
   ```

### Step 2: Accessing Jenkins
1. Open your web browser
2. Navigate to: `http://localhost:8080`
3. Log in with the following credentials:
   - Username: `admin`
   - Password: `admin`
   > Note: These credentials are pre-configured in the Jenkins environment for this challenge.

### Step 3: Understanding the Challenge
The challenge consists of five main tasks:
1. Finding exposed credentials
2. Implementing secret management
3. Adding security scanning
4. Configuring access controls
5. Securing artifact handling

### Step 4: Task 1 - Finding Exposed Credentials
1. Create a new pipeline job:
   - Click "New Item" on the left sidebar
   - Enter "Vulnerable-Pipeline" as the name
   - Select "Pipeline" as the type
   - Click "OK"

2. Configure the pipeline with exposed credentials:
   ```groovy
   pipeline {
       agent any
       
       environment {
           // Exposed credentials (BAD PRACTICE)
           DEPLOY_USER = 'deploy-user'
           DEPLOY_PASS = 'super-secret-password'
       }
       
       stages {
           stage('Build') {
               steps {
                   echo "Building with credentials: ${DEPLOY_USER}:${DEPLOY_PASS}"
               }
           }
       }
   }
   ```

3. Run the pipeline and observe the exposed credentials in the build logs

### Step 5: Task 2 - Implementing Secret Management
1. Create secure credentials:
   - Go to "Manage Jenkins" → "Manage Credentials"
   - Click on "System" under "Stores scoped to Jenkins"
   - Click on "Global credentials (unrestricted)"
   - Click "Add Credentials"
   - Fill in:
     - Kind: "Username with password"
     - Scope: "Global"
     - Username: `deploy-user`
     - Password: `super-secret-password`
     - ID: `secure-deploy-creds`
     - Description: "Secure deployment credentials"
   - Click "Create"

2. Update the pipeline to use secure credentials:
   ```groovy
   pipeline {
       agent any
       
       stages {
           stage('Build') {
               steps {
                   withCredentials([usernamePassword(credentialsId: 'secure-deploy-creds', 
                                                  usernameVariable: 'USERNAME', 
                                                  passwordVariable: 'PASSWORD')]) {
                       echo "Building with secure credentials"
                       sh 'echo "Username: $USERNAME"'
                       sh 'echo "Password: ********"'
                   }
               }
           }
       }
   }
   ```

### Step 6: Task 3 - Adding Security Scanning
1. Install security plugins:
   - Go to "Manage Jenkins" → "Manage Plugins"
   - Click on "Available" tab
   - Search for and install:
     - OWASP Dependency Check
     - SonarQube Scanner
   - Click "Install without restart"

2. Update the pipeline with security scanning:
   ```groovy
   pipeline {
       agent any
       
       stages {
           stage('Setup Sample Project') {
               steps {
                   sh '''
                       mkdir -p src/main/java
                       echo "package com.example;
                       public class Main {
                           public static void main(String[] args) {
                               System.out.println(\"Hello, World!\");
                           }
                       }" > src/main/java/Main.java
                       
                       echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
                       <project xmlns=\"http://maven.apache.org/POM/4.0.0\"
                                xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
                                xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd\">
                           <modelVersion>4.0.0</modelVersion>
                           <groupId>com.example</groupId>
                           <artifactId>vulnerable-app</artifactId>
                           <version>1.0-SNAPSHOT</version>
                           <dependencies>
                               <dependency>
                                   <groupId>org.apache.logging.log4j</groupId>
                                   <artifactId>log4j-core</artifactId>
                                   <version>2.0-beta9</version>
                               </dependency>
                           </dependencies>
                       </project>" > pom.xml
                   '''
               }
           }
           
           stage('Security Scan') {
               steps {
                   dependencyCheck additionalArguments: '''
                       --scan ./ 
                       --format HTML 
                       --format XML 
                       --prettyPrint 
                       --enableExperimental
                       ''', odcInstallation: 'OWASP Dependency-Check'
                   
                   dependencyCheckPublisher pattern: 'dependency-check-report.xml'
               }
           }
           
           stage('Quality Gate') {
               steps {
                   script {
                       def report = readFile('dependency-check-report.xml')
                       if (report.contains('severity="HIGH"')) {
                           error 'High severity vulnerabilities found!'
                       }
                   }
               }
           }
       }
       
       post {
           always {
               archiveArtifacts artifacts: '**/dependency-check-report.html', fingerprint: true
           }
       }
   }
   ```

### Step 7: Task 4 - Configuring Access Controls
1. Configure security realm:
   - Go to "Manage Jenkins" → "Configure Global Security"
   - Under "Security Realm", select "Jenkins' own user database"
   - Uncheck "Allow users to sign up"
   - Click "Save"

2. Create test users:
   - Go to "Manage Jenkins" → "Manage Users"
   - Click "Create User" and create:
     ```
     Username: developer
     Password: developer123
     Full name: Developer User
     
     Username: viewer
     Password: viewer123
     Full name: Viewer User
     ```

3. Install and configure Role-based Authorization:
   - Install "Role-based Authorization Strategy" plugin
   - Go to "Configure Global Security"
   - Select "Role-Based Strategy"
   - Click "Save"

4. Set up roles:
   - Go to "Manage and Assign Roles"
   - Under "Global roles", add:
     ```
     Admin:
     - All permissions
     
     Developer:
     - Job/Build
     - Job/Cancel
     - Job/Configure
     - Job/Create
     - Job/Delete
     - Job/Read
     - View/Read
     
     Viewer:
     - Job/Read
     - View/Read
     ```

5. Assign roles to users

### Step 8: Task 5 - Securing Artifact Handling
1. Update the pipeline with secure artifact handling:
   ```groovy
   pipeline {
       agent any
       
       stages {
           // ... previous stages ...
           
           stage('Secure Artifact Handling') {
               steps {
                   sh '''
                       echo "Simulating artifact signing..."
                       touch target/vulnerable-app-1.0-SNAPSHOT.jar.sig
                   '''
               }
           }
       }
       
       post {
           success {
               archiveArtifacts artifacts: 'target/*.jar, target/*.sig', 
                               fingerprint: true,
                               onlyIfSuccessful: true
               
               fingerprint 'target/*.jar'
               
               sh '''
                   echo "Build Report" > build-report.txt
                   echo "Artifact: target/vulnerable-app-1.0-SNAPSHOT.jar" >> build-report.txt
                   echo "Signature: target/vulnerable-app-1.0-SNAPSHOT.jar.sig" >> build-report.txt
                   echo "Build Time: $(date)" >> build-report.txt
               '''
               archiveArtifacts artifacts: 'build-report.txt', fingerprint: true
           }
           
           always {
               archiveArtifacts artifacts: '**/dependency-check-report.html', fingerprint: true
               
               sh '''
                   rm -f *.tmp
                   rm -f *.key
               '''
           }
       }
   }
   ```

### Step 9: Verifying Your Solution
1. Run the complete pipeline
2. Verify:
   - Credentials are properly secured
   - Security scanning is working
   - Access controls are effective
   - Artifacts are handled securely
   - Build information is documented

### Step 10: Cleanup
1. Stop the Jenkins container:
   ```bash
   docker-compose down
   ```

2. Remove unused resources:
   ```bash
   docker system prune -a
   ```

### Troubleshooting Guide
1. **Jenkins won't start**
   - Check port 8080: `netstat -ano | findstr :8080`
   - Verify Docker: `docker ps`
   - Check logs: `docker logs gamify-itsec-challenge-env-1`

2. **Plugins won't install**
   - Check Jenkins version compatibility
   - Verify internet connectivity
   - Try manual plugin installation

3. **Pipeline fails**
   - Check console output
   - Verify plugin configurations
   - Review security settings

4. **Access issues**
   - Verify user roles
   - Check security realm settings
   - Review authorization strategy

### Best Practices
1. **Credential Management**
   - Never store credentials in plain text
   - Use Jenkins credential store
   - Rotate credentials regularly

2. **Security Scanning**
   - Run scans on every build
   - Fail builds on high-severity issues
   - Archive scan reports

3. **Access Control**
   - Implement least privilege
   - Regular access reviews
   - Strong password policies

4. **Artifact Handling**
   - Sign all artifacts
   - Implement retention policies
   - Secure storage locations

### Additional Resources
1. [Jenkins Security Documentation](https://www.jenkins.io/doc/book/security/)
2. [OWASP Top 10](https://owasp.org/www-project-top-ten/)
3. [DevSecOps Best Practices](https://www.devsecops.org/)

### Scoring
- Base completion: 100 points
- Additional security measures: Up to 50 points
- Time bonus: Up to 50 points

### Badges
- CI/CD Security Expert (Bronze)
- Pipeline Guardian (Silver)
- DevSecOps Master (Gold)

Remember: This challenge is designed to help you learn about CI/CD security. Take your time, understand each concept, and don't hesitate to experiment with different security measures. 

### Updated Pipeline Script
```groovy
pipeline {
    agent any
    stages {
        stage('Security Scan') {
            steps {
                dependencyCheck arguments: '''
                    --scan ./src
                    --format HTML
                    --out ./reports
                '''
                sonarQubeScan
            }
        }
    }

    post {
        always {
            // Archive the HTML report
            archiveArtifacts artifacts: '**/dependency-check-report.html', fingerprint: true
        }
    }
} 
