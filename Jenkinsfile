pipeline {
    agent any

    environment {
        // Apne DockerHub credentials ki ID jo Jenkins mein save ki hai
        DOCKERHUB_CREDS = credentials('dockerhub-credentials') 
        DOCKER_IMAGE = "sauraabh/atm-project-app:latest"
        // SonarQube server ka naam jo aapne Jenkins System config mein diya hai
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
                    // Tool ka naam jo aapne Jenkins Global Tool config mein diya hai
                    def scannerHome = tool 'SonarScanner' 
                    withSonarQubeEnv("${SONAR_SERVER}") {
                        sh "${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=ATM-Project \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://<YOUR_VM_IP>:9000 \
                            -Dsonar.login=${SONAR_TOKEN}" 
                    }
                }
            }
        }

        stage('3. Build Docker Image') {
            steps {
                // dependencies pehle se server pe hain, seedha build
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
        always {
            // Build ke baad images saaf karne ke liye
            sh "docker rmi ${DOCKER_IMAGE} || true"
        }
    }
}
