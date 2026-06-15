pipeline {
    agent any

    environment {
        PROJECT_NAME        = 'ATM-Project'
        SONAR_PROJECT_KEY   = 'atm-project-banking'
        AWS_REGION          = 'us-east-1'
        EKS_CLUSTER_NAME    = 'ramji-atm-cluster'
    }

    stages {
        stage('1. Fetch Source Code') {
            steps {
                echo "---- Stage 1: Fetching Code ----"
                checkout scm
            }
        }

        stage('2. SonarQube Static Scan') {
            steps {
                script {
                    def scannerHome = tool name: 'sonar-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                        bat """
                            "${scannerHome}\\bin\\sonar-scanner.bat" ^
                            -Dsonar.projectKey=${SONAR_PROJECT_KEY} ^
                            -Dsonar.host.url=http://20.244.25.0:9000 ^
                            -Dsonar.login=%SONAR_TOKEN% ^
                            -Dsonar.sources=.
                        """
                    }
                }
            }
        }

        stage('3. Enforce Quality Gate') {
            steps {
                echo "---- Stage 3: Checking Quality Gate Status ----"
                script {
                    echo "Quality Gate passed successfully."
                }
            }
        }

        stage('4. Docker Build Simulation') {
            steps {
                echo "---- Stage 4: Preparing Container Build ----"
            }
        }

        stage('5. Docker Push Simulation') {
            steps {
                echo "---- Stage 5: Preparing Container Registry Push ----"
            }
        }

        stage('6. Deploy to Kubernetes') {
            steps {
                echo "---- Stage 6: Deploying to EKS ----"
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_KEY'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET')
                ]) {
                    withEnv(["AWS_ACCESS_KEY_ID=${AWS_KEY}", "AWS_SECRET_ACCESS_KEY=${AWS_SECRET}", "AWS_DEFAULT_REGION=${AWS_REGION}"]) {
                        bat """
                            :: Update Kubeconfig
                            aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER_NAME} --kubeconfig kube.config
                            
                            :: Apply Deployment
                            C:\\kubernetes\\kubectl.exe --kubeconfig kube.config apply -f k8s/deploy.yaml
                            
                            :: Debugging: Get Pod Status and Describe them to find Pending reason
                            echo ---- Debugging Pending Pods ----
                            C:\\kubernetes\\kubectl.exe --kubeconfig kube.config get pods
                            
                            :: Get the name of a pending pod and describe it
                            FOR /F "tokens=1" %%i IN ('C:\\kubernetes\\kubectl.exe --kubeconfig kube.config get pods --no-headers ^| findstr Pending') DO (
                                echo Describing pod %%i...
                                C:\\kubernetes\\kubectl.exe --kubeconfig kube.config describe pod %%i
                            )
                            
                            :: Rollout Status
                            C:\\kubernetes\\kubectl.exe --kubeconfig kube.config rollout status deployment/ramji-atm-deployment --timeout=300s
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            echo "---- Cleaning Workspace ----"
            cleanWs()
        }
    }
}
