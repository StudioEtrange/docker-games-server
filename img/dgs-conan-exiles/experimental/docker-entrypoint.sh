#!/bin/bash
set -e

echo "#!/bin/bash" > /dgs/env.sh
# proxy env var
[ ! "$HTTP_PROXY" = "" ] && echo "export HTTP_PROXY=$HTTP_PROXY" >> /dgs/env.sh
[ ! "$HTTPS_PROXY" = "" ] && echo "export HTTPS_PROXY=$HTTPS_PROXY" >> /dgs/env.sh
[ ! "$http_proxy" = "" ] && echo "export http_proxy=$http_proxy" >> /dgs/env.sh
[ ! "$https_proxy" = "" ] && echo "export https_proxy=$https_proxy" >> /dgs/env.sh
[ ! "$NO_PROXY" = "" ] && echo "export NO_PROXY=$NO_PROXY" >> /dgs/env.sh
[ ! "$no_proxy" = "" ] && echo "export no_proxy=$no_proxy" >> /dgs/env.sh

# some global env var
echo 'export SHELL="$(which bash)"' >> /dgs/env.sh

# welcome screen
echo 'screenfetch 2>/dev/null' >> /dgs/env.sh

# path
echo "export PATH=${PATH}" >> /dgs/env.sh

# dgs
echo "export DGS_APP_ID=${DGS_APP_ID}" >> /dgs/env.sh
echo "export DGS_INSTALL_DIR=${DGS_INSTALL_DIR}" >> /dgs/env.sh
echo "export DGS_GAME_PORT=${DGS_GAME_PORT}" >> /dgs/env.sh
echo "export DGS_STEAM_PORT=${DGS_STEAM_PORT}" >> /dgs/env.sh
echo "export DGS_START_OPTIONS=${DGS_START_OPTIONS}" >> /dgs/env.sh

# SSH security
if [ "$PASSWORD" = "" ]; then
  echo 'root:ddsroot' | chpasswd
else
  echo "root:$PASSWORD" | chpasswd
fi


# supervisord need some env var
if [ "$1" = "supervisord" ]; then
  # cloud9 security
  if [ "$PASSWORD" = "" ]; then
    export C9_SECURITY="--auth :"
  else
    export C9_SECURITY="--auth root:$PASSWORD"
  fi

  # path
  export PATH="${PATH}"

  # dgs_options
  export DGS_APP_ID="${DGS_APP_ID}"
  export DGS_INSTALL_DIR="${DGS_INSTALL_DIR}"
  export DGS_GAME_PORT="${DGS_GAME_PORT}"
  export DGS_STEAM_PORT="${DGS_STEAM_PORT}"
  export DGS_START_OPTIONS="${DGS_START_OPTIONS}"
fi

case $1 in
  dgs_* )
    . dgs_functions_conan-exiles.sh
    ;;
esac


exec "$@"
