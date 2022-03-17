_woot_build_command=""

_woot_set_build_command() {
  _woot_build_command="$1"
}

_woot_invoke_build_command() {
  $SHELL -c "${_woot_build_command}"
}

_woot_help_build_command() {
  if [[ -n "$_woot_build_command" ]]; then 
    echo "         build:   build $projectName"
  fi
}