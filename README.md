# Shipping Service

The Shipping service provides price quote, tracking IDs, and the impression of order fulfillment & shipping processes.

## Local

Run the following command to restore dependencies to `vendor/` directory:

    dep ensure --vendor-only

## Build

From `src/shippingservice`, run:

```
docker build ./
```

## Test

```
go test .
```

# Docker File Explain
This Dockerfile encapsulates the setup and deployment requirements for a Golang-based microservice application (shippingservice). It leverages Docker's capabilities for dependency management, isolation, and portability, ensuring the application can be reliably deployed across different environments. The stack emphasizes lightweight containers, efficient dependency handling, and robust application monitoring through health checking mechanisms.

# Jenkins File Explain
This Jenkins Pipeline script automates the build and push process for a Docker image. It uses Docker registry credentials (docker-cred) and the Docker CLI (docker) tool to build an image tagged as mamir32825/shippingservice:latest and subsequently push it to a Docker registry. The stages ensure that the Docker image is built and tagged correctly before being deployed or used further in the CI/CD pipeline.