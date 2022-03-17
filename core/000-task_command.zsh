declare -A _woot_task_map

_woot_help_tasks() {
  if [[ -n "${(k)_woot_task_map}" ]]; then 
    echo "          run:   start a script for $projectName"
    echo
    echo "available scripts: "
    for task in ${(k)_woot_task_map}; do
      echo "$toolName $task"
    done
  fi
}

_woot_create_task_command() {
  _woot_task_map[$1]="$2"
}

_woot_invoke_task() {
  $SHELL -c "${_woot_task_map[$*]}"
}