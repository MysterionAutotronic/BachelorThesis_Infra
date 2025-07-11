#!/bin/bash

set -e

# Tenant ID
TENANT_ID="$1"

if [ -z "$TENANT_ID" ]; then
    echo "❌ Tenant ID is required as the first argument. Usage: ./scripts/build/tenantFE.sh <TENANT_ID>"
    exit 1
fi

# read .env.production file
source ./.env.production

# 🧠 Resolve dynamic API URL
UPPER_TENANT_ID=$(echo "$TENANT_ID" | tr '[:lower:]' '[:upper:]')
URL_VAR_NAME="TENANT_${UPPER_TENANT_ID}_BE_URL"
TENANT_BE_URL="${!URL_VAR_NAME}"

if [ -z "$TENANT_BE_URL" ]; then
    echo "❌ No backend URL found for tenant ID '$TENANT_ID' in .env.production"
    exit 1
fi

# 🧾 Configurable values
IMAGE_NAME="tenant-fe-$TENANT_ID"
TAG="latest"
DOCKERFILE_PATH="./BachelorThesis_TenantFE/Dockerfile"
BUILD_CONTEXT="./BachelorThesis_TenantFE/tenant_fe"

echo "🚧 Building Docker image: $IMAGE_NAME:$TAG"

# 🔍 Check for Dockerfile
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "❌ Dockerfile not found: $DOCKERFILE_PATH"
    exit 1
fi

# 🏗️ Build Docker image
docker build \
    -t "$IMAGE_NAME:$TAG" \
    --build-arg TENANT_BE_URL="$TENANT_BE_URL" \
    -f "$DOCKERFILE_PATH" \
    "$BUILD_CONTEXT"

echo "✅ Build completed: $IMAGE_NAME:$TAG"
