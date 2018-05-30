

# dgs_start Port 27930 QueryPort 27015 MaxPlayers 40 AdminPassword pass ServerName MonServeur
# Start server Options
# Port 27930 : game port
# QueryPort 27015 : steam port
# MaxPlayers 40 :: max nb of players
# AdminPassword pass : admin password
# ServerName myname : server
dgs_start() {
  _arg="$@"
  _opt=""

  _f=0
  for a in $_arg; do
    if [ "$_f" = "0" ]; then
      _opt="${_opt} -${a}"
      _f=1
    else
      _opt="${_opt}=${a}"
      _f=0
    fi
  done

  wine "${DGS_INSTALL_DIR}/"ConanSandboxServer.exe -log "${_opt}"
}

dgs_stop() {
  kill -SIGINT $(pgrep 'ConanSandboxServer.exe')
}

dgs_init() {
  start
  sleep 120
  stop
  sleep 30
  stop
}

dgs_update() {
  install
}

# dgs_install 443030 /dgs/exiles
dgs_install() {
  steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "${DGS_INSTALL_DIR}" +login anonymous +app_update "${DGS_APP_ID}" validate +quit
}

dgs_install_mod() {
  echo "TODO"
            #'+login {} {}'.format(user, password),
            #'+force_install_dir {}'.format(game_install_dir),
            #'+workshop_download_item {} {}'.format(gameid, modID),
            #'{}'.format(validate),
            #'+quit',
}
