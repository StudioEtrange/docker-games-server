
# create instruction to export all DGS_VAR_* variables
dgs_build_export_var() {

  _export_string=""

  for var in ${!DGS_VAR@}; do
    _export_string="${_export_string}export ${var}=${!var};"
  done

  echo "${_export_string}"
}


dgs_start() {
  echo "dgs_start"
}

dgs_stop() {
  echo "dgs_stop"
}

dgs_init() {
  echo "dgs_init"
}

dgs_update() {
  echo "dgs_update"
}

dgs_install() {
  echo "dgs_install"
}

dgs_install_mod() {
  echo "dgs_install_mod"
}
