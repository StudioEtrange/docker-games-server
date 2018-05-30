FROM dgs-ubuntu-minimal:experimental
LABEL maintainer "StudioEtrange <sboucault@gmail.com>"
LABEL description "docker-games-server conan exiles"


ENV DGS_IMAGE_BASE "dgs-ubuntu-minimal:experimental"
ENV DGS_IMAGE_TYPE "official-image"
ENV DGS_IMAGE_TREE_ROOT "dgs-ubuntu-base"
ENV DGS_IMAGE_NAME "dgs-conan-exiles"
ENV DGS_IMAGE_VERSION "experimental"

ENV DGS_APP_ID 443030
ENV DGS_GAME_PORT 7777
ENV DGS_STEAM_PORT 27030
ENV DGS_INSTALL_DIR /dgs/exiles


LABEL com.studioetrange.dgs 1
LABEL com.studioetrange.dgs.base "${DGS_IMAGE_BASE}"
LABEL com.studioetrange.dgs.type "${DGS_IMAGE_TYPE}"
LABEL com.studioetrange.dgs.tree-root "${DGS_IMAGE_TREE_ROOT}"
LABEL com.studioetrange.dgs.name "${DGS_IMAGE_NAME}"
LABEL com.studioetrange.dgs.version "${DGS_IMAGE_VERSION}"

LABEL com.studioetrange.dgs.appid "${DGS_APP_ID}"
LABEL com.studioetrange.dgs.gameport "${DGS_GAME_PORT}"
LABEL com.studioetrange.dgs.steamport "${DGS_STEAM_PORT}"

# BUILD TIME VARIABLES --------------------------------------------
ARG HTTP_PROXY
ARG http_proxy
ARG HTTPS_PROXY
ARG https_proxy
ARG NO_PROXY
ARG no_proxy


# TREE FILESYSTEM --------------------------------------------------



# COMPONENTS ------------------------------------
# Base packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    screen \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# shell functions
ADD img/${DGS_IMAGE_NAME}/${DGS_IMAGE_VERSION}/dgs_functions_conan-exiles.sh /dgs/bin/dgs_functions-conan-exiles.sh

# GAME ------------------------------------------
# install
# https://steamcommunity.com/sharedfiles/filedetails/?id=869441506
# http://www.oktopuss.net/Serveur-dedie-Conan-Exiles-sur-Linux.html

# config
# https://conanexiles.gamepedia.com/Server_Configuration
# https://www.gamingalliance.com.au/ConanExiles_TechManual.pdf

# pysteamcmd
# https://github.com/david-maus/ConanServerManager/tree/master/_SRC





RUN bash -c ". /dgs/bin/dgs_functions_conan-exiles.sh && dgs_install"
#RUN steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /dgs/exiles +login anonymous +app_update 443030 validate +quit

RUN bash -c ". /dgs/bin/dgs_functions_conan-exiles.sh && dgs_init"

#RUN wine /dgs/exiles/ConanSandboxServer.exe -log -Port=27030 -QueryPort=27015 \
#	&& sleep 120 \
#	&& kill -SIGINT $(pgrep 'ConanSandboxServer.exe') \
#	&& sleep 30 \
#	&& kill -SIGINT $(pgrep 'ConanSandboxServer.exe')

#RUN crudini --set config_file section parameter value

# [OnlineSubsystemSteam]
# ServerName="Conan Exiles Test Server by Runningman"
# ServerPassword=mypassword
# AsyncTaskTimeout=300


# SUPERVISOR ---------------------------------------------------------

# add supervisor configuration for conan-exiles
COPY img/${DGS_IMAGE_NAME}/${DGS_IMAGE_VERSION}/supervisord-conan-exiles.conf /etc/supervisor/conf.d/supervisord-conan-exiles.conf

# DOCKER RUN PARAMETERS ----------------------------------------------

# supervisor web interface
EXPOSE 9999
# SSH server
EXPOSE 22
# Cloud9
EXPOSE 8181

# Conan Exiles
EXPOSE ${DGS_GAME_PORT}
EXPOSE ${DGS_STEAM_PORT}

# entrypoint
COPY img/${DGS_IMAGE_NAME}/${DGS_IMAGE_VERSION}/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# default command
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
