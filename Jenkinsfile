pipeline {
    agent {
        docker {
            image 'node:20'
            args '-u root --privileged'
        }
    }

    environment {
        DOCKER_IMAGE = "sauraabh/atm-project-app:latest"
    }

    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('2. Code Analysis') {
            steps {
                sh 'npm install'
            }
        }

        stage('3. Build Docker Image') {
            steps {
                sh 'docker --version'
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('4. Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', 
                               usernameVariable: 'DOCKER_USER', 
                               passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('5. Deploy to Kubernetes') {
            steps {
                echo '🚀 Kubernetes deployment stage (ready for future)'
                // sh 'kubectl apply -f k8s/'   // Uncomment when you have cluster
            }
        }
    }

    post {
        success { echo '✅ ATM Project Pipeline Completed Successfully!' }
        failure { echo '❌ Pipeline Failed!' }
    }
}
