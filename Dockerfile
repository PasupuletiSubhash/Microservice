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

# Stage 1: Base image with Python and essential tools
FROM python:3.10.8-slim@sha256:49749648f4426b31b20fca55ad854caa55ff59dc604f2f76b57d814e0a47c181 as base

# Stage 2: Builder stage for additional dependencies
FROM base as builder

# Install system dependencies
RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends \
        wget g++ \
    && rm -rf /var/lib/apt/lists/*

# Download and install grpc health probe
ENV GRPC_HEALTH_PROBE_VERSION=v0.4.18
RUN wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

# Install Python dependencies from requirements.txt
COPY requirements.txt .
RUN pip install -r requirements.txt

# Stage 3: Final image without grpc_health_probe binary
FROM base as without-grpc-health-probe-bin

# Set environment variable for unbuffered logging and Set working directory for the application
ENV PYTHONUNBUFFERED=1
WORKDIR /recommendationservice

# Copy Python packages from builder stage to final image and Add application code to the image
COPY --from=builder /usr/local/lib/python3.10/ /usr/local/lib/python3.10/
COPY . .

# Set listening port for the application and Define the entry point for the container
ENV PORT "8080"
EXPOSE 8080
ENTRYPOINT ["python", "recommendation_server.py"]

# Stage 4: Final image with grpc_health_probe binary
FROM without-grpc-health-probe-bin

# Copy grpc_health_probe binary from builder stage
COPY --from=builder /bin/grpc_health_probe /bin/grpc_health_probe