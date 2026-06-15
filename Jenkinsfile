pipeline {
    agent any

    environment {
        // Project strict naming configurations
        PROJECT_NAME        = 'ATM-Project'
        SONAR_PROJECT_KEY   = 'atm-project-banking'
        
        // Registry & Image Details (Apna DockerHub username yahan change kar lena)
        DOCKER_HUB_USER     = 'your-dockerhub-username'
        IMAGE_NAME          = "${DOCKER_HUB_USER}/atm-project-app"
        IMAGE_TAG           = "${BUILD_NUMBER}" 
        
        // Jenkins UI Credentials IDs (Jo aap Jenkins Dashboard par exact banaoge)
        SONAR_SERVER_REF    = 'sonar-server'      // Manage Jenkins -> System me jo naam doge
        DOCKER_CREDS_ID     = 'docker-hub-creds'  // Docker Hub ka username-password ID
        AWS_CREDS_ID        = 'aws-cloud-creds'   // AWS Access & Secret Key ki ID
        
        // Infrastructure Details
        AWS_REGION          = 'us-east-1'
        EKS_CLUSTER_NAME    = 'ramji-atm-cluster'
    }

    options {
        timeout(time: 1, hours: true) // Build agar 1 ghante se upar fase toh auto-abort
        timestamps()                  // Logs me time dikhane ke liye
        disableConcurrentBuilds()     // Ek sath do builds ko rokne ke liye
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
                withSonarQubeEnv("${SONAR_SERVER_REF}") {
                    sh """
                        sonar-scanner \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                        -Dsonar.projectName=${PROJECT_NAME} \
                        -Dsonar.sources=. \
                        -Dsonar.exclusions=**/node_modules/**,**/k8s/**,**/terraform/**,**/ansible/**
                    """
                }
            }
        }

        stage('3. Enforce Quality Gate') {
            steps {
                echo "---- Checking SonarQube Quality Gate Status ----"
                timeout(time: 5, unit: 'MINUTES') {
                    script {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline Stopped! Security vulnerability found in ${PROJECT_NAME}."
                        }
                    }
                }
            }
        }

        stage('4. Docker Build Container') {
            steps {
                echo "---- Building Safe Docker Image for ${PROJECT_NAME} ----"
                script {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('5. Docker Push Registry') {
            steps {
                echo "---- Pushing ${PROJECT_NAME} Image to Docker Hub ----"
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDS_ID}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh """
                        echo "${PASS}" | docker login -u "${USER}" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('6. Deploy to Kubernetes') {
            steps {
                echo "---- Direct CD Deployment to EKS via Kubectl ----"
                withCredentials([usernamePassword(credentialsId: "${AWS_CREDS_ID}", usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh """
                        export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                        export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                        
                        # Azure VM se AWS cluster connect karne ki command
                        aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER_NAME}
                        
                        # deploy.yaml me dynamic image tag update karne ke liye
                        sed -i 's|image: .*/atm-project-app:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|g' k8s/deploy.yaml
                        
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
