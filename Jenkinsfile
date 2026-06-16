pipeline {
    agent any
    
    environment {
        // Apne DockerHub username se replace karo
        DOCKERHUB_CREDENTIALS = 'dockerhub-login' 
        IMAGE_NAME = 'sauraabh/atm-project-app'
        IMAGE_TAG = 'latest'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/apka-github-user/aapka-repo-name.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Docker build karne ke liye
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('', env.DOCKERHUB_CREDENTIALS) {
                        sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                // Kubectl use karke deployment update karna
                sh 'C:\\kubernetes\\kubectl.exe --kubeconfig C:\\kubernetes\\kube.config apply -f k8s/deploy.yaml'
                sh 'C:\\kubernetes\\kubectl.exe --kubeconfig C:\\kubernetes\\kube.config delete pods -l app=atm-project-app'
            }
        }
    }
}
