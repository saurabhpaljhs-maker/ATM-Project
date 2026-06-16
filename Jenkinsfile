pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sauraabh/atm-project-app:latest"
        // Inhe manually check kar lena ki ye sahi path hain ya nahi
        NPM_PATH = "C:\\Program Files\\nodejs\\npm.cmd"
        DOCKER_PATH = "C:\\Program Files\\Docker\\Docker\\resources\\bin\\docker.exe"
        KUBECTL_PATH = "C:\\kubernetes\\kubectl.exe"
        K8S_CONFIG = "C:\\kubernetes\\kube.config"
    }

    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('2. Code Analysis') {
            steps {
                echo "Running npm install..."
                // 'bat' ki jagah seedha executable call kar rahe hain
                bat "\"${NPM_PATH}\" install"
            }
        }

        stage('3. Build Docker Image') {
            steps {
                echo "Building Docker Image..."
                bat "\"${DOCKER_PATH}\" build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('4. Push to DockerHub') {
            steps {
                echo "Pushing to DockerHub..."
                bat "\"${DOCKER_PATH}\" push ${DOCKER_IMAGE}"
            }
        }

        stage('5. Deploy to Kubernetes') {
            steps {
                echo "Deploying to K8s Cluster..."
                bat "\"${KUBECTL_PATH}\" --kubeconfig ${K8S_CONFIG} apply -f k8s/deploy.yaml"
            }
        }

        stage('6. Verify & Cleanup') {
            steps {
                echo "Restarting deployment..."
                bat "\"${KUBECTL_PATH}\" --kubeconfig ${K8S_CONFIG} rollout restart deployment ramji-atm-deployment"
            }
        }
    }
}
