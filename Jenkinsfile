pipeline {
    agent any
    stages {
        stage('Unit Tests') {
            steps {
                sh '''
                # 1. Verwijder oude containers als die nog bestaan
                docker rm -f db webapp || true
                
                # 2. Start de PostgreSQL database container
                docker run -d --name db \
                  -e POSTGRES_USER=myuser \
                  -e POSTGRES_PASSWORD=mypassword \
                  -e POSTGRES_DB=rise_db \
                  -p 5432:5432 \
                  postgres:15
                  
                # 3. Bouw de webapplicatie image
                docker build -t rise-webapp .
                
                # 4. Start de webapplicatie en link deze aan de database container
                docker run -d --name webapp \
                  -p 8081:8080 \
                  --link db:db \
                  -e ConnectionStrings__DefaultConnection="Host=db;Database=rise_db;Username=myuser;Password=mypassword" \
                  rise-webapp
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

        post {
        always {
            // Ruim beide containers netjes op
            sh 'docker rm -f webapp db || true'
            }
        }
    }
    }
}
