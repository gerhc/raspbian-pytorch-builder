#!/bin/bash

docker build ./docker -t rpi-pytorch-builder

docker run --privileged -v "$(pwd)":/pytorch_install -it rpi-pytorch-builder:latest /bin/bash /pytorch_install/docker/compiler.sh