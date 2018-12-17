#!/bin/sh

CWD=$(cd `dirname $0`; pwd;)
UID=`id --user`

# Remap detach to Ctrl+e,e
DOCKER_CFG="/tmp/docker-hitf-$UID"
mkdir "$DOCKER_CFG" 2>/dev/null || true
cat >$DOCKER_CFG/config.json <<EOF
{ "detachKeys": "ctrl-e,e" }
EOF

set -e -x

docker build \
  --build-arg=http_proxy=$https_proxy \
  --build-arg=https_proxy=$https_proxy \
  --build-arg=ftp_proxy=$https_proxy \
  -t hitf \
  -f $CWD/docker/Dockerfile.dev $CWD/docker

docker --config "$DOCKER_CFG" \
    run -it \
    --volume $CWD:/workspace \
    --workdir /workspace \
    -e HOST_PERMS="$(id -u):$(id -g)" \
    -e "CI_BUILD_HOME=/workspace" \
    -e "CI_BUILD_USER=$(id -u -n)" \
    -e "CI_BUILD_UID=$(id -u)" \
    -e "CI_BUILD_GROUP=$(id -g -n)" \
    -e "CI_BUILD_GID=$(id -g)" \
    -e "DISPLAY=$DISPLAY" \
    hitf \
    bash --login /install/with_the_same_user.sh bash

