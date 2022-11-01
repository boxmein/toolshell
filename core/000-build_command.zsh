_toolshell_build_command=""

_toolshell_set_build_command() {
  _toolshell_build_command="$1"
}

_toolshell_invoke_build_command() {
  ${=_toolshell_build_command}
}

_toolshell_help_build_command() {
  if [[ -n "$_toolshell_build_command" ]]; then 
    echo "         build:   build $projectName"
  fi
}