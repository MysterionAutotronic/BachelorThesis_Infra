#!/usr/bin/env bash

set -euo pipefail

# Make sure kubectl + plugins are in PATH
export PATH="$HOME/Dokumente/BachelorThesis_Infra/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Set KUBECONFIG
export KUBECONFIG="$(pwd)/.kcp/admin.kubeconfig"

# Create the workspace
kubectl ws use :root
kubectl create-workspace dashboard
kubectl ws use dashboard
echo "✅ Workspace 'dashboard' created and entered."
echo "Current workspace: $(kubectl ws current)"

# Create child workspace "cluster"
kubectl ws use :root:dashboard
kubectl apply -f k8s/workspaces/root-dashboard-cluster.yaml

# :root RBAC
kubectl ws use :root
kubectl apply -f k8s/rbac/root.yaml

# :root:dashboard binding
kubectl ws use :root:dashboard
kubectl kcp bind apiexport root:tenancy.kcp.io --name tenancy

# :root:dashboard:cluster binding
kubectl ws use :root:dashboard:cluster
kubectl delete apibinding kubernetes --ignore-not-found
kubectl kcp bind apiexport root:kubernetes --name kubernetes --accept-permission-claim namespaces.core

