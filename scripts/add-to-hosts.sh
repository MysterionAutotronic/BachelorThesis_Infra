#!/bin/bash

IP="$1"
shift

if [ -z "$IP" ] || [ "$#" -lt 1 ]; then
    echo "❌ Usage: $0 <IP_ADDRESS> <HOSTNAME_1> [HOSTNAME_2] ..."
    exit 1
fi

for HOST in "$@"; do
    if ! grep -qE "^[^#]*\s+$HOST(\s|$)" /etc/hosts; then
        echo "➕ Adding $HOST → $IP to /etc/hosts"
        echo "$IP $HOST # added-by-script" | sudo tee -a /etc/hosts > /dev/null
    else
        echo "✅ $HOST already present in /etc/hosts"
    fi
done