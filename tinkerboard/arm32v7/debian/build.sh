#!/bin/bash
#
# docker build nodered image
# Usage:
#        [sudo] build.sh <nodered-version> <node-lts-version>
#
# Must run as superuser, either you are root or must sudo 
#
docker build --build-arg NODERED_VERSION="$1" --build-arg NODE_VERSION="$2" --build-arg NODE_SVC_NAME="node" --build-arg NODE_SVC_UID="9001" -t nodered:"$1"-arm32v7-debian .
