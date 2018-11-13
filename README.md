# nodered-docker
This repository contains scripts and a dockerfile which can be used to create an arm32v7/debian:stretch-slim docker image to run node-red.
The image uses a non-root user in the container, a volume to store the persistent node-red configuration,nodes and flows and exposes the node-red GUI to the host.
This image can be combined with the deCONZ image to create a quite capable Zigbee Gateway with a powerfull Rule system.
