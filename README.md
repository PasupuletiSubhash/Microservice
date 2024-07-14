# Loadgenerator

### Framework:
The application is built using Python and utilizes Locust as the load testing framework. Locust is designed for scalable load testing and is scriptable using Python, making it suitable for simulating user behavior on web applications or APIs.

### Technology Stack
Type and Framework: Load Testing Service on Locust with Python framework
Dependencies: Managed using pip with dependencies listed in requirements.txt
Execution: Configured to run headless load tests against a specified frontend (FRONTEND_ADDR) with a default of 10 users (USERS)

# Docker File Explain
This Dockerfile facilitates the setup of a scalable and portable load testing environment using Locust and Python. It ensures efficient dependency management and runtime configuration, making it suitable for performance testing against web applications or APIs.
### Base Image: 
Python 3.11.1-slim for a lightweight environment.
### Builder Stage: 
Installs Python dependencies specified in requirements.txt into /install.
### Application: 
Copies locustfile.py to define load testing scenarios.
### Configuration: 
Enables gevent support (GEVENT_SUPPORT=True) and specifies locust as the entry point to run headless load tests against a frontend specified by FRONTEND_ADDR, with a default of 10 users (USERS).

# Jenkins File explain
This Jenkins Pipeline script automates the build and push process for a Docker image. It uses Docker registry credentials (docker-cred) and the Docker CLI (docker) tool to build an image tagged as mamir32825/loadgenerator:latest and subsequently push it to a Docker registry. The stages ensure that the Docker image is built and tagged correctly before being deployed or used further in the CI/CD pipeline.