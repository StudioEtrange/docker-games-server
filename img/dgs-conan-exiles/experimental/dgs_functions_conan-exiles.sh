#!/bin/bash


# VARIABLES -------------
# TODO : do not list all variables : but search for it inside ini files ?
dgs_config_file1="${DGS_VAR_INSTALL_DIR}/ConanSandbox/Config/DefaultServerSettings.ini"
dgs_config_file2="${DGS_VAR_INSTALL_DIR}/ConanSandbox/Saved/Config/WindowsServer/ServerSettings.ini"
dgs_config_file3="${DGS_VAR_INSTALL_DIR}/ConanSandboxSaved/Config/WindowsServer/Engine.ini"
dgs_config_file4="${DGS_VAR_INSTALL_DIR}/ConanSandboxSaved/Config/WindowsServer/Game.ini"

declare -A dgs_config_array
dgs_config_array["UseClientCatchUpTime"]="$dgs_config_file1:ServerSettings"
dgs_config_array["MaxNudity"]="$dgs_config_file2:ServerSettings"
dgs_config_array["ServerName"]="$dgs_config_file3:OnlineSubsystemSteam"
dgs_config_array["ServerPassword"]="$dgs_config_file3:OnlineSubsystemSteam"
dgs_config_array["AsyncTaskTimeout"]="$dgs_config_file3:OnlineSubsystemSteam"
dgs_config_array["MaxPlayers"]="$dgs_config_file4:/script/engine.gamesession"



# PUBLIC FUNCTIONS ---------------
# Public functions are meant to be called from outside container from an help script
set-default-config() {
  _param="$1"
  _value="$2"
  dgs_internal_config_quick_set dgs_config_array "${_param}" "${_value}"
}

get-default-config() {
  _param="$1"
  dgs_internal_config_quick_get dgs_config_array "${_param}"
}

auto-backup() {
  # TODO : DGS_VAR_INSTANCE_ID do not exist
  dgs_internal_backup_auto "${DGS_VAR_GAME_ID}-${DGS_VAR_INSTANCE_ID}" "${DGS_VAR_INSTALL_DIR}"
}

backup() {
  dgs_internal_backup_oneshot "${DGS_VAR_GAME_ID}-${DGS_VAR_INSTANCE_ID}" "${DGS_VAR_INSTALL_DIR}"
}

list-backup() {
  dgs_internal_backup_list
}

restore() {
  _archive_name="$1"
  dgs_internal_backup_restore "${_archive_name}" "${DGS_VAR_INSTALL_DIR}"
}

delete-backup() {
  _archive_name="$1"
  dgs_internal_backup_delete "${_archive_name}"
}

update() {
  dgs_internal_install
}

install-mod() {
  echo "TODO"
            #'+login {} {}'.format(user, password),
            #'+force_install_dir {}'.format(game_install_dir),
            #'+workshop_download_item {} {}'.format(gameid, modID),
            #'{}'.format(validate),
            #'+quit',
}


# PRIVATE FUNCTIONS ---------------
# Internal functions are meant to be called from inside container

# start
# example : -Port=27930 -QueryPort=27015 -MaxPlayers=40 -AdminPassword=pass -ServerName=myname
# Start server Options
# Port 27930 : game port
# QueryPort 27015 : steam port
# MaxPlayers 40 :: max nb of players
# AdminPassword pass : admin password
# ServerName myname : server
dgs_internal_start() {
  # Transform some DGS_VAR into start options
  declare -A options_mappings
  options_mappings["DGS_VAR_GAME_PORT"]="-Port="
  options_mappings["DGS_VAR_GAME_STEAM_PORT"]="-QueryPort="
  options_mappings["DGS_VAR_GAME_MAX_PLAYERS"]="-MaxPlayers="
  options_mappings["DGS_VAR_GAME_ADMIN_PASSWORD"]="-AdminPassword="
  options_mappings["DGS_VAR_GAME_INSTANCE_NAME"]="-ServerName="

  _opt=""
  for key in ${!options_mappings[@]}; do
    [ ! ${#key} = "" ] && _opt="${_opt} ${options_mappings[$key]}${#_opt_name}"
  done

  # https://unix.stackexchange.com/questions/291804/howto-terminate-xvfb-run-properly
  Xvfb :0 -screen 0, 640x480x24:32 &
  export DISPLAY=:0
  wine "${DGS_VAR_GAME_INSTALL_DIR}/"ConanSandboxServer.exe -log ${_opt}
  #xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine "${DGS_VAR_INSTALL_DIR}/"ConanSandboxServer.exe -log ${_opt}
}

dgs_internal_internal() {
  #kill -s SIGINT $(pgrep -f  'Z:\\.*\\ConanSandboxServer.exe')
  kill -s SIGINT $(pgrep -f  'Xvfb') 2>/dev/null
}

dgs_internal_init() {
  dgs_start &
  sleep 120
  dgs_stop
  sleep 30
  dgs_stop
}


dgs_internal_install() {
  steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "${DGS_VAR_GAME_INSTALL_DIR}" +login anonymous +app_update "${DGS_VAR_GAME_STEAM_APP_ID}" validate +quit
}
