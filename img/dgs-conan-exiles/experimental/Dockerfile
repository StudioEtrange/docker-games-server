FROM dgs-ubuntu-minimal:experimental
LABEL maintainer "StudioEtrange <sboucault@gmail.com>"
LABEL description "docker-games-server conan exiles"

# Image informations
ENV DGS_IMAGE_BASE "dgs-ubuntu-minimal:experimental"
ENV DGS_IMAGE_TYPE "official-image"
ENV DGS_IMAGE_TREE_ROOT "dgs-ubuntu-base"
ENV DGS_IMAGE_NAME "dgs-conan-exiles"
ENV DGS_IMAGE_VERSION "experimental"
LABEL com.studioetrange.dgs 1
LABEL com.studioetrange.dgs.base "${DGS_IMAGE_BASE}"
LABEL com.studioetrange.dgs.type "${DGS_IMAGE_TYPE}"
LABEL com.studioetrange.dgs.tree-root "${DGS_IMAGE_TREE_ROOT}"
LABEL com.studioetrange.dgs.name "${DGS_IMAGE_NAME}"
LABEL com.studioetrange.dgs.version "${DGS_IMAGE_VERSION}"

# Game informations
ENV DGS_VAR_GAME_ID "dgs-conan-exiles"
ENV DGS_VAR_GAME_NAME "Conan Exiles"
ENV DGS_VAR_GAME_STEAM_APP_ID 443030
ENV DGS_VAR_GAME_INSTALL_DIR ${DGS_VAR_VOLUME_ROOT}/${DGS_VAR_GAME_ID}
LABEL com.studioetrange.dgs.game.id "${DGS_VAR_GAME_ID}"
LABEL com.studioetrange.dgs.game.name "${DGS_VAR_GAME_NAME}"
LABEL com.studioetrange.dgs.game.steam-appid "${DGS_VAR_STEAM_APP_ID}"

# Default game configuration
ENV DGS_VAR_GAME_PORT 7777
ENV DGS_VAR_GAME_STEAM_PORT 27030
ENV DGS_VAR_GAME_MAX_PLAYERS 40
ENV DGS_VAR_GAME_INSTANCE_NAME "DGS Conan Exiles Server"

# Informations used into helper shell script
ENV DGS_VAR_PUBLIC_COMMANDS "update set-default-config get-default-config backup restore auto-backup delete-backup"
ENV DGS_VAR_PUBLIC_LAUNCH_OPTIONS "maxplayers DGS_VAR_GAME_MAX_PLAYERS adminpassword DGS_VAR_GAME_ADMIN_PASSWORD servername DGS_VAR_GAME_INSTANCE_NAME"
LABEL com.studioetrange.dgs.public.commands "${DGS_VAR_PUBLIC_COMMANDS}"
LABEL com.studioetrange.dgs.public.launch-options "${DGS_VAR_PUBLIC_LAUNCH_OPTIONS}"

# Network information
ENV DGS_VAR_PORT_GENERIC_LIST "9999:supervisor 22:ssh 8181:c9"
ENV DGS_VAR_PORT_GAME_LIST "${DGS_VAR_GAME_PORT}:gameport ${DGS_VAR_GAME_STEAM_PORT}:steamport"
LABEL com.studioetrange.dgs.port.generic "${DGS_VAR_PORT_GENERIC_LIST}"
LABEL com.studioetrange.dgs.port.game "${DGS_VAR_PORT_GAME_LIST}"

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
ADD img/${DGS_IMAGE_NAME}/${DGS_IMAGE_VERSION}/dgs_functions_conan-exiles.sh /dgs/lib/dgs_functions_conan-exiles.sh

# GAME ------------------------------------------
# install
# https://steamcommunity.com/sharedfiles/filedetails/?id=869441506
# http://www.oktopuss.net/Serveur-dedie-Conan-Exiles-sur-Linux.html

# config
# https://conanexiles.gamepedia.com/Server_Configuration
# https://www.gamingalliance.com.au/ConanExiles_TechManual.pdf

# pysteamcmd
# https://github.com/david-maus/ConanServerManager/tree/master/_SRC

# install
RUN bash -c ". /dgs/bin/dgs_functions_conan-exiles.sh && dgs_install"

# init
RUN bash -c ". /dgs/bin/dgs_functions_conan-exiles.sh && dgs_init"


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
EXPOSE ${DGS_VAR_GAME_PORT}
EXPOSE ${DGS_VAR_STEAM_PORT}

# volumes
VOLUME ${DGS_VAR_VOLUME_ROOT}

# entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]

# default command
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
