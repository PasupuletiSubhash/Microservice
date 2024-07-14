# currency service
This Dockerfile efficiently builds and runs a Node.js application, optimizing for production by minimizing image size and adding a tool for service health monitoring.

### Framework:
This is custom Node.js application using server.js as the entry point.

### Technology Stack:
Language and Dependencies Management : JavaScript (Node.js) and npm for package management (package.json)
Tools: Uses python3, make, and g++ for building certain npm packages
Enhancements: Includes grpc_health_probe for monitoring service health using gRPC