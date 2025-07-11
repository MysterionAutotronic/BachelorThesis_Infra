#!/bin/bash

set -e

# 🧾 Configurable values
IMAGE_NAME="tenant-be"
TAG="latest"
CONFIG_PATH="./config/config.example.json"
DOCKERFILE_PATH="./BachelorThesis_TenantBE/Dockerfile"
BUILD_CONTEXT="."

echo "🚧 Building Docker image: $IMAGE_NAME:$TAG"
echo "📄 Using config: $CONFIG_PATH"

# Check if Docker is installed
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "❌ Dockerfile not found: $DOCKERFILE_PATH"
    exit 1
fi

# Check if config exists
if [ ! -f "$CONFIG_PATH" ]; then
    echo "❌ Config file not found: $CONFIG_PATH"
    exit 1
fi

# Build command
docker build \
    -t "$IMAGE_NAME:$TAG" \
    --build-arg CONFIG_PATH="$CONFIG_PATH" \
    -f "$DOCKERFILE_PATH" \
    "$BUILD_CONTEXT"

echo "✅ Build completed: $IMAGE_NAME:$TAG"
