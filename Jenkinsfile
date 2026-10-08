pipeline {
    agent any
    stages {
        stage('Unit Tests') {
            steps {
                sh '''
                # 1. Clean up any leftover test containers
                docker rm -f test-runner || true
                
                # 2. Start a temporary test container in the background
                docker run -d --name test-runner -w /app mcr.microsoft.com/dotnet/sdk:9.0 sleep 600
                
                # 3. Copy the Jenkins workspace files directly into the container (bypassing the volume bug)
                docker cp . test-runner:/app/
                
                # 4. Execute the tests
                docker exec test-runner dotnet test
                
                # 5. Clean up the container
                docker rm -f test-runner
                '''
            }
        }
        stage('Build and Run') {
            steps {
                sh 'docker-compose up -d --build'
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
