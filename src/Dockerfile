# Copyright 2021 Google LLC
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

# https://mcr.microsoft.com/v2/dotnet/sdk/tags/list

# Use the base SDK image from Microsoft to build the application.
FROM mcr.microsoft.com/dotnet/sdk:7.0.302@sha256:5c638e77052b5ae4f6f1da3885035b510fc379d2ce4be274c70679114bcdb936 as builder

# Set the working directory inside the container and Copy the project file into the container's working directory.
WORKDIR /app
COPY cartservice.csproj .

# Restore dependencies specified in the project file and Copy the entire application source code into the container.
RUN dotnet restore cartservice.csproj -r linux-musl-x64
COPY . .

# Publish the application using single file deployment for Linux, targeting musl-x64.
RUN dotnet publish cartservice.csproj -p:PublishSingleFile=true -r linux-musl-x64 --self-contained true -p:PublishTrimmed=True -p:TrimMode=Link -c release -o /cartservice --no-restore

# Use the base runtime dependencies image from Microsoft for Alpine Linux.
# https://mcr.microsoft.com/v2/dotnet/runtime-deps/tags/list
FROM mcr.microsoft.com/dotnet/runtime-deps:7.0.4-alpine3.16-amd64@sha256:7141eea9c7be5f4d2f09df427ba37620e50be150fc93015288b3e26c5071af81 as without-grpc-health-probe-bin

# Set the working directory inside the container and Copy the published single-file application from the builder stage into the current stage.
WORKDIR /app
COPY --from=builder /cartservice .

# Expose port 7070 to allow communication to the containerized application.
EXPOSE 7070

# Set environment variables for the application runtime. 
ENV DOTNET_EnableDiagnostics=0 \
    ASPNETCORE_URLS=http://*:7070

# Set the user context for the container to a non-root user (user with ID 1000) and Define the entry point for the container, which starts the cart service.
USER 1000
ENTRYPOINT ["/app/cartservice"]

# Start a new stage based on the previous stage (without-grpc-health-probe-bin).
FROM without-grpc-health-probe-bin

# Switch back to root user temporarily to install grpc_health_probe.
USER root

# Download and install grpc_health_probe for health checking purposes.
# It fetches a specific version (v0.4.18) of grpc_health_probe and makes it executable.
# renovate: datasource=github-releases depName=grpc-ecosystem/grpc-health-probe
ENV GRPC_HEALTH_PROBE_VERSION=v0.4.18
RUN wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

# Set the user context for the container to a non-root user (user with ID 1000)
USER 1000