#$!/bin/bash
#
docker run -d \
	-t \
	--init \
	--name="node-red" \
	--restart="unless-stopped" \
	--user="9001" \
	--volume="/etc/localtime:/etc/localtime:ro" \
	--volume="/var/lib/node-red/:/home/node/.node-red/" \
	--network="bridge" \
	-p 1880:1880 \
	-e NODERED_WEB_PORT="1880" \
	-e NODERED_VERSION="$1" \
	nodered:"$1"-arm32v7-debian;

