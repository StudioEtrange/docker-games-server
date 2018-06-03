#!/bin/bash
set -e

echo "#!/bin/bash" > /dgs/env.sh
echo "echo 'FRON /dgs/env'" >> /dgs/env.sh

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

# import dgs functions into env.sh
for f in /dgs/lib/dgs_functions_*; do
  echo ". ${f}" >> /dgs/env.sh
done
# export all DGS_VAR_* into env.sh
echo 'eval "$(dgs_build_export_var)"' >> /dgs/env.sh

# borg backup
echo "export BORG_REPO=${DGS_VAR_BACKUP_ROOT}" >> /dgs/env.sh


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

  # import dgs functions into supervisord context
  for f in /dgs/lib/dgs_functions_*; do
    . ${f}
  done
  # export all DGS_VAR_* into supervisord context
  eval "$(dgs_build_export_var)"
fi

exec "$@"
