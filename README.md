# productcatalogservice
This backend service (productcatalogservice) written in Go, aimed at serving data likely related to product catalogs (products.json). It includes features for debugging (GOTRACEBACK setting) and integrates a gRPC health check capability (grpc_health_probe) for monitoring service health. The application exposes itself on port 3550 and is suitable for deployment in containerized environments.

Run the following command to restore dependencies to `vendor/` directory:

    dep ensure --vendor-only

## Dynamic catalog reloading / artificial delay

This service has a "dynamic catalog reloading" feature that is purposefully
not well implemented. The goal of this feature is to allow you to modify the
`products.json` file and have the changes be picked up without having to
restart the service.

However, this feature is bugged: the catalog is actually reloaded on each
request, introducing a noticeable delay in the frontend. This delay will also
show up in profiling tools: the `parseCatalog` function will take more than 80%
of the CPU time.

You can trigger this feature (and the delay) by sending a `USR1` signal and
remove it (if needed) by sending a `USR2` signal:

```
# Trigger bug
kubectl exec \
    $(kubectl get pods -l app=productcatalogservice -o jsonpath='{.items[0].metadata.name}') \
    -c server -- kill -USR1 1
# Remove bug
kubectl exec \
    $(kubectl get pods -l app=productcatalogservice -o jsonpath='{.items[0].metadata.name}') \
    -c server -- kill -USR2 1
```

## Latency injection

This service has an `EXTRA_LATENCY` environment variable. This will inject a sleep for the specified [time.Duration](https://golang.org/pkg/time/#ParseDuration) on every call to
to the server.

For example, use `EXTRA_LATENCY="5.5s"` to sleep for 5.5 seconds on every request.

# Docker File Explain

The Dockerfile sets up a Go-based backend service called productcatalogservice using a multi-stage build process. The application is built in a Golang environment and then copied to a minimal Alpine Linux image for efficient deployment. It includes necessary dependencies and a gRPC health probe for monitoring. The service is exposed on port 3550.

# Jenkins File Explain

This Jenkins Pipeline script automates the build and push process for a Docker image. It uses Docker registry credentials (docker-cred) and the Docker CLI (docker) tool to build an image tagged as mamir32825/productcatalogservice:latest and subsequently push it to a Docker registry. The stages ensure that the Docker image is built and tagged correctly before being deployed or used further in the CI/CD pipeline.