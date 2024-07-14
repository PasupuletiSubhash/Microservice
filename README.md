# Ad Service

The Ad service provides advertisement based on context keys. If no context keys are provided then it returns random ads.

## Building locally

The Ad service uses gradlew to compile/install/distribute. Gradle wrapper is already part of the source code. To build Ad Service, run:

```
./gradlew installDist
```
It will create executable script src/adservice/build/install/hipstershop/bin/AdService

### Upgrading gradle version
If you need to upgrade the version of gradle then run

```
./gradlew wrapper --gradle-version <new-version>
```

## Building docker image

From `src/adservice/`, run:

```
docker build ./
```

# Ad service Explanation:

### Type of Application: 
It is a Java-based backend application.
### Technology Stack:
Uses Java and Gradle, with additional tools like the Stackdriver Profiler Java agent for monitoring.

# Docker File Explanation:

## Multi-stage build:
The Dockerfile begins with a multi-stage build pattern. This allows different images to be used at different stages of the build process, optimizing both size and security.

## First stage (builder):
Sets up the build environment, copies necessary files, downloads dependencies, and builds the application.

## Second stage (without-grpc-health-probe-bin): 
Prepares a smaller runtime environment, installs CA certificates, and downloads the Stackdriver Profiler Java agent.

## Final stage:
Adds the grpc_health_probe binary for health checking.

This Dockerfile is structured to first build the application with dependencies and then optimize the runtime environment, including necessary tools like the Stackdriver Profiler Java agent and grpc_health_probe for health checks.

# Jenkins File Explanation:
This Jenkins Pipeline script automates the build and push process for a Docker image. It uses Docker registry credentials (docker-cred) and the Docker CLI (docker) tool to build an image tagged as mamir32825/adservice:latest and subsequently push it to a Docker registry. The stages ensure that the Docker image is built and tagged correctly before being deployed or used further in the CI/CD pipeline.