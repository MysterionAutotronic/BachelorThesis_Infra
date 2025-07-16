#!/usr/bin/env bash

set -euo pipefail

# Get OS and architecture
GOOS="$(uname | tr '[:upper:]' '[:lower:]' | grep -E 'linux|darwin')"
GOARCH="$(uname -m | sed 's/x86_64/amd64/ ; s/aarch64/arm64/' | grep -E 'amd64|arm64')"

BIN_DIR="./bin"
mkdir -p "$BIN_DIR"

# kcp
echo "🔧 Installing kcp..."
curl -sSL "https://github.com/kcp-dev/kcp/releases/download/v0.27.1/kcp_0.27.1_${GOOS}_${GOARCH}.tar.gz" \
    | tar -xz -C "$BIN_DIR" bin/kcp --strip-components=1

# api-syncagent
echo "🔧 Installing api-syncagent..."
curl -sSL "https://github.com/kcp-dev/api-syncagent/releases/download/v0.2.0-alpha.1/api-syncagent_0.2.0-alpha.1_${GOOS}_${GOARCH}.tar.gz" \
    | tar -xz -C "$BIN_DIR" --strip-components=0

# kind
echo "🔧 Installing kind..."
curl -Lo "$BIN_DIR/kind" "https://github.com/kubernetes-sigs/kind/releases/download/v0.27.0/kind-${GOOS}-${GOARCH}"
chmod +x "$BIN_DIR/kind"

# kubectl
echo "🔧 Installing kubectl..."
curl -Lo "$BIN_DIR/kubectl" "https://dl.k8s.io/v1.31.7/bin/${GOOS}/${GOARCH}/kubectl"
chmod +x "$BIN_DIR/kubectl"

# kubectl krew
echo "🔧 Installing kubectl-krew..."
curl -sSL "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew-${GOOS}_${GOARCH}.tar.gz" \
    | tar -xz -C "$BIN_DIR" --strip-components=1
mv "$BIN_DIR/krew-${GOOS}_${GOARCH}" "$BIN_DIR/kubectl-krew"

# jq
echo "🔧 Installing jq..."
JQ_OS="$GOOS"
[[ "$GOOS" == "darwin" ]] && JQ_OS="macos"
curl -Lo "$BIN_DIR/jq" "https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-${JQ_OS}-${GOARCH}"
chmod +x "$BIN_DIR/jq"

# mcp
echo "🚀 Downloading KCP's mcp-example-crd"
curl -L "https://github.com/kcp-dev/contrib/releases/download/v1-kubecon2025-london/contrib_1-kubecon2025-london_${GOOS}_${GOARCH}.tar.gz" \
    | tar -C "${WORKSHOP_ROOT}/bin" -xzf - mcp-example-crd
touch "${WORKSHOP_ROOT}/bin/.checkpoint-mcp-example-crd"

echo "✅ All tools installed in: $BIN_DIR"
echo "👉 Add to PATH: export PATH=\"\$PATH:$(pwd)/bin\""