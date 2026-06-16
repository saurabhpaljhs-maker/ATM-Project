pipeline {
    agent any

    // NodeJS plugin ke liye tool configuration
    tools {
        nodejs 'NodeJS-26.3.0'
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
                bat 'npm install'
            }
        }

        stage('3. Build Docker Image') {
            steps {
                tool name: 'Docker', type: 'dockerTool'   // or whatever name you gave

                echo "Building Docker Image..."
                bat 'docker --version'                    // Diagnostic
                bat "docker build -t sauraabh/atm-project-app:latest ."
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
                bat "\"${KUBECTL_PATH}\" --kubeconfig ${K8S_CONFIG} apply -f k8s/deploy.yaml"
            }
        }

        stage('6. Verify & Cleanup') {
            steps {
                echo "Restarting deployment..."
                bat "\"${KUBECTL_PATH}\" --kubeconfig ${K8S_CONFIG} rollout restart deployment ramji-atm-deployment"
                echo "Pipeline finished successfully!"
            }
        }
    }
}
