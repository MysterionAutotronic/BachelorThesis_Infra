#!/bin/bash

set -e

# 🧾 Configurable values

IMAGE_NAME="dashboard-fe"
TAG="latest"
API_URL="${1}"
DOCKERFILE_PATH="./BachelorThesis_DashboardFE/Dockerfile"
BUILD_CONTEXT="./BachelorThesis_DashboardFE"

# Check if API URL is provided
if [ -z "$API_URL" ]; then
    echo "❌ API URL is required as the first argument. Usage: ./scripts/build/dashboardFE.sh <API_URL>"
    exit 1
fi

# Check if Dockerfile exists
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "❌ Dockerfile not found: $DOCKERFILE_PATH"
    exit 1
fi

echo "🚧 Building Docker image: $IMAGE_NAME:$TAG"
echo "Using API URL: $API_URL"

# Build Docker image
docker build \
    -t "$IMAGE_NAME:$TAG" \
    --build-arg CONFIG_ENDPOINT="${API_URL}/config" \
    -f "$DOCKERFILE_PATH" \
    "$BUILD_CONTEXT"
