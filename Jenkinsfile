pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sauraabh/atm-project-app:latest"
        K8S_CONFIG = "C:\\kubernetes\\kube.config"
        KUBECTL_PATH = "C:\\kubernetes\\kubectl.exe"
    }

    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('2. Code Analysis') {
            steps {
                echo "Running npm install directly..."
                // Agar npm path mein hai toh ye chalega. 
                // Agar nahi hai, toh yahan npm ka full path do (e.g., 'C:\\Program Files\\nodejs\\npm install')
                bat 'npm install' 
            }
        }

        stage('3. Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('4. Push to DockerHub') {
            steps {
                sh "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('5. Deploy to Kubernetes') {
            steps {
                bat "${KUBECTL_PATH} --kubeconfig ${K8S_CONFIG} apply -f k8s/deploy.yaml"
            }
        }

        stage('6. Verify & Cleanup') {
            steps {
                bat "${KUBECTL_PATH} --kubeconfig ${K8S_CONFIG} rollout restart deployment ramji-atm-deployment"
            }
        }
    }
}
