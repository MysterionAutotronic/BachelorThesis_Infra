#!/usr/bin/env bash

set -euo pipefail

# TENANT ID
TENANT_ID=$1

if [[ -z "$TENANT_ID" ]]; then
    echo "Usage: $0 <TENANT_ID>"
    exit 1
fi

CLUSTER_NAME="tenant-${TENANT_ID}"
HTTP_PORT=$((8000 + TENANT_ID)) # collision on 8080 -> we don't need 80 tenants for the prototype
HTTPS_PORT=$((8400 + TENANT_ID))

echo "Creating cluster '$CLUSTER_NAME' with ports:"
echo "  → HTTP  : $HTTP_PORT → containerPort 80"
echo "  → HTTPS : $HTTPS_PORT → containerPort 443"

kind create cluster --name "$CLUSTER_NAME" --config=- <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 80
        hostPort: $HTTP_PORT
        protocol: TCP
      - containerPort: 443
        hostPort: $HTTPS_PORT
        protocol: TCP
EOF
