**Bhai, samajh gaya!**  

Yeh **real DevOps wale** style mein simple, easy English ka **practical README** hai. Na zyada lambi theory, na over-fancy words — bilkul real experience wala feel.

---

### **Final README.md** (Copy-Paste kar do repo mein)

```markdown
# ATM-Project

**Simple ATM Banking Simulation with Full DevOps Pipeline**

Yeh project ek basic ATM system hai jisme balance check aur cash withdrawal kar sakte ho. Isme main focus DevOps practices pe hai — Docker, Jenkins CI/CD, Terraform, Kubernetes (EKS) tak pura flow.

---

## Project Overview

- Backend: Node.js + Express  
- ATM operations: Check Balance aur Withdraw  
- Goal: End-to-end DevOps demonstration (Code → Production)

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
- **Others**: Ansible (config)

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

3. Start the app:
   ```bash
   npm start
   ```

4. Test karo (Postman ya curl se):
   - Health Check: `GET http://localhost:8081/api/atm/health`
   - Balance: `POST http://localhost:8081/api/atm/balance`

---

## Docker Commands

```bash
# Build image
docker build -t atm-app .

# Run container
docker run -p 8081:8081 atm-app
```

---

## CI/CD Pipeline (Jenkins)

Jenkinsfile mein ye steps hain:
- Code checkout from GitHub
- SonarQube code analysis
- Docker image build
- Push image to Docker Hub
- Ready for deployment

---

## Deploy on Kubernetes

```bash
kubectl apply -f k8s/deploy.yaml
````

