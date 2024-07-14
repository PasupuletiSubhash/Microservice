# recommendationsrvice

The recommendation service application was developed utilizes Python for application logic and Docker for containerization, ensuring portability and scalability of the application.

# Docker File Explain
This Dockerfile defines a multi-stage build to efficiently manage dependencies and build artifacts, resulting in a final image optimized for running a Python-based recommendation server with optional health checking using grpc_health_probe.

# Jenkins File Explain

This Jenkins Pipeline script automates the build and push process for a Docker image. It uses Docker registry credentials (docker-cred) and the Docker CLI (docker) tool to build an image tagged as mamir32825/recommendationservice:latest and subsequently push it to a Docker registry. The stages ensure that the Docker image is built and tagged correctly before being deployed or used further in the CI/CD pipeline.