FROM dgs-ubuntu-minimal:experimental
LABEL maintainer "StudioEtrange <sboucault@gmail.com>"
LABEL description "docker-games-server conan exiles"


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

# BUILD TIME VARIABLES --------------------------------------------
ARG HTTP_PROXY
ARG http_proxy
ARG HTTPS_PROXY
ARG https_proxy
ARG NO_PROXY
ARG no_proxy


# TREE FILESYSTEM --------------------------------------------------



# COMPONENTS ------------------------------------

# GAME ------------------------------------------
# install
# https://steamcommunity.com/sharedfiles/filedetails/?id=869441506
# http://www.oktopuss.net/Serveur-dedie-Conan-Exiles-sur-Linux.html

# config
# https://conanexiles.gamepedia.com/Server_Configuration
# https://www.gamingalliance.com.au/ConanExiles_TechManual.pdf


#RUN apt-get update && apt-get install -y --no-install-recommends \
#		xvfb
# && rm -rf /var/lib/apt/lists/*




RUN steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /dgs/exiles +login anonymous +app_update 443030 validate +quit

RUN wine /dgs/exiles/ConanSandboxServer.exe -log -Port=27030 -QueryPort=27015 \
	&& sleep 120 \
	&& kill -SIGINT $(pgrep 'ConanSandboxServer.exe') \
	&& sleep 30 \
	&& kill -SIGINT $(pgrep 'ConanSandboxServer.exe')

#RUN crudini --set config_file section parameter value

# [OnlineSubsystemSteam]
# ServerName="Conan Exiles Test Server by Runningman"
# ServerPassword=mypassword
# AsyncTaskTimeout=300