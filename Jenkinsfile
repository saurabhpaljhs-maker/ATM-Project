pipeline {
    agent any

    // NodeJS tool configure kiya hai, ensure karein Jenkins Tools mein "NodeJS-18" set hai
    tools {
        nodejs 'NodeJS-18'
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
                echo "Running npm install..."
                sh 'npm install'
            }
        }

        stage('3. Build Docker Image') {
            steps {
                echo "Building Docker Image..."
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('4. Push to DockerHub') {
            steps {
                echo "Pushing to DockerHub..."
                sh "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('5. Deploy to Kubernetes') {
            steps {
                echo "Deploying to K8s Cluster..."
                sh "${KUBECTL_PATH} --kubeconfig ${K8S_CONFIG} apply -f k8s/deploy.yaml"
            }
        }

        stage('6. Verify & Cleanup') {
            steps {
                echo "Restarting deployment to ensure fresh pull..."
                sh "${KUBECTL_PATH} --kubeconfig ${K8S_CONFIG} rollout restart deployment ramji-atm-deployment"
                echo "Deployment Pipeline Completed Successfully!"
            }
        }
    }
}
