_woot_start_command=""

_woot_set_start_command() {
  _woot_start_command="$1"
}

_woot_help_start_command() {
  if [[ -n "$_woot_start_command" ]]; then 
    echo "         start:   start the dev mode"
  fi
}

_woot_invoke_start_command() {
  $SHELL -c "${_woot_start_command}"
}
