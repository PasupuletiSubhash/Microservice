# checkoutservice

This application is a backend service written in Go, optimized for containerized deployment using Docker. It focuses on providing services over port 5050 and includes additional tooling like grpc_health_probe for monitoring service health.

### Technology Stack
Language and Dependencies: Go (Golang) and Managed with go mod
Runtime: Alpine Linux for efficiency
Enhancements: Includes grpc_health_probe for service monitoring

Run the following command to restore dependencies to `vendor/` directory:

    dep ensure --vendor-only

# Docker file explain

This Dockerfile efficiently builds a Go application, optimizes its runtime environment using Alpine Linux, and enhances it with a gRPC health probe for service monitoring.

### Build Stage:
Uses golang:1.20.4-alpine to compile the application. Installs dependencies (ca-certificates, git, build-base).Copies source code, resolves dependencies, and builds checkoutservice.

### Runtime Stage:
Uses alpine:3.18.0 for a minimal runtime environment.Copies checkoutservice and sets it as the entry point.Exposes port 5050 for the application.

### Enhancements:
Adds grpc_health_probe (v0.4.18) for service monitoring.

# Jenkins file explain
This Jenkins Pipeline script automates the build and push process for a Docker image. It uses Docker registry credentials (docker-cred) and the Docker CLI (docker) tool to build an image tagged as mamir32825/checkoutservice:latest and subsequently push it to a Docker registry. The stages ensure that the Docker image is built and tagged correctly before being deployed or used further in the CI/CD pipeline.