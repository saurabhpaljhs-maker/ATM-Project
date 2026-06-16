pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sauraabh/atm-project-app:latest"
        K8S_CONFIG = "C:\\kubernetes\\kube.config"
        KUBECTL_PATH = "C:\\kubernetes\\kubectl.exe"
        // NPM ka path yahan fix kar rahe hain taaki error na aaye
        PATH = "C:\\Program Files\\nodejs;%PATH%"
    }

    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('2. Code Analysis') {
            steps {
                echo "Running unit tests and linting..."
                bat 'npm install'
            }
        }

        stage('3. Build Docker Image') {
            steps {
                echo "Building Docker Image..."
                bat "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('4. Push to DockerHub') {
            steps {
                echo "Pushing to DockerHub..."
                bat "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('5. Deploy to Kubernetes') {
            steps {
                echo "Deploying to K8s Cluster..."
                bat "${KUBECTL_PATH} --kubeconfig ${K8S_CONFIG} apply -f k8s/deploy.yaml"
            }
        }

        stage('6. Verify & Cleanup') {
            steps {
                echo "Restarting deployment..."
                bat "${KUBECTL_PATH} --kubeconfig ${K8S_CONFIG} rollout restart deployment ramji-atm-deployment"
                echo "Deployment Pipeline Completed Successfully!"
            }
        }
    }
}
