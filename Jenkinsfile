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

        stage('2. Code Analysis') {
            steps {
                // Jenkins ab aapke configure kiye hue 'node-20' tool ka use karega
                nodejs('node-20') {
                    sh 'npm install'
                }
            }
        }

        stage('3. Build Docker Image') {
            steps {
                // Docker daemon ab host VM par hai, ye command seedhe chalegi
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
    }
}
