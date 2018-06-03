#!/bin/bash

# VAR MANAGEMENT -----------------------
# create instruction to export all DGS_VAR_* variables
dgs_internal_build_export_var() {

  _export_string=""

  for var in ${!DGS_VAR@}; do
    _export_string="${_export_string}export ${var}=${!var};"
  done

  echo "${_export_string}"
}

# CONFIG MANAGEMENT --------------------
dgs_internal_config_set() {
  _file="$1"
  _section="$2"
  _param="$3"
  _value="$4"

  echo "Value to be changed : "
  dgs_internal_config_get "${_file}" "${_section}" "${_param}"
  crudini --verbose --set "${_file}" "${_section}" "${_param}" "${_value}"
}

dgs_internal_config_get() {
  _file="$1"
  _section="$2"
  _param="$3"

  echo $(crudini --get "${_file}" "${_section}" "${_param}")
}


# helper functions using an array
#     array format :
#     declare -A dgs_config_array
#     dgs_config_array["param"]="file_path:section"
dgs_internal_config_quick_set() {
  local -n _array="$1"
  _param="$1"
  _value="$2"

  _v=${_array[$_param]}
  _file="${_v%%:*}"
  _section="${_v##*:}"

  dgs_internal_config_set "${_file}" "${_section}" "${_param}" "${_value}"
}

dgs_internal_config_quick_get() {
  local -n _array="$1"
  _param="$1"

  _v=${_array[$_param]}
  _file="${_v%%:*}"
  _section="${_v##*:}"

  dgs_internal_config_get "${_file}" "${_section}" "${_param}"
}

# BACKUP MANAGEMENT -----------------------
dgs_internal_backup_init() {
  borg init --encryption=none "${DGS_VAR_BACKUP_ROOT}"
}

dgs_internal_backup_oneshot() {
  _archive_name="$1"
  _folder="$2"

  cd "${_folder}"

  borg create \
    --verbose \
    --progress \
    --stats \
    --compression zstd \
    "${DGS_VAR_BACKUP_ROOT}::${_archive_name}-'{now}'" \
    .

    backup_exit=$?

    if [ ${backup_exit} -eq 1 ];
    then
        info "Backup finished with a warning"
    fi

    if [ ${backup_exit} -gt 1 ];
    then
        info "Backup finished with an error"
    fi
}

dgs_internal_backup_delete() {
  _archive_name="$1"

  if [ "${_archive_name}" = "" ]; then
    echo "Please specify an archive name"
    return
  else
    borg delete "${DGS_VAR_BACKUP_ROOT}::${_archive_name}"
  fi
}


# auto backup - meant to be called once a day
# prefix them with 'AUTO-'
# keep one backup for 2 last days
# keep one backup for 1 last weeks
# delete all others auto backup
dgs_internal_backup_auto() {
  _archive_name="$1"
  _folder="$2"

  dgs_internal_backup_oneshot "AUTO-${_archive_name}" "${_folder}"
  borg prune --list --keep-daily=2 --keep-weekly=1 --prefix='AUTO-' "${DGS_VAR_BACKUP_ROOT}"
}

dgs_internal_backup_list() {
  borg list "${DGS_VAR_BACKUP_ROOT}"
}

dgs_internal_backup_restore() {
  _archive_name="$1"
  _folder="$2"

  cd "${_folder}"
  borg extract --list "${DGS_VAR_BACKUP_ROOT}::${_archive_name}"
}
