In this guide, we’ll walk through the process of deploying an Microservice e-commerce app on Amazon EKS (Elastic Kubernetes Service). Whether you’re tech-savvy or not, this step-by-step tutorial will help you understand and execute the deployment process seamlessly.

# Application Architecture: Microservice
## Why Microservices?
We prefer a microservice-based architecture because it allows us to modify or update any part of the application without affecting other parts.
We use gRPC (Google Remote Procedure Call) as a message broker to maintain communication between our microservices. gRPC supports various programming languages, enabling each service to be written in a different language.

## Microservices Breakdown:
Frontend: The user interface of the application.
Product Catalog Service: Handles product searches and returns available items.
Recommendation Service: Suggests items based on your selection.
Cart Service: Manages selected items and stores data in a Redis database.
AD Service: Determines which advertisements to display based on your searches.
Checkout Service: Manages the checkout process and currency selection.
Currency Service: Allows you to select the currency for purchases.
Email Service: Sends invoices to your email after a purchase.
Payment Service: Manages payments during the buying process.
Shipping Service: Handles the final step of shipping the product once payment is complete.

# Deployment-service.yml

This configuration file defines deployments and services for microservices such as emailservice, checkoutservice, recommendationservice, frontend, paymentservice, productcatalogservice, cartservice, loadgenerator, currencyservice, shippingservice, redis-cart, and adservice. Each section specifies how the pods should be deployed, configured, and connected within a Kubernetes cluster.

# Jenkins File Explain

This Jenkins pipeline automates the deployment and verification of Kubernetes resources. It leverages Jenkins' integration with Kubernetes via the Kubernetes credentials stored in Jenkins (credentialsId: 'k8-token') to deploy configurations (deployment-service.yml) and verify the deployment status (kubectl get svc). The pipeline ensures consistent and reliable deployment processes for applications hosted on Amazon EKS (EKS-1 cluster in us-east-1 region).