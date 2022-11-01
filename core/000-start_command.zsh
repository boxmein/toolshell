_toolshell_start_command=""

_toolshell_set_start_command() {
  _toolshell_start_command="$1"
}

_toolshell_help_start_command() {
  if [[ -n "$_toolshell_start_command" ]]; then 
    echo "         start:   start the dev mode"
  fi
}

_toolshell_invoke_start_command() {
  ${=_toolshell_start_command}
}
