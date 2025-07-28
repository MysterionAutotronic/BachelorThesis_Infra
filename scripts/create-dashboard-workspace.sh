#!/usr/bin/env bash

set -euo pipefail

# Make sure kubectl + plugins are in PATH
export PATH="$HOME/Dokumente/BachelorThesis_Infra/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Set KUBECONFIG
export PATH=$PATH:/home/mysterion/Dokumente/BachelorThesis_Infra/contrib-tmc/bin

# Create the workspaces and enter dashboard workspace
kubectl ws use :root
kubectl tmc workspace create dashboard --type tmc
kubectl create-workspace tenants --type universal
kubectl ws use :root:dashboard

# Create the kind cluster for the dashboard
kind create cluster --config ./k8s/cluster/kind-config.yaml

# Build dashboardBE docker image
./scripts/build/dashboardBE.sh

# Load image to kind cluster
kind load docker-image dashboard-be:latest --name dashboard

# Apply deployment
kubectl config use-context kind-dashboard
kubectl apply -f ./k8s/deployments/dashboard-be.yaml

# Build dashboardFE docker image
./scripts/build/dashboardFE.sh http://api.dashboard.local:8080

# Load image to kind cluster
kind load docker-image dashboard-fe:latest --name dashboard

# Apply deployment
kubectl apply -f ./k8s/deployments/dashboard-fe.yaml

# Ingress (not needed for development, but useful for production)
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/kind/deploy.yaml
# kubectl label node dashboard-control-plane ingress-ready=true
# kubectl wait --namespace ingress-nginx \
    # --for=condition=Ready pod \
    # --selector=app.kubernetes.io/component=controller \
    # --timeout=90s
# sudo bash ./scripts/add-to-hosts.sh 127.0.0.1 dashboard.local api.dashboard.local
# kubectl apply -f ./k8s/ingress/dashboard-ingress.yaml
# sudo iptables -t nat -A OUTPUT -p tcp --dport 80 -d 127.0.0.1 -j REDIRECT --to-port 30863
