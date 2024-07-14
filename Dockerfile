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

# Stage 1: Builder stage with Golang and dependencies
FROM golang:1.20.4-alpine@sha256:0a03b591c358a0bb02e39b93c30e955358dadd18dc507087a3b7f3912c17fe13 as builder

# Install necessary dependencies and Set working directory for the build
RUN apk add --no-cache ca-certificates git
RUN apk add build-base
WORKDIR /src

# Copy and download Go module dependencies
COPY go.mod go.sum ./
RUN go mod download
COPY . .

# Build the application with Skaffold-specific compiler flags
ARG SKAFFOLD_GO_GCFLAGS
RUN go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -o /go/bin/shippingservice .

# Stage 2: Final image without grpc_health_probe binary
FROM alpine:3.18.0@sha256:02bb6f428431fbc2809c5d1b41eab5a68350194fb508869a33cb1af4444c9b11 as without-grpc-health-probe-bin

# Install necessary certificates for secure communication and Set working directory for the application
RUN apk add --no-cache ca-certificates
WORKDIR /src

# Copy the built binary from the builder stage and Set environment variables
COPY --from=builder /go/bin/shippingservice /src/shippingservice
ENV APP_PORT=50051
ENV GOTRACEBACK=single

# Expose port for the application and Define the entry point for the container
EXPOSE 50051
ENTRYPOINT ["/src/shippingservice"]

# Stage 3: Final image with grpc_health_probe binary
FROM without-grpc-health-probe-bin

# Install grpc_health_probe for health checking gRPC services
ENV GRPC_HEALTH_PROBE_VERSION=v0.4.18
RUN wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe