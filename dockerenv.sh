#!/bin/sh
# This file is intended to be sourced from Docker container's interactive shell

export CWD=`pwd`

# User Aliasing
case $USER in
  grwlf) USER=mironov ;;
  *) ;;
esac

export TF=$CWD/tensorflow
export PYTHONPATH="$TF/tensorflow:$PYTHONPATH"
export PATH="~/.local/bin:$PATH"

dmake() {(
  set -e -x
  rm -rf /tmp/tf 2>/dev/null || true
  cd "$TF"
  bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
  ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tf
  echo "dmake finished. To install, type \`pip3 install --user --force `ls /tmp/tf/*whl`\`"
)}

djupyter() {(
  jupyter-notebook --ip 0.0.0.0 --port 8888 --NotebookApp.token='' --NotebookApp.password='' "$@" --no-browser
)}

dtensorboard() {(
  mkdir $CWD/_logs 2>/dev/null
  tensorboard --logdir=$CWD/_logs "$@"
)}

