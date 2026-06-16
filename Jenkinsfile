pipeline {
    agent any

    tools {
        nodejs 'NodeJS-26.3.0'
        // Add the Docker tool configuration here
        dockerTool 'Docker' 
    }

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
                bat 'npm install'
            }
        }

        stage('3. Build Docker Image') {
            steps {
                echo "Building Docker Image..."
                // Now 'docker' command will be recognized via the tool environment
                bat "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('4. Push to DockerHub') {
            steps {
                bat "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('5. Deploy to Kubernetes') {
            steps {
                bat "\"${KUBECTL_PATH}\" --kubeconfig ${K8S_CONFIG} apply -f k8s/deploy.yaml"
            }
        }

        stage('6. Verify & Cleanup') {
            steps {
                bat "\"${KUBECTL_PATH}\" --kubeconfig ${K8S_CONFIG} rollout restart deployment ramji-atm-deployment"
            }
        }
    }
}
