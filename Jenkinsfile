pipeline {
    agent any

    environment {
        // Credentials (Make sure these IDs match your Jenkins Credentials IDs)
        SONAR_TOKEN = credentials('sonarqube-token') 
        DOCKERHUB_CREDS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = "sauraabh/atm-project-app:${env.BUILD_NUMBER}"
        SONAR_SERVER = 'MySonarQubeServer'
    }

    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('2. Code Analysis (SonarQube)') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner' 
                    withSonarQubeEnv("${SONAR_SERVER}") {
                        sh "${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=ATM-Project \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://20.244.25.0:9000 \
                            -Dsonar.login=${SONAR_TOKEN}" 
                    }
                }
            }
        }

        stage('3. Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('4. Push to DockerHub') {
            steps {
                script {
                    sh "echo ${DOCKERHUB_CREDS_PSW} | docker login -u ${DOCKERHUB_CREDS_USR} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
    }

    post {
        success {
            echo "CI Success! CD Pipeline trigger ho rahi hai..."
            // CD Pipeline ko trigger karne ka command
            build job: 'ATM-CD-Pipeline', parameters: [
                string(name: 'IMAGE_TAG', value: "${env.BUILD_NUMBER}")
            ]
        }
        always {
            sh "docker rmi ${DOCKER_IMAGE} || true"
        }
    }
}
