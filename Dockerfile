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

# Use Python 3.11.1-slim as the base image
FROM python:3.11.1-slim@sha256:1591aa8c01b5b37ab31dbe5662c5bdcf40c2f1bce4ef1c1fd24802dae3d01052 as base

# Create a builder stage based on the base image
FROM base as builder

# Copy requirements.txt to the builder stage
COPY requirements.txt .

# Install Python dependencies into /install directory
RUN pip install --prefix="/install" -r requirements.txt

# Use the base image for the final stage
FROM base

# Set working directory for the application and Copy installed dependencies from builder stage to /usr/local
WORKDIR /loadgen
COPY --from=builder /install /usr/local

# Add application code (locustfile.py) and Enable gevent support for debugging
COPY locustfile.py .
ENV GEVENT_SUPPORT=True

# Define the entry point for running Locust in headless mode
ENTRYPOINT locust --host="http://${FRONTEND_ADDR}" --headless -u "${USERS:-10}" 2>&1
