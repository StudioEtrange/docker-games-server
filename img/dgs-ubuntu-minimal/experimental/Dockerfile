FROM dgs-ubuntu-base:experimental
LABEL maintainer "StudioEtrange <sboucault@gmail.com>"
LABEL description "docker-games-server minimal image"


ENV DGS_IMAGE_BASE "dgs-ubuntu-base:experimental"
ENV DGS_IMAGE_TYPE "official-image"
ENV DGS_IMAGE_TREE_ROOT "dgs-ubuntu-base"
ENV DGS_IMAGE_NAME "dgs-ubuntu-minimal"
ENV DGS_IMAGE_VERSION "experimental"


ENV PATH /dgs/steamcmd:/dgs/crudini:${PATH}


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



# COMPONENTS -------------------------------------------------------

# Wine
# https://linuxconfig.org/install-wine-on-ubuntu-18-04-bionic-beaver-linux
#
#
RUN dpkg --add-architecture i386 \
		&& apt-get update && apt-get install -y --no-install-recommends \
		# for steamcmd \
		lib32gcc1 \
		# wine \
	    wine32=3.0-1ubuntu1 \
	    wine64=3.0-1ubuntu1 \
	    wine-stable=3.0-1ubuntu1 \
	    # for crudini \
	    python-iniparse \
 && rm -rf /var/lib/apt/lists/*


# SteamCMD
RUN mkdir -p /dgs/steamcmd \
    && curl -fkSL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -o /opt/steamcmd_linux.tar.gz \
    && cd /dgs/steamcmd \
    && tar -xvzf /opt/steamcmd_linux.tar.gz \
    && rm /opt/steamcmd_linux.tar.gz


# crudini
# modify ini files
# http://www.pixelbeat.org/programs/crudini/
# https://github.com/StudioEtrange/crudini
RUN mkdir -p /dgs/crudini \
    && curl -fkSL https://raw.githubusercontent.com/StudioEtrange/crudini/0.9/crudini -o /dgs/crudini/crudini \
    && chmod +x /dgs/crudini/crudini



# shell functions
ADD img/${DGS_IMAGE_NAME}/${DGS_IMAGE_VERSION}/dgs_functions_base.sh /dgs/bin/dgs_functions_base.sh


# SUPERVISOR ---------------------------------------------------------

# DOCKER RUN PARAMETERS ----------------------------------------------

# supervisor web interface
EXPOSE 9999
# SSH server
EXPOSE 22
# Cloud9
EXPOSE 8181

# entrypoint
COPY img/${DGS_IMAGE_NAME}/${DGS_IMAGE_VERSION}/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# default command
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
