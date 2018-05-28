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



# SSH security
if [ "$PASSWORD" = "" ]; then
  echo 'root:ddsroot' | chpasswd
else
  echo "root:$PASSWORD" | chpasswd
fi


# supervisord need some env var
if [ "$1" = "supervisord" ]; then
  # cloud security
  if [ "$PASSWORD" = "" ]; then
    export C9_SECURITY="--auth :"
  else
    export C9_SECURITY="--auth root:$PASSWORD"
  fi
fi

exec "$@"