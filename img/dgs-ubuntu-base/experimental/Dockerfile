FROM ubuntu:18.04
LABEL maintainer "StudioEtrange <sboucault@gmail.com>"
LABEL description "docker-games-server base image"


ENV DGS_IMAGE_BASE "ubuntu:18.04"
ENV DGS_IMAGE_TYPE "official-image"
ENV DGS_IMAGE_TREE_ROOT "dgs-ubuntu-base"
ENV DGS_IMAGE_NAME "dgs-ubuntu-base"
ENV DGS_IMAGE_VERSION "experimental"

ENV DGS_VAR_VOLUME_ROOT /volumes
ENV DGS_VAR_BACKUP_ROOT /backup

ENV PATH /dgs/borg:/dgs/crudini:/dgs/bin:${PATH}

LABEL com.studioetrange.dgs 1
LABEL com.studioetrange.dgs.base "${DGS_IMAGE_BASE}"
LABEL com.studioetrange.dgs.type "${DGS_IMAGE_TYPE}"
LABEL com.studioetrange.dgs.tree-root "${DGS_IMAGE_TREE_ROOT}"
LABEL com.studioetrange.dgs.name "${DGS_IMAGE_NAME}"
LABEL com.studioetrange.dgs.version "${DGS_IMAGE_VERSION}"

# BUILD TIME VARIABLES --------------------------------------------
ARG HTTP_PROXY
ARG http_proxy
ARG HTTPS_PROXY
ARG https_proxy
ARG NO_PROXY
ARG no_proxy

# TREE FILESYSTEM --------------------------------------------------
RUN mkdir -p /etc/supervisor && mkdir -p /var/log/supervisor \
    && mkdir -p /dgs && mkdir -p /dgs/bin && mkdir -p /dgs/lib \
    && mkdir -p ${DGS_VAR_VOLUME_ROOT} \
    && mkdir -p ${DGS_VAR_BACKUP_ROOT}


# COMPONENTS -------------------------------------------------------
# Base packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential gcc-multilib g++-multilib \
	ca-certificates \
	curl \
  git \
	nano \
  # for crudini \
  python-iniparse \
	ssh \
	screenfetch \
  supervisor \
  software-properties-common \
  unzip \
 && rm -rf /var/lib/apt/lists/*

# locales
#RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
#		&& locale-gen en_US.UTF-8 \
#		&& /usr/sbin/update-locale LANG=en_US.UTF-8

# Bash startup files
# https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
# Invoked as an interactive login shell, or with --login
RUN echo '. /dgs/env.sh' > /etc/profile.d/dgs.sh
# NOTE : on debian /etc/profile.d/dgs.sh AND /root/.bashrc are both called
# Invoked as an interactive non-login shell
#RUN echo '. /dgs/env.sh' > /root/.bashrc



# SSH Service X11 forwarding
# Authorize root login
RUN mkdir -p /var/run/sshd \
		&& sed -i 's/\(#\)\?PermitRootLogin\(.*\)/PermitRootLogin yes/' /etc/ssh/sshd_config \
   && sed -i 's/\(#\)\?AllowAgentForwarding\(.*\)/AllowAgentForwarding yes/' /etc/ssh/sshd_config \
   && sed -i 's/\(#\)\?AllowTcpForwarding\(.*\)/AllowTcpForwarding yes/' /etc/ssh/sshd_config \
   && sed -i 's/\(#\)\?X11Forwarding\(.*\)/X11Forwarding yes/' /etc/ssh/sshd_config \
   && sed -i 's/\(#\)\?X11DisplayOffset\(.*\)/X11DisplayOffset 10/' /etc/ssh/sshd_config \
   && sed -i 's/\(#\)\?X11UseLocalhost\(.*\)/X11UseLocalhost no/' /etc/ssh/sshd_config \
   && ssh-keygen -A


# nodejs
RUN apt-get update \
  		&& apt-get install -y --no-install-recommends gnupg2 \
		&& curl -fkSL https://deb.nodesource.com/setup_9.x | bash - \
		&& apt-get install -y --no-install-recommends nodejs \
		&& rm -rf /var/lib/apt/lists/*


# Cloud9
# https://github.com/sapk/dockerfiles/tree/master/cloud9
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    tmux sqlite \
   && npm install -g forever && npm cache clean --force \
   && git clone https://github.com/StudioEtrange/core /root/.c9 \
   && cd /root/.c9 \
   && git checkout 15911b3ed65e69efd27d19683a2ac90c69ca4242 \
   && mkdir -p ./node/bin ./bin ./node_modules \
   && ln -sf "`which tmux`" ./bin/tmux \
   && ln -s "`which node`" ./node/bin/node \
   && ln -s "`which npm`" ./node/bin/npm \
   && npm install pty.js \
   && echo 1 > ./installed \
   && NO_PULL=1 ./scripts/install-sdk.sh \
   && npm cache clean --force && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* \
   && git reset --hard

# borg backup
RUN mkdir -p /dgs/borg \
   && curl -fkSL https://github.com/borgbackup/borg/releases/download/1.1.5/borg-linux64 -o /dgs/borg/borg \
   && chmod +x /dgs/borg/borg


# crudini
# modify ini files
# http://www.pixelbeat.org/programs/crudini/
# https://github.com/StudioEtrange/crudini
RUN mkdir -p /dgs/crudini \
   && curl -fkSL https://raw.githubusercontent.com/StudioEtrange/crudini/0.9/crudini -o /dgs/crudini/crudini \
   && chmod +x /dgs/crudini/crudini

# shell functions
ADD img/${DGS_IMAGE_NAME}/${DGS_IMAGE_VERSION}/dgs_functions_base.sh /dgs/lib/dgs_functions_base.sh


# SUPERVISOR ---------------------------------------------------------
# add supervisor default configuration
COPY img/${DGS_IMAGE_NAME}/${DGS_IMAGE_VERSION}/supervisord.conf /etc/supervisor/supervisord.conf

# add supervisor configuration for cloud9
COPY img/${DGS_IMAGE_NAME}/${DGS_IMAGE_VERSION}/supervisord-cloud9.conf /etc/supervisor/conf.d/supervisord-cloud9.conf

# add supervisor configuration for sshd
COPY img/${DGS_IMAGE_NAME}/${DGS_IMAGE_VERSION}/supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf

# DOCKER RUN PARAMETERS ----------------------------------------------

# supervisor web interface
EXPOSE 9999
# SSH server
EXPOSE 22
# Cloud9
EXPOSE 8181

# volumes
VOLUME ${DGS_VAR_VOLUME_ROOT}

# entrypoint
COPY img/${DGS_IMAGE_NAME}/${DGS_IMAGE_VERSION}/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# default command
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
