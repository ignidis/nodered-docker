#!/bin/bash
#
# Echo DEBUG Info to the console
#
USER="$(id -un)"
USER_ID="$(id -u)"
echo "Service Account: $USER $USER_ID";
#
# Start node-red
#
cd /home/"$USER";
node-red;
