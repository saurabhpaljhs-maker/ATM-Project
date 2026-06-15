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
            steps { checkout scm }
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
                            
                            :: Debugging: Find Pending pods and Describe them
                            echo ---- Debugging Pending Pods ----
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
}
