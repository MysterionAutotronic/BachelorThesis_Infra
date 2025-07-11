#!/bin/bash
set -e

SERVICE_NAME="dashboard-be"
IMAGE_NAME="${SERVICE_NAME}:latest"
DOCKERFILE_PATH="./BachelorThesis_DashboardBE/Dockerfile"
BUILD_CONTEXT="./BachelorThesis_DashboardBE"

# 🔍 Check for Dockerfile
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "❌ Dockerfile not found: $DOCKERFILE_PATH"
    exit 1
fi

# 🏗️ Build Docker image

echo "🚧 Building Docker image: ${IMAGE_NAME}"

docker build \
    -t "$IMAGE_NAME" \
    -f "$DOCKERFILE_PATH" \
    "$BUILD_CONTEXT"

echo "✅ Build completed: $IMAGE_NAME"
