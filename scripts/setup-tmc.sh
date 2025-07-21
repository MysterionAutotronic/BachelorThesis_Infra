# !/bin/bash

if [ ! -d "./contrib-tmc" ]; then
    echo "📦 Cloning contrib-tmc repository..."
    git clone https://github.com/kcp-dev/contrib-tmc.git
fi

echo "🔧 Building tmc-kcp..."
cd ./contrib-tmc
make build
cd ..
