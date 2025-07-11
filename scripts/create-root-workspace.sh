#!/usr/bin/env bash

set -euo pipefail

# Make sure kubectl + plugins are in PATH
export PATH="$HOME/Dokumente/BachelorThesis_Infra/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Workspace name
WORKSPACE_NAME="root-dashboard"

echo "📦 Creating root workspace: $WORKSPACE_NAME..."

# Set KUBECONFIG
export KUBECONFIG="$(pwd)/.kcp/admin.kubeconfig"

# Create the workspace
kubectl config use-context system:admin
kubectl create-workspace "$WORKSPACE_NAME" --type root

echo "✅ Workspace '$WORKSPACE_NAME' created and entered."
echo "📂 Current workspace tree:"
kubectl ws tree
