pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "sauraabh"
        APP_NAME        = "atm-project-app"
        DOCKER_IMAGE    = "${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                cleanWs()
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('MySonarQubeServer') {
                        def scannerHome = tool 'SonarScanner'
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=ATM-Project -Dsonar.sources=."
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "CI completed successfully. Triggering CD pipeline..."
            build job: 'ATM-CD-Pipeline', wait: false, parameters: [
                string(name: 'IMAGE_TAG', value: "${BUILD_NUMBER}")
            ]
        }
        always {
            sh "docker rmi ${DOCKER_IMAGE} || true"
        }
    }
}
