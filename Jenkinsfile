pipeline {
    agent any // This pipeline can run on any available agent

    stages {
        stage('Build & Tag Docker Image') {
            steps {
                script {
                    // Use Docker registry credentials and tool for Docker commands
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        // Build the Docker image and tag it as 'latest'
                        sh "docker build -t subbusubhash/emailservice:latest ."
                    }
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    // Use Docker registry credentials and tool for Docker commands
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        // Push the Docker image to the registry
                        sh "docker push subbusubhash/emailservice:latest "
                    }
                }
            }
        }
    }
}
