pipeline {
    agent any // Runs the pipeline on any available agent

    stages {
        stage('Deploy To Kubernetes') { 
            steps {
                // Uses Kubernetes credentials to apply deployment configuration
                withKubeCredentials(kubectlCredentials: [[
                    clusterName: 'EKS-1',
                    credentialsId: 'k8-token',
                    namespace: 'webapps',
                    serverUrl: 'https://4A4E0AAEBA049C744159175F41A2A562.gr7.us-east-1.eks.amazonaws.com'
                ]]) {
                    sh "kubectl apply -f deployment-service.yml"
                }
            }
        }
        
        stage('Verify Deployment') { 
            steps {
                // Uses Kubernetes credentials to check the status of deployed services
                withKubeCredentials(kubectlCredentials: [[
                    clusterName: 'EKS-1',
                    credentialsId: 'k8-token',
                    namespace: 'webapps',
                    serverUrl: 'https://4A4E0AAEBA049C744159175F41A2A562.gr7.us-east-1.eks.amazonaws.com'
                ]]) {
                    sh "kubectl get svc -n webapps"
                }
            }
        }
    }
}
