docker build \
    -t tenant-be \
    --build-arg CONFIG_PATH=./config/config.json \
    -f BachelorThesis_TenantBE/Dockerfile .