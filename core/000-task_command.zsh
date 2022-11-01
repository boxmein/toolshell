declare -A _toolshell_task_map

_toolshell_help_tasks() {
  if [[ -n "${(k)_toolshell_task_map}" ]]; then 
    echo
    echo "Additional commands:"
    echo
    for task in ${(k)_toolshell_task_map}; do
      echo "  $SCRIPT_NAME run $task:   alias for \"${_toolshell_task_map[$task]}\""
    done
  fi
}

_toolshell_create_task_command() {
  _toolshell_task_map[$1]="$2"
}

_toolshell_invoke_task() {
  ${=_toolshell_task_map[$*]}
}