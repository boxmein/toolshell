_woot_fuzzy_ui() {
  local -a tasks_to_run=()

  [[ -n "$_woot_start_command" ]] && tasks_to_run+=(start)
  [[ -n "$_woot_build_command" ]] && tasks_to_run+=(build)

  for f in ${(k)_woot_task_map}; do
    tasks_to_run+=($f)
  done

  task_to_run=$(echo $tasks_to_run | tr ' ' '\n' | fzf)
  echo "Running ./x $task_to_run"
  _woot_invoke_task "$task_to_run"
}

_woot_fallback() {
  if [[ -n "${_woot_task_map[$*]}" ]]; then 
    _woot_invoke_task "$*"
  else
    _woot_fuzzy_ui "$*"
  fi
}
