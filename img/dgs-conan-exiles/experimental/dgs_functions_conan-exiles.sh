#!/bin/bash

. dgs_functions_base.sh

# example : -Port=27930 -QueryPort=27015 -MaxPlayers=40 -AdminPassword=pass -ServerName=myname
# Start server Options
# Port 27930 : game port
# QueryPort 27015 : steam port
# MaxPlayers 40 :: max nb of players
# AdminPassword pass : admin password
# ServerName myname : server

# Transform some DGS_VAR into start options
DGS_START_OPTIONS="DGS_VAR_GAME_PORT -Port= DGS_VAR_STEAM_PORT -QueryPort= DGS_VAR_MAX_PLAYERS -MaxPlayers= DGS_VAR_ADMIN_PASSWORD -AdminPassword= DGS_VAR_SERVER_NAME -ServerName="
dgs_start() {
  _opt=""
  _f=0
  for a in $DGS_START_OPTIONS; do
    if [ "$_f" = "0" ]; then
      _opt_name="${a}"
      _f=1
    else
      [ ! ${#_opt_name} = "" ] && _opt="${_opt} ${a}${#_opt_name}"
      _f=0
    fi
  done

  xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine "${DGS_VAR_INSTALL_DIR}/"ConanSandboxServer.exe -log ${_opt}
}

dgs_stop() {
  kill -s SIGINT $(pgrep -f  'Z:\\.*\\ConanSandboxServer.exe')
  #2>/dev/null
}

dgs_init() {
  dgs_start &
  sleep 120
  dgs_stop
  sleep 30
  dgs_stop
}

dgs_update() {
  dgs_install
}

dgs_install() {
  steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "${DGS_VAR_INSTALL_DIR}" +login anonymous +app_update "${DGS_VAR_APP_ID}" validate +quit
}

dgs_install_mod() {
  echo "TODO"
            #'+login {} {}'.format(user, password),
            #'+force_install_dir {}'.format(game_install_dir),
            #'+workshop_download_item {} {}'.format(gameid, modID),
            #'{}'.format(validate),
            #'+quit',
}
