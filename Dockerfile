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

# Use Golang 1.20.4-alpine as the builder stage
FROM golang:1.20.4-alpine@sha256:0a03b591c358a0bb02e39b93c30e955358dadd18dc507087a3b7f3912c17fe13 as builder

# Install required dependencies and Set working directory
RUN apk add --no-cache ca-certificates git
RUN apk add build-base
WORKDIR /src

# Copy and download Go module dependencies and Copy application source code
COPY go.mod go.sum ./
RUN go mod download
COPY . .

# Build the application with debug-oriented flags from Skaffold
ARG SKAFFOLD_GO_GCFLAGS
RUN go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -o /go/bin/frontend .

# Use Alpine 3.18.0 as the release stage
FROM alpine:3.18.0@sha256:02bb6f428431fbc2809c5d1b41eab5a68350194fb508869a33cb1af4444c9b11 as release

# Install necessary dependencies for release stage and Set working directory for release stage
RUN apk add --no-cache ca-certificates \
    busybox-extras net-tools bind-tools
WORKDIR /src

# Copy built binary from builder stage to release stage and # Copy templates and static files
COPY --from=builder /go/bin/frontend /src/server
COPY ./templates ./templates
COPY ./static ./static

# Set environment variable for Go error trace behavior and Expose port 8080
# Definition of this variable is used by 'skaffold debug' to identify a golang binary.
# Default behavior - a failure prints a stack trace for the current goroutine.
# See https://golang.org/pkg/runtime/
ENV GOTRACEBACK=single
EXPOSE 8080

# Define entry point for the container
ENTRYPOINT ["/src/server"]
