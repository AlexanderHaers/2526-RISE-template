pipeline {
    agent any
    stages {
        stage('Unit Tests') {
            steps {
                sh '''
                docker rm -f test-runner || true
                docker run -d --name test-runner -w /app mcr.microsoft.com/dotnet/sdk:9.0 sleep 600
                docker cp . test-runner:/app/
                docker exec test-runner dotnet test
                docker rm -f test-runner
                '''
            }
        }
        stage('Build and Run') {
            steps {
                sh '''
                docker rm -f db webapp || true
                
                docker run -d --name db \
                  -e POSTGRES_USER=myuser \
                  -e POSTGRES_PASSWORD=mypassword \
                  -e POSTGRES_DB=rise_db \
                  -p 5432:5432 \
                  postgres:15
                  
                docker build -t rise-webapp .
                
                docker run -d --name webapp \
                  -p 8081:8080 \
                  --link db:db \
                  -e ConnectionStrings__DefaultConnection="Host=db;Database=rise_db;Username=myuser;Password=mypassword" \
                  rise-webapp
                '''
            }
        }
        stage('Acceptance Test') {
            steps {
                sleep time: 25, unit: 'SECONDS'
                sh 'curl http://172.16.0.10:8081/ | grep -i "rise"'
            }
        }
    }
}
