# frontend

Run the following command to restore dependencies to `vendor/` directory:

    dep ensure --vendor-only

This service is a Go-based backend service optimized for efficiency and performance. It utilizes a multi-stage build process to manage dependencies and separate development and production environments. The application includes tools for service health monitoring (grpc_health_probe) and is configured for streamlined error tracing (GOTRACEBACK=single), all while exposing itself on port 8080 for external interaction.

### Technology Stack
Language and Dependencies: Go (Golang) and Managed using go mod
Environment Configuration: Sets up the environment for optimal runtime performance and monitoring

# Docker File explain
This Dockerfile facilitates the efficient development and deployment of a Go-based application by leveraging multi-stage builds to separate build dependencies from the final runtime environment. It ensures minimal image size and optimal runtime performance while providing necessary tools and configurations for both development and production environments.

## Builder Stage

### Base Image: 
golang:1.20.4-alpine
### Dependencies: 
Installs ca-certificates, git, and build-base.
### Build: 
Downloads dependencies, copies and builds frontend with specified debug flags.

## Release Stage

### Base Image: 
alpine:3.18.0
### Dependencies: 
Installs ca-certificates, busybox-extras, net-tools, bind-tools.
### Setup: 
Copies frontend binary, templates, and static files.
### Environment: 
Configures GOTRACEBACK=single.
### Port: 
Exposes 8080.
### Entry Point: 
Executes /src/server to start the application.#

# Jenkins File explain
This Jenkins Pipeline script automates the build and push process for a Docker image. It uses Docker registry credentials (docker-cred) and the Docker CLI (docker) tool to build an image tagged as mamir32825/frontend:latest and subsequently push it to a Docker registry. The stages ensure that the Docker image is built and tagged correctly before being deployed or used further in the CI/CD pipeline.