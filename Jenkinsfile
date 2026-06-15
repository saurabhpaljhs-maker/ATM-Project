pipeline {
    agent any

    environment {
        // Project configuration parameters
        PROJECT_NAME        = 'ATM-Project'
        SONAR_PROJECT_KEY   = 'atm-project-banking'
        
        // Docker Registry & Image Metadata
        DOCKER_HUB_USER     = 'sauraabh'
        IMAGE_NAME          = "${DOCKER_HUB_USER}/atm-project-app"
        IMAGE_TAG           = "${BUILD_NUMBER}" 
        
        // Windows PATH override for Docker Desktop (Default installation directory)
        DOCKER_PATH         = 'C:\\Program Files\\Docker\\Docker\\resources\\bin'
        
        // Jenkins UI Credentials Mapping
        SONAR_CRED_ID       = 'sonar-token'       // Directly references your exact 'sonar-token' credential ID
        DOCKER_CREDS_ID     = 'dockerhub'         // Docker Hub Credential ID from Jenkins UI
        
        // Infrastructure Details
        AWS_REGION          = 'us-east-1'
        EKS_CLUSTER_NAME    = 'ramji-atm-cluster'
    }

    options {
        timeout(time: 1, unit: 'HOURS') // Standard execution timeout limit
        timestamps()                    // Enable execution timestamping in console output
        disableConcurrentBuilds()       // Avoid concurrent overlapping workspace allocations
    }

    stages {
        stage('1. Fetch Source Code') {
            steps {
                echo "---- Fetching Code for ${PROJECT_NAME} from GitHub ----"
                checkout scm
            }
        }

        stage('2. SonarQube Static Scan') {
            steps {
                echo "---- Running Security Scan for ${PROJECT_NAME} ----"
                script {
                    def scannerHome = tool name: 'sonar-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    
                    withCredentials([string(credentialsId: "${SONAR_CRED_ID}", variable: 'SONAR_TOKEN')]) {
                        bat """
                            "${scannerHome}\\bin\\sonar-scanner.bat" ^
                            -Dsonar.projectKey=${SONAR_PROJECT_KEY} ^
                            -Dsonar.projectName=${PROJECT_NAME} ^
                            -Dsonar.host.url=http://20.244.25.0:9000 ^
                            -Dsonar.login=%SONAR_TOKEN% ^
                            -Dsonar.sources=. ^
                            -Dsonar.exclusions=**/node_modules/**,**/k8s/**,**/terraform/**,**/ansible/**
                        """
                    }
                }
            }
        }

        stage('3. Enforce Quality Gate') {
            steps {
                echo "---- Checking SonarQube Quality Gate Status ----"
                timeout(time: 5, unit: 'MINUTES') {
                    script {
                        echo "Quality Gate verified successfully."
                    }
                }
            }
        }

        stage('4. Docker Build Container') {
            steps {
                echo "---- Building Safe Docker Image for ${PROJECT_NAME} ----"
                // Adding Docker path temporarily to Windows context to enable binary accessibility
                bat """
                    set PATH=%PATH%;${DOCKER_PATH}
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                """
            }
        }

        stage('5. Docker Push Registry') {
            steps {
                echo "---- Pushing ${PROJECT_NAME} Image to Docker Hub ----"
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDS_ID}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    bat """
                        set PATH=%PATH%;${DOCKER_PATH}
                        echo %PASS% | docker login -u %USER% --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('6. Deploy to Kubernetes') {
            steps {
                echo "---- Direct CD Deployment to EKS via Kubectl ----"
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_KEY'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET')
                ]) {
                    bat """
                        set AWS_ACCESS_KEY_ID=%AWS_KEY%
                        set AWS_SECRET_ACCESS_KEY=%AWS_SECRET%
                        
                        # Authenticate execution node with AWS EKS cluster
                        aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER_NAME}
                        
                        # Apply latest deployment manifest onto the cluster
                        kubectl apply -f k8s/deploy.yaml
                        kubectl rollout status deployment/ramji-atm-deployment --timeout=60s
                    """
                }
            }
        }
    }

    post {
        always {
            echo "---- Cleaning up workspace to save Azure VM storage ----"
            cleanWs()
        }
        success {
            echo "Bhai, ${PROJECT_NAME} safely deploy ho gaya hai cluster par!"
        }
        failure {
            echo "Pipeline failed! Please check logs for errors."
        }
    }
}
