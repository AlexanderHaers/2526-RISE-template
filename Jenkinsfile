pipeline {
    agent any
    stages {
        stage('Unit Tests') {
            steps {
                // Uses a temporary Docker container to test the .NET code
                sh 'docker run --rm -v ${WORKSPACE}:/app -w /app mcr.microsoft.com/dotnet/sdk:10.0 dotnet test'
            }
        }
        stage('Build and Run') {
            steps {
                sh 'docker compose up -d --build'
            }
        }
        stage('Acceptance Test') {
            steps {
                sleep time: 25, unit: 'SECONDS'
                
                sh 'curl http://172.16.0.10:8081/ | grep "RISE"'
            }
        }
    }
}
