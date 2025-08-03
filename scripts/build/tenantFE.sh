#!/bin/bash

set -e

# Tenant ID
TENANT_ID="$1"
TENANT_BE_URL="$2"

if [ -z "$TENANT_ID" ]; then
    echo "❌ Tenant ID is required as the first argument. Usage: ./scripts/build/tenantFE.sh <TENANT_ID> <TENANT_BE_URL>"
    exit 1
fi

if [ -z "$TENANT_BE_URL" ]; then
    echo "❌ Tenant BE URL is required as the second argument. Usage: ./scripts/build/tenantFE.sh <TENANT_ID> <TENANT_BE_URL>"
    exit 1
fi

# read .env.production file
source ./.env.production

# 🧠 Resolve dynamic API URL
UPPER_TENANT_ID=$(echo "$TENANT_ID" | tr '[:lower:]' '[:upper:]')
URL_VAR_NAME="TENANT_${UPPER_TENANT_ID}_BE_URL"

if [ -z "$TENANT_BE_URL" ]; then
    echo "❌ No backend URL found for tenant ID '$TENANT_ID' in .env.production"
    exit 1
fi

# 🧾 Configurable values
IMAGE_NAME="tenant-fe-$TENANT_ID"
TAG="latest"
DOCKERFILE_PATH="./BachelorThesis_TenantFE/Dockerfile"
BUILD_CONTEXT="./BachelorThesis_TenantFE/tenant_fe"
CONFIG_ENDPOINT="${TENANT_BE_URL}/config"
CRASH_ENDPOINT="${TENANT_BE_URL}/crash"

echo "🚧 Building Docker image: $IMAGE_NAME:$TAG"

# 🔍 Check for Dockerfile
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "❌ Dockerfile not found: $DOCKERFILE_PATH"
    exit 1
fi

# 🏗️ Build Docker image
docker build \
    -t "$IMAGE_NAME:$TAG" \
    --build-arg CONFIG_ENDPOINT="$CONFIG_ENDPOINT" \
    --build-arg CRASH_ENDPOINT="$CRASH_ENDPOINT" \
    -f "$DOCKERFILE_PATH" \
    "$BUILD_CONTEXT"

echo "✅ Build completed: $IMAGE_NAME:$TAG"
