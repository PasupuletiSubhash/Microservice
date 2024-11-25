pipeline {
    agent any // Runs the pipeline on any available agent
	environment { 
        SCANNER_HOME=tool 'sonar-scanner' 
    }

    stages {
		stage("Sonarqube Analysis "){
			steps{
				withSonarQubeEnv('sonar-server') {
				sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=microservice \
					-Dsonar.java.binaries=. \
					-Dsonar.projectKey=microservice '''
				}
			}
		}
        stage('Deploy To Kubernetes') { 
            steps {
                // Uses Kubernetes credentials to apply deployment configuration
                withKubeCredentials(kubectlCredentials: [[
                    clusterName: 'EKS-1',
                    credentialsId: 'k8-token',
                    namespace: 'webapps',
                    serverUrl: 'https://8E52AF38634C710085F92A4CC3DF0F5C.gr7.us-east-1.eks.amazonaws.com'
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
                    serverUrl: 'https://8E52AF38634C710085F92A4CC3DF0F5C.gr7.us-east-1.eks.amazonaws.com'
                ]]) {
                    sh "kubectl get svc -n webapps"
                }
            }
        }
    }
}
