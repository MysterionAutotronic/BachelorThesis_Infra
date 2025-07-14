# !/usr/bin/env bash
set -euo pipefail

kubectl ws use dashboard || {
    echo "❌ Workspace 'dashboard' does not exist. Please create it first."
    exit 1
}
kubectl apply -f ./k8s/dashboardBE.yaml