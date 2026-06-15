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
                echo "---- Fetching Code ----"
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

        stage('6. Deploy to Kubernetes') {
            steps {
                echo "---- Deploying to EKS ----"
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_KEY'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET')
                ]) {
                    withEnv(["AWS_ACCESS_KEY_ID=${AWS_KEY}", "AWS_SECRET_ACCESS_KEY=${AWS_SECRET}", "AWS_DEFAULT_REGION=${AWS_REGION}"]) {
                        bat """
                            aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER_NAME}
                            C:\\kubernetes\\kubectl.exe apply -f k8s/deploy.yaml
                            C:\\kubernetes\\kubectl.exe rollout status deployment/ramji-atm-deployment --timeout=60s
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
