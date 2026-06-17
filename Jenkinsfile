pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sauraabh/atm-project-app:latest"
    }

    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('2. Build Docker Image') {
            steps {
                // Ab npm install karne ki zaroorat nahi hai, dependencies pehle se server pe hain
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('3. Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', 
                                       usernameVariable: 'DOCKER_USER', 
                                       passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
    }
}
