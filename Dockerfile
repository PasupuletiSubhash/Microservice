# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Use the official Golang image as the build stage
FROM golang:1.20.4-alpine@sha256:0a03b591c358a0bb02e39b93c30e955358dadd18dc507087a3b7f3912c17fe13 as builder

# Install necessary dependencies for building and Set the working directory inside the container
RUN apk add --no-cache ca-certificates git
RUN apk add build-base
WORKDIR /src

# Copy module files for dependency resolution and Copy the rest of the application source code
COPY go.mod go.sum ./
RUN go mod download
COPY . .

# Build the application using skaffold-provided compiler flags
ARG SKAFFOLD_GO_GCFLAGS
RUN go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -o /checkoutservice .

# Use a minimal Alpine Linux image for the runtime stage
FROM alpine:3.18.0@sha256:02bb6f428431fbc2809c5d1b41eab5a68350194fb508869a33cb1af4444c9b11 as without-grpc-health-probe-bin

# Install necessary certificates for secure communication
RUN apk add --no-cache ca-certificates

# Set the working directory for the runtime stage and Copy the built executable from the builder stage
WORKDIR /src
COPY --from=builder /checkoutservice /src/checkoutservice

# Set environment variable to control Go's stack trace behavior
# Definition of this variable is used by 'skaffold debug' to identify a golang binary.
# Default behavior - a failure prints a stack trace for the current goroutine.
# See https://golang.org/pkg/runtime/
ENV GOTRACEBACK=single

# Expose port 5050 for the application and Define the entry point for the container
EXPOSE 5050
ENTRYPOINT ["/src/checkoutservice"]

# Use the previous image as base and add gRPC health probe
FROM without-grpc-health-probe-bin

# Download and install gRPC health probe binary
# renovate: datasource=github-releases depName=grpc-ecosystem/grpc-health-probe
ENV GRPC_HEALTH_PROBE_VERSION=v0.4.18
RUN wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe