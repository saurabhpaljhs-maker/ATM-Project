# ATM-Project

**Simple ATM Banking Simulation with Full DevOps Pipeline**

This project is a basic ATM system where you can check account balance and withdraw cash. The main focus is to show real DevOps practices — from code to production using Docker, Jenkins CI/CD, Terraform, and Kubernetes (EKS).

---

## Project Overview

- **Backend**: Node.js + Express  
- **ATM Operations**: Check Balance and Cash Withdrawal  
- **Goal**: End-to-end DevOps demonstration (From Code → Production)

---

## Architecture

```mermaid
flowchart TD
    Git[GitHub] --> Jenkins[Jenkins CI]
    Jenkins --> Sonar[SonarQube]
    Jenkins --> Docker[Docker Build & Push]
    Docker --> K8s[Kubernetes (EKS)]
    Terraform[Terraform IaC] --> AWS[AWS EKS]
```

---

## Tech Stack

- **Language**: Node.js + Express  
- **Container**: Docker  
- **CI/CD**: Jenkins  
- **Code Quality**: SonarQube  
- **IaC**: Terraform (AWS)  
- **Orchestration**: Kubernetes (EKS)  
- **Others**: Ansible (Configuration)

---

## Folder Structure

```
ATM-Project/
├── server.js                 # Main application
├── Dockerfile
├── Jenkinsfile               # CI Pipeline
├── terraform/                # AWS infrastructure
├── k8s/                      # Kubernetes yaml files
├── ansible/                  # Configuration
├── package.json
└── sonar-project.properties
```

---

## How to Run Locally

1. Clone the project:
   ```bash
   git clone https://github.com/saurabhpaljhs-maker/ATM-Project.git
   cd ATM-Project
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the application:
   ```bash
   npm start
   ```

4. Test the APIs (using Postman or curl):
   - Health Check: `GET http://localhost:8081/api/atm/health`
   - Check Balance: `POST http://localhost:8081/api/atm/balance`

---

## Docker Commands

```bash
# Build the Docker image
docker build -t atm-app .

# Run the container
docker run -p 8081:8081 atm-app
```

---

## CI/CD Pipeline (Jenkins)

The Jenkinsfile contains the following steps:
- Checkout code from GitHub
- Run SonarQube code analysis
- Build Docker image
- Push image to Docker Hub
- Ready for deployment

---

## Deploy on Kubernetes

```bash
kubectl apply -f k8s/deploy.yaml
```

---
