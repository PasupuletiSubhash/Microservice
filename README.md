# currency service
This Dockerfile efficiently builds and runs a Node.js application, optimizing for production by minimizing image size and adding a tool for service health monitoring.

### Framework:
This is custom Node.js application using server.js as the entry point.

### Technology Stack:
Language and Dependencies Management : JavaScript (Node.js) and npm for package management (package.json)
Tools: Uses python3, make, and g++ for building certain npm packages
Enhancements: Includes grpc_health_probe for monitoring service health using gRPC

# Docker File Explain

### Base Image and Builder Stage:
Uses node:20.2.0-alpine for Node.js environment. Installs additional tools (python3, make, g++) for certain npm packages. Sets working directory and installs production dependencies from package.json.

### Without gRPC Health Probe Stage:
Copies node_modules from the builder stage to optimize image size. Copies application source code and exposes port 7000. Defines server.js as the entry point for the application.

### Additional Stage (with gRPC Health Probe):
Inherits from the previous stage. Installs grpc_health_probe (v0.4.18) for monitoring service health using gRPC.

# Jenkins file explain
This Jenkins Pipeline script automates the build and push process for a Docker image. It uses Docker registry credentials (docker-cred) and the Docker CLI (docker) tool to build an image tagged as mamir32825/currencyservice:latest and subsequently push it to a Docker registry. The stages ensure that the Docker image is built and tagged correctly before being deployed or used further in the CI/CD pipeline.