# Deployment-service.yml

This configuration file defines deployments and services for microservices such as emailservice, checkoutservice, recommendationservice, frontend, paymentservice, productcatalogservice, cartservice, loadgenerator, currencyservice, shippingservice, redis-cart, and adservice. Each section specifies how the pods should be deployed, configured, and connected within a Kubernetes cluster.

# Jenkins File Explain

This Jenkins pipeline automates the deployment and verification of Kubernetes resources. It leverages Jenkins' integration with Kubernetes via the Kubernetes credentials stored in Jenkins (credentialsId: 'k8-token') to deploy configurations (deployment-service.yml) and verify the deployment status (kubectl get svc). The pipeline ensures consistent and reliable deployment processes for applications hosted on Amazon EKS (EKS-1 cluster in us-east-1 region).