pipeline {
    agent any // Use any available agent to run this pipeline

    stages {
        stage('Build & Tag Docker Image') {
            steps {
                script {
                    // Use Docker registry credentials and Docker CLI tool
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        // Build Docker image tagged as mamir32825/adservice:latest
                        sh "docker build -t mamir32825/adservice:latest ."
                    }
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    // Use Docker registry credentials and Docker CLI tool
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        // Push the previously built Docker image to the registry
                        sh "docker push mamir32825/adservice:latest "
                    }
                }
            }
        }
    }
}
