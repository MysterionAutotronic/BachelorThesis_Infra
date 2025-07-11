#!/bin/bash

set -e

# 🧾 Configurable values
IMAGE_NAME="tenant-be"
TAG="latest"
CONFIG_SRC_PATH="./config/config.example.json"
CONFIG_TMP_PATH="./BachelorThesis_TenantBE/temp.config.json"
CONFIG_ARG_NAME="CONFIG_PATH"
DOCKERFILE_PATH="./BachelorThesis_TenantBE/Dockerfile"
BUILD_CONTEXT="./BachelorThesis_TenantBE"

echo "🚧 Building Docker image: $IMAGE_NAME:$TAG"
echo "📄 Using config: $CONFIG_SRC_PATH"

# 🔍 Check for Dockerfile
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "❌ Dockerfile not found: $DOCKERFILE_PATH"
    exit 1
fi

# 🔍 Check for config
if [ ! -f "$CONFIG_SRC_PATH" ]; then
    echo "❌ Config file not found: $CONFIG_SRC_PATH"
    exit 1
fi

# 🧪 Prepare temporary config inside build context
cp "$CONFIG_SRC_PATH" "$CONFIG_TMP_PATH"

# 🏗️ Build Docker image
docker build \
    -t "$IMAGE_NAME:$TAG" \
    --build-arg "$CONFIG_ARG_NAME=temp.config.json" \
    -f "$DOCKERFILE_PATH" \
    "$BUILD_CONTEXT"

# 🧹 Clean up temp file
rm "$CONFIG_TMP_PATH"

echo "✅ Build completed: $IMAGE_NAME:$TAG"
