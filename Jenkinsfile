pipeline {
    agent any

    environment {
        // Yahan 'sonarqube-token' wahi ID hai jo aapne Credentials mein di hai
        SONAR_TOKEN = credentials('sonarqube-token') 
        DOCKERHUB_CREDS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = "sauraabh/atm-project-app:latest"
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
                        // Ab SONAR_TOKEN yahan environment variable ki tarah available hoga
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
                    // DOCKERHUB_CREDS_USR aur PSW automatically generate hote hain jab aap credentials use karte hain
                    sh "echo ${DOCKERHUB_CREDS_PSW} | docker login -u ${DOCKERHUB_CREDS_USR} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
    }

    post {
        always {
            sh "docker rmi ${DOCKER_IMAGE} || true"
        }
    }
}
