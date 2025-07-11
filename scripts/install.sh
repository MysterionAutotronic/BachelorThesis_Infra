# docker buildx
mkdir -p ~/.docker/cli-plugins
curl -sSL https://github.com/docker/buildx/releases/latest/download/buildx-linux-amd64 \
    -o ~/.docker/cli-plugins/docker-buildx
chmod +x ~/.docker/cli-plugins/docker-buildx
