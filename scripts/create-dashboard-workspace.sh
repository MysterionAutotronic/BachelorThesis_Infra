#!/usr/bin/env bash

set -euo pipefail

# Make sure kubectl + plugins are in PATH
export PATH="$HOME/Dokumente/BachelorThesis_Infra/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Workspace name
WORKSPACE_NAME="dashboard"

echo "📦 Creating root workspace: $WORKSPACE_NAME..."

# Set KUBECONFIG
export KUBECONFIG="$(pwd)/.kcp/admin.kubeconfig"

# Create the workspace
kubectl ws root
kubectl create-workspace "$WORKSPACE_NAME"
kubectl ws use "$WORKSPACE_NAME"

echo "✅ Workspace '$WORKSPACE_NAME' created and entered."
echo "Current workspace: $(kubectl ws current)"
echo "📂 Current workspace tree:"
kubectl ws tree
