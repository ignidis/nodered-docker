FROM arm32v7/debian:stretch-slim

#
# Build Time Arguments
#
ARG NODERED_VERSION
ARG NODE_VERSION
ARG	NODE_SVC_NAME
ARG	NODE_SVC_UID

#
# Runtime environment variables
#
ENV	NODERED_WEB_PORT=1880 \
	PATH="/opt/node/bin:${PATH}"

#
# Update the operating system and install required packges
#
RUN	export DEBIAN_FRONTEND="noninteractive"; \
	export TERM="xterm"; \
	apt-get update; \
	apt-get install -y --no-install-recommends --autoremove apt-utils xz-utils unzip wget ca-certificates; \
	apt-get install -y --no-install-recommends --autoremove \
	sudo \
	; \
#
# Define Service Account variables
#
	SERVICE_USER=${NODE_SVC_NAME}; \
	SERVICE_USER_UID=${NODE_SVC_UID}; \
	SERVICE_GROUP=${NODE_SVC_NAME}; \
	SERVICE_GROUP_UID=${NODE_SVC_UID}; \
#
# Do not add sudo, if required add that group to the docker run command
#
	ADD_GROUPS=""; \
#
# Create service group and service account
#
	groupadd -g "$SERVICE_GROUP_UID" "$SERVICE_GROUP"; \
	useradd -u "$SERVICE_USER_UID" -g "$SERVICE_GROUP" --groups "$ADD_GROUPS" --shell /bin/bash --create-home "$SERVICE_USER"; \
#
# Allow service account to sudo without pasword
# We will use this only when we need a initialization run for the container, the init run should also assign the sudo group to the service user
#
#	echo "${SERVICE_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/090_${SERVICE_USER}-nopasswd; \
#
# CWD
#
	cd /home/"$SERVICE_USER"/; \
#
# Install node-red
#
#
# Install the nodeJS Runtime
#
	ARCH= \ 
	    dpkgArch="$(dpkg --print-architecture)"; \
	    case "${dpkgArch##*-}" in \
		amd64) ARCH='x64';; \
		ppc64el) ARCH='ppc64le';; \
		s390x) ARCH='s390x';; \
		arm64) ARCH='arm64';; \
		armhf) ARCH='armv7l';; \
		i386) ARCH='x86';; \
		*) echo "unsupported architecture"; exit 1 ;; \
	    esac; \
	wget "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz"; \
	if [ ! -d "/opt/" ]; then mkdir -p "/opt/"; fi; \ 
	tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C "/opt/" --no-same-owner; \ 
	rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz"; \
	ln -s "/opt/node-v$NODE_VERSION-linux-$ARCH" "/opt/node"; \ 
#
# Install the node-red modules
#
	if [ ! -d "/opt/node-red/" ]; then mkdir -p "/opt/node-red/"; fi; \ 
	wget "https://github.com/node-red/node-red/releases/download/$NODERED_VERSION/node-red-$NODERED_VERSION.zip"; \
	unzip -d "/opt/" "node-red-$NODERED_VERSION.zip"; \
	rm -f "node-red-$NODERED_VERSION.zip"; \
	cd "/opt/node-red-$NODERED_VERSION/"; \
	/opt/node/bin/npm install -g --production --no-optional; \
#
# Remove all preinstalled nodes to allow these been installed via the palette manager and thus stored outside of the container
#
	cd "/opt/node-red-$NODERED_VERSION/node_modules/"; \
	/opt/node/bin/npm rm -s --no-audit --production --no-optional node-red-node-*; \
#
# Remove the Raspberry Pi hardware specific nodes
#
	cd "/opt/node-red-$NODERED_VERSION/nodes/core/hardware/"; \
	rm 36-rpi-gpio* nrgpio*; \
#
# Set permisions for application directory and nodejs runtime
#
	chown -R "$SERVICE_USER":"$SERVICE_GROUP" "/opt/node-v$NODE_VERSION-linux-$ARCH"; \
	chown -R "$SERVICE_USER":"$SERVICE_GROUP" "/opt/node-red-$NODERED_VERSION/"; \
#
# Clean the apt cache and remove packages needed only for the installation
#
	apt-get -y --purge remove ca-certificates wget unzip xz-utils apt-utils; \
	apt -y autoremove; \
	apt-get clean -y; \
	rm -rf /var/lib/apt/lists/*; 

#
# Create the Configuration directory
#
VOLUME	/home/${NODE_SVC_NAME}/.node-red/

#
# Publish the web app ports
#
EXPOSE ${NODERED_WEB_PORT}

#
# Copy the start command
#
COPY	nodeRED-run.sh "/opt/node-red/nodeRED-run.sh"
RUN	chown "$SERVICE_USER":"$SERVICE_GROUP" "/opt/node-red/nodeRED-run.sh" && chmod +x "/opt/node-red/nodeRED-run.sh"

USER	${NODE_SVC_UID}
WORKDIR "/opt/node-red/"
ENTRYPOINT [ "/opt/node-red/nodeRED-run.sh" ]
#
# For testing and debugging comment out the above ENTRYPOINT and uncomment the following
#
#WORKDIR "/home/${NODE_SVC_NAME}/"
#ENTRYPOINT [ "/bin/bash" ]