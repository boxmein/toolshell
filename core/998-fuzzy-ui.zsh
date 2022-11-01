_toolshell_fuzzy_ui() {
  local -a tasks_to_run=()

  [[ -n "$_toolshell_start_command" ]] && tasks_to_run+=(start)
  [[ -n "$_toolshell_build_command" ]] && tasks_to_run+=(build)

  for f in ${(k)_toolshell_task_map}; do
    tasks_to_run+=($f)
  done

  task_to_run=$(echo $tasks_to_run | tr ' ' '\n' | fzf)
  echo "Running $0 $task_to_run"
  _toolshell_invoke_task "$task_to_run"
}

_toolshell_fallback() {
  if [[ -n "${_toolshell_task_map[$*]}" ]]; then 
    _toolshell_invoke_task "$*"
  else
    _toolshell_fuzzy_ui "$*"
  fi
}
