#!/bin/bash

set -e

echo "🔧 Updating system..."
sudo apt update
sudo apt upgrade -y

echo "📦 Installing core tools..."
sudo apt install -y curl git ca-certificates gnupg lsb-release unzip build-essential 

echo "🧰 Installing Node.js + npm (LTS)..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

echo "📦 Installing Go..."
sudo apt install -y golang

echo "🐳 Installing Docker..."
# Add Docker’s official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
    "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin

echo "➕ Adding user to docker group..."
sudo usermod -aG docker "$USER"

echo "✅ Setup complete. Please reboot or re-login for Docker group changes to apply."
