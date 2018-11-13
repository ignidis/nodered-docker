#!/bin/bash
#
# Echo DEBUG Info to the console
#
USER="$(whoami)"
USER_ID="$(id -u ${USER})"
echo "Service Account: $USER $USER_ID"
#
# Set Permissions for home and persistent storage volumes
#
sudo chown -R "$USER":"$USER" /home/"$USER"/;
sudo chown -R "$USER":root /home/"$USER"/.node-red/;
cd /home/"$USER";
#
# Start node-red
#
node-red
