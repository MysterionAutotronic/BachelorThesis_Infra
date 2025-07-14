# !/usr/bin/env bash
set -euo pipefail

kubectl ws use :root
kubectl apply -f ./k8s/apiexport-kubernetes.yaml
kubectl config use-context system:admin
kubectl ws use :root:dashboard || {
    echo "❌ Workspace 'dashboard' does not exist. Please create it first."
    exit 1
}
kubectl apply -f ./k8s/apibinding-kubernetes.yaml --as=system:admin --validate=false
echo "Current API Bindings:"
kubectl get apibindings
echo "Current API Resources:"
kubectl get apiresources