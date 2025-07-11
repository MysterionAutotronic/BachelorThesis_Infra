#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel)"
export PATH="${PROJECT_ROOT}/bin:$PATH"
KUBECONFIGS_DIR="${PROJECT_ROOT}/.kubeconfigs"

function try_with_timeout {
    attempts=15
    while [[ "${attempts}" -gt 0 ]]; do
        kubectl version &> /dev/null && return
        sleep 5
        attempts=$((attempts-1))
    done
    echo "❌ kcp takes too long to start, maybe something is wrong?"
    exit 1  
}

pgrep kcp &> /dev/null && {
    echo "✅ kcp is already running."
    exit 0
}

echo "🚀 Starting KCP..."
cd "${PROJECT_ROOT}"

kcp start & kcp_pid=$!
trap 'kill -TERM ${kcp_pid}' TERM INT EXIT

export KUBECONFIG="${PROJECT_ROOT}/.kcp/admin.kubeconfig"
try_with_timeout

mkdir -p "${KUBECONFIGS_DIR}"
cp "${KUBECONFIG}" "${KUBECONFIGS_DIR}/admin.kubeconfig"
cp "${KUBECONFIG}" "${KUBECONFIGS_DIR}/internal-checkscript.kubeconfig"
cp "${KUBECONFIG}" "${KUBECONFIGS_DIR}/sync-agent.kubeconfig"

echo "✅ KCP started and kubeconfigs initialized."

wait "${kcp_pid}"