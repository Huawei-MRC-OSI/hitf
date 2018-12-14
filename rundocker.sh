#!/bin/sh

CWD=$(cd `dirname $0`; pwd;)

docker run -it --workdir "$CWD/tensorflow" \
    --volume $CWD/tensorflow:/tensorflow \
    --volume $CWD:/mnt \
    -e HOST_PERMS="$(id -u):$(id -g)" tensorflow/tensorflow:nightly-devel bash

