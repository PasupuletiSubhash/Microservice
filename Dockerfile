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

# Use Node.js 20.2.0-alpine as the base image
FROM node:20.2.0-alpine@sha256:f25b0e9d3d116e267d4ff69a3a99c0f4cf6ae94eadd87f1bf7bd68ea3ff0bef7 as base

# Create a builder stage based on the base image
FROM base as builder

# Install additional dependencies required by some packages
# Some packages (e.g. @google-cloud/profiler) require additional
# deps for post-install scripts
RUN apk add --update --no-cache \
    python3 \
    make \
    g++

# Set the working directory for subsequent commands and Copy package.json and package-lock.json for npm install
WORKDIR /usr/src/app
COPY package*.json ./

# Install production dependencies only and Create a stage without gRPC health probe based on the base image
RUN npm install --only=production
FROM base as without-grpc-health-probe-bin

# Set the working directory for the new stage and Copy node_modules from the builder stage to optimize image size
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/node_modules ./node_modules

# Copy application source code and Expose port 7000 for the application
COPY . .
EXPOSE 7000

# Define the entry point for the container and Use the previous stage as base and add gRPC health probe
ENTRYPOINT [ "node", "server.js" ]
FROM without-grpc-health-probe-bin

# Install gRPC health probe binary from GitHub releases
# renovate: datasource=github-releases depName=grpc-ecosystem/grpc-health-probe
ENV GRPC_HEALTH_PROBE_VERSION=v0.4.18
RUN wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe