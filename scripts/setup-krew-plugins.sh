#!/usr/bin/env bash

set -o nounset
set -o pipefail
set -o errexit

PROJECT_ROOT="$(git rev-parse --show-toplevel)"
export KREW_ROOT="$HOME/.krew"
export PATH="${HOME}/.krew/bin:$PATH"

# ✅ Add kcp-dev Krew index
if ! kubectl krew index list | grep -q 'github.com/kcp-dev/krew-index.git'; then
    kubectl krew index add kcp-dev https://github.com/kcp-dev/krew-index.git
fi

echo "🔌 Installing Krew plugins..."

kubectl krew install kcp-dev/kcp || echo "🔁 Plugin 'kcp' already installed"
kubectl krew install kcp-dev/ws || echo "🔁 Plugin 'ws' already installed"
kubectl krew install kcp-dev/create-workspace || echo "🔁 Plugin 'create-workspace' already installed"

# ⚠️ Hack: Fix for create-workspace plugin
if [ -f "$(which kubectl-create_workspace)" ]; then
    cp "$(which kubectl-create_workspace)" "$KREW_ROOT/bin/kubectl-create-workspace"
fi

echo "🎉 Krew plugins installed successfully!"