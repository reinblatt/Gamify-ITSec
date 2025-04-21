@echo off
echo 🔍 Validating CI/CD Security Challenge Environment...

REM Check Docker
echo Checking Docker installation...
where docker >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Docker is not installed. Please install Docker first.
    exit /b 1
)
echo ✅ Docker is installed

REM Check Docker Compose
echo Checking Docker Compose installation...
where docker-compose >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Docker Compose is not installed. Please install Docker Compose first.
    exit /b 1
)
echo ✅ Docker Compose is installed

REM Check if Docker is running
echo Checking if Docker is running...
docker info >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Docker is not running. Please start Docker first.
    exit /b 1
)
echo ✅ Docker is running

REM Check port 8080 availability
echo Checking port 8080 availability...
netstat -ano | findstr :8080 >nul
if %ERRORLEVEL% equ 0 (
    echo ❌ Port 8080 is already in use. Please free up port 8080.
    exit /b 1
)
echo ✅ Port 8080 is available

REM Check required files
echo Checking required files...
set "required_files=Dockerfile docker-compose.yml jenkins.yaml WALKTHROUGH.md SETUP.md"
for %%f in (%required_files%) do (
    if not exist "%%f" (
        echo ❌ Required file %%f is missing.
        exit /b 1
    )
    echo ✅ %%f exists
)

REM Check Docker image build
echo Building Docker image...
docker-compose build challenge-env
if %ERRORLEVEL% neq 0 (
    echo ❌ Failed to build Docker image.
    exit /b 1
)
echo ✅ Docker image built successfully

REM Start the container
echo Starting Jenkins container...
docker-compose up -d challenge-env
if %ERRORLEVEL% neq 0 (
    echo ❌ Failed to start Jenkins container.
    exit /b 1
)
echo ✅ Jenkins container started

REM Wait for Jenkins to be ready
echo Waiting for Jenkins to be ready...
timeout /t 30 /nobreak >nul

REM Check if Jenkins is accessible
echo Checking Jenkins accessibility...
curl -s http://localhost:8080/login >nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Jenkins is not accessible. Please check the container logs.
    exit /b 1
)
echo ✅ Jenkins is accessible

echo 🎉 Environment validation completed successfully!
echo You can now proceed with the challenge by following the WALKTHROUGH.md guide. 