#!/usr/bin/env bash

set -euo pipefail

# TENANT ID
TENANT_ID="${1}"

# Check if TENANT_ID is provided
if [ -z "$TENANT_ID" ]; then
    echo "❌ Tenant ID is required as the first argument. Usage: ./scripts/create-tenant-x-workspace.sh <TENANT_ID>"
    exit 1
fi

# Make sure kubectl + plugins are in PATH
export PATH="$HOME/Dokumente/BachelorThesis_Infra/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Set KUBECONFIG
export PATH=$PATH:/home/mysterion/Dokumente/BachelorThesis_Infra/contrib-tmc/bin

kubectl config use-context root

# Navigate to the root workspace
kubectl ws use :root:tenants

# Create the tenant workspace
kubectl tmc workspace create "tenant-${TENANT_ID}" --type tmc
kubectl ws use :root:tenants:tenant-${TENANT_ID}

# Create the kind cluster for the tenant
./scripts/create-tenant-x-cluster.sh "${TENANT_ID}"

# Build tenantBE docker image
./scripts/build/tenantBE.sh

# Load image to kind cluster
kind load docker-image tenant-be:latest --name tenant-${TENANT_ID}

# Apply deployment
kubectl config use-context kind-tenant-${TENANT_ID}
kubectl apply -f ./k8s/deployments/tenant-be.yaml

# Build tenantFE docker image
./scripts/build/tenantFE.sh ${TENANT_ID} http://tenant-be.default.svc.cluster.local

# Load image to kind cluster
kind load docker-image tenant-fe:latest --name tenant-${TENANT_ID}

# Apply deployment
kubectl apply -f ./k8s/deployments/tenant-fe.yaml

# Create CRD for the tenant
./scripts/CRDs/create-tenant-x-CRD.sh "${TENANT_ID}"

# Create role binding and service account for tenant
kubectl apply -f ./k8s/roleBinding/tmc-role-binding.yaml